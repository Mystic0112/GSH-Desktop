# Status de turno — hooks dos harnesses

Como o Cockpit sabe que um agente numa aba está trabalhando, terminou o turno ou
precisa de uma ação do usuário (spinner, badge, chime, notificação do SO).

Suportados hoje: **Claude Code** e **Codex CLI** (0.147+).

Demais harnesses detectados na aba (Antigravity, Cursor, Copilot, OpenCode, Pi)
não têm hook: o status vem de uma heurística de saída do PTY em
`TerminalSession` (`working` enquanto imprime, `idle` após
`outputSilenceIdle` ≈ 3s de silêncio; eco de digitação/resize ignorado; só um
turno que passou do 1º tick notifica). TUI que anima parada dá falso
`working` — o upgrade é hook nativo por harness (ex.: issue #214, OpenCode).

## Como funciona

1. No boot, `bootstrapper.dart` roda os `HookInstaller` de cada harness. Eles
   materializam a CLI interna em `~/.cockpit/bin/cockpit` e registram
   `<cli> hook` nos eventos de ciclo de vida da config do harness.
2. A cada evento, o harness executa `cockpit hook` passando um JSON pelo stdin.
3. `cli/src/hook.rs` traduz o evento num status (`working` / `waiting` / `idle`)
   e manda pro app por socket Unix (TCP + token no Windows).
4. O roteamento é pela env `COCKPIT_PANE_ID`, que o app injeta na PTY da aba.
   Sessão de agente aberta **fora** do Cockpit não tem essa env, então o hook é
   no-op. É o gate natural: nada a configurar, nada a desligar.

Por que socket e não OSC na PTY: os harnesses rodam hooks sem terminal
controlador, e escrever em `/dev/tty` falha com `ENXIO`.

## Onde cada um instala

| Harness | Arquivo | Formato |
|---|---|---|
| Claude Code | `~/.claude/settings.json` | `hooks.<Evento>[]`, cada item `{matcher, hooks:[{type, command}]}` |
| Codex CLI | `~/.codex/hooks.json` | mesma forma; **mais** um bloco de trust no `~/.codex/config.toml` |

Os dois instaladores fazem **append idempotente** de um entry marcado
(`_cockpit: v1`): re-rodar remove o entry antigo nosso e re-adiciona, sem nunca
reescrever a lista (hooks do usuário, de plugins ou do iTerm2 sobrevivem).

## Mapeamento de eventos

| Evento | Claude | Codex | Status |
|---|:--:|:--:|---|
| `UserPromptSubmit` | ✓ | ✓ | `working` (início de turno) |
| `PreToolUse` | ✓ | ✓ | `working` — exceto ferramenta bloqueante do Claude (ver abaixo) |
| `PostToolUse` | ✓ | ✓ | `working` |
| `Notification` | ✓ | — | `waiting` / `idle` (heurística sobre o texto) |
| `PermissionRequest` | — | ✓ | `waiting` |
| `Stop` | ✓ | ✓ | `idle` |
| `SessionStart` / `SessionEnd` | ✓ | ✓ | `idle` |
| `SubagentStart` / `SubagentStop`, `PreCompact` / `PostCompact` | — | ✓ | **ignorados**: não são o turno da aba |

Duas assimetrias que importam:

- **Claude**: ferramentas que bloqueiam esperando o usuário (`AskUserQuestion`,
  `ExitPlanMode`) não emitem `Notification`. O último hook antes do bloqueio é o
  `PreToolUse`, então ele vira `waiting` para essas duas — senão a aba fica com
  spinner eterno, sem chime.
- **Codex**: a aprovação tem evento próprio (`PermissionRequest`), então não há
  heurística de texto nem desvio no `PreToolUse`. O desvio do Claude continua no
  código e é inerte aqui (aquelas ferramentas não existem no Codex).

O envelope é praticamente o mesmo nos dois (`hook_event_name`, `session_id`,
`transcript_path`, `cwd`, `tool_name`, `tool_input`, `permission_mode`). O Codex
manda um `turn_id` a mais, que o helper repassa como `tid`.

## Quem mexeu no quê (arquivos por aba)

O mesmo hook carrega os arquivos que o agente editou. No `PostToolUse`,
`touched_files` (em `cli/src/hook.rs`) extrai os caminhos e manda no campo
opcional `files` (absolutos; relativo resolve contra o `cwd` do envelope):

| Harness | Ferramenta | De onde vem o caminho |
|---|---|---|
| Claude Code | `Edit` / `Write` / `MultiEdit` | `tool_input.file_path` |
| Claude Code | `NotebookEdit` | `tool_input.notebook_path` |
| Codex CLI | `apply_patch` (ou o patch como argv de shell) | cabeçalhos `*** Add/Update/Delete File:` e `*** Move to:` do patch, achado em qualquer string do `tool_input` |

Formato desconhecido = sem `files` (o hook nunca falha por isso). O app grava
em `AgentFileActivity` (`ui/viewmodels/agent_file_activity.dart`: aba →
caminho → quando, `inferred`), em memória, limpo ao fechar a aba.

Abas **sem hook** (heurística de saída acima) usam o git: no início de um turno
inferido o app guarda o status da root onde a aba está; no fim (turno
sustentado) re-lê o git e atribui à aba os sujos com mtime ≥ início do turno e
os removidos novos — sempre como `inferred`. Arquivos que outra aba reportou
por hook no mesmo intervalo ficam com ela. Teto: arquivo fora do git ou
ignorado não aparece, dois agentes sem hook no mesmo repo são ambíguos, e
workspace remoto fica de fora. Upgrade: hook nativo por harness.

Na UI, o painel Files ganha o filtro por agente (cor estável por aba via
`agentColorFor` em `core/ui/themes/agent_colors.dart`).

## Retomar a sessão (quem é o dono do session-id)

O app persiste no layout o `session_id` que veio pelo hook, e no restore da aba
digita o comando que reata a conversa. **O id sozinho não diz de qual harness
é**, e os comandos diferem:

| Harness | Comando de resume |
|---|---|
| Claude Code | `claude --resume <id>` |
| Codex CLI | `codex resume <id>` |

Por isso o instalador registra o comando do hook com `--harness <nome>`
(`cockpit hook --harness codex`), o helper carimba o payload com `hn`, e o
layout guarda `harness` ao lado de `claude_sid`. Sem a flag, o helper assume
`claude` — é o que os entries instalados por versões anteriores passam, e todos
eles eram do Claude.

Foi exatamente esse o bug do primeiro E2E: o app restaurou uma aba de Codex com
`claude --resume <id do codex>` e o Claude respondeu "No conversation found with
session ID".

## O gate de confiança do Codex

O Codex **só executa hook confiado**. Sem trust ele ignora o hook **em
silêncio** — nenhum aviso, nenhum log. O trust vive no `~/.codex/config.toml`:

```toml
[hooks.state."/Users/você/.codex/hooks.json:session_start:0:0"]
enabled = true
trusted_hash = "sha256:…"
```

- **Chave**: `"<caminho do hooks.json>:<evento_snake>:<índice do grupo>:<índice do handler>"`.
- **Hash**: `sha256` (hex, prefixado `sha256:`) do **JSON canônico** — chaves
  ordenadas, sem espaços — da identidade normalizada do handler:

  ```json
  {"event_name":"session_start","hooks":[{"async":false,"command":"…","timeout":600,"type":"command"}]}
  ```

  O `timeout` é o **normalizado**: 600s para todos os eventos, exceto
  `SessionEnd`, que tem default 1s (teto 3s). Campos ausentes (`matcher`,
  `commandWindows`, `statusMessage`, `additionalContextLimit`) não entram.
  Campos extras no arquivo — como o nosso marcador `_cockpit` — são ignorados
  na desserialização e **não** afetam o hash.

Como o hash deriva da config e não do binário, o Cockpit computa e grava o trust
junto com a instalação: o usuário não precisa aprovar nada na mão. É o mesmo
grau de confiança que já assumimos ao escrever no `settings.json` do Claude —
instalamos o nosso helper, e só ele. O bloco fica entre delimitadores
(`# >>> cockpit hooks` … `# <<< cockpit hooks`) e é regerado a cada boot;
o resto do `config.toml` nunca é tocado — fora a tabela abaixo.

### Servidor MCP `cockpit` (o Codex não alcança a CLI de shell)

O sandbox do Codex tira as envs `COCKPIT_*` dos comandos e bloqueia o socket
do app (`could not connect to app: Operation not permitted`), então
`cockpit msg`/`peers` não funcionam de dentro dele. Servidor MCP roda **fora**
do sandbox: no mesmo passe do trust, o instalador garante, antes do bloco,

```toml
[mcp_servers.cockpit]
command = "/home/u/.cockpit/bin/cockpit"   # bin-debug no flavor de dev
args = ["mcp", "--agent", "codex-desktop"]
env_vars = ["COCKPIT_TAB_ID", "COCKPIT_STATUS_SOCK", "COCKPIT_STATUS_PORT", "COCKPIT_STATUS_TOKEN"]
```

É a **mesma** entrada que o dialog de apps desktop escreve pro app do Codex
(que divide este config), então ninguém duplica nada. O `cockpit mcp` decide
quem é ao subir (`mcp-whoami`): o app procura o pid dele na árvore de processos
das abas (a mesma leitura do detector de harness); achou = age como aquela aba
(`send` = `cockpit msg`, `peers`, `list_agents`, e `wait_messages` devolve o que
chegou pra aba desde a última chamada — a entrega continua sendo digitada no
PTY). Não achou = nó externo `ext:codex-desktop`. O Codex (0.150+) limpa o env
dos servidores MCP; `env_vars` repassa as nossas. O `COCKPIT_TAB_ID` herdado só
vale onde a árvore da aba não é visível (WSL, host remoto): env herdado não
prova parentesco. Escreve só se algo mudou; antes da primeira escrita guarda
`config.toml.cockpit-bak` (0600). Tabela `cockpit` definida de outro jeito
(chave pontilhada) não é tocada.

Referência no fonte do Codex: `codex-rs/hooks/src/engine/discovery.rs`
(`hook_hash`, `hook_key`) e `codex-rs/config/src/fingerprint.rs`
(`version_for_toml`).

### Limitações conhecidas

- **Índice do grupo faz parte da chave.** Se o usuário adicionar um hook próprio
  *antes* do nosso no mesmo evento, nosso índice muda e o trust deixa de bater —
  o hook para de rodar, em silêncio. O instalador corrige no boot seguinte,
  porque recalcula os índices a partir do arquivo final.
- **Editar o `hooks.json` na mão** entre boots tem o mesmo efeito, e a mesma
  correção.
- Se o Codex mudar o algoritmo do hash, o teste de golden em
  `test/data/codex_hook_installer_test.dart` quebra — os valores lá foram
  capturados de uma sessão real que executou os hooks sem
  `--dangerously-bypass-hook-trust`.

## Estrutura no código

```
cli/src/hook.rs                                   # tradução evento → status (agnóstico de harness)
lib/app/cockpit/domain/contracts/hook_installer.dart
lib/app/cockpit/data/hooks/hook_installer_base.dart      # CLI + comando (comum)
lib/app/cockpit/data/hooks/claude_hook_installer_impl.dart
lib/app/cockpit/data/hooks/codex_hook_installer_impl.dart
lib/app/bootstrapper.dart                         # roda os dois no boot, não-fatal
```
