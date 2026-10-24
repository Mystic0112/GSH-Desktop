---
name: gsh-cli
description: Drive GSH's terminal tabs from inside one. Use when you (an agent in a GSH terminal) need to open, split, type into, read or close tabs, run a shell line through the app (`gsh exec`), start or read a task run, or list tabs and workspaces. Triggers on tmux-like needs (new window, send keys, read another tab's output, interrupt a stuck process) and on "where am I / what is open" questions. Databases, telemetry and the files the human reads (.panel, .kanban, .notebook, .ckp, .http) have their own skills: gsh-db, gsh-telemetry, gsh-design.
---

# gsh — GSH's internal CLI

You are running inside a **GSH** terminal (an IDE that multiplexes
terminals). The `gsh` command talks to the app and lets you **inject
text/keys** into any tab, **read** what tabs and tasks printed, and **list**
tabs/workspaces. It only exists inside GSH tabs (it is not on the global
PATH). `ck` is the same binary under a shorter name.

> **Tab vs pane.** A **tab** is a single terminal/agent session, the unit this
> CLI addresses (`--tab-id`). A **pane** is the split leaf that holds tabs; the
> CLI does not address it. `list-panes`/`read-pane`/`$GSH_PANE_ID` are
> legacy aliases of `list-tabs`/`read-tab`/`$GSH_TAB_ID`.

## Verbs at a glance

| Verb | What |
|---|---|
| `send [--tab-id] [--enter] <text>` | type text; `--enter` submits |
| `send-key [--tab-id] <Key>...` | `Enter`, `Tab`, `Escape`, arrows, `C-c`... |
| `msg --to <label\|id> <text>` | message another agent's tab (signed, submitted) |
| `peers [--json]` | agents the human connected to your tab in the Agents graph |
| `new-tab [--cwd] [--title] [--split h\|v]` | open a terminal tab, prints its id |
| `close-tab [<label\|id>]` | close a tab (**no target = your own tab**) |
| `open <file>` / `gsh <file>` | open a file in the app's viewer |
| `exec [--cwd] [--timeout] [--json] -- <cmd>` | run a shell line through the app (on the host, in a remote workspace) |
| `browse <url>` | open the built-in browser tab |
| `read-tab [<label\|id>] [--lines N]` | a tab's rendered output, tail by default |
| `list-tasks` · `run-task` · `stop-task` · `restart-task` · `send-task-key` · `read-task` | drive and read the Tasks panel |
| `list-tabs` · `list-workspaces` | what is open (ids change every boot) |
| `new-workspace <path> [--host]` · `close-workspace` · `rename-workspace` | the rail |
| `orchestrate <file.ckp> [--append]` | apply a pane layout (format: gsh-design, `references/ckp.md`) |
| `panel new --template <t> <file>` · `panel screenshot [<target>]` | scaffold a `.panel`, see it as a PNG (gsh-design) |

Flags, output shapes and edge cases of every verb: **read `references/verbs.md`**
before using a verb for the first time.

Other skills, when the task is one of these:
- SQL / Redis / Mongo / `.dbq` / connections: **gsh-db**.
- Errors, logs, "why did it fail", instrumenting a project: **gsh-telemetry**.
- Writing a `.panel`, `.html`, `.kanban`, `.notebook`, `.ckp` or `.http` the
  human will open: **gsh-design**.

## Target (--tab-id)

Without `--tab-id`, the command acts on **your own tab** (via `$GSH_TAB_ID`,
legacy fallback `$GSH_PANE_ID`). To drive **another** tab, pass
`--tab-id <id>`.

> Ids (`t0`, `t1`…) are sequential and **change on every app boot**. Never
> guess an id: run `gsh list-tabs` first and use the `id` from there.

## Usage pattern

To run a command in a tab, use `--enter` (the text alone is only typed, not
submitted):

```sh
gsh send --enter "npm test"
```

`--enter` presses Enter as a separate keystroke right after the text, which is
what TUIs expect. The two-step form still works when you need to type something
and press a different key:

```sh
gsh send "npm test"
gsh send-key Enter
```

Cross-tab (drive another tab):

```sh
gsh list-tabs                        # find the target id, e.g. t4
gsh send --tab-id t4 --enter "git status"
```

Interrupt a stuck process in another tab:

```sh
gsh send-key --tab-id t4 C-c
```

Read what another tab printed (e.g. check on a worker, debug a failure):

```sh
gsh read-tab t4 --lines 50            # last 50 lines of t4
gsh read-tab Extension                # by stable label (last 100 lines)
gsh read-tab t4 --lines 100 --offset 100   # the 100 lines before those
```

Read a task run's output (dev server, build, test — the Task Run feature):

```sh
gsh list-tasks                        # ids: ● = running, [output] = readable
gsh read-task npm:dev --lines 80      # tail of the "npm:dev" task output
```

Talk to another agent (signed with your tab; the app presses Enter for you):

```sh
gsh list-tabs --json                  # `harness`: claudeCode, codex, antigravity… or null
gsh msg --to Reviewer "diff ready on feat/x, please review"
# Reviewer receives: [from: <your label> · <your harness>] diff ready on …
gsh peers                             # who you were connected to (Agents graph)
```

A line `[from: gsh] You are now connected to <name> …` means the human
linked you to that agent in the Agents graph: talk to it with the `msg`
command the line gives.
If the intro says you are the **maestro**, you coordinate every agent on the
canvas: delegate with `gsh msg --to <label>` and check `gsh peers`
(`maestro: true` marks the maestro in the other agents' peers).
A peer with `app` (`claude-desktop`, `cursor`…) is a desktop app joined via
`gsh mcp`: message it with `msg --to <label>` as usual; it reads the queue
when it calls `wait_messages`, so its reply can take a while.

**Codex: use the `gsh` MCP tools.** Codex's sandbox strips the
`GSH_*` env and blocks the app socket, so `gsh msg`/`peers` fail there
(`could not connect to app: Operation not permitted`). GSH registers a
`gsh` MCP server in `~/.codex/config.toml` that runs outside the sandbox
and acts as your tab: `send {to, text}` instead of `msg`, `peers`,
`list_agents`, and `wait_messages` (messages to your tab since its last call;
they are also typed into your terminal as `[from: …]` lines).
Always pass `from: "<your tab id>"` (from GSH's connection message) to
these tools: Codex spawns MCP servers outside your tab, so that is how they
know who you are.

Typical loop — dispatch work to a tab, wait, then read the result:

```sh
gsh send --tab-id t4 --enter "npm test"
# poll `gsh list-tabs --json` until t4 shows "working": false, then:
gsh read-tab t4 --lines 60
```

## Common errors

- "GSH_STATUS_SOCK is unset" → you are not inside a GSH terminal.
- "tab ... does not exist" → stale id (app reboot). Run `list-tabs` again.
- "tab ... is not a terminal" → the target is an agent/file tab, not a shell.
- "has no readable output" → read-tab target is an agent/file tab; only
  terminal and task-output tabs are readable.
- "no output recorded for task ..." → the task never ran this app boot, or the
  id is wrong — check both with `gsh list-tasks` (`[output]` = readable).
