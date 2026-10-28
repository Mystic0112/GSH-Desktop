import 'package:gsh_desktop/app/gsh/data/hooks/claude_permission_hook.dart';
import 'dart:async' show unawaited;
import 'dart:convert';
import 'dart:io' show Directory, File, FileSystemException, Platform;

import 'package:gsh_remote/gsh_remote.dart' show RemoteRpcException;
import 'package:gsh_desktop/app/gsh/ui/viewmodels/team_post.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/team_shell_bridge.dart';
import 'package:gsh_desktop/app/gsh/data/remote/remote_host_connector.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/layout_spec.dart';
import 'package:gsh_desktop/app/core/data/diagnostics/diagnostics_log.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/http_request_runner.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/task_discovery.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/task_runner_gateway.dart';
import 'package:gsh_desktop/app/gsh/domain/contracts/terminal_status_server.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/db_connection.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/db_result.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/dbq_document.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/http_document.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/notebook_document.dart';
import 'package:gsh_desktop/app/gsh/domain/exceptions/http_request_error.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/project.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/task_definition.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/remote_host.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/remote_workspace_pin.dart';
import 'package:gsh_desktop/app/gsh/data/remote/ssh_tunnel.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/sql_statements.dart';
import 'package:gsh_desktop/app/gsh/domain/services/db_access_gate.dart';
import 'package:gsh_desktop/app/gsh/domain/services/db_query_service.dart';
import 'package:gsh_desktop/app/gsh/domain/services/mongo_browse_service.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/browser_capability.dart';
import 'package:gsh_desktop/app/core/domain/result.dart';
import 'package:gsh_desktop/app/core/utils/path_utils.dart';
import 'package:gsh_desktop/app/core/utils/shell_command.dart';
import 'package:gsh_desktop/app/gsh/ui/document/document_windows.dart';
import 'package:gsh_desktop/app/gsh/ui/session/agent_graph_session.dart';
import 'package:gsh_desktop/app/gsh/ui/session/farm_session.dart';
import 'package:gsh_desktop/app/gsh/ui/session/chat_session.dart';
import 'package:gsh_desktop/app/gsh/ui/session/empty_tab.dart';
import 'package:gsh_desktop/app/gsh/ui/session/external_agent.dart';
import 'package:gsh_desktop/app/gsh/ui/session/browser_session.dart';
import 'package:gsh_desktop/app/gsh/ui/session/notebook_session.dart';
import 'package:gsh_desktop/app/gsh/ui/session/file_viewer_session.dart';
import 'package:gsh_desktop/app/gsh/ui/widgets/panel_view.dart';
import 'package:gsh_desktop/app/gsh/ui/session/mongo_browser_session.dart';
import 'package:gsh_desktop/app/gsh/ui/session/neovim_session.dart';
import 'package:gsh_desktop/app/gsh/ui/session/pane_item.dart';
import 'package:gsh_desktop/app/gsh/ui/session/redis_browser_session.dart';
import 'package:gsh_desktop/app/gsh/ui/session/task_output_session.dart';
import 'package:gsh_desktop/app/gsh/ui/session/task_terminal_store.dart';
import 'package:gsh_desktop/app/gsh/ui/session/terminal_read_window.dart';
import 'package:gsh_desktop/app/gsh/ui/session/terminal_session.dart';
import 'package:gsh_desktop/app/gsh/ui/states/pane_node.dart' show SplitDir;
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_graph_store.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_message_delivery.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/agent_message_log.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/gsh_viewmodel.dart';
import 'package:gsh_desktop/app/gsh/ui/viewmodels/telemetry_cli_handler.dart';

/// Atende os comandos da CLI interna `gsh` (mesmo socket do
/// `TerminalStatusServer`), extraído do `GshViewModel` (refactor
/// 2026-07-19). Roda **fora** da árvore de widgets — não toca `BuildContext`,
/// só lê/muta o estado do shell via a API pública do VM. Retorna rápido (o
/// `insertText` só enfileira o write no PTY).
class GshCliHandler {
  GshCliHandler(
    this._vm,
    this._db,
    this._http,
    this._tasks,
    this._taskRuns,
    this._taskTerms,
    this._telemetry,
  );

  final GshViewModel _vm;
  final TelemetryCliHandler _telemetry;
  final DbQueryService _db;
  final HttpRequestRunner _http;
  final TaskDiscovery _tasks;
  final TaskRunnerGateway _taskRuns;
  final TaskTerminalStore _taskTerms;

  /// Contexto de tasks REMOTO por workspace (plano 58): a página pluga a
  /// mesma fábrica que serve o painel Tasks (par descoberta + runner do host,
  /// cacheado por host). `null` = workspace local. Sem isto, `list-tasks` numa
  /// aba de host remoto tentava descobrir tasks num caminho que só existe lá.
  ({TaskDiscovery discovery, TaskRunnerGateway runner})? Function(
    String workspaceId,
  )?
  remoteContextFor;

  /// Workspace + raiz de tasks + (descoberta, runner) do comando: workspace da
  /// aba emissora (default da CLI = a própria tab) ou o selecionado. Remoto
  /// resolve pelo [remoteContextFor]; local usa os binds do módulo.
  ({
    Project project,
    String root,
    TaskDiscovery discovery,
    TaskRunnerGateway runner,
  })?
  _taskContext(GshCommand c) {
    final sender = c.tabId == null ? null : _vm.session(c.tabId!);
    final project = sender != null
        ? _vm.projectById(sender.projectId)
        : _vm.selectedProject;
    final root = project?.effectiveRoot ?? '';
    if (project == null || project.isSystemTerminal || root.isEmpty) {
      return null;
    }
    final remote = remoteContextFor?.call(project.id);
    return (
      project: project,
      root: root,
      discovery: remote?.discovery ?? _tasks,
      runner: remote?.runner ?? _taskRuns,
    );
  }

  /// Task [taskId] do contexto [ctx], ou `null` se não existe nele.
  Future<TaskDefinition?> _findTask(
    ({
      Project project,
      String root,
      TaskDiscovery discovery,
      TaskRunnerGateway runner,
    })
    ctx,
    String taskId,
  ) async {
    final defs = await ctx.discovery.discover(ctx.root);
    for (final d in defs) {
      if (d.id == taskId) return d;
    }
    return null;
  }

