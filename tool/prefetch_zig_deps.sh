#!/usr/bin/env bash
# Põe no cache global do Zig as dependências do Ghostty, baixadas com o curl.
#
# Por quê: no runner Windows do GitHub o cliente HTTP do Zig falha ao baixar
# de deps.files.ghostty.org ("HTTP response read failure"), mesmo com o
# servidor respondendo ao curl. Com o pacote já no cache (o `zig fetch`
# confere o hash do build.zig.zon), o `zig build` não baixa nada.
#
# Roda depois de uma tentativa de build, que deixa o código do Ghostty em
# .dart_tool/. Usa ZIG_GLOBAL_CACHE_DIR, o mesmo que o hook do libghostty
# passa ao Zig no Windows.
set -u
cache="${ZIG_GLOBAL_CACHE_DIR:-}"
zon="$(find .dart_tool/hooks_runner -path '*/ghostty-source-*/build.zig.zon' 2>/dev/null | awk '{ print length, $0 }' | sort -n | head -1 | cut -d' ' -f2-)"
if [ -z "$cache" ] || [ -z "$zon" ]; then
  echo "prefetch: sem ZIG_GLOBAL_CACHE_DIR ou sem código do Ghostty; nada a fazer"
  exit 0
fi
src="$(dirname "$zon")"
cd "$src" || exit 0
mkdir -p .prefetch
# Caminhos relativos: o zig.exe não entende os /tmp/... do bash do Windows.
# Inclui os build.zig.zon dos pacotes internos (pkg/*): o Zig resolve em cascata.
find . -name build.zig.zon -exec grep -ohE 'https://[^"]+\.(tar\.gz|tar\.xz|tgz|zip)' {} + |
  grep -v /COMMIT. | sort -u |
  while read -r url; do
    file=".prefetch/$(basename "$url")"
    if curl -fsSL --retry 5 --retry-all-errors --retry-delay 3 -o "$file" "$url"; then
      zig fetch --global-cache-dir "$cache" "$file" >/dev/null ||
        echo "prefetch: zig fetch falhou para $url"
    else
      echo "prefetch: download falhou para $url"
    fi
  done
rm -rf .prefetch
echo "prefetch: dependências do Ghostty no cache $cache"
