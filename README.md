# GSH Desktop

Harness/IDE da **Gorila Software House** para trabalhar com agentes de código
(Claude Code, Codex e outros) no desktop: terminais, chat nativo com o Claude
Code, uma "fazenda" que mostra os agentes trabalhando, arquivos, git, bancos e
tasks lado a lado. Linux, macOS e Windows.

Fork do [Cockpit](https://github.com/jacobaraujo7/remote_pi) (Remote Pi, de
Jacob Moura, MIT). O mundo em pixel art da fazenda foi portado do
[clodfarm](https://github.com/matank001/clodfarm) (MIT; licença em
`third_party/clodfarm/LICENSE`).

## O que tem

- **Chat** (botão de balão no topo): conversa com o Claude Code no estilo do
  Claude Desktop, sobre o `claude` instalado na máquina e o login de cada
  pessoa. Aprovação de permissão com um clique ("Sempre permitir" grava a regra
  no projeto), diffs inline, plano, perguntas com opções, anexos (imagem, PDF,
  arquivo; Ctrl+V cola print), raciocínio, retomar conversa ao reabrir,
  mensagens entre sessões e "Continuar no Remote Control".
- **Fazenda** (botão de grama): cada loop de agente da máquina é um bicho num
  canteiro; subagentes em volta do pai; quem espera permissão levanta bandeira.
  Lê os transcripts do Claude Code, então pega sessões abertas fora do GSH.
  Clique no bicho abre o terminal dele.
- **Terminais, arquivos, git, worktrees, bancos, tasks, navegador embutido**:
  herdados do Cockpit.
- **Configurações** em dois lados: *GSH Desktop* (aparência, terminal, atalhos…)
  e *Claude* (conta, uso, memória, Claude Code, skills, conectores, plugins…),
  no estilo do Claude Desktop, lendo e gravando o `~/.claude/settings.json` e
  a CLI `claude`.
- **Hosts protegidos** (Configurações → Claude → Claude Code → Segurança):
  nenhum agente roda um comando que cite `prod`, `homolog` etc., em nenhuma
  sessão da máquina.
- **Remote Control**: toggle para toda sessão interativa conectar ao celular /
  claude.ai; o chat entrega a conversa a um terminal com Remote Control.

O GSH não fala com a API da Anthropic: o motor é sempre o `claude` da máquina.

## Rodar

Pré-requisitos: Flutter 3.44+, Rust (`cargo`), Zig 0.16 (compila o libghostty),
`claude` instalado e logado.

```bash
flutter pub get
flutter run -d linux   # ou macos / windows
```

Checagens antes de commitar:

```bash
flutter analyze && flutter test test/data && (cd cli && cargo test)
```

Build Linux: `flutter build linux` (gera `build/linux/x64/release/bundle/gsh`).
Empacotamento (deb/rpm/dmg/exe): [`packaging/README.md`](packaging/README.md).

## Como é organizado

- `lib/app/gsh/` — o shell (workspaces, panes, chat, fazenda, settings de
  sessão). `lib/app/settings/` — a tela de configurações. `lib/app/core/` — o
  que é compartilhado. Regras em [`CLAUDE.md`](CLAUDE.md) e
  [`lib/app/CLAUDE.md`](lib/app/CLAUDE.md).
- `cli/` — a CLI interna `gsh` (Rust): hooks dos harnesses (status de turno,
  fazenda, hosts protegidos), MCP, comandos de aba/workspace.
- `packages/` — motor compartilhado com o `gsh-server` (workspaces remotos).
- `docs/` — formatos de arquivo (`.ckp`, tema, tasks), hooks, telemetria.

Nomes internos: CLI `gsh` (alias `gd`), dados em `~/.gsh/`, pasta `.gsh/` no
workspace, env `GSH_*`.

## Trabalho

Branches: `master` (estável), `helio` (harness/chat/configurações), `yan`
(fazenda/visibilidade). Pull request para o `master`. Backlog e decisões na
lista **GSH Desktop** do ClickUp.

## Licença

MIT — veja [`LICENSE`](LICENSE) (Cockpit, Jacob Moura) e
`third_party/clodfarm/LICENSE`.