  /// Atende um comando da CLI interna `gsh` (via o mesmo socket do
  /// [TerminalStatusServer]). Roda **fora** da árvore de widgets — não toca
  /// `BuildContext`, só lê/muta o estado da VM. Retorna rápido (o `insertText`
  /// só enfileira o write no PTY).
  Future<GshCommandResult> handle(GshCommand rawCommand) async {
    // `--focused` chega como o sentinela `@focused` no `tabId`: quem sabe qual
    // aba está em foco é a VM, não a CLI. Resolver aqui (e não em cada case)
    // vale pra todo comando que mira aba. Ferramenta externa (ditado por voz,
    // por exemplo) não tem como saber o id, e copiá-lo a cada uso é inviável.
    final focused = _resolveFocusSentinel(rawCommand);
    if (focused == null) {
      return const GshCommandResult.fail(
        'no focused tab (is a workspace open?)',
      );
    }
    final GshCommand c;
    switch (actAsMcpFrom(focused, _vm.allSessions)) {
      case Success(:final value):
        c = value;
      case Failure(:final error):
        return GshCommandResult.fail(error);
    }
    // Telemetria (plano 66): verbos `telemetry-*` têm handler próprio; o
    // workspace é o da aba emissora (ou `--workspace`), como no `db`.
    if (TelemetryCliHandler.handles(c.cmd)) {
      // `--app` (plano 68): store do próprio GSH, sem workspace.
      if (c.args['app'] == true) return _telemetry.handle(c, null, '');
      return _projectCommand(
        c,
        (project, root) => _telemetry.handle(c, project, root),
      );
    }
    switch (c.cmd) {
      // `send` e `send-key` chegam unificados como `write` (a CLI já resolveu o
      // texto/tecla em bytes UTF-8, transmitidos em base64 pra não quebrar o
      // framing de uma-linha-por-conexão).
      case 'write':
        final id = c.tabId;
        if (id == null || id.isEmpty) {
          return const GshCommandResult.fail(
            'missing tabId (use --tab-id or run inside a GSH terminal)',
          );
        }
        final s = _vm.session(id);
        if (s == null) {
          return GshCommandResult.fail('tab "$id" does not exist');
        }
        if (s is! TerminalSession) {
          return GshCommandResult.fail('tab "$id" is not a terminal');
        }
        final raw = (c.args['data'] ?? '').toString();
        String text;
        try {
          text = utf8.decode(base64.decode(raw));
        } catch (_) {
          return const GshCommandResult.fail('invalid data (base64 expected)');
        }
        s.insertText(text);
        return const GshCommandResult.ok();

      case 'list-panes':
        final focusedId = _vm.focusedTabId;
        final panes = _vm.allSessions
            .map(
              (s) => <String, dynamic>{
                'id': s.id,
                'kind': _paneKind(s),
                'title': s.title,
                // Rótulo manual estável (duplo-clique / "Rename"); `null` quando
                // a aba segue o título automático. É por ESTE campo que a
                // orquestração resolve pane por nome — não pelo `title` dinâmico
                // (que o claude/OSC reescrevem) nem pelo cwd (volátil).
                'label': s.manualLabel,
                'workspaceId': s.projectId,
                // Raiz do workspace no disco. `workspaceId` é um UUID opaco
                // desde a migração dos realms — quem precisa do caminho (ex.:
                // scripts que casavam por sufixo) usa este campo.
                'workspacePath': _vm.projectById(s.projectId)?.effectiveRoot,
                // Aba de task output → id da task espelhada (`npm:dev`…), o
                // mesmo aceito por `read-task`. Ausente nas demais tabs.
                if (s is TaskOutputSession) 'taskId': s.taskId,
                'working': s.isWorking,
                // Harness detectado no processo da aba (`HarnessKind.name`:
                // `claudeCode`, `antigravity`…), `null` fora de agente.
                'harness': s is TerminalSession ? s.activeHarness?.name : null,
                // Aba em foco (a que `--focused` mira). Sempre no máximo uma.
                'focused': s.id == focusedId,
              },
            )
            .toList();
        return GshCommandResult.ok(panes);

      // `gsh hook` no PermissionRequest do Claude: segura até a decisão na
      // ilha/notificação e devolve a saída do hook (`null` = o terminal
      // pergunta). Quem está olhando a aba responde no próprio terminal.
      case 'permission-ask':
        final id = c.tabId;
        final tab = id == null ? null : _vm.session(id);
        if (tab is! TerminalSession) return const GshCommandResult.ok({});
        if (_vm.notifications.windowFocused && _vm.focusedTabId == tab.id) {
          return const GshCommandResult.ok({});
        }
        final ask = parseClaudePermissionAsk(
          c.args,
          id: 'p${++_permissionSeq}',
          tabId: tab.id,
        );
        final decision = await _vm.permissions.ask(ask);
        return GshCommandResult.ok({
          'output': claudePermissionHookOutput(ask, decision),
        });

      // `gsh msg --to <label|tab-id> <texto>` — agente fala com agente.
      // `tabId` é o EMISSOR (a CLI exige `$GSH_TAB_ID`), `to` o alvo.
      case 'msg':
        return _sendAgentMessage(c);

      // `gsh deliver --to <Fulano/aba> <arquivo> [nota]` — entrega um arquivo
      // ao agente de um colega do time (cai na caixa de entrada da pasta dele).
      case 'deliver':
        final sender = _agentCaller(c.tabId);
        if (sender == null) return _unknownCaller(c.tabId);
        final to = (c.args['to'] ?? '').toString();
        final path = (c.args['path'] ?? '').toString();
        if (to.isEmpty) return const GshCommandResult.fail('missing --to');
        if (path.isEmpty) return const GshCommandResult.fail('missing file');
        return _teamSend(
          sender,
          to,
          (c.args['text'] ?? '').toString(),
          filePath: path,
        );

      // `gsh peers` — links definidos no grafo de agentes da aba emissora
      // (ou do nó externo `ext:<app>`, pelo `peers` do MCP).
      // `agents` — todo agente do workspace (o `list_agents` do MCP).
      case 'peers' || 'agents':
        final caller = _agentCaller(c.tabId);
        if (caller == null) return _unknownCaller(c.tabId);
        return GshCommandResult.ok([
          ...(c.cmd == 'peers' ? agentPeers : workspaceAgentList)(
            _vm.agentGraph,
            caller,
            _vm.allSessions,
          ),
          // Agentes de colegas do time na rede (`--to Fulano/aba`).
          for (final t in _vm.teamPost.contacts)
            {
              'id': t.address,
              'label': t.address,
              'title': t.agent.project,
              'harness': t.agent.harness,
              'working': false,
              'team': true,
            },
        ]);

      // Servidor MCP de app desktop (`gsh mcp`): batimento de presença e
      // long-poll da fila do nó externo `tabId` = `ext:<app>`.
      case 'ext-ping':
        final e = _vm.agentGraph.externalById(c.tabId ?? '');
        if (e == null) return _unknownCaller(c.tabId);
        e.heartbeat();
        return const GshCommandResult.ok();
      // `wait_messages` do MCP: fila do nó externo, ou — `gsh mcp` agindo
      // como aba (Codex) — o log de mensagens pra aba desde a última chamada.
      // Teto de 55s: o cliente MCP do Claude Desktop corta a requisição em ~60s.
      case 'ext-wait':
        final secs = ((c.args['timeout'] as num?)?.toInt() ?? 45).clamp(0, 55);
        final e = _vm.agentGraph.externalById(c.tabId ?? '');
        if (e == null) return _waitAsTab(c.tabId, Duration(seconds: secs));
        e.markActive();
        final msgs = await e.waitMessages(Duration(seconds: secs));
        return GshCommandResult.ok([
          for (final m in msgs)
            {
              'from': m.from,
              'text': m.text,
              'sentAt': m.sentAt.toIso8601String(),
            },
        ]);

      // `gsh mcp` pergunta quem é: a aba cuja árvore de processos contém
      // ele (`pids` = ele e os ancestrais; o Codex da aba o spawnou). `tabId` =
      // o `GSH_TAB_ID` que ele herdou, se herdou (só vale onde a árvore não
      // é visível). Falha = não está sob aba nenhuma: o servidor vira o nó
      // externo do `--agent`.
      case 'mcp-whoami':
        final hint = c.tabId;
        final pids = c.args['pids'];
        final id = await _vm.tabOwningProcess(
          [
            if (pids is List)
              for (final p in pids)
                if (p is num) p.toInt(),
          ],
          hint: hint != null && _vm.session(hint) is TerminalSession
              ? hint
              : null,
        );
        final tab = id == null ? null : _vm.session(id);
        if (tab is! TerminalSession) {
          return const GshCommandResult.fail('not inside a GSH terminal');
        }
        _vm.agentMessages.markRead(tab.id);
        return GshCommandResult.ok({
          'tabId': tab.id,
          'label': tab.displayTitle,
        });

      // `gsh open <path>` — abre um arquivo no viewer. A CLI já resolveu
      // pro caminho absoluto (o cwd do pane ≠ cwd do app). Abre no workspace do
      // pane que emitiu (trazendo-o pra frente se não for o ativo) e como aba
      // ao lado do próprio terminal (mesma folha).
      case 'open':
        final path = (c.args['path'] ?? '').toString();
        if (path.isEmpty) {
          return const GshCommandResult.fail('missing path');
        }
        // Aba remota: o path é do HOST. Checar no disco do cliente daria
        // "file not found" (ou, pior, abriria um homônimo local) — quem valida
        // é o `fs.read` do outro lado, dentro de `openFile`.
        // `.notebook` é pasta e abre como caderno; o resto tem que ser arquivo.
        if (!_isRemoteTab(c.tabId) &&
            !await File(path).exists() &&
            !(isNotebookFolder(path) && await Directory(path).exists())) {
          return GshCommandResult.fail('file not found: "$path"');
        }
        final from = c.tabId;
        String? targetProject;
        String? targetLeaf;
        if (from != null && from.isNotEmpty) {
          final s = _vm.session(from);
          if (s != null) {
            targetProject = s.projectId;
            targetLeaf = _vm.leafOfTab(targetProject, from);
          }
        }
        if (targetProject != null && targetProject != _vm.selectedProjectId) {
          _vm.selectProject(targetProject);
        }
        if (_vm.selectedProjectId == null) {
          return const GshCommandResult.fail(
            'no active workspace to open the file in',
          );
        }
        await _vm.openFile(path, inPane: targetLeaf, isPreview: false);
        return const GshCommandResult.ok();

      // `open-document` — abre cada caminho numa janela de documento. Não é um
      // verbo da CLI: é o que o SEGUNDO processo do GSH (duplo clique no
      // Explorer/xdg) manda pro app vivo antes de sair (instância única no
      // Windows/Linux, ver `RunningInstance`). Não depende de workspace ativo.
      case 'open-document':
        final raw = c.args['paths'];
        final paths = raw is List
            ? raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
            : const <String>[];
        if (paths.isEmpty) {
          return const GshCommandResult.fail('missing paths');
        }
        for (final path in paths) {
          if (await File(path).exists() || await Directory(path).exists()) {
            unawaited(DocumentWindows.open(path));
          }
        }
        return const GshCommandResult.ok();

      // `apply-layout` — o botão Apply do viewer de `.ckp` aberto na JANELA DE
      // DOCUMENTO. Também não é verbo da CLI (quem aplica layout por script é
      // o `orchestrate`, que tem uma aba emissora para se ancorar): a janela
      // solta não tem workspace, então empurra o caminho para o app, que
      // resolve o destino e pede a confirmação com a janela na frente.
      case 'apply-layout':
        final path = (c.args['path'] ?? '').toString();
        if (path.isEmpty) {
          return const GshCommandResult.fail('missing path');
        }
        if (!await File(path).exists()) {
          return GshCommandResult.fail('file not found: "$path"');
        }
        _vm.requestLayoutApply(path);
        return const GshCommandResult.ok();

      // `gsh new-tab` — cria uma aba de terminal. A CLI já resolveu o cwd
      // pro absoluto. Ancora no workspace/pane da tab emissora (trazendo o
      // workspace pra frente, mesma regra do `open`); `split` = right|down
      // divide a pane em vez de anexar a aba. Devolve `{tabId}` da tab criada.
      case 'new-tab':
        final cwd = (c.args['cwd'] ?? '').toString();
        if (cwd.isEmpty) {
          return const GshCommandResult.fail('missing cwd');
        }
        // Idem `open`: num terminal remoto o cwd é uma pasta do host.
        if (!_isRemoteTab(c.tabId) && !await Directory(cwd).exists()) {
          return GshCommandResult.fail('directory not found: "$cwd"');
        }
        final split = (c.args['split'] ?? '').toString();
        // Wire usa a geometria (right|down), não os nomes do SplitDir — o
        // enum é contra-intuitivo (vertical = lado a lado).
        final SplitDir? splitDir;
        switch (split) {
          case '':
            splitDir = null;
          case 'right':
            splitDir = SplitDir.vertical;
          case 'down':
            splitDir = SplitDir.horizontal;
          default:
            return GshCommandResult.fail(
              'invalid split "$split" (expected right or down)',
            );
        }
        final title = (c.args['title'] ?? '').toString();
        final sender = c.tabId == null ? null : _vm.session(c.tabId!);
        String? anchorLeaf;
        if (sender != null) {
          if (sender.projectId != _vm.selectedProjectId) {
            _vm.selectProject(sender.projectId);
          }
          anchorLeaf = _vm.leafOfTab(sender.projectId, sender.id);
        }
        final created = _vm.newTerminalTab(
          cwd: cwd,
          title: title.isEmpty ? null : title,
          inPane: anchorLeaf,
          splitDir: splitDir,
        );
        return switch (created) {
          Success(:final value) => GshCommandResult.ok({'tabId': value}),
          Failure(:final error) => GshCommandResult.fail(error),
        };

      // `gsh close-tab [<label|tab-id>]` — fecha uma aba (a contraparte do
      // `new-tab`). Sem alvo, fecha a PRÓPRIA aba emissora.
      //
      // Mesma semântica do "x" da UI (`closeTab`): a última aba de uma folha
      // remove a folha; a última folha do workspace vira uma aba vazia.
      case 'close-tab':
        final target = (c.args['target'] ?? '').toString();
        final PaneItem? s;
        if (target.isNotEmpty) {
          final resolved = _resolvePaneTarget(target);
          if (resolved case Failure(:final error)) {
            return GshCommandResult.fail(error);
          }
          s = (resolved as Success<PaneItem, String>).value;
        } else {
          final id = c.tabId;
          if (id == null || id.isEmpty) {
            return const GshCommandResult.fail(
              'missing target (pass <label|tab-id> or run inside a GSH '
              'terminal)',
            );
          }
          s = _vm.session(id);
          if (s == null) {
            return GshCommandResult.fail('tab "$id" does not exist');
          }
        }
        // `closeTab` opera sobre o workspace ATIVO (lê `_activeTree`), então
        // fechar aba de outro workspace exige trazê-lo pra frente antes —
        // mesma regra do `open`/`new-tab`.
        if (s.projectId != _vm.selectedProjectId) {
          _vm.selectProject(s.projectId);
        }
        final leaf = _vm.leafOfTab(s.projectId, s.id);
        if (leaf == null) {
          return GshCommandResult.fail(
            'tab "${s.id}" is not in any pane (already closed?)',
          );
        }
        if (s is NeovimSession) {
          final modified = await s.hasModifiedBuffers();
          if (modified case Success(value: true)) {
            return const GshCommandResult.fail(
              'Neovim has modified buffers; close it from the UI to confirm',
            );
          }
        }
        // O fechamento roda DEPOIS da resposta (`afterResponse`): fechar a
        // própria aba emissora mata o PTY — e com ele o shell e o processo
        // `gsh` que espera o `ok` neste socket. Fechando aqui, o sucesso
        // viraria erro de transporte na tela. Tudo que pode falhar (resolver
        // alvo, achar a folha) já foi validado acima, então nada de erro se
        // perde no adiamento.
        final closingLeaf = leaf;
        final closingId = s.id;
        return GshCommandResult.ok({
          'tabId': s.id,
        }, () => _vm.closeTab(closingLeaf, closingId));

      // `gsh orchestrate <file.ckp> [--append]` — aplica um layout de
      // panes no workspace ativo. A CLI já resolveu o path pro absoluto.
      // Default = REPLACE (fecha as abas do workspace antes, sem diálogo: a
      // CLI não pergunta); `--append` = merge idempotente antigo (tab de mesmo
      // nome = pulada). Devolve {created, skipped, closed}.
      // `gsh note add <dir.notebook> --title T [--tag a]... [--body ...]`
      // Cria a nota com frontmatter certo (tag `agent` sempre entra — é a
      // marca de nota escrita por agente) e recarrega a aba do caderno se
      // estiver aberta. Devolve `{path}`. A pasta é criada se faltar.
      case 'note-add':
        {
          final dir = (c.args['notebook'] ?? '').toString();
          if (dir.isEmpty || !isNotebookFolder(dir)) {
            return const GshCommandResult.fail(
              'notebook must be a folder ending in .notebook',
            );
          }
          final title = (c.args['title'] ?? '').toString().trim();
          if (title.isEmpty) {
            return const GshCommandResult.fail('missing --title');
          }
          final rawTags = c.args['tags'];
          final tags = <String>{
            if (rawTags is List) ...rawTags.map((e) => e.toString()),
            kAgentTag,
          }.toList();
          final body = (c.args['body'] ?? '').toString();
          if (!_isRemoteTab(c.tabId)) {
            try {
              await Directory(dir).create(recursive: true);
            } on FileSystemException catch (e) {
              return GshCommandResult.fail(
                'cannot create "$dir": ${e.message}',
              );
            }
          }
          final now = DateTime.now();
          var name = NotebookNote.fileNameFor(title, now);
          final taken = (await _vm.listChildren(
            dir,
          )).map((e) => e.name).toSet();
          var i = 2;
          while (taken.contains(name)) {
            name = NotebookNote.fileNameFor('$title $i', now);
            i++;
          }
          final path = '$dir/$name';
          final ok = await _vm.writeTextAt(
            path,
            NotebookNote.template(
              title: title,
              tags: tags,
              now: now,
              body: body,
            ),
          );
          if (!ok) return GshCommandResult.fail('could not write "$path"');
          _vm.notebookSessionFor(dir)?.requestReload();
          return GshCommandResult.ok({'path': path});
        }

      // `gsh note list <dir.notebook>` — notas com título e tags.
      case 'note-list':
        {
          final dir = (c.args['notebook'] ?? '').toString();
          if (dir.isEmpty || !isNotebookFolder(dir)) {
            return const GshCommandResult.fail(
              'notebook must be a folder ending in .notebook',
            );
          }
          final out = <Map<String, dynamic>>[];
          for (final e in await _vm.listChildren(dir)) {
            if (e.isDirectory || !e.name.toLowerCase().endsWith('.md')) {
              continue;
            }
            final raw = await _vm.readTextAt(e.path);
            if (raw == null) continue;
            final n = NotebookNote.parse(e.path, raw);
            out.add({'path': n.path, 'title': n.title, 'tags': n.tags});
          }
          return GshCommandResult.ok(out);
        }

      case 'orchestrate':
        final path = (c.args['path'] ?? '').toString();
        if (path.isEmpty) {
          return const GshCommandResult.fail('missing path');
        }
        final sender = c.tabId == null ? null : _vm.session(c.tabId!);
        if (sender != null && sender.projectId != _vm.selectedProjectId) {
          _vm.selectProject(sender.projectId);
        }
        final append = c.args['append'] == true;
        // A aba emissora sobrevive ao replace: fechá-la mataria o `gsh`
        // que ainda espera esta resposta.
        final applied = await _vm.applyLayoutFile(
          path,
          mode: append ? LayoutApplyMode.append : LayoutApplyMode.replace,
          keepTabId: sender?.id,
        );
        return switch (applied) {
          Success(:final value) => GshCommandResult.ok({
            'created': value.created,
            'skipped': value.skipped,
            'closed': value.closed,
          }),
          Failure(:final error) => GshCommandResult.fail(error),
        };

      case 'list-workspaces':
        final ws = _vm.projects
            .map(
              (p) => <String, dynamic>{
                'id': p.id,
                'name': p.name,
                // Raiz do workspace na máquina onde ele vive (mesma razão do
                // `workspacePath` do list-panes: o `id` virou UUID opaco; antes
                // o path ERA o id). Num workspace remoto é a pasta do HOST —
                // reportar o `path` cru mostrava '' e sugeria "sem pasta".
                'path': p.effectiveRoot,
                // Nº de tabs (sessões) abertas nesse workspace. Campo era 'panes'
                // (enganoso — sempre foi contagem de tabs, não de folhas-pane).
                'tabs': _vm.allSessions
                    .where((s) => s.projectId == p.id)
                    .length,
              },
            )
            .toList();
        return GshCommandResult.ok(ws);

      // `gsh new-workspace <path> [--host <host>] [--name <name>]`
      // `gsh new-remote-workspace --host <host> --path <path> [--name <name>]`
      // Adiciona um workspace como projeto de primeiro nível no rail (local ou
      // remoto). Idempotente: se já estiver aberto, seleciona e devolve os
      // dados do workspace.
      case 'new-remote-workspace':
      case 'new-workspace':
      case 'open-workspace':
        final hostRef = (c.args['host'] ?? '').toString().trim();
        final rawPath = (c.args['path'] ?? '').toString().trim();
        if (rawPath.isEmpty) {
          return const GshCommandResult.fail('missing path');
        }
        final rawName = (c.args['name'] ?? '').toString().trim();
        final customName = rawName.isEmpty ? null : rawName;

        if (hostRef.isNotEmpty) {
          // Workspace REMOTO (plano 58 / dd-swarm):
          // Resolve host existente (por id/sshTarget/nome) ou registra
          // automaticamente com o sshTarget (ex: alias do ~/.ssh/config).
          final host = await _resolveOrRegisterRemoteHost(hostRef);
          final cleanPath = await _resolveRemotePath(host, rawPath);
          await _vm.createRemoteWorkspace(host.id, cleanPath);
          final workspaceId =
              '${Project.remotePrefix}${RemoteWorkspacePin.idFor(host.id, cleanPath)}';
          if (customName != null) {
            await _vm.updateRemoteWorkspace(workspaceId, name: customName);
          }
          final sessions = _vm.allSessions
              .where((s) => s.projectId == workspaceId)
              .toList();
          if (sessions.isEmpty || sessions.every((s) => s is EmptyTab)) {
            _vm.newTerminalTab(cwd: cleanPath);
          }
          final project = _vm.projectById(workspaceId);
          final tabCount = _vm.allSessions
              .where((s) => s.projectId == workspaceId)
              .length;
          return GshCommandResult.ok({
            'id': workspaceId,
            'name': project?.name ?? (customName ?? cleanPath),
            'path': project?.effectiveRoot ?? cleanPath,
            'host': host.sshTarget,
            'tabs': tabCount,
          });
        }

        // Workspace LOCAL
        final cleanPath = _cleanWorkspacePath(rawPath);
        if (!_isRemoteTab(c.tabId) && !await Directory(cleanPath).exists()) {
          return GshCommandResult.fail('directory not found: "$cleanPath"');
        }

        final project = await _vm.addProject(cleanPath, name: customName);
        _vm.selectProject(project.id);

        if (customName != null && customName != project.name) {
          await _vm.updateProject(project.id, name: customName);
        }

        final sessions = _vm.allSessions
            .where((s) => s.projectId == project.id)
            .toList();
        if (sessions.isEmpty || sessions.every((s) => s is EmptyTab)) {
          _vm.newTerminalTab(cwd: project.effectiveRoot);
        }

        final resolved = _vm.projectById(project.id) ?? project;
        final tabCount = _vm.allSessions
            .where((s) => s.projectId == resolved.id)
            .length;

        return GshCommandResult.ok({
          'id': resolved.id,
          'name': resolved.name,
          'path': resolved.effectiveRoot,
          'tabs': tabCount,
        });

      // `gsh close-workspace [<id|path>]` — fecha/remove o workspace do
      // GSH (mantém os arquivos no disco). Suporta workspaces locais e remotos.
      // O encerramento roda em `afterResponse` para permitir que o socket
      // responda antes de derrubar o PTY/shell caso o comando venha de dentro
      // do workspace fechado.
      case 'close-workspace':
        final target = (c.args['target'] ?? '').toString().trim();
        final Project? project;
        if (target.isNotEmpty) {
          project = _resolveWorkspace(target);
          if (project == null) {
            return GshCommandResult.fail('no workspace matches "$target"');
          }
        } else {
          final sender = c.tabId == null ? null : _vm.session(c.tabId!);
          project = sender != null
              ? _vm.projectById(sender.projectId)
              : _vm.selectedProject;
          if (project == null) {
            return const GshCommandResult.fail(
              'missing target workspace (pass <id|path> or run inside a GSH workspace)',
            );
          }
        }
        if (project.isSystemTerminal) {
          return const GshCommandResult.fail(
            'cannot close the system terminal workspace',
          );
        }
        final isRemote = project.isRemoteTerminal;
        final closingId = project.id;
        final closingPath = project.effectiveRoot;
        return GshCommandResult.ok(
          {'id': closingId, 'path': closingPath, 'closed': true},
          () {
            if (isRemote) {
              unawaited(_vm.removeRemoteWorkspace(closingId));
            } else {
              unawaited(_vm.removeProject(closingId));
            }
          },
        );

      // `gsh rename-workspace [<id|path>] <new-name>` — renomeia o título
      // de exibição do workspace no rail (local ou remoto).
      case 'rename-workspace':
        final target = (c.args['target'] ?? '').toString().trim();
        final newName = (c.args['name'] ?? '').toString().trim();
        if (newName.isEmpty) {
          return const GshCommandResult.fail('missing new workspace name');
        }
        final Project? project;
        if (target.isNotEmpty) {
          project = _resolveWorkspace(target);
          if (project == null) {
            return GshCommandResult.fail('no workspace matches "$target"');
          }
        } else {
          final sender = c.tabId == null ? null : _vm.session(c.tabId!);
          project = sender != null
              ? _vm.projectById(sender.projectId)
              : _vm.selectedProject;
          if (project == null) {
            return const GshCommandResult.fail(
              'missing target workspace (pass <id|path> or run inside a GSH workspace)',
            );
          }
        }
        if (project.isSystemTerminal) {
          return const GshCommandResult.fail(
            'cannot rename the system terminal workspace',
          );
        }
        if (project.isRemoteTerminal) {
          await _vm.updateRemoteWorkspace(project.id, name: newName);
        } else {
          await _vm.updateProject(project.id, name: newName);
        }
        final renamed = _vm.projectById(project.id) ?? project;
        return GshCommandResult.ok({
          'id': renamed.id,
          'name': renamed.name,
          'path': renamed.effectiveRoot,
        });

      // `gsh read-pane [<label|tab-id>]` — devolve uma janela de linhas do
      // buffer renderizado do pane (texto plano, sem ANSI — é o que o xterm já
      // pintou). Args: `lines` (default 100), `offset` (pula N a partir da
      // âncora), `fromStart` (âncora no começo; default = fim/tail). A ordem
      // das linhas é sempre cronológica — as flags só escolhem a janela.
      case 'read-pane':
        final target = (c.args['target'] ?? '').toString();
        final PaneItem? s;
        if (target.isNotEmpty) {
          final resolved = _resolvePaneTarget(target);
          if (resolved case Failure(:final error)) {
            return GshCommandResult.fail(error);
          }
          s = (resolved as Success<PaneItem, String>).value;
        } else {
          final id = c.tabId;
          if (id == null || id.isEmpty) {
            return const GshCommandResult.fail(
              'missing target (pass <label|tab-id> or run inside a GSH '
              'terminal)',
            );
          }
          s = _vm.session(id);
          if (s == null) {
            return GshCommandResult.fail('tab "$id" does not exist');
          }
        }
        final term = switch (s) {
          TerminalSession t => t.terminal,
          TaskOutputSession t => t.terminal,
          _ => null,
        };
        if (term == null) {
          return GshCommandResult.fail(
            'tab "${s.id}" (${_paneKind(s)}) has no readable output',
          );
        }
        return GshCommandResult.ok(readTerminalWindow(term, c.args));

      // `gsh exec <command...>` (plano 67) — roda uma linha de shell na
      // máquina do app e devolve stdout/stderr/exit code. O shell é o **perfil
      // de terminal padrão** das configurações (o mesmo que o `+` abre: no
      // Windows, PowerShell/cmd/WSL; no POSIX, o login shell com `-lc`). É o
      // que os botões de um `.panel` usam por baixo; o env leva o roteamento
      // da CLI (`GSH_TAB_ID`, socket, PATH do `gsh`), então o comando
      // pode chamar `gsh` de volta.
      case 'exec':
        final command = (c.args['command'] ?? '').toString();
        if (command.trim().isEmpty) {
          return const GshCommandResult.fail('missing command');
        }
        final cwd = (c.args['cwd'] ?? '').toString();
        final timeoutRaw = c.args['timeout'];
        final timeout = timeoutRaw is num ? timeoutRaw.toInt() : 60;
        // Aba remota: o comando e o cwd são do HOST. Roda lá via `proc.run`
        // (gsh-server ≥ 2.1.13); antes executava aqui, com um cwd que
        // não existe neste disco, e o `.panel` remoto recebia erro em tudo.
        if (_isRemoteTab(c.tabId)) {
          final session = _vm.session(c.tabId!);
          final host = session == null
              ? null
              : _vm.remote.hostForWorkspace(session.projectId);
          if (host == null) {
            return const GshCommandResult.fail('remote host not found');
          }
          try {
            final proc = await _vm.remoteHosts.procServiceFor(host);
            final data = await proc.run(
              command,
              cwd: cwd,
              timeoutSeconds: timeout <= 0 ? 60 : timeout,
            );
            return GshCommandResult.ok(data);
          } on RemoteRpcException catch (e) {
            return GshCommandResult.fail(switch (e.code) {
              'cwd_not_found' => 'cwd not found on host: "$cwd"',
              'unknown_method' =>
                'the gsh-server on this host is too old for exec '
                    '(update it: curl -fsSL '
                    'https://remote-pi.jacobmoura.work/gsh-server.sh | bash)',
              _ => 'exec failed on host: ${e.detail ?? e.code}',
            });
          } on RemoteHostException catch (e) {
            return GshCommandResult.fail('host unreachable: ${e.kind.name}');
          }
        }
        if (cwd.isNotEmpty && !await Directory(cwd).exists()) {
          return GshCommandResult.fail('cwd not found: "$cwd"');
        }
        final result = await runShellCommand(
          command,
          cwd: cwd.isEmpty ? null : cwd,
          environment: _vm.cliEnvironment(tabId: c.tabId),
          timeout: Duration(seconds: timeout <= 0 ? 60 : timeout),
          profile: _vm.defaultTerminalProfile,
        );
        return GshCommandResult.ok(result.toJson());

      // `gsh panel screenshot [<label|tab-id|file.panel>] [--out x.png]`
      // (plano 69): PNG da webview de um .panel aberto, pro agente ver o que
      // escreveu. Sem --out grava em arquivo temporário e devolve o caminho.
      case 'panel-screenshot':
        final target = (c.args['target'] ?? '').toString();
        final PaneItem? s;
        if (target.isNotEmpty) {
          if (target.endsWith('.panel')) {
            s = _vm.allSessions
                .whereType<FileViewerSession>()
                .cast<PaneItem?>()
                .firstWhere(
                  (x) => (x as FileViewerSession).path == target,
                  orElse: () => null,
                );
            if (s == null) {
              return GshCommandResult.fail('no open tab for "$target"');
            }
          } else {
            final resolved = _resolvePaneTarget(target);
            if (resolved case Failure(:final error)) {
              return GshCommandResult.fail(error);
            }
            s = (resolved as Success<PaneItem, String>).value;
          }
        } else {
          final id = c.tabId;
          s = (id == null || id.isEmpty) ? null : _vm.session(id);
          if (s == null) {
            return const GshCommandResult.fail(
              'missing target (pass <label|tab-id|file.panel> or run from the panel)',
            );
          }
        }
        if (s is! FileViewerSession ||
            !s.path.toLowerCase().endsWith('.panel')) {
          return GshCommandResult.fail('tab "${s.id}" is not a .panel');
        }
        final web = PanelWebViews.of(s.id);
        if (web == null) {
          return GshCommandResult.fail(
            'panel "${s.id}" has no web view yet (not visible or still loading)',
          );
        }
        final png = await web.takeScreenshot();
        if (png == null || png.isEmpty) {
          return const GshCommandResult.fail('screenshot failed');
        }
        final out = (c.args['out'] ?? '').toString();
        final file = out.isNotEmpty
            ? File(out)
            : File(
                '${Directory.systemTemp.path}/gsh-panel-${s.id}-'
                '${DateTime.now().millisecondsSinceEpoch}.png',
              );
        await file.parent.create(recursive: true);
        await file.writeAsBytes(png, flush: true);
        return GshCommandResult.ok({'path': file.path, 'bytes': png.length});

      // `gsh list-tasks` — tasks do workspace do pane emissor (tabId,
      // default da CLI = a própria tab; fallback: workspace selecionado).
      // Mesmos binds do painel Tasks → mesma lista que a UI. `id` é o aceito
      // por `read-task`; `hasOutput` diz se o read vai responder.
      case 'list-tasks':
        final ctx = _taskContext(c);
        if (ctx == null) {
          return const GshCommandResult.fail('no workspace to list tasks for');
        }
        final defs = await ctx.discovery.discover(ctx.root);
        final tasks = defs
            .map(
              (d) => <String, dynamic>{
                'id': d.id,
                'label': d.label,
                'kind': d.kind.name,
                'source': d.source.name,
                'running': ctx.runner.runOf(d.id).isActive,
                'hasOutput': _taskTerms.existingTerminal(d.id) != null,
                'profiles': [for (final p in d.profiles) p.name],
                'keys': [for (final k in d.interactiveKeys) k.key],
              },
            )
            .toList();
        return GshCommandResult.ok(tasks);

      // `gsh run-task|stop-task|restart-task <task-id>` e
      // `gsh send-task-key <task-id> <key>` — o agente dirige o painel
      // Tasks: o que a UI faz com botões, aqui por verbo. Mesmo runner da UI
      // (local ou do host remoto), então o estado do painel acompanha.
      case 'run-task':
      case 'stop-task':
      case 'restart-task':
      case 'send-task-key':
        final ctx = _taskContext(c);
        if (ctx == null) {
          return const GshCommandResult.fail('no workspace for tasks');
        }
        final taskId = (c.args['target'] ?? '').toString();
        if (taskId.isEmpty) {
          return const GshCommandResult.fail('missing task id');
        }
        final def = await _findTask(ctx, taskId);
        if (def == null) {
          return GshCommandResult.fail(
            'unknown task "$taskId" (see `gsh list-tasks`)',
          );
        }
        final running = ctx.runner.runOf(def.id).isActive;
        switch (c.cmd) {
          case 'run-task':
            final profile = (c.args['profile'] ?? '').toString();
            if (profile.isNotEmpty &&
                !def.profiles.any((p) => p.name == profile)) {
              return GshCommandResult.fail(
                'unknown profile "$profile" for "$taskId"',
              );
            }
            if (running) {
              if (c.args['restart'] != true) {
                return GshCommandResult.fail(
                  '"$taskId" is already running (use --restart)',
                );
              }
              await ctx.runner.stop(def.id);
            }
            await ctx.runner.start(
              def,
              profileName: profile.isEmpty ? null : profile,
            );
          case 'stop-task':
            if (!running) {
              return GshCommandResult.fail('"$taskId" is not running');
            }
            await ctx.runner.stop(def.id);
          case 'restart-task':
            if (running) {
              await ctx.runner.restart(def.id);
            } else {
              await ctx.runner.start(def);
            }
          case 'send-task-key':
            final key = (c.args['key'] ?? '').toString();
            if (key.isEmpty) {
              return const GshCommandResult.fail('missing key');
            }
            if (!running) {
              return GshCommandResult.fail('"$taskId" is not running');
            }
            ctx.runner.sendKey(def.id, key);
        }
        return GshCommandResult.ok({
          'taskId': def.id,
          'running': ctx.runner.runOf(def.id).isActive,
        });

      // `gsh read-task <task-id>` — mesma leitura, mas do terminal da task
      // no `TaskTerminalStore` (funciona mesmo sem aba `task_output` aberta).
      case 'read-task':
        final taskId = (c.args['target'] ?? '').toString();
        if (taskId.isEmpty) {
          return const GshCommandResult.fail('missing task id');
        }
        final term = _taskTerms.existingTerminal(taskId);
        if (term == null) {
          return GshCommandResult.fail(
            'no output recorded for task "$taskId" (never ran this boot?)',
          );
        }
        return GshCommandResult.ok(readTerminalWindow(term, c.args));

      // ── `gsh db …` (plano 51) — acesso a banco pros agentes. A CLI é
      // cliente magro: quem executa é o app (mesmo motor da tab `.dbq`), e a
      // credencial nunca sai daqui. Workspace do pane emissor; `--workspace
      // <id|path>` pra uso fora de pane. Erros de banco voltam como
      // `<kind>: <message>` (a CLI reconstrói o JSON `{"error":{…}}`).
      case 'db-list':
        return _dbCommand(c, (project, root) async {
          final conns = await _db.connections(root, workspaceId: project.id);
          return GshCommandResult.ok([
            // `agents: false` = invisível pros agentes (a GUI segue vendo).
            for (final conn in conns)
              if (conn.agents)
                {
                  'name': conn.name,
                  'engine': conn.engine.label,
                  'target': conn.displayTarget,
                  'origin': conn.origin.name,
                  'access': conn.access.name,
                },
          ]);
        });

      case 'db-schema':
        return _dbCommand(c, (project, root) async {
          final (conn, connErr) = await _agentConn(
            project,
            (c.args['db'] ?? '').toString(),
          );
          if (connErr != null) return GshCommandResult.fail(connErr);
          final table = (c.args['table'] ?? '').toString();
          final result = await _db.schema(
            workspaceRoot: root,
            workspaceId: project.id,
            connName: conn!.name,
            table: table.isEmpty ? null : table,
          );
          return GshCommandResult.ok(result.toJson());
        });

      case 'db-query':
      case 'db-execute':
        return _dbCommand(c, (project, root) async {
          final (conn, connErr) = await _agentConn(
            project,
            (c.args['db'] ?? '').toString(),
          );
          if (connErr != null) return GshCommandResult.fail(connErr);
          final sql = (c.args['sql'] ?? '').toString();
          // Guardrail (conexão `read`): execute é recusado de cara; query
          // passa pelo gate de statement (SELECT-like apenas).
          if (conn!.access == DbAccess.read) {
            if (c.cmd == 'db-execute') {
              return const GshCommandResult.fail(
                'read_only_connection: this connection is read-only for '
                'agents — enable Read & write on it in the Database panel',
              );
            }
            final violation = sqlReadViolation(sql);
            if (violation != null) return GshCommandResult.fail(violation);
          }
          final result = await _db.query(
            workspaceRoot: root,
            workspaceId: project.id,
            connName: conn.name,
            sql: sql,
            limit: int.tryParse('${c.args['limit'] ?? ''}'),
            dml: c.cmd == 'db-execute',
          );
          return GshCommandResult.ok(result.toJson());
        });

      // `gsh db run <file.dbq>` — executa o arquivo (frontmatter decide
      // conexão e limite). O path chega absoluto (a CLI resolve contra o cwd).
      case 'db-run':
        return _dbCommand(c, (project, root) async {
          final path = (c.args['path'] ?? '').toString();
          if (path.isEmpty) {
            return const GshCommandResult.fail('missing .dbq path');
          }
          final String content;
          try {
            content = await File(path).readAsString();
          } on FileSystemException catch (e) {
            return GshCommandResult.fail('cannot read "$path": ${e.message}');
          }
          final doc = DbqDocument.parse(content);
          if (doc.db == null) {
            return GshCommandResult.fail(
              'unknown_connection: "$path" has no "-- db:" frontmatter — '
              'pick a database in the GSH tab or add the line manually',
            );
          }
          final (conn, connErr) = await _agentConn(project, doc.db!);
          if (connErr != null) return GshCommandResult.fail(connErr);
          final statements = [
            for (final st in splitSqlStatements(doc.sql)) st.text,
          ];
          // Conexão `read`: cada statement do script passa pelo gate.
          if (conn!.access == DbAccess.read) {
            for (final st in statements) {
              final violation = sqlReadViolation(st);
              if (violation != null) {
                return GshCommandResult.fail(violation);
              }
            }
          }
          // Mesma semântica de script da tab: statements em sequência,
          // resultado do último.
          final result = await _db.runStatements(
            workspaceRoot: root,
            workspaceId: project.id,
            connName: conn.name,
            statements: statements,
            limit: doc.limit,
          );
          return GshCommandResult.ok(result.toJson());
        });

      // ── `gsh http …` — dispara requests de um arquivo `.http` pros
      // agentes. Mesmo motor da tab (`HttpRequestRunner`), mesma saída JSON de
      // uma linha do `gsh db`. Texto em inglês por decisão: a CLI fala com
      // agentes e scripts, não com a UI.
      case 'http-list':
        return _projectCommand(c, (project, root) async {
          final (doc, err) = await _httpDoc(c);
          if (err != null) return GshCommandResult.fail(err);
          return GshCommandResult.ok([
            for (var i = 0; i < doc!.requests.length; i++)
              {
                'index': i,
                'name': doc.requests[i].name,
                'method': doc.requests[i].method,
                'url': doc.requests[i].url,
              },
          ]);
        });

      // `gsh http run <file.http> [--request <nome|índice>]` — sem
      // `--request`, roda o primeiro request do arquivo.
      case 'http-run':
        return _projectCommand(c, (project, root) async {
          final (doc, err) = await _httpDoc(c);
          if (err != null) return GshCommandResult.fail(err);
          if (doc!.requests.isEmpty) {
            return const GshCommandResult.fail(
              'no_request: the file has no request',
            );
          }
          final wanted = (c.args['request'] ?? '').toString();
          var index = 0;
          if (wanted.isNotEmpty) {
            final asIndex = int.tryParse(wanted);
            if (asIndex != null) {
              if (asIndex < 0 || asIndex >= doc.requests.length) {
                return GshCommandResult.fail(
                  'no_request: no request at index $asIndex '
                  '(the file has ${doc.requests.length})',
                );
              }
              index = asIndex;
            } else {
              index = doc.requests.indexWhere(
                (r) => r.name.toLowerCase() == wanted.toLowerCase(),
              );
              if (index < 0) {
                return GshCommandResult.fail(
                  'no_request: no request named "$wanted" '
                  '(see `gsh http list`)',
                );
              }
            }
          }
          final path = (c.args['path'] ?? '').toString();
          final timeout = int.tryParse('${c.args['timeout'] ?? ''}');
          final result = await _http.send(
            doc.resolveRequest(doc.requests[index]),
            baseDir: Directory(path).parent.path,
            timeout: Duration(seconds: timeout ?? 30),
          );
          return result.fold(
            (value) => GshCommandResult.ok(value.toJson()),
            (error) => GshCommandResult.fail(_httpErrorText(error)),
          );
        });

      // `gsh redis` — comando de cache CLI-only (plano 51). `args.parts`
      // é a lista do comando (`['GET','foo']`). Reply cru em JSON.
      case 'redis-cmd':
        return _dbCommand(c, (project, root) async {
          final (conn, connErr) = await _agentConn(
            project,
            (c.args['db'] ?? '').toString(),
          );
          if (connErr != null) return GshCommandResult.fail(connErr);
          final parts = [
            for (final p in (c.args['parts'] as List? ?? const [])) '$p',
          ];
          if (conn!.access == DbAccess.read) {
            final violation = redisReadViolation(parts);
            if (violation != null) return GshCommandResult.fail(violation);
          }
          final reply = await _db.redisCommand(
            workspaceRoot: root,
            workspaceId: project.id,
            connName: conn.name,
            parts: parts,
          );
          return GshCommandResult.ok(reply);
        });

      // `gsh mongo` — CLI-only: `args.command` é o JSON do runCommand.
      case 'mongo-cmd':
        return _dbCommand(c, (project, root) async {
          final raw = (c.args['command'] ?? '{}').toString();
          final Map<String, dynamic> command;
          try {
            command = Map<String, dynamic>.from(jsonDecode(raw) as Map);
          } catch (_) {
            return const GshCommandResult.fail(
              'query_failed: invalid JSON command',
            );
          }
          final (conn, connErr) = await _agentConn(
            project,
            (c.args['db'] ?? '').toString(),
          );
          if (connErr != null) return GshCommandResult.fail(connErr);
          if (conn!.access == DbAccess.read) {
            final violation = mongoReadViolation(command);
            if (violation != null) return GshCommandResult.fail(violation);
          }
          var database = (c.args['database'] ?? '').toString().trim();
          // Comando que só roda no `admin` (listDatabases) é roteado pra lá —
          // é o comando de descoberta do agente e falharia com `Unauthorized`
          // contra qualquer outra base. Mesma regra do seletor do painel.
          if (database.isEmpty) {
            database = mongoForcedDatabase(command) ?? '';
          }
          final dbErr = await _mongoDatabaseError(project, conn, database);
          if (dbErr != null) return GshCommandResult.fail(dbErr);
          final reply = await _db.mongoCommand(
            workspaceRoot: root,
            workspaceId: project.id,
            connName: conn.name,
            command: command,
            database: database.isEmpty ? null : database,
          );
          return GshCommandResult.ok(reply);
        });

      // `gsh redis browse` / `gsh mongo browse` (plano 53, decisão D):
      // o agente abre a view filtrada pro humano. Abrir view ≠ executar — não
      // devolve dados; valida filtro/conexão ANTES de abrir.
      case 'browse':
        return _dbCommand(c, (project, root) async {
          final raw = (c.args['url'] ?? '').toString();
          if (raw.isEmpty) {
            return const GshCommandResult.fail('missing url');
          }
          final url = normalizeBrowserUrl(raw);
          // Sem webview inline (Linux): browser do SO, e o JSON diz isso.
          if (!BrowserCapability.resolve().isInline) {
            final ok = await _vm.openUrlExternally(url);
            if (!ok) {
              return GshCommandResult.fail('could not open "$url"');
            }
            return GshCommandResult.ok({'mode': 'system', 'url': url});
          }
          final session = _vm.openWebBrowser(
            url,
            projectId: project.id,
            reuse: true,
          );
          if (session == null) {
            return const GshCommandResult.fail(
              'workspace has no open pane to attach the browser to',
            );
          }
          return GshCommandResult.ok({'mode': 'inline', 'url': url});
        });

      case 'redis-browse':
        return _dbCommand(c, (project, root) async {
          final connName = (c.args['db'] ?? '').toString();
          final err = await _checkBrowseConn(project, connName, DbEngine.redis);
          if (err != null) return GshCommandResult.fail(err);
          final ok = _vm.openRedisBrowser(
            connName,
            projectId: project.id,
            pattern: (c.args['pattern'] ?? '').toString(),
          );
          if (!ok) {
            return const GshCommandResult.fail(
              'workspace has no open pane to attach the browser to',
            );
          }
          return GshCommandResult.ok({'opened': 'redis', 'db': connName});
        });

      case 'mongo-browse':
        return _dbCommand(c, (project, root) async {
          final connName = (c.args['db'] ?? '').toString();
          final collection = (c.args['collection'] ?? '').toString();
          if (collection.isEmpty) {
            return const GshCommandResult.fail('missing <collection>');
          }
          final err = await _checkBrowseConn(project, connName, DbEngine.mongo);
          if (err != null) return GshCommandResult.fail(err);
          final filter = (c.args['filter'] ?? '').toString();
          // Valida o JSON aqui — nunca abrir a tab com filtro quebrado.
          MongoBrowseService.parseFilter(filter);
          // Diferente do `mongo-cmd`: aqui o `--database` **fixa** a base da
          // conexão. A tab é o que o humano passa a ver, e ela resolve o alvo
          // pela conexão — abrir uma view apontando pra outra base seria mentira.
          final (conn, _) = await _agentConn(project, connName);
          final database = (c.args['database'] ?? '').toString().trim();
          if (conn != null) {
            final dbErr = await _mongoDatabaseError(project, conn, database);
            if (dbErr != null) return GshCommandResult.fail(dbErr);
            if (database.isNotEmpty) {
              await _db.selectMongoDatabase(project.id, conn.name, database);
            }
          }
          final ok = _vm.openMongoBrowser(
            connName,
            collection,
            projectId: project.id,
            filter: filter,
          );
          if (!ok) {
            return const GshCommandResult.fail(
              'workspace has no open pane to attach the browser to',
            );
          }
          return GshCommandResult.ok({
            'opened': 'mongo',
            'db': connName,
            'collection': collection,
          });
        });

      default:
        return GshCommandResult.fail('unknown command: "${c.cmd}"');
    }
  }

