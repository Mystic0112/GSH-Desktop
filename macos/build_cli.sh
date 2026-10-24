#!/bin/bash
# Compila a CLI interna `gsh` (crate Rust em `cli/`) e a empacota como
# `gsh-cli` (nome distinto de `gsh.app`/PRODUCT_NAME) em Resources,
# assinada. Dois modos:
#
#   ./macos/build_cli.sh dev
#     Compila só a arquitetura do host para ~/.gsh/bin-debug/gsh (para
#     `flutter run` / testes E2E) — o diretório da CLI é namespaceado por
#     flavor, como o status.sock, pra build de dev e instalada não
#     sobrescreverem a CLI uma da outra.
#
#   (sem args / rodado pelo Xcode como Run Script phase)
#     Compila **universal** (arm64 + x86_64), copia para
#       ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Resources/gsh-cli
#     e code-signa com ${EXPANDED_CODE_SIGN_IDENTITY} (a mesma da app). O app,
#     no boot, materializa essa cópia como ~/.gsh/bin[-debug]/gsh.
#
# Por que Rust e não mais `dart compile exe`: o AOT do Dart sai de UMA
# arquitetura por vez, não cross-compila pra macOS x64 e **não sobrevive ao
# lipo** (o binário fat perde o snapshot e vira um `dartvm` sem programa). Com
# Rust as duas fatias saem do mesmo host e o `lipo` é válido, então a release
# feita em Apple Silicon roda em Intel. A CLI também absorveu o `gsh-hook`
# como subcomando (`gsh hook`).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"   # gsh/
CRATE="$ROOT/cli"

resolve_cargo() {
  if command -v cargo >/dev/null 2>&1; then command -v cargo; return; fi
  if [ -x "$HOME/.cargo/bin/cargo" ]; then echo "$HOME/.cargo/bin/cargo"; return; fi
  echo "[build_cli] erro: 'cargo' não encontrado (instale Rust: https://rustup.rs)" >&2
  exit 1
}
CARGO="$(resolve_cargo)"

# Flavor assado no binário (ver cli/build.rs): decide qual socket a CLI procura
# PRIMEIRO quando roda fora de um terminal do GSH. Sem isso, a CLI do build
# de dev era atendida pelo app instalado quando os dois estavam abertos.
# `CONFIGURATION` vem do Xcode; o modo `dev` é sempre debug.
if [ "${1:-bundle}" = "dev" ] || [ "${CONFIGURATION:-Release}" = "Debug" ]; then
  export GSH_FLAVOR=debug
else
  export GSH_FLAVOR=release
fi
echo "[build_cli] flavor=$GSH_FLAVOR"

mode="${1:-bundle}"
if [ "$mode" = "dev" ]; then
  DEST="$HOME/.gsh/bin-debug/gsh"
  echo "[build_cli] dev: compilando para a arquitetura do host -> $DEST"
  "$CARGO" build --release --manifest-path "$CRATE/Cargo.toml"
  mkdir -p "$(dirname "$DEST")"
  cp "$CRATE/target/release/gsh" "$DEST"
  chmod +x "$DEST"
  echo "[build_cli] dev OK"
  exit 0
fi

# Modo bundle (Xcode).
: "${BUILT_PRODUCTS_DIR:?precisa rodar pelo Xcode (BUILT_PRODUCTS_DIR ausente)}"
: "${PRODUCT_NAME:?PRODUCT_NAME ausente}"
DEST="$BUILT_PRODUCTS_DIR/$PRODUCT_NAME.app/Contents/Resources/gsh-cli"
mkdir -p "$(dirname "$DEST")"

# Fatias: por padrão as duas (o app é distribuído universal). `ARCHS` do Xcode
# manda quando presente — build local de dev com uma arch só não paga o dobro.
TARGETS=()
case "${ARCHS:-arm64 x86_64}" in
  *arm64*) TARGETS+=("aarch64-apple-darwin") ;;
esac
case "${ARCHS:-arm64 x86_64}" in
  *x86_64*) TARGETS+=("x86_64-apple-darwin") ;;
esac
if [ ${#TARGETS[@]} -eq 0 ]; then TARGETS=("aarch64-apple-darwin"); fi

SLICES=()
for target in "${TARGETS[@]}"; do
  echo "[build_cli] compilando $target"
  # `rustup target add` é idempotente; falha (ex.: rust sem rustup) não é fatal
  # — se o target realmente faltar, o cargo abaixo falha alto com a razão.
  rustup target add "$target" >/dev/null 2>&1 || true
  "$CARGO" build --release --manifest-path "$CRATE/Cargo.toml" --target "$target"
  SLICES+=("$CRATE/target/$target/release/gsh")
done

if [ ${#SLICES[@]} -eq 1 ]; then
  cp "${SLICES[0]}" "$DEST"
else
  /usr/bin/lipo -create "${SLICES[@]}" -output "$DEST"
fi
chmod +x "$DEST"

# Verificação executável, não só estrutural: `lipo -verify_arch` passa em
# binário quebrado (foi assim que o PR #96 achou que tinha funcionado). Rodar a
# fatia nativa é o que prova que ela funciona.
"$DEST" --version >/dev/null || {
  echo "[build_cli] erro: o binário gerado não executa" >&2
  exit 1
}
echo "[build_cli] $(/usr/bin/lipo -archs "$DEST") · $("$DEST" --version)"

IDENTITY="${EXPANDED_CODE_SIGN_IDENTITY:-}"
if [ -z "$IDENTITY" ] || [ "$IDENTITY" = "-" ]; then
  echo "[build_cli] codesign ad-hoc (dev) $DEST"
  codesign --force -s - "$DEST"
else
  echo "[build_cli] codesign ($IDENTITY) + hardened runtime $DEST"
  codesign --force --options runtime \
    --entitlements "$ROOT/macos/gsh_hook.entitlements" \
    -s "$IDENTITY" "$DEST"
fi
echo "[build_cli] bundle OK -> $DEST"

# Nota (plano 51): os dylibs do anakiORM NÃO são copiados aqui. Os pacotes
# `anaki_*` trazem os binários via **native assets** (hook/build.dart), e o
# Flutter os empacota/assina no `flutter build` automaticamente. Se algum
# engine falhar por binário ausente, é problema do pacote anaki (issue #4) —
# não recriamos staging manual aqui.
