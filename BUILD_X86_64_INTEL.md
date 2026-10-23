# Binário X86_64

O Cockpit.app é uma versão para a arquitetura x86_64, compilado a partir de um hardware Intel.

Processador: Intel(R) Core(TM) i7-14700K
Placa de vídeo: AMD Radeon RX 6800 XT 16GB
Memória: 64GB(4x16GB) DDR5 5200MHz
OS: MacOS Tahoe 26.2

Flutter 3.44.2 • channel stable • https://github.com/flutter/flutter.git
Framework • revision c9a6c48423 (5 weeks ago) • 2026-06-10 15:52:41 -0700
Engine • hash 04efd7c093d4e9281d5526ebcad6ecc60ba8badf (revision 77e2e94772) (1
months ago) • 2026-06-10 19:59:06.000Z
Tools • Dart 3.12.2 • DevTools 2.57.0

Download [Cockpit.app](https://drive.google.com/drive/folders/14-dNbEAlk3LvVPS2tzT3tcsk02J8qpXJ?usp=sharing)
https://drive.google.com/drive/folders/14-dNbEAlk3LvVPS2tzT3tcsk02J8qpXJ?usp=sharing

[Video Testando Compilação](https://drive.google.com/file/d/1ofxiLO84ZQu3fN4-7iXUMdU9j5fsC2Xb/view?usp=sharing)
https://drive.google.com/file/d/1ofxiLO84ZQu3fN4-7iXUMdU9j5fsC2Xb/view?usp=sharing

Precisei executar os comandos abaixo após a compilação para conseguir executar o Cockpit.app sem a assinatura oficial, sem esses passos o app dava crash:

```bash
# Seta path do arquivo à variável APP
APP="build/macos/Build/Products/Release/Cockpit.app"
# Seta path do mktemp à variável ENT
ENT="$(mktemp)"
# Copia o arquivo Release.entitlements para a variável ENT
cp macos/Runner/Release.entitlements "$ENT"
# Adiciona a chave :com.apple.security.cs.disable-library-validation com valor true ao arquivo Release.entitlements
# Usado para desabilitar a validação de bibliotecas
# Necessário para que o arquivo seja executado em sistemas com macOS 13 ou superior
/usr/libexec/PlistBuddy -c "Add :com.apple.security.cs.disable-library-validation bool true" "$ENT"
# Assina o arquivo com o mktemp
# Usado para que o arquivo seja executado em sistemas com macOS 13 ou superior
# Necessário para que o arquivo seja executado em sistemas com macOS 13 ou superior
codesign --force --deep --options runtime --entitlements "$ENT" --sign - "$APP"
# Verifica a assinatura do arquivo
# Usado para verificar se o arquivo foi assinado corretamente
# Necessário para que o arquivo seja executado em sistemas com macOS 13 ou superior
codesign -d --entitlements - "$APP" 2>&1
```