  /// Recusa comandos Mongo que não têm database resolvível, listando o que
  /// existe. `null` = pode seguir.
  ///
  /// Sem isto o runner caía em `admin` e o agente recebia `ok:1` com as
  /// `system.*` do deployment — resposta que *parece* sucesso e não é. Erro
  /// explícito é a única saída honesta: URL de Atlas não traz database no path,
  /// e a seleção do painel pode nunca ter acontecido neste workspace.
  Future<String?> _mongoDatabaseError(
    Project project,
    DbConnection conn,
    String database,
  ) async {
    if (database.isNotEmpty) return null;
    if (_db.mongoDatabase(project.id, conn) != null) return null;
    final available = await _mongoDatabaseNames(project, conn);
    return 'query_failed: connection "${conn.name}" has no database — its URL '
        'has none in the path and none was picked in the app. Pass '
        '--database <name>${available.isEmpty ? '' : ' (available: '
                  '${available.join(', ')})'}.';
  }

  /// Databases do deployment, pro texto do erro acima. Falha vira lista vazia:
  /// a mensagem principal continua valendo sem eles.
  Future<List<String>> _mongoDatabaseNames(
    Project project,
    DbConnection conn,
  ) async {
    try {
      final svc = MongoBrowseService(_db)
        ..target(
          workspaceRoot: project.effectiveRoot,
          workspaceId: project.id,
          connName: conn.name,
        );
      return await svc.listDatabases();
    } on Object {
      return const [];
    }
  }

