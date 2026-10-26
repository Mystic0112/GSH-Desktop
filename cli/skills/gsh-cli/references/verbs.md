# gsh — verbs in detail

Full reference of every CLI verb (the skill lists them in a table). Each entry
shows flags, output shape and the mistakes to avoid.

- `gsh send [--tab-id <id>] [--enter] <text>` — type literal text; add
  `--enter` to submit it (equivalent to a `send-key Enter` right after).
  `--focused` targets whichever tab the human is looking at (the app resolves
  it) — meant for tools driven by the human, not for agent orchestration, where
  an explicit `--tab-id` is what keeps you from typing into the wrong tab.
- `gsh send-key [--tab-id <id>] <Key>...` — press key(s): `Enter`, `Tab`,
  `Escape`, `Space`, `BSpace`, `Up`/`Down`/`Left`/`Right`, `Home`/`End`,
  `PageUp`/`PageDown`, `Delete`, and `C-<letter>` (e.g. `C-c` = Ctrl+C).
- `gsh msg --to <label|tab-id> [--json] <text...>` — message another
  agent: the target tab receives `[from: <your label or title> · <your
  harness>] <text>` followed by Enter (sent as a separate keystroke, so TUIs
  submit it). The sender is your own tab (`$GSH_TAB_ID`, required); `--to`
  resolves like `read-tab` (tab-id, else exact case-insensitive label; an
  ambiguous label fails). Prints the target id (`--json`: `{"from","to"}`).
  Messaging your own tab or a non-terminal tab fails.
- `gsh peers [--json]` — the agents linked to your tab (`$GSH_TAB_ID`)
  in the Agents graph (topbar → Visualize agents): one line per peer with its
  tab id, label (or title), `[harness]` and `●` while working. `--json`: array
  of `{"id","label","title","harness","working"}`; `label` may be null — then
  address the peer by `id`. Empty (`(none)`) when the human linked nobody.
  When a link is created both sides receive `[from: gsh] You are now
  connected to <name> (<harness>). Talk to it with: gsh msg --to <label|id>
  "..."`. A peer with `app` (+ `online`) is a desktop app (`ext:<app>` id):
  `msg` to it is queued and delivered when it calls its `wait_messages` tool.
- Team mail (Settings > Resources > Team farm, same team name and password
  on both machines, same LAN): `peers` also lists teammates' agents as
  `Name/agent` with `team: true`, and `msg --to Name/agent` goes over the
  network. The agent part is the tab's manual label, else its folder; two
  agents in one folder get the harness appended (`api-claude-code`,
  `api-codex`), and the tab id if it still repeats. When the teammate is
  gone, `msg` fails with the team error ("no teammate … on the network").
- `gsh deliver --to <Name/agent> <file> [note]` — hand a file (≤ 25 MB) to a
  teammate's agent: saved as `<its cwd>/.gsh/inbox/<your name>/<file>`
  (never overwrites) and announced in its terminal with the note.
- `gsh mcp --agent <claude-desktop|cursor|antigravity-ide|codex-desktop>`
  — stdio MCP server (JSON-RPC, one message per line) that a desktop agent
  app runs from its MCP config; the New agent dialog (Desktop apps) writes
  that entry. Tools: `peers`, `send {to, text}`, `wait_messages
  {timeout_seconds}` (default 45, max 55: call again to keep waiting),
  `list_agents`. Run under a GSH tab (Codex: GSH adds the entry to
  `~/.codex/config.toml`) it acts as that tab — `send` = `msg`, `peers`,
  `list_agents`, and `wait_messages` returns messages to the tab since the
  last call (also typed into the terminal, as usual).
- `gsh new-tab [--cwd <dir>] [--title <name>] [--split h|v]` — open a new
  **terminal tab** in the app and print its id (`t12`). `--cwd` defaults to
  your current directory; `--title` sets the stable tab label (so `send`/
  `read-tab` can target it by name). Without `--split` the tab opens in the
  same pane (next to yours); `--split h` (or `right`) splits side by side,
  `--split v` (or `down`) stacks — tmux semantics. Capture the id to drive it:

  ```sh
  id=$(gsh new-tab --cwd ~/proj --title Worker --split h)
  gsh send --tab-id "$id" --enter "npm test"
  ```
