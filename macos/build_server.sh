#!/bin/bash
# Empacota o gsh-server (plano 58) no .app via `dart build cli` — que
# SUPORTA build hooks (native assets do anaki), ao contrário do
# `dart compile exe`. O resultado (bin/ + lib/) vai para
#   Resources/gsh-server-bundle/{bin,lib}
# e o app resolve o binário lá (SidecarTerminalConnector). Além do sidecar
# Darwin, empacota o target de bootstrap remoto em
#   Resources/gsh-server-bundle/targets/linux-arm64/{bin,lib}.
#
# ATENÇÃO — arquitetura: fatia única (a do host que buildou), no nome sem
# sufixo (`bin/gsh-server`), que é o fallback do resolver. No CI, o
# tool/lipo-server-bundle.sh troca esse arquivo pelas duas fatias
# `gsh-server-arm64` e `gsh-server-x64` — o exe é um AOT do Dart e
# NÃO sobrevive ao `lipo` (o snapshot anexado some do alcance do
# dartaotruntime). Nunca transforme este binário num Mach-O universal.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"   # gsh/

resolve_dart() {
  if [ -n "${FLUTTER_ROOT:-}" ] && [ -x "$FLUTTER_ROOT/bin/dart" ]; then
    echo "$FLUTTER_ROOT/bin/dart"; return
  fi
  if command -v dart >/dev/null 2>&1; then command -v dart; return; fi
  echo "[build_server] erro: 'dart' não encontrado" >&2
  exit 1
}
DART="$(resolve_dart)"

: "${BUILT_PRODUCTS_DIR:?precisa rodar pelo Xcode (BUILT_PRODUCTS_DIR ausente)}"
: "${PRODUCT_NAME:?PRODUCT_NAME ausente}"
DEST="$BUILT_PRODUCTS_DIR/$PRODUCT_NAME.app/Contents/Resources/gsh-server-bundle"
rm -rf "$DEST"
mkdir -p "$DEST"

# Dylib do PTY: universal (C compila as duas fatias num comando).
SRC="$ROOT/plugins/gsh_pty/src"
PTY="$ROOT/build/wave0/libgsh_pty.dylib"
mkdir -p "$ROOT/build/wave0"
cc -dynamiclib -O2 -DDART_SHARED_LIB -arch arm64 -arch x86_64 \
  -o "$PTY" "$SRC/gsh_pty.c" -I"$SRC" -lpthread

# Servidor via dart build cli (bundle bin/ + lib/ com os native assets).
( cd "$ROOT/packages/gsh_server" && "$DART" pub get >/dev/null )
BUNDLE="$(mktemp -d)/out"
( cd "$ROOT/packages/gsh_server" && "$DART" build cli -o "$BUNDLE" >/dev/null )
# `dart build cli` gera <out>/bundle/{bin,lib}.
mv "$BUNDLE"/bundle/* "$DEST"/
mv "$DEST/bin/gsh_server" "$DEST/bin/gsh-server"
cp "$PTY" "$DEST/lib/libgsh_pty.dylib"
chmod +x "$DEST/bin/gsh-server"

# Target de bootstrap para os VMs Linux arm64 de workspaces remotos. Fica
# isolado do sidecar macOS para o resolver nunca tentar executar um ELF local.
# O helper também produz libgsh_pty.so e a CLI Rust para o host remoto.
# O cross-compile exige `dart build cli --target-os`, ausente no Dart 3.12
# (Flutter 3.44.x fixado): sem ele o target fica de fora e o resolver devolve
# null para hosts Linux arm64, como no build do Windows.
if "$DART" build cli --help 2>&1 | grep -q -- '--target-os'; then
  "$ROOT/tool/build-linux-arm64-server-bundle.sh" \
    "$DEST/targets/linux-arm64"
else
  echo "[build_server] aviso: Dart sem 'build cli --target-os'; target linux-arm64 não embarcado" >&2
fi

# CLI `gsh` embarcada AO LADO do server (plano 60, Wave G): o server instala
# o hook do agente no ~/.claude do host apontando pra `gsh hook`, e a acha
# via _besideServer (mesma pasta bin/). Fatia única do host, como o server.
CARGO="${CARGO:-cargo}"
command -v "$CARGO" >/dev/null 2>&1 || CARGO="$HOME/.cargo/bin/cargo"
( cd "$ROOT/cli" && "$CARGO" build --release >/dev/null )
cp "$ROOT/cli/target/release/gsh" "$DEST/bin/gsh"
chmod +x "$DEST/bin/gsh"

IDENTITY="${EXPANDED_CODE_SIGN_IDENTITY:-}"
sign() {
  if [ -z "$IDENTITY" ] || [ "$IDENTITY" = "-" ]; then
    codesign --force -s - "$@"
  else
    codesign --force --options runtime \
      --entitlements "$ROOT/macos/gsh_hook.entitlements" \
      -s "$IDENTITY" "$@"
  fi
}
# Assina as dylibs antes do exe.
for f in "$DEST"/lib/*.dylib; do sign "$f"; done
sign "$DEST/bin/gsh-server"
[ -f "$DEST/bin/gsh" ] && sign "$DEST/bin/gsh"
echo "[build_server] bundle OK -> $DEST"