  /// Resolve a conexão [connName] pro caminho **dos agentes**: conexões com
  /// `agents: false` são tratadas como inexistentes (nem o nome vaza — a
  /// lista de disponíveis também as omite). Devolve (conexão, null) ou
  /// (null, mensagem de erro).
  Future<(DbConnection?, String?)> _agentConn(
    Project project,
    String connName,
  ) async {
    if (connName.isEmpty) return (null, 'missing --db <name>');
    final conns = [
      for (final c in await _db.connections(
        project.effectiveRoot,
        workspaceId: project.id,
      ))
        if (c.agents) c,
    ];
    for (final conn in conns) {
      if (conn.name == connName) return (conn, null);
    }
    final available = conns.map((c) => c.name).join(', ');
    return (
      null,
      'no connection named "$connName" '
          '(available: ${available.isEmpty ? 'none' : available})',
    );
  }

  /// Valida a conexão alvo de um `browse`: visível pra agentes e do [engine]
  /// esperado. `null` = ok; senão a mensagem de erro.
  Future<String?> _checkBrowseConn(
    Project project,
    String connName,
    DbEngine engine,
  ) async {
    final (conn, err) = await _agentConn(project, connName);
    if (err != null) return err;
    return conn!.engine == engine
        ? null
        : '"$connName" is a ${conn.engine.label} connection, '
              'not ${engine.label}';
  }