- `gsh close-tab [<label|tab-id>]` — close a tab and print its id: the
  counterpart of `new-tab`. **Without a target it closes YOUR OWN tab**, which
  ends the shell you are typing in — pass the target explicitly unless that is
  what you mean. Closing the last tab of a split removes the split; closing the
  last tab of a workspace leaves an empty tab behind (same as the tab's "x").

  ```sh
  id=$(gsh new-tab --cwd ~/proj --title Worker)
  gsh close-tab "$id"     # or: gsh close-tab Worker
  ```
- `gsh open [--tab-id <id>] <file>` — open the file in the app's viewer
  (tab next to the terminal). `gsh <file>` is the shortcut. The path is
  resolved against the tab cwd (relative, `~` and absolute all work). Any type
  opens as text — including extensionless ones (`.zprofile`, `Makefile`).
- `gsh exec [--cwd <dir>] [--timeout <s>] [--json] [--] <command...>` —
  run a shell line through the app and print its output; the exit code is the
  command's. The shell is the app's **default terminal profile** (Settings →
  Terminal): the login shell on macOS/Linux (so your PATH applies), and on
  Windows whatever the `+` opens — PowerShell, cmd or a WSL distro — so write
  the line in that shell's syntax. `--json` prints
  `{ok, code, stdout, stderr, timedOut}` on one line. In a **remote**
  workspace the line runs on the host (login shell, host cwd), so paths and
  tools are the host's; the host needs gsh-server 2.1.13 or newer. This
  is what `.panel` buttons use under the hood; from a terminal you already
  have a shell, so
  prefer it only when you want the app's environment (`gsh` on PATH,
  `GSH_TAB_ID` set) from outside a GSH tab.
- `gsh browse <url> [--json]` — open the app's built-in **browser tab** at
  `<url>` (e.g. a dev server you just started: `gsh browse
  http://localhost:3000`). A browser tab already open on the same host:port is
  reused (it navigates/reloads instead of duplicating). Schemeless URLs get
  `http://` for localhost targets and `https://` otherwise. On platforms
  without an inline webview (Linux) the URL opens in the system browser —
  `--json` output tells you which happened: `{"mode":"inline"|"system","url":…}`.
- `gsh read-tab [<label|tab-id>] [--lines N] [--offset N] [--from-start]`
  (alias: `read-pane`) — read a tab's **rendered output** as plain text (no
  ANSI escapes; covers TUIs on the alt-screen too). Without a target it reads
  your **own** tab; a target may be a stable tab `label` or a tab-id. Default
  window: the **last 100 lines** (tail). `--lines N` sets the window size
  (server cap 2000); `--from-start` anchors at the beginning of the buffer
  instead of the end; `--offset N` skips N lines from the chosen anchor
  (pagination: read the last 100, then `--lines 100 --offset 100` for the 100
  before those). Output is always chronological (top→bottom) — the flags only
  pick the window.
- `gsh read-task <task-id> [--lines N] [--offset N] [--from-start]` — same
  windowed read, but for a **task run's** output (the Task Run feature). Works
  even if no task-output tab is open, but only for tasks that ran this boot.
  Discover ids with `gsh list-tasks` (never guess them).
