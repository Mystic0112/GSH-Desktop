Prévia do **GSH Desktop**, o harness/IDE da Gorila para agentes de código (fork do Cockpit). Usa o `claude` instalado na máquina com o login de cada um; nenhuma chave de API passa pelo app.

> **Pré-release.** Windows e Linux já rodaram em máquinas do time; **macOS ainda não foi aberto num Mac de verdade**. Se algo der errado, mande o print para o Hélio.

## Baixar

| Sistema | Arquivo |
|---|---|
| **Windows** (instalador) | `GSH-Desktop-windows-x64-setup.exe` |
| Windows (portátil, sem instalar) | `GSH-Desktop-windows-x64-portable.zip` |
| **macOS** (Apple Silicon e Intel) | `GSH-Desktop-macos.dmg` |
| macOS (alternativa) | `GSH-Desktop-macos.zip` |
| **Linux** x64 | `GSH-Desktop-linux-x64.tar.gz` |

Conferência dos arquivos: `SHA256SUMS.txt`.

Pré-requisito em todos: o [Claude Code](https://code.claude.com) instalado e logado (`claude` no terminal).

## Instalar

**Windows**
1. Rode o `GSH-Desktop-windows-x64-setup.exe`. Instala só para o seu usuário, sem pedir admin.
2. O SmartScreen vai avisar (o instalador ainda não é assinado): **Mais informações → Executar assim mesmo**.
3. Na primeira vez, o Firewall pergunta sobre rede: permita em **rede privada** (precisa para a fazenda do time e a conversa entre agentes).

**macOS**
1. Abra o `.dmg` e arraste o **GSH.app** para **Aplicativos**.
2. O app não é assinado pela Apple ainda. Na primeira vez: botão direito no app → **Abrir** → **Abrir**. No macOS 15+, se não der: **Ajustes do Sistema → Privacidade e Segurança → Abrir Mesmo Assim**. Ou no terminal, uma vez:
   ```bash
   xattr -dr com.apple.quarantine "/Applications/GSH.app"
   ```
3. Aceite as permissões que ele pedir (rede local, pastas, notificações).

**Linux**
```bash
tar -xzf GSH-Desktop-linux-x64.tar.gz
cd GSH-Desktop && ./install.sh   # põe no menu de apps, com o ícone
./gsh                            # ou abra pelo menu
```

## Conhecido
- Atualização automática ainda não existe: para atualizar, baixe a próxima release.
- macOS: o servidor do GSH para hosts remotos **Linux arm64** não vem nesta versão.
- "Chat com Remote Control (experimental)" só em macOS/Linux.