  /// Molde dos comandos `db-*`: resolve o workspace (decisão K do plano 51 —
  /// `--workspace <id|path>` > pane emissor > erro, **nunca** cwd nem chute) e
  /// converte [DbQueryException] em `fail("<kind>: <mensagem>")`.
  /// `true` se a aba emissora pertence a um workspace de host remoto — aí os
  /// caminhos que chegam pela CLI são do host, não deste computador.
  bool _isRemoteTab(String? tabId) {
    if (tabId == null || tabId.isEmpty) return false;
    final session = _vm.session(tabId);
    if (session == null) return false;
    return _vm.projectById(session.projectId)?.isRemoteTerminal ?? false;
  }

  /// Lê e parseia o `.http` de `args['path']` (absoluto — a CLI resolve
  /// contra o cwd). Devolve `(doc, null)` ou `(null, erro em inglês)`.
  Future<(HttpDocument?, String?)> _httpDoc(GshCommand c) async {
    final path = (c.args['path'] ?? '').toString();
    if (path.isEmpty) return (null, 'missing .http path');
    try {
      return (HttpDocument.parse(await File(path).readAsString()), null);
    } on FileSystemException catch (e) {
      return (null, 'cannot read "$path": ${e.message}');
    }
  }

  /// Erro de request no formato `<kind>: <mensagem>` que a CLI reconstrói em
  /// `{"error":{kind,message}}`. Em inglês por decisão (saída de CLI não é
  /// traduzida); a UI usa `httpRequestErrorMessage`, que traduz.
  static String _httpErrorText(HttpRequestError e) {
    final detail = e.detail?.trim() ?? '';
    return switch (e.kind) {
      HttpRequestErrorKind.noRequest => 'no_request: no request found',
      HttpRequestErrorKind.invalidUrl =>
        'invalid_url: "$detail" is not a '
            'valid absolute URL',
      HttpRequestErrorKind.unresolvedVariable =>
        'unresolved_variable: {{${e.variable}}} has no value — declare it '
            'with @${e.variable} = … in the file',
      HttpRequestErrorKind.bodyFileUnreadable =>
        'body_file_unreadable: cannot read "${e.path}"'
            '${detail.isEmpty ? '' : ': $detail'}',
      HttpRequestErrorKind.connectionFailed =>
        'connection_failed: ${detail.isEmpty ? 'could not reach the server' : detail}',
      HttpRequestErrorKind.timeout =>
        'timeout: no response after ${e.timeoutSeconds}s',
      HttpRequestErrorKind.responseTooLarge =>
        'response_too_large: over the ${e.limitBytes} byte limit',
    };
  }

