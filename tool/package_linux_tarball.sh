#!/usr/bin/env bash
# Empacota o bundle Linux (x64) em GSH-Desktop-linux-x64.tar.gz: pasta
# GSH-Desktop/ com o bundle release, o install.sh e desktop/ (.desktop, ícones,
# tipos MIME). Rode depois de `flutter build linux --release`.
# Uso: tool/package_linux_tarball.sh [arquivo de saída]
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
bundle="$root/build/linux/x64/release/bundle"
output="$(realpath -m "${1:-$root/dist/GSH-Desktop-linux-x64.tar.gz}")"

if [ ! -x "$bundle/gsh" ]; then
  echo "bundle não encontrado em $bundle: rode 'flutter build linux --release'" >&2
  exit 1
fi

stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT
app="$stage/GSH-Desktop"

cp -a "$bundle" "$app"
install -m 755 "$root/linux/packaging/tarball/install.sh" "$app/install.sh"
mkdir "$app/desktop"
cp "$root/linux/gshdesktop.desktop" "$root/linux/work.gorila.gshdesktop.xml" "$app/desktop/"
for size in 64 128 256 512 1024; do
  cp "$root/linux/runner/resources/app_icon_$size.png" "$app/desktop/icon_$size.png"
done

mkdir -p "$(dirname "$output")"
tar -C "$stage" -czf "$output" GSH-Desktop
echo "$output"