- `gsh list-tasks [--json]` — tasks of **your workspace** (the one owning
  the current tab, or `--tab-id`'s): `id`, `label`, `kind` (watch|oneShot),
  `source` (detected|manual), `running`, `hasOutput` (`read-task` has output
  to read). Ids are stable per workspace: `npm:<script>` (package.json
  scripts), `flutter:run`/`flutter:test`, `json:<label>`
  (`.gsh/tasks.json`). With `--json` each task also lists its `profiles`
  and interactive `keys`.
- `gsh run-task <task-id> [--profile <name>] [--restart]`,
  `gsh stop-task <task-id>`, `gsh restart-task <task-id>`,
  `gsh send-task-key <task-id> <key>` — drive the **Tasks panel** from a
  tab: start a task (fails if already running unless `--restart`), stop it,
  restart it with the same profile, or write an interactive key to its stdin
  (`r` = hot reload, `R` = hot restart on Flutter; the keys come from
  `list-tasks --json`). Same runner the human sees in the panel, so state and
  output stay in sync; works on local and remote workspaces (the task runs
  where the workspace lives). Prefer `send-task-key` over a restart when the
  task offers a reload key — it is what the human would press.

  ```sh
  gsh list-tasks --json                 # ids, profiles, keys
  gsh run-task npm:dev                  # start the dev server
  gsh send-task-key flutter:run r       # hot reload after an edit
  gsh restart-task npm:dev              # config changed, reload won't do
  gsh read-task npm:dev --lines 40      # check what it printed
  ```
- `gsh list-tabs [--json]` (alias: `list-panes`) — active tabs: `id`,
  `kind` (terminal|agent|file|task), `title` (dynamic), `label` (manual stable
  name, or null), `workspaceId` (opaque UUID), `workspacePath` (workspace root
  on disk), `working`, `harness` (the agent detected in the tab: `claudeCode`,
  `codex`, `antigravity`, `cursor`, `gitHubCopilot`, `openCode`, `pi`, or
  null), and `taskId` on task-output tabs (the id `read-task` accepts).
  Resolve a tab by its stable `label`, not the dynamic `title`. `working`
  comes from hooks for Claude Code and Codex; for other agents it is inferred
  from terminal output (busy while it prints, idle after ~3s of silence), so
  treat it as a hint there.
- `gsh list-workspaces [--json]` — open projects: `id` (opaque UUID),
  `name`, `path` (root on disk), `tabs`.
- `gsh new-workspace <path> [--host <ssh-target>] [--name <title>] [--json]`
  (aliases: `open-workspace`, `new-remote-workspace`) — add `<path>` as a top-level
  project in GSH's rail (local or remote), select it, and ensure an initial
  terminal tab is opened. For remote workspaces, pass `--host` (SSH host or
  `~/.ssh/config` alias). Idempotent: focuses an already open workspace.
  Prints the workspace id (or full object with `--json`).
- `gsh close-workspace [<id|path>] [--json]` — remove a top-level project
  from GSH (ends its tabs; files on disk are kept). Target may be an id,
  path, or unique name (default: current workspace). Prints the closed workspace id.
- `gsh rename-workspace [<id|path>] <new-name> [--json]` — update the
  display title of a workspace in the rail. Target may be an id, path, or
  unique name (default: current workspace).
- `gsh orchestrate <file.ckp> [--append] [--json]` — apply a **pane
  layout** to the current workspace: opens the terminals/splits declared in
  the file and types each pane's `command`. By default the workspace
  **becomes** the layout: every open tab is closed first, with no
  confirmation, then the panes are created. The tab you run the command from
  is the only one kept (closing it would kill the CLI mid-call).
  An invalid file closes nothing. With `--append` the open tabs are kept and
  the layout is merged on top (idempotent: a pane whose `name` already exists
  as a tab label is skipped, so running it twice is a no-op). Prints
  `closed:`/`created:`/`skipped:` (or `{"created":[],"skipped":[],"closed":0}`
  with `--json`).
- `gsh http <list|run> <file.http>` — runs HTTP requests written in a
  `.http` file (REST Client / JetBrains HTTP Client syntax: `###` separates
  requests, `@name = value` declares a variable, `{{name}}` interpolates it).
  - `gsh http list api/users.http` — the requests in the file, with their
    index, name, method and URL.
  - `gsh http run api/users.http [--request <name|index>]` — runs one
    (default: the first). Output is one JSON line: `{"ok":{"status":200,
    "headers":{…},"elapsedMs":12,"json":{…}}}`; the body comes back as `json`
    when it parses as JSON, otherwise as `body`. A 4xx/5xx is a normal
    response — check `status`, not the exit code.
  - Prefer writing a `.http` when the human should see the request too: the app
    renders the same file as a request tab (editor + response), so they can
    re-run and tweak it themselves.
  - Outside a GSH tab, add `--workspace <id|path>`.

The `.http` file format itself (requests, variables) is documented in the
**gsh-design** skill, `references/http.md`.

- `gsh panel new --template <dashboard|list-detail|form> <file.panel>` —
  writes an embedded template (refuses to overwrite) and opens it. Templates
  and the design rules are in the **gsh-design** skill.
- `gsh panel screenshot [<label|tab-id|file.panel>] [--out <file.png>]` —
  PNG of an open `.panel` tab (default: your own tab, or the tab holding the
  file). Without `--out` writes a temp file and prints the path; read that
  image to see what the human sees. Fails if the panel is not visible yet.