  /// Resolve o workspace do comando (`--workspace <id|path>`, ou o do pane
  /// emissor) e roda [action] nele. Compartilhado por `db`/`redis`/`mongo` e
  /// `http` — todos precisam de uma pasta de workspace real.
  /// Resolve o workspace do comando e entrega a **raiz efetiva** junto.
  ///
  /// A raiz vem pronta (e não `project.path`) porque num workspace remoto o
  /// `path` é vazio — a pasta vive em `remotePath`. Enquanto cada caso lia
  /// `project.path` por conta própria, toda aba remota recebia "this pane has
  /// no workspace folder" em `db`, `list-tasks` e `read-task`; e agentes
  /// contornavam apontando `--workspace` para um workspace local, o que troca
  /// a MÁQUINA em silêncio e responde sobre o computador errado.
  Future<GshCommandResult> _projectCommand(
    GshCommand c,
    Future<GshCommandResult> Function(Project project, String root) action,
  ) async {
    Project? project;
    final ws = (c.args['workspace'] ?? '').toString();
    if (ws.isNotEmpty) {
      for (final p in _vm.projects) {
        if (p.id == ws || p.path == ws) {
          project = p;
          break;
        }
      }
      if (project == null) {
        return GshCommandResult.fail('no workspace matches "$ws"');
      }
    } else {
      final sender = c.tabId == null ? null : _vm.session(c.tabId!);
      project = sender == null ? null : _vm.projectById(sender.projectId);
      if (project == null) {
        return const GshCommandResult.fail(
          'not inside a GSH pane — pass --workspace <id|path> '
          '(see `gsh list-workspaces`)',
        );
      }
    }
    final root = project.effectiveRoot;
    if (project.isSystemTerminal || root.isEmpty) {
      return const GshCommandResult.fail('this pane has no workspace folder');
    }
    final result = await action(project, root);
    final crossing = _machineWarning(c, project);
    // Só decora o sucesso: um erro já traz a explicação dele.
    if (crossing == null || !result.ok) return result;
    return GshCommandResult.ok(result.data, result.afterResponse, crossing);
  }

