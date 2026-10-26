#!/bin/sh
# Instala o GSH Desktop só para este usuário: atalho no menu de apps,
# ícone do gorila no dock e tipos de arquivo. Rode de dentro da pasta.
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
SHARE="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "$SHARE/applications" "$SHARE/mime/packages"
sed "s#^Exec=gsh %F#Exec=\"$DIR/gsh\" %F#" "$DIR/desktop/gshdesktop.desktop" \
  > "$SHARE/applications/work.gorila.gshdesktop.desktop"
for s in 64 128 256 512 1024; do
  mkdir -p "$SHARE/icons/hicolor/${s}x${s}/apps"
  cp "$DIR/desktop/icon_$s.png" "$SHARE/icons/hicolor/${s}x${s}/apps/work.gorila.gshdesktop.png"
done
cp "$DIR/desktop/work.gorila.gshdesktop.xml" "$SHARE/mime/packages/"
update-desktop-database "$SHARE/applications" 2>/dev/null || true
gtk-update-icon-cache -f -t "$SHARE/icons/hicolor" 2>/dev/null || true
update-mime-database "$SHARE/mime" 2>/dev/null || true
echo "GSH Desktop instalado no menu de apps. Para abrir agora: \"$DIR/gsh\""