  /// Aviso quando `--workspace` mira um workspace de OUTRA máquina que não a da
  /// aba emissora.
  ///
  /// A execução sempre acontece onde o workspace vive — essa parte está certa.
  /// O problema é o silêncio: um agente numa aba do host, ao apontar para um
  /// workspace local, recebe de volta o estado da máquina do CLIENTE com toda a
  /// cara de ser a de onde ele está. Já aconteceu: a resposta descrevia um
  /// Postgres em `localhost:5433` que rodava no cliente, não no host da aba.
  String? _machineWarning(GshCommand c, Project target) {
    if ((c.args['workspace'] ?? '').toString().isEmpty) return null;
    final tabId = c.tabId;
    final sender = tabId == null ? null : _vm.session(tabId);
    final from = sender == null ? null : _vm.projectById(sender.projectId);
    if (from == null) return null;
    final fromHost = from.remoteHostId;
    final toHost = target.remoteHostId;
    if (fromHost == toHost) return null;
    String where(String? hostId) =>
        hostId == null ? 'this computer' : 'remote host $hostId';
    return 'ran on ${where(toHost)} — the workspace you targeted with '
        '--workspace lives there, while this tab runs on ${where(fromHost)}';
  }

  /// [_projectCommand] + tradução do erro de banco para o formato
  /// `<kind>: <message>` que a CLI reconstrói em `{"error":{…}}`.
  Future<GshCommandResult> _dbCommand(
    GshCommand c,
    Future<GshCommandResult> Function(Project project, String root) action,
  ) => _projectCommand(c, (project, root) async {
    try {
      return await action(project, root);
    } on DbQueryException catch (e) {
      return GshCommandResult.fail('${e.kind}: ${e.message}');
    }
  });

  Result<PaneItem, String> _resolvePaneTarget(String target) =>
      resolveTabTarget(target, _vm.allSessions);

  /// Emissor de um verbo de agente: aba, ou nó externo (`ext:<app>`, o
  /// servidor MCP) — que conta como atividade (status "working" do nó).
  var _permissionSeq = 0;

  PaneItem? _agentCaller(String? id) {
    if (id == null) return null;
    final ext = _vm.agentGraph.externalById(id);
    ext?.markActive();
    return ext ?? _vm.session(id);
  }

  /// `wait_messages` de uma aba de terminal (ver [AgentMessageLog.takeFor]).
  Future<GshCommandResult> _waitAsTab(String? id, Duration timeout) async {
    final tab = id == null ? null : _vm.session(id);
    if (tab is! TerminalSession) return _unknownCaller(id);
    final msgs = await _vm.agentMessages.takeFor(
      tab.id,
      tab.projectId,
      timeout,
    );
    return GshCommandResult.ok([
      for (final m in msgs)
        {
          'from': m.signedBy ?? m.fromTabId,
          'text': m.preview.length < AgentMessageLog.previewLength
              ? m.preview
              : '${m.preview}… (truncated: the full text was typed into '
                    'your terminal)',
          'sentAt': m.sentAt.toIso8601String(),
        },
    ]);
  }

  GshCommandResult _unknownCaller(String? id) => GshCommandResult.fail(
    id != null && id.startsWith('ext:')
        ? '${id.substring(4)} is not on a GSH agents canvas: in GSH '
              'open Visualize agents → New agent → Desktop apps and add it'
        : 'unknown tab (run inside a GSH terminal)',
  );

  /// Mensagem ou arquivo para o agente de um colega (ver [TeamPost.send]).
  Future<GshCommandResult> _teamSend(
    PaneItem sender,
    String to,
    String text, {
    String? filePath,
  }) async {
    final r = await _vm.teamPost.send(
      from: TeamSender(
        tabId: sender.id,
        // O endereço que os colegas veem (já sem repetição), para a
        // resposta voltar a esta aba.
        label:
            _vm.teamPost
                .localAgents()
                .where((a) => a.tabId == sender.id)
                .firstOrNull
                ?.label ??
            teamAgentLabel(sender),
        sessionId: sender is TerminalSession ? sender.claudeSessionId : null,
      ),
      target: to,
      text: text,
      filePath: filePath,
    );
    return switch (r) {
      Success(:final value) => GshCommandResult.ok({
        'from': sender.id,
        'to': value,
        'team': true,
      }),
      Failure(:final error) => GshCommandResult.fail(error),
    };
  }

  Future<GshCommandResult> _sendAgentMessage(GshCommand c) async {
    final sender = _agentCaller(c.tabId);
    if (sender == null) return _unknownCaller(c.tabId);
    final to = (c.args['to'] ?? '').toString();
    final text = (c.args['text'] ?? '').toString();
    if (to.isEmpty) return const GshCommandResult.fail('missing --to');
    if (text.isEmpty) return const GshCommandResult.fail('missing text');
    // `Fulano/aba` de um colega do time: vai pelo correio da rede local.
    final team = to.contains('/') ? _vm.teamPost.resolve(to) : null;
    if (team is Success) return _teamSend(sender, to, text);
    final reachable = [..._vm.allSessions, ..._vm.agentGraph.externals];
    final PaneItem target;
    switch (resolveTabTarget(to, reachable)) {
      case Success(:final value) when value is TerminalSession:
        target = value;
      case Success(:final value) when value is ExternalAgent:
        target = value;
      // Aba de chat: a mensagem vira turno da conversa.
      case Success(:final value) when value is ChatSession:
        target = value;
      case Success(:final value):
        return GshCommandResult.fail(
          'tab "${value.id}" is not an agent (terminal or chat)',
        );
      // Nem aba local nem colega: o erro do time explica (saiu da rede,
      // nome errado) melhor que "no tab".
      case Failure(:final error):
        return GshCommandResult.fail(
          team is Failure<TeamContact, String> ? team.error : error,
        );
    }
    if (target.id == sender.id) {
      return const GshCommandResult.fail('cannot message your own tab');
    }
    deliverAgentMessage(
      log: _vm.agentMessages,
      from: sender,
      target: target,
      // Sem label manual, o título é dinâmico (Codex/Claude reescrevem com
      // spinner e status): assina com o id estável da aba.
      senderName: sender.manualLabel ?? sender.id,
      senderHarness: agentKindLabel(sender),
      text: text,
      targetAlive: () => identical(_vm.session(target.id), target),
    );
    return GshCommandResult.ok({'from': sender.id, 'to': target.id});
  }

  Future<String> _resolveRemotePath(RemoteHost host, String rawPath) async {
    var p = rawPath.trim();
    if (p == '~' || p.startsWith('~/')) {
      try {
        final (code, out, _) = await SshTunnel.capture(
          host.sshTarget,
          r'printf %s "$HOME"',
          port: host.port,
          identityFile: host.effectiveIdentityFile,
        );
        if (code == 0 && out.trim().isNotEmpty) {
          final remoteHome = out.trim();
          final normalizedHome = remoteHome.endsWith('/')
              ? remoteHome.substring(0, remoteHome.length - 1)
              : remoteHome;
          p = p == '~' ? normalizedHome : '$normalizedHome/${p.substring(2)}';
        }
      } on Object catch (e) {
        // Fallback: tenta via fileService se capture falhar
        DiagnosticsLog.instance.warn('remote-home', 'capture failed', error: e);
        try {
          final service = await _vm.remoteHosts.fileServiceFor(host);
          final remoteHome = await service.home();
          if (remoteHome.isNotEmpty) {
            final normalizedHome = remoteHome.endsWith('/')
                ? remoteHome.substring(0, remoteHome.length - 1)
                : remoteHome;
            p = p == '~' ? normalizedHome : '$normalizedHome/${p.substring(2)}';
          }
        } on Object catch (e) {
          DiagnosticsLog.instance.warn(
            'remote-home',
            'fileService fallback failed; keeping ~ unexpanded',
            error: e,
          );
        }
      }
    }
    while (p.length > 1 && (p.endsWith('/') || p.endsWith(r'\'))) {
      p = p.substring(0, p.length - 1);
    }
    return p;
  }

  Future<RemoteHost> _resolveOrRegisterRemoteHost(String hostRef) async {
    final clean = hostRef.trim();
    for (final h in _vm.remoteHosts.hosts) {
      if (h.id == clean ||
          h.sshTarget == clean ||
          h.name.toLowerCase() == clean.toLowerCase() ||
          h.host == clean) {
        return h;
      }
    }
    await _vm.addRemoteHost(name: clean, sshTarget: clean);
    for (final h in _vm.remoteHosts.hosts) {
      if (h.sshTarget == clean || h.name == clean) {
        return h;
      }
    }
    return _vm.remoteHosts.hosts.last;
  }

  String _cleanWorkspacePath(String path) {
    var p = normalizePath(path).trim();
    if (p == '~' || p.startsWith('~/')) {
      final home =
          Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
      if (home != null && home.isNotEmpty) {
        final normHome = normalizePath(home);
        p = p == '~' ? normHome : '$normHome${p.substring(1)}';
      }
    }
    while (p.length > 1 && p.endsWith('/')) {
      p = p.substring(0, p.length - 1);
    }
    return p;
  }

  Project? _resolveWorkspace(String target) {
    if (target.isEmpty) return null;
    final normalized = normalizePath(target);
    final clean = _cleanWorkspacePath(target);
    for (final p in _vm.projects) {
      if (p.id == target ||
          p.id == '${Project.remotePrefix}$target' ||
          p.id.replaceFirst(Project.remotePrefix, '') == target) {
        return p;
      }
      if (p.path == target || p.path == normalized || p.path == clean) return p;
      if (p.effectiveRoot == target ||
          p.effectiveRoot == normalized ||
          p.effectiveRoot == clean) {
        return p;
      }
      if (p.remotePath == target || p.remotePath == clean) return p;
    }
    try {
      final dir = Directory(clean);
      if (dir.existsSync()) {
        final abs = _cleanWorkspacePath(dir.absolute.path);
        for (final p in _vm.projects) {
          if (p.path == abs || p.effectiveRoot == abs) {
            return p;
          }
        }
      }
    } catch (_) {
      /* ignore invalid path syntax */
    }
    final byName = _vm.projects
        .where((p) => p.name.toLowerCase() == target.toLowerCase())
        .toList();
    if (byName.length == 1) return byName.first;
    return null;
  }

  String _paneKind(PaneItem s) {
    if (s is TerminalSession) return 'terminal';
    if (s is FileViewerSession) return 'file';
    if (s is TaskOutputSession) return 'task';
    if (s is RedisBrowserSession) return 'redis';
    if (s is MongoBrowserSession) return 'mongo';
    if (s is NotebookSession) return 'notebook';
    if (s is AgentGraphSession) return 'agents';
    if (s is FarmSession) return 'farm';
    if (s is ChatSession) return 'chat';
    return 'other';
  }

  /// Sentinela do `--focused` da CLI. Devolve o comando com o `tabId` real, ou
  /// `null` quando não há aba em foco pra resolver (aí o chamador falha com
  /// mensagem clara em vez de escrever numa aba arbitrária).
  static const String _focusSentinel = '@focused';

  GshCommand? _resolveFocusSentinel(GshCommand c) {
    if (c.tabId != _focusSentinel) return c;
    final id = _vm.focusedTabId;
    if (id == null || id.isEmpty) return null;
    return GshCommand(cmd: c.cmd, tabId: id, args: c.args);
  }
}

/// Resolve o alvo de um verbo de aba (`read-tab`, `msg`, …): primeiro por id
/// exato (`t3`), depois por `manualLabel` (case-insensitive). Label ambíguo =
/// erro — nunca chuta pane (mesma regra do dispatch de orquestração).
Result<PaneItem, String> resolveTabTarget(
  String target,
  Iterable<PaneItem> sessions,
) {
  for (final s in sessions) {
    if (s.id == target) return Success(s);
  }
  final lower = target.toLowerCase();
  final byLabel = sessions
      .where((s) => s.manualLabel?.toLowerCase() == lower)
      .toList();
  if (byLabel.length == 1) return Success(byLabel.first);
  if (byLabel.length > 1) {
    return Failure(
      'label "$target" is ambiguous (${byLabel.length} tabs) — '
      'use a tab-id from `gsh list-tabs`',
    );
  }
  return Failure('no tab with id or label "$target" (see `gsh list-tabs`)');
}

/// `from` das ferramentas do `gsh mcp` (verbos `msg`/`peers`/`agents`/
/// `ext-wait`): o Codex CLI roda as sessões num app-server daemon
/// compartilhado que spawna o MCP fora da árvore da aba (sem pid nem env pra
/// achá-la), e um processo serve várias abas — então a aba se identifica a
/// cada chamada. Presente: só vale aba de terminal com Codex
/// ([AgentChannel.mcpTab]), e o comando passa a ter o `tabId` dela (o cursor
/// do `wait_messages` já é por aba no [AgentMessageLog]). Ausente: o comando
/// como veio (identidade do startup).
// ponytail: confia na palavra do agente (app local, usuário único); upgrade =
// token por sessão se o Codex um dia repassar o env da sessão pro MCP.
Result<GshCommand, String> actAsMcpFrom(
  GshCommand c,
  Iterable<PaneItem> sessions,
) {
  final from = c.args['from'];
  if (!const {
        'msg',
        'deliver',
        'peers',
        'agents',
        'ext-wait',
      }.contains(c.cmd) ||
      from is! String ||
      from.trim().isEmpty) {
    return Success(c);
  }
  return switch (resolveTabTarget(from.trim(), sessions)) {
    Failure(:final error) => Failure('from: $error'),
    Success(:final value) when agentChannel(value) == AgentChannel.mcpTab =>
      Success(GshCommand(cmd: c.cmd, tabId: value.id, args: c.args)),
    Success(:final value) => Failure(
      'from: tab "${value.id}" is not a Codex terminal tab (pass from only '
      'when you are Codex running in a GSH terminal; omit it otherwise)',
    ),
  };
}
