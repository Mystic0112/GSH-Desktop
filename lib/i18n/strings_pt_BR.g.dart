///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsPtBr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsPtBr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ptBr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <pt-BR>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsPtBr _root = this; // ignore: unused_field

	@override 
	TranslationsPtBr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsPtBr(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$core$pt_BR core = _Translations$core$pt_BR._(_root);
	@override late final _Translations$common$pt_BR common = _Translations$common$pt_BR._(_root);
	@override late final _Translations$gsh$pt_BR gsh = _Translations$gsh$pt_BR._(_root);
	@override late final _Translations$settings$pt_BR settings = _Translations$settings$pt_BR._(_root);
	@override late final _Translations$automation$pt_BR automation = _Translations$automation$pt_BR._(_root);
	@override late final _Translations$fileOperation$pt_BR fileOperation = _Translations$fileOperation$pt_BR._(_root);
	@override late final _Translations$theme$pt_BR theme = _Translations$theme$pt_BR._(_root);
}

// Path: core
class _Translations$core$pt_BR extends Translations$core$en {
	_Translations$core$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$core$bootstrapError$pt_BR bootstrapError = _Translations$core$bootstrapError$pt_BR._(_root);
	@override late final _Translations$core$macosNotifications$pt_BR macosNotifications = _Translations$core$macosNotifications$pt_BR._(_root);
	@override late final _Translations$core$appErrorView$pt_BR appErrorView = _Translations$core$appErrorView$pt_BR._(_root);
	@override late final _Translations$core$errorReportDialog$pt_BR errorReportDialog = _Translations$core$errorReportDialog$pt_BR._(_root);
	@override late final _Translations$core$windowControls$pt_BR windowControls = _Translations$core$windowControls$pt_BR._(_root);
	@override late final _Translations$core$crash$pt_BR crash = _Translations$core$crash$pt_BR._(_root);
	@override late final _Translations$core$menu$pt_BR menu = _Translations$core$menu$pt_BR._(_root);
}

// Path: common
class _Translations$common$pt_BR extends Translations$common$en {
	_Translations$common$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get confirm => 'Confirmar';
	@override String get create => 'Criar';
	@override String get gotIt => 'Entendi';
	@override String get save => 'Salvar';
	@override String get close => 'Fechar';
	@override String get delete => 'Excluir';
	@override String get done => 'Concluído';
	@override String get add => 'Adicionar';
	@override String get test => 'Testar';
	@override String get ok => 'OK';
	@override String get loading => 'Carregando…';
	@override String get checking => 'Verificando…';
	@override String get remove => 'Remover';
	@override String get restart => 'Reiniciar';
	@override String get settings => 'Configurações';
	@override String get send => 'Enviar';
	@override String get open => 'Abrir';
	@override String get dismiss => 'Dispensar';
	@override String get report => 'Reportar';
	@override String get copyCode => 'Copiar código';
	@override String get search => 'Buscar';
	@override String get noResults => 'Nenhum resultado';
}

// Path: gsh
class _Translations$gsh$pt_BR extends Translations$gsh$en {
	_Translations$gsh$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$gsh$confirmDialog$pt_BR confirmDialog = _Translations$gsh$confirmDialog$pt_BR._(_root);
	@override late final _Translations$gsh$neovim$pt_BR neovim = _Translations$gsh$neovim$pt_BR._(_root);
	@override late final _Translations$gsh$worktreeCreateDialog$pt_BR worktreeCreateDialog = _Translations$gsh$worktreeCreateDialog$pt_BR._(_root);
	@override late final _Translations$gsh$commitMessageDialog$pt_BR commitMessageDialog = _Translations$gsh$commitMessageDialog$pt_BR._(_root);
	@override late final _Translations$gsh$tasksPanel$pt_BR tasksPanel = _Translations$gsh$tasksPanel$pt_BR._(_root);
	@override late final _Translations$gsh$gshPage$pt_BR gshPage = _Translations$gsh$gshPage$pt_BR._(_root);
	@override late final _Translations$gsh$welcomeView$pt_BR welcomeView = _Translations$gsh$welcomeView$pt_BR._(_root);
	@override late final _Translations$gsh$paneView$pt_BR paneView = _Translations$gsh$paneView$pt_BR._(_root);
	@override late final _Translations$gsh$fileTreePanel$pt_BR fileTreePanel = _Translations$gsh$fileTreePanel$pt_BR._(_root);
	@override late final _Translations$gsh$fileViewer$pt_BR fileViewer = _Translations$gsh$fileViewer$pt_BR._(_root);
	@override late final _Translations$gsh$workspaceSettingsDialog$pt_BR workspaceSettingsDialog = _Translations$gsh$workspaceSettingsDialog$pt_BR._(_root);
	@override late final _Translations$gsh$realmDialogs$pt_BR realmDialogs = _Translations$gsh$realmDialogs$pt_BR._(_root);
	@override late final _Translations$gsh$dbRedisTable$pt_BR dbRedisTable = _Translations$gsh$dbRedisTable$pt_BR._(_root);
	@override late final _Translations$gsh$dbQueryView$pt_BR dbQueryView = _Translations$gsh$dbQueryView$pt_BR._(_root);
	@override late final _Translations$gsh$httpView$pt_BR httpView = _Translations$gsh$httpView$pt_BR._(_root);
	@override late final _Translations$gsh$kanbanView$pt_BR kanbanView = _Translations$gsh$kanbanView$pt_BR._(_root);
	@override late final _Translations$gsh$dbPanel$pt_BR dbPanel = _Translations$gsh$dbPanel$pt_BR._(_root);
	@override late final _Translations$gsh$dbMongoView$pt_BR dbMongoView = _Translations$gsh$dbMongoView$pt_BR._(_root);
	@override late final _Translations$gsh$dbConnectionDialog$pt_BR dbConnectionDialog = _Translations$gsh$dbConnectionDialog$pt_BR._(_root);
	@override late final _Translations$gsh$sshPrompts$pt_BR sshPrompts = _Translations$gsh$sshPrompts$pt_BR._(_root);
	@override late final _Translations$gsh$projectsRail$pt_BR projectsRail = _Translations$gsh$projectsRail$pt_BR._(_root);
	@override late final _Translations$gsh$findBar$pt_BR findBar = _Translations$gsh$findBar$pt_BR._(_root);
	@override late final _Translations$gsh$contentSearch$pt_BR contentSearch = _Translations$gsh$contentSearch$pt_BR._(_root);
	@override late final _Translations$gsh$topbar$pt_BR topbar = _Translations$gsh$topbar$pt_BR._(_root);
	@override late final _Translations$gsh$tasks$pt_BR tasks = _Translations$gsh$tasks$pt_BR._(_root);
	@override late final _Translations$gsh$notifications$pt_BR notifications = _Translations$gsh$notifications$pt_BR._(_root);
	@override late final _Translations$gsh$terminalLink$pt_BR terminalLink = _Translations$gsh$terminalLink$pt_BR._(_root);
	@override late final _Translations$gsh$terminal$pt_BR terminal = _Translations$gsh$terminal$pt_BR._(_root);
	@override late final _Translations$gsh$remoteHost$pt_BR remoteHost = _Translations$gsh$remoteHost$pt_BR._(_root);
	@override late final _Translations$gsh$browserPane$pt_BR browserPane = _Translations$gsh$browserPane$pt_BR._(_root);
	@override late final _Translations$gsh$documentWindow$pt_BR documentWindow = _Translations$gsh$documentWindow$pt_BR._(_root);
	@override late final _Translations$gsh$gallery$pt_BR gallery = _Translations$gsh$gallery$pt_BR._(_root);
	@override late final _Translations$gsh$notebook$pt_BR notebook = _Translations$gsh$notebook$pt_BR._(_root);
	@override late final _Translations$gsh$layoutPreview$pt_BR layoutPreview = _Translations$gsh$layoutPreview$pt_BR._(_root);
	@override late final _Translations$gsh$telemetry$pt_BR telemetry = _Translations$gsh$telemetry$pt_BR._(_root);
	@override late final _Translations$gsh$panelView$pt_BR panelView = _Translations$gsh$panelView$pt_BR._(_root);
	@override late final _Translations$gsh$chat$pt_BR chat = _Translations$gsh$chat$pt_BR._(_root);
	@override late final _Translations$gsh$farm$pt_BR farm = _Translations$gsh$farm$pt_BR._(_root);
	@override late final _Translations$gsh$agentGraph$pt_BR agentGraph = _Translations$gsh$agentGraph$pt_BR._(_root);
}

// Path: settings
class _Translations$settings$pt_BR extends Translations$settings$en {
	_Translations$settings$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$settings$language$pt_BR language = _Translations$settings$language$pt_BR._(_root);
	@override late final _Translations$settings$page$pt_BR page = _Translations$settings$page$pt_BR._(_root);
	@override late final _Translations$settings$remoteHosts$pt_BR remoteHosts = _Translations$settings$remoteHosts$pt_BR._(_root);
}

// Path: automation
class _Translations$automation$pt_BR extends Translations$automation$en {
	_Translations$automation$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$automation$error$pt_BR error = _Translations$automation$error$pt_BR._(_root);
}

// Path: fileOperation
class _Translations$fileOperation$pt_BR extends Translations$fileOperation$en {
	_Translations$fileOperation$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$fileOperation$error$pt_BR error = _Translations$fileOperation$error$pt_BR._(_root);
}

// Path: theme
class _Translations$theme$pt_BR extends Translations$theme$en {
	_Translations$theme$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$theme$error$pt_BR error = _Translations$theme$error$pt_BR._(_root);
}

// Path: core.bootstrapError
class _Translations$core$bootstrapError$pt_BR extends Translations$core$bootstrapError$en {
	_Translations$core$bootstrapError$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Falha ao inicializar o GSH Desktop';
	@override String get retry => 'Tentar novamente';
}

// Path: core.macosNotifications
class _Translations$core$macosNotifications$pt_BR extends Translations$core$macosNotifications$en {
	_Translations$core$macosNotifications$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ativar notificações no macOS';
	@override String get intro => 'As notificações estão desativadas nas configurações do sistema. Siga os passos abaixo para ativá-las:';
	@override String get step1 => 'Abra as Configurações do Sistema no seu Mac.';
	@override String get step2 => 'Acesse a seção Notificações na barra lateral esquerda.';
	@override String get step3 => 'Encontre e selecione o aplicativo GSH Desktop na lista.';
	@override String get step4 => 'Ative a opção Permitir Notificações.';
	@override String get tip => 'Dica: se o aplicativo não aparecer na lista, feche e reabra-o para acionar seu registro no sistema.';
	@override String get gotIt => 'Entendi';
}

// Path: core.appErrorView
class _Translations$core$appErrorView$pt_BR extends Translations$core$appErrorView$en {
	_Translations$core$appErrorView$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get renderFailed => 'Esta parte do aplicativo falhou ao renderizar';
	@override String get details => 'Detalhes';
	@override String get renderErrorTitle => 'Erro de renderização';
}

// Path: core.errorReportDialog
class _Translations$core$errorReportDialog$pt_BR extends Translations$core$errorReportDialog$en {
	_Translations$core$errorReportDialog$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get defaultDescription => 'Algo deu errado. Os detalhes abaixo foram salvos no log — você pode reportá-los para que isso seja corrigido.';
	@override String get copyDetails => 'Copiar detalhes';
	@override String get reportIssue => 'Reportar problema';
}

// Path: core.windowControls
class _Translations$core$windowControls$pt_BR extends Translations$core$windowControls$en {
	_Translations$core$windowControls$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get minimize => 'Minimizar';
	@override String get maximize => 'Maximizar';
	@override String get close => 'Fechar';
}

// Path: core.crash
class _Translations$core$crash$pt_BR extends Translations$core$crash$en {
	_Translations$core$crash$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Encerramento inesperado';
	@override String get bannerTitle => 'O GSH Desktop fechou inesperadamente';
	@override String get report => 'Reportar';
	@override String get dismiss => 'Dispensar';
	@override String crashMessage({required Object version}) => 'A sessão anterior (versão ${version}) terminou sem encerrar corretamente. Quer reportar? O log vai junto e você pode revisar tudo antes de enviar.';
	@override String crashError({required Object startedAt, required Object pid}) => 'A sessão iniciada em ${startedAt} (pid ${pid}) terminou sem encerramento limpo.';
	@override String get crashDescription => 'Nenhum erro foi capturado: o app foi encerrado pelo sistema. O log abaixo é dessa sessão e é a parte mais útil.';
}

// Path: core.menu
class _Translations$core$menu$pt_BR extends Translations$core$menu$en {
	_Translations$core$menu$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Configurações…';
	@override String get checkForUpdates => 'Verificar Atualizações…';
	@override String get file => 'Arquivo';
	@override String get newTerminal => 'Novo Terminal';
	@override String get openWorkspace => 'Abrir Workspace';
	@override String get save => 'Salvar';
	@override String get discard => 'Descartar';
	@override String get format => 'Formatar';
	@override String get view => 'Exibir';
	@override String get toggleWorkspacePanel => 'Alternar Painel de Workspaces';
	@override String get toggleFiles => 'Alternar Arquivos';
	@override String get splitRight => 'Dividir à Direita';
	@override String get splitDown => 'Dividir Abaixo';
	@override String get focusPane => 'Focar Painel';
	@override String get focusLeft => 'Esquerda  (⌘⌥←)';
	@override String get focusRight => 'Direita  (⌘⌥→)';
	@override String get focusUp => 'Acima  (⌘⌥↑)';
	@override String get focusDown => 'Abaixo  (⌘⌥↓)';
	@override String get selectTab => 'Selecionar Aba';
	@override String tabN({required Object n}) => 'Aba ${n}';
	@override String get lastTab => 'Última Aba';
	@override String get previousWorkspace => 'Workspace Anterior';
	@override String get nextWorkspace => 'Próximo Workspace';
	@override String get zoomIn => 'Aumentar Zoom';
	@override String get zoomOut => 'Diminuir Zoom';
	@override String get actualSize => 'Tamanho Real';
	@override String get window => 'Janela';
	@override String get quit => 'Sair';
	@override String get minimize => 'Minimizar';
	@override String get zoom => 'Zoom';
}

// Path: gsh.confirmDialog
class _Translations$gsh$confirmDialog$pt_BR extends Translations$gsh$confirmDialog$en {
	_Translations$gsh$confirmDialog$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get unsavedChangesTitle => 'Alterações não salvas';
	@override String unsavedChangesMessage({required Object fileName}) => '“${fileName}” tem alterações não salvas. Salvar antes de fechar?';
	@override String get dontSave => 'Não salvar';
	@override String get saveAndClose => 'Salvar e fechar';
}

// Path: gsh.neovim
class _Translations$gsh$neovim$pt_BR extends Translations$gsh$neovim$en {
	_Translations$gsh$neovim$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get unavailable => 'O Neovim não está disponível. Abrindo no GSH Desktop.';
	@override String get openFailed => 'Não foi possível acessar o Neovim. Abrindo no GSH Desktop.';
	@override String get unsavedTitle => 'Buffers não salvos no Neovim';
	@override String get unsavedMessage => 'O Neovim tem buffers modificados. Fechar a aba e descartar essas alterações?';
	@override String get closeAnyway => 'Fechar mesmo assim';
}

// Path: gsh.worktreeCreateDialog
class _Translations$gsh$worktreeCreateDialog$pt_BR extends Translations$gsh$worktreeCreateDialog$en {
	_Translations$gsh$worktreeCreateDialog$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get forkTitle => 'Fork da worktree';
	@override String get createTitle => 'Criar worktree';
	@override String forkSubtitle({required Object root}) => 'Nova worktree ramificada a partir de ${root}.';
	@override String createSubtitle({required Object root}) => 'Nova feature em ${root} — novo branch a partir do HEAD atual.';
	@override String get namePlaceholder => 'feat/minha-feature';
	@override String get errorWhitespace => 'Sem espaços no nome.';
	@override String get errorInvalidChar => 'Caractere inválido para nome de branch.';
	@override String get errorInvalidSequence => 'Sequência inválida (ex.: "..", "//", começar/terminar com "/").';
	@override String get errorReserved => 'Posição reservada (não comece com "-"/"." nem termine com ".lock").';
	@override String get errorDuplicateBranch => 'Já existe um branch com esse nome.';
	@override String get errorDuplicateWorktree => 'Já existe uma worktree com esse nome.';
	@override String errorBranchHierarchyConflict({required Object target, required Object existing}) => 'Não é possível criar o branch \'${target}\' porque ele conflita com o branch \'${existing}\' já existente.';
	@override String get errorBranchHierarchicalConflictGeneral => 'Já existe um branch com uma hierarquia conflitante.';
	@override String get fork => 'Fork';
	@override String get postCheckoutHint => 'Este repositório tem um hook post-checkout.';
	@override String get running => 'Executando…';
	@override String get advancedSettings => 'Configurações Avançadas';
	@override String get copyIgnored => 'Copiar arquivos ignorados (.gitignore)';
	@override String get copyIgnoredDesc => 'Copia arquivos ignorados pelo .gitignore (ex: .env, chaves locais) para a nova pasta.';
	@override String get copyUntracked => 'Copiar arquivos não rastreados';
	@override String get copyUntrackedDesc => 'Copia arquivos novos ou modificados que ainda não foram adicionados ao stage.';
	@override String get baseBranch => 'Branch base';
	@override String get baseBranchDesc => 'O branch de onde a nova worktree e branch serão ramificados.';
	@override String get fetchRemote => 'Sincronizar branch remota (fetch)';
	@override String get fetchRemoteDesc => 'Roda git fetch para garantir que a branch base esteja confirmada antes de criar a worktree.';
	@override String get searchBranch => 'Buscar branch...';
	@override String get back => 'Voltar';
}

// Path: gsh.commitMessageDialog
class _Translations$gsh$commitMessageDialog$pt_BR extends Translations$gsh$commitMessageDialog$en {
	_Translations$gsh$commitMessageDialog$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get commitTitle => 'Commit';
	@override String get stageAndCommitTitle => 'Stage e Commit';
	@override String scopeNote({required Object fileName}) => 'Commit apenas de "${fileName}".';
	@override String get placeholder => 'fix: resumo curto da mudança';
	@override String get errorEmptySubject => 'A primeira linha (assunto) não pode ficar vazia.';
	@override String errorTooShort({required Object min}) => 'Assunto muito curto (mín. ${min} caracteres).';
	@override String errorTooLong({required Object max}) => 'Assunto muito longo (máx. ${max} caracteres).';
	@override String get errorTrailingPeriod => 'O assunto não deve terminar com ponto.';
	@override String get errorControlChars => 'O assunto contém caracteres de controle.';
	@override String get errorBlankSecondLine => 'Deixe a segunda linha em branco (separador entre assunto e corpo do git).';
	@override String get generate => 'Gerar mensagem de commit';
	@override String generateWith({required Object harness}) => 'Gerar com ${harness}';
	@override String get generating => 'Gerando…';
	@override String get cancelGeneration => 'Cancelar geração';
}

// Path: gsh.tasksPanel
class _Translations$gsh$tasksPanel$pt_BR extends Translations$gsh$tasksPanel$en {
	_Translations$gsh$tasksPanel$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get reloadTasksTooltip => 'Recarregar tasks';
	@override String get restartTooltip => 'Reiniciar';
	@override String get stopTooltip => 'Parar';
	@override String get runTooltip => 'Executar';
	@override String sendsKeyTooltip({required Object label, required Object key}) => '${label} (envia \'${key}\')';
	@override String get startingTooltip => 'Iniciando…';
	@override String get stoppingTooltip => 'Parando…';
	@override String get switchProfileTooltip => 'Trocar perfil';
	@override String get moreKeysTooltip => 'Mais teclas';
	@override String get sectionTasks => 'TAREFAS';
	@override String get noTasks => 'Nenhuma tarefa detectada neste projeto.';
	@override String get createTasksJson => 'Criar tasks.json';
	@override String get generateComposeTasks => 'Gerar tasks do Compose';
	@override String get selectComposeEngine => 'Escolha uma engine Compose';
	@override String get noComposeEngine => 'Docker Compose ou Podman Compose não foi encontrado.';
	@override String get invalidComposeFile => 'O arquivo ativo não é um Compose válido com services.';
	@override String get invalidTasksJson => 'tasks.json é inválido. Nenhuma alteração foi gravada.';
	@override String composeConflicts({required Object labels}) => 'Tasks não Compose com rótulos conflitantes foram mantidas: ${labels}';
}

// Path: gsh.gshPage
class _Translations$gsh$gshPage$pt_BR extends Translations$gsh$gshPage$en {
	_Translations$gsh$gshPage$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get chooseProjectFolderDialogTitle => 'Escolha a pasta do projeto';
	@override String get chooseWorkspaceFolderDialogTitle => 'Escolha a pasta do workspace';
	@override String get workspaceRenamedTitle => 'Workspace renomeado';
	@override String workspaceRenamedMessage({required Object name}) => 'O novo nome "${name}" só será enviado aos agentes após reiniciar o workspace ou o aplicativo.';
	@override String syncTitle({required Object label}) => 'Sync — ${label}';
	@override String pullTitle({required Object label}) => 'Pull — ${label}';
	@override String pushTitle({required Object label}) => 'Push — ${label}';
	@override String updateFromParentTitle({required Object name}) => 'Atualizar a partir do Pai — ${name}';
	@override String mergeToParentTitle({required Object name}) => 'Merge para o Pai — ${name}';
	@override String get worktreeMergedAndRemoved => 'Worktree mesclada e removida.';
	@override String get nothingWasChanged => 'Nada foi alterado.';
	@override String get newRealmTitle => 'Novo realm';
	@override String get closeWorkspaceTitle => 'Fechar workspace';
	@override String closeWorkspaceMessage({required Object name}) => 'Fechar "${name}"? Os agentes deste workspace serão encerrados. A pasta no disco é mantida.';
	@override String get closeAction => 'Fechar';
	@override String get removeWorktreeTitle => 'Remover worktree';
	@override String removeWorktreeMessage({required Object name, required Object warn}) => 'Remover "${name}"? A pasta da worktree e o branch serão excluídos e os agentes deste fork serão encerrados.${warn}';
	@override String removeWorktreeWarning({required Object name}) => '\n\nAviso: o branch "${name}" ainda não foi mesclado — removê-lo (git branch -D) descarta o trabalho não mesclado.';
	@override String get failedToRemoveWorktreeTitle => 'Falha ao remover a worktree';
	@override String get openLayoutTitle => 'Abrir layout';
	@override String get replaceLayoutTitle => 'Substituir o layout atual?';
	@override String replaceLayoutMessage({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: '1 aba será fechada, e ela tem um processo em execução.',
		other: '${n} abas serão fechadas, inclusive as com processos em execução.',
	);
	@override String get replaceLayoutConfirm => 'Substituir';
	@override String get restartServerTooltip => 'Reiniciar servidor';
	@override String get noLspAvailable => 'Nenhum LSP disponível';
	@override String get lspRunning => 'em execução';
	@override String get lspStopped => 'parado';
}

// Path: gsh.welcomeView
class _Translations$gsh$welcomeView$pt_BR extends Translations$gsh$welcomeView$en {
	_Translations$gsh$welcomeView$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bem-vindo ao GSH Desktop';
	@override String get subtitle => 'Abra uma pasta ou conecte a um host remoto para começar.';
	@override String get createWorkspace => 'Criar workspace';
	@override String get openLocalFolder => 'Abrir pasta local';
	@override String get connectHost => 'Conectar a um host';
	@override String get configureHost => 'Configurar host';
	@override String get addWorkspace => 'Adicionar workspace';
}

// Path: gsh.paneView
class _Translations$gsh$paneView$pt_BR extends Translations$gsh$paneView$en {
	_Translations$gsh$paneView$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get closePaneTitle => 'Fechar painel?';
	@override String closePaneMessage({required Object count}) => 'Isso fecha todas as ${count} aba(s) deste painel e encerra os agentes/terminais nele.';
	@override String get close => 'Fechar';
	@override String get closeOtherTabs => 'Fechar as outras';
	@override String get closeTabsToTheRight => 'Fechar à direita';
	@override String get closeAllTabs => 'Fechar todas';
	@override String get closeTabsTitle => 'Fechar abas?';
	@override String closeTabsMessage({required Object count}) => 'Isso fecha ${count} aba(s) e encerra os agentes/terminais nelas.';
	@override String get allTabs => 'Todas as abas';
	@override String get pinTab => 'Fixar aba';
	@override String get openInNewWindow => 'Abrir em nova janela';
	@override String get rename => 'Renomear';
	@override String get openAsMarkdown => 'Abrir como markdown';
	@override String get openAsBoard => 'Abrir como quadro';
	@override String get resetTitle => 'Redefinir título';
	@override String get copyId => 'Copiar Id';
	@override String get restartTab => 'Reiniciar';
	@override String get newTab => 'Nova aba';
	@override String get newTerminal => 'Novo terminal…';
	@override String get splitRight => 'Dividir à direita';
	@override String get splitDown => 'Dividir abaixo';
	@override String get closePane => 'Fechar painel';
	@override String get dropHereToMove => 'Solte aqui para mover a aba';
	@override String get dockAsTab => 'Encaixar como aba';
	@override String get openBrowser => 'Abrir navegador';
	@override String get openTerminal => 'Abrir terminal';
	@override String get openAsLayout => 'Abrir como layout';
	@override String get openAsYaml => 'Abrir como YAML';
	@override String get openAsPanel => 'Abrir como painel';
	@override String get openAsHtml => 'Abrir como HTML';
}

// Path: gsh.fileTreePanel
class _Translations$gsh$fileTreePanel$pt_BR extends Translations$gsh$fileTreePanel$en {
	_Translations$gsh$fileTreePanel$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get viewDiff => 'Ver Diff';
	@override String get commit => 'Commit';
	@override String get stageAndCommit => 'Stage e Commit';
	@override String get unstage => 'Tirar do stage';
	@override String get stageChanges => 'Colocar no stage';
	@override String get discardChanges => 'Descartar alterações';
	@override String get enterCommitMessage => 'Digite uma mensagem de commit.';
	@override String get commitUnavailable => 'Commit indisponível para este workspace.';
	@override String get gitErrorTitle => 'Erro do Git';
	@override String get deleteNewFileTitle => 'Excluir arquivo novo?';
	@override String get discardChangesTitle => 'Descartar alterações?';
	@override String deleteNewFileMessage({required Object name}) => '"${name}" é um arquivo novo e não pode ser restaurado. Excluir?';
	@override String discardOneMessage({required Object name}) => 'Descartar todas as alterações em "${name}"? Arquivos excluídos serão restaurados.';
	@override String get discard => 'Descartar';
	@override String get deleteAllNewFilesTitle => 'Excluir todos os arquivos novos?';
	@override String allNewFilesMessage({required Object count}) => 'Todos os ${count} arquivos são novos e serão excluídos. Isso não pode ser desfeito.';
	@override String discardTrackedMessage({required Object count, required Object extra}) => 'Descartar alterações em ${count} arquivo(s) rastreado(s)?${extra}';
	@override String discardTrackedExtra({required Object count}) => ' ${count} arquivo(s) novo(s) será(ão) mantido(s).';
	@override String get deleteAll => 'Excluir tudo';
	@override String get deleteQuestionTitle => 'Excluir?';
	@override String moveToTrash({required Object name}) => 'Mover “${name}” para a Lixeira?';
	@override String permanentlyDelete({required Object name}) => 'Excluir “${name}” permanentemente? Isso não pode ser desfeito.';
	@override String get couldNotDeleteTitle => 'Não foi possível excluir';
	@override String get moveQuestionTitle => 'Mover?';
	@override String moveMessage({required Object name, required Object dest}) => 'Mover “${name}” para “${dest}”?';
	@override String get moveAction => 'Mover';
	@override String get couldNotMoveTitle => 'Não foi possível mover';
	@override String get couldNotPasteTitle => 'Não foi possível colar';
	@override String get filesTooltip => 'Arquivos';
	@override String get searchTooltip => 'Buscar';
	@override String get sourceControlTooltip => 'Controle de versão';
	@override String get databaseTooltip => 'Banco de dados';
	@override String get sectionFiles => 'ARQUIVOS';
	@override String get newFile => 'Novo arquivo';
	@override String get newFolder => 'Nova pasta';
	@override String get refreshTooltip => 'Atualizar';
	@override String get agentFilterTooltip => 'Filtrar por agente';
	@override String get allAgents => 'Todos os agentes';
	@override String get trackingUnavailable => 'rastreio indisponível';
	@override String editedBy({required Object label, required Object time}) => 'Editado por ${label} · ${time}';
	@override String get inferredSuffix => '(inferido)';
	@override String get noTouchedFiles => 'Nenhum arquivo tocado por este agente ainda';
	@override String get concurrentAgentEdits => 'Editado por 2+ agentes nos últimos 10 minutos';
	@override String get collapseAll => 'Recolher todas as pastas';
	@override String get sectionSourceControl => 'CONTROLE DE VERSÃO';
	@override String get viewAsList => 'Ver como lista';
	@override String get viewAsTree => 'Ver como árvore';
	@override String get noFolderMessage => 'Nenhuma pasta — abra um workspace.';
	@override String get amend => 'Amend';
	@override String get commitMessagePlaceholder => 'Mensagem do commit';
	@override String get amendCommit => 'Amend do commit';
	@override String get lastCommit => 'último commit';
	@override String get openInFinder => 'Abrir no Finder';
	@override String get openInExplorer => 'Abrir no Explorer';
	@override String get openInFileManager => 'Abrir no gerenciador de arquivos';
	@override String get open => 'Abrir';
	@override String get openWith => 'Abrir com';
	@override String get openInNewWindow => 'Abrir em nova janela';
	@override String get openLayout => 'Abrir layout';
	@override String get openAsMarkdown => 'Abrir como markdown';
	@override String get showGitDiff => 'Mostrar diff do git';
	@override String get createTerminal => 'Abrir no terminal';
	@override String get rename => 'Renomear';
	@override String get copy => 'Copiar';
	@override String get cut => 'Recortar';
	@override String get paste => 'Colar';
	@override String get copyRelativePath => 'Copiar caminho relativo';
	@override String get copyAbsolutePath => 'Copiar caminho absoluto';
	@override String get renameFailed => 'Falha ao renomear.';
	@override String get noChanges => 'Nenhuma alteração.';
	@override String stagedChangesHeader({required Object count}) => 'ALTERAÇÕES EM STAGE (${count})';
	@override String changesHeader({required Object count}) => 'ALTERAÇÕES (${count})';
	@override String get discardAllChanges => 'Descartar todas as alterações';
	@override String get unstageAllChanges => 'Tirar tudo do stage';
	@override String get stageAllChanges => 'Colocar tudo no stage';
	@override String get discardFolderChanges => 'Descartar alterações da pasta';
	@override String get unstageFolderChanges => 'Tirar pasta do stage';
	@override String get stageFolderChanges => 'Colocar pasta no stage';
	@override String get generateCommitMessage => 'Gerar mensagem de commit';
	@override String generateWith({required Object harness}) => 'Gerar com ${harness}';
	@override String get generateUnavailableWhileAmending => 'Indisponível durante o amend de um commit';
	@override String get cancelGeneration => 'Cancelar geração';
	@override String get changes => 'Alteracoes';
	@override String get history => 'Historico';
	@override String get historyRepository => 'Repositorio';
	@override String get historyNoRepository => 'Nenhum repositorio Git disponivel.';
	@override String get historyEmpty => 'Nenhum commit encontrado.';
	@override String get historyLoadFailed => 'Nao foi possivel carregar o historico Git.';
	@override String get historyUntitledCommit => 'Commit sem titulo';
	@override String get historyNow => 'agora';
	@override String historyMinutesAgo({required Object count}) => 'ha ${count} min';
	@override String historyHoursAgo({required Object count}) => 'ha ${count} h';
	@override String get historyYesterday => 'ontem';
	@override String get historyDayAgo => 'ha 1 dia';
	@override String historyDaysAgo({required Object count}) => 'ha ${count} dias';
	@override String get historyFiles => 'Arquivos alterados';
	@override String get historyFilesEmpty => 'Nenhum arquivo alterado.';
	@override String get historyFilesLoadFailed => 'Nao foi possivel carregar os arquivos alterados.';
	@override String get diffEmptyTree => 'Arvore vazia';
	@override String diffOriginal({required Object ref}) => 'Original ${ref}';
	@override String diffModified({required Object ref}) => 'Modificado ${ref}';
	@override String get diffWorkingTree => 'Diretorio de trabalho';
	@override String get diffBinaryFile => 'Arquivo binario - sem diff de texto.';
	@override String get diffNoChanges => 'Sem alteracoes.';
	@override String diffError({required Object detail}) => 'Não foi possível ler o diff: ${detail}';
	@override String get galleryTooltip => 'Galeria';
	@override String get sectionGallery => 'GALERIA';
	@override String get openAsHtml => 'Abrir como HTML';
	@override String get importQuestionTitle => 'Copiar aqui?';
	@override String importMessage({required Object count, required Object dest}) => 'Copiar ${count} itens para “${dest}”?';
	@override String get importAction => 'Copiar';
	@override String get couldNotImportTitle => 'Não foi possível copiar';
	@override String openInAgent({required Object harness}) => 'Abrir no ${harness}';
}

// Path: gsh.fileViewer
class _Translations$gsh$fileViewer$pt_BR extends Translations$gsh$fileViewer$en {
	_Translations$gsh$fileViewer$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get cantOpen => 'Não é possível abrir este arquivo.';
	@override String get couldNotLoadImage => 'Não foi possível carregar a imagem.';
	@override String get preview => 'Pré-visualização';
	@override String get source => 'Código-fonte';
	@override String get reload => 'Recarregar';
}

// Path: gsh.workspaceSettingsDialog
class _Translations$gsh$workspaceSettingsDialog$pt_BR extends Translations$gsh$workspaceSettingsDialog$en {
	_Translations$gsh$workspaceSettingsDialog$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get choosePhotoTitle => 'Escolher foto do workspace';
	@override String get title => 'Configurações do workspace';
	@override String get namePlaceholder => 'Nome do workspace';
	@override String get addPhoto => 'Adicionar foto';
	@override String get changePhoto => 'Alterar foto';
	@override String get remove => 'Remover';
	@override String get color => 'Cor';
	@override String get host => 'Host';
	@override String get folder => 'Pasta';
}

// Path: gsh.realmDialogs
class _Translations$gsh$realmDialogs$pt_BR extends Translations$gsh$realmDialogs$en {
	_Translations$gsh$realmDialogs$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => 'Nome do realm';
	@override String get duplicateName => 'Já existe um realm com esse nome.';
	@override String get newRealmTitle => 'Novo realm';
	@override String get renameRealmTitle => 'Renomear realm';
	@override String get rename => 'Renomear';
	@override String get deleteRealmTitle => 'Excluir realm';
	@override String deleteMessage({required Object name, required Object suffix}) => 'Excluir "${name}"? Nenhum workspace é excluído — só a lista de pastas muda.${suffix}';
	@override String get deleteSuffixOne => ' O workspace dele irá para o Padrão.';
	@override String deleteSuffixMany({required Object count}) => ' Os ${count} workspaces dele irão para o Padrão.';
	@override String get manageRealmsTitle => 'Gerenciar realms';
	@override String workspaceCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: '1 workspace',
		other: '${n} workspaces',
	);
}

// Path: gsh.dbRedisTable
class _Translations$gsh$dbRedisTable$pt_BR extends Translations$gsh$dbRedisTable$en {
	_Translations$gsh$dbRedisTable$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get deleteKeyTitle => 'Excluir chave';
	@override String deleteKeyMessage({required Object key}) => 'Excluir "${key}" deste banco Redis?';
	@override String get refresh => 'Atualizar';
	@override String get newKey => 'Nova chave';
	@override String get columnKey => 'CHAVE';
	@override String get columnValue => 'VALOR';
	@override String get columnType => 'TIPO';
	@override String get columnTtl => 'TTL';
	@override String keyCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: '1 chave',
		other: '${n} chaves',
	);
	@override String get noKeys => 'Nenhuma chave neste banco de dados.';
	@override String noKeysMatch({required Object pattern}) => 'Nenhuma chave corresponde a "${pattern}".';
	@override String get loadMore => 'Carregar mais';
	@override String get loadingFullValue => 'Carregando valor completo…';
	@override String get ttlMustBeNumber => 'TTL deve ser um número de segundos.';
	@override String get addKey => 'Adicionar chave';
	@override String get keyFieldHint => 'chave';
	@override String get ttlFieldHint => 'ttl (s, opcional)';
	@override String get valueFieldHint => 'valor';
	@override String get searchHint => 'Buscar — padrão, ex.: user:*';
}

// Path: gsh.dbQueryView
class _Translations$gsh$dbQueryView$pt_BR extends Translations$gsh$dbQueryView$en {
	_Translations$gsh$dbQueryView$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get saveQueryAs => 'Salvar query como';
	@override String get couldNotSave => 'Não foi possível salvar';
	@override String get selectDatabase => 'Selecionar banco de dados';
	@override String get noSqlConnections => 'Nenhuma conexão SQL';
	@override String get running => 'Executando…';
	@override String get runSelection => 'Executar seleção';
	@override String get run => 'Executar';
	@override String get pickDatabaseHint => 'Escolha um banco de dados acima e depois Executar (⌘↵).';
	@override String get runQueryHint => 'Execute a query (⌘↵) para ver os resultados aqui.';
	@override String get noRows => 'Nenhuma linha.';
	@override String rowsAffected({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: '1 linha afetada',
		other: '${n} linhas afetadas',
	);
	@override String rowsFooter({required Object n}) => '${n} linhas';
	@override String get truncatedSuffix => ' · truncado (aumente -- limit)';
	@override String get table => 'Tabela';
	@override String get json => 'JSON';
	@override String get unsaved => 'não salvo';
	@override String get saved => 'salvo';
	@override String get copied => 'Copiado';
	@override String get copy => 'Copiar';
}

// Path: gsh.httpView
class _Translations$gsh$httpView$pt_BR extends Translations$gsh$httpView$en {
	_Translations$gsh$httpView$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get saveRequestAs => 'Salvar request como';
	@override String get couldNotSave => 'Não foi possível salvar';
	@override String get run => 'Executar';
	@override String get running => 'Executando…';
	@override String get noRequests => 'Nenhum request neste arquivo — escreva um, ex.: GET https://example.com';
	@override String get selectRequest => 'Selecionar request';
	@override String requestCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: '1 request',
		other: '${n} requests',
	);
	@override String get runHint => 'Execute o request (⌘↵) para ver a resposta aqui.';
	@override String get emptyBody => 'Corpo da resposta vazio.';
	@override String get body => 'JSON';
	@override String get headers => 'Headers';
	@override String get raw => 'Text';
	@override String get truncatedSuffix => ' · truncado (resposta grande demais)';
	@override late final _Translations$gsh$httpView$error$pt_BR error = _Translations$gsh$httpView$error$pt_BR._(_root);
}

// Path: gsh.kanbanView
class _Translations$gsh$kanbanView$pt_BR extends Translations$gsh$kanbanView$en {
	_Translations$gsh$kanbanView$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get filter => 'Filtrar';
	@override String get filterTitlePlaceholder => 'Buscar por título';
	@override String get filterLabels => 'Marcadores';
	@override String get filterClear => 'Limpar';
	@override String get filterDependencies => 'Dependências';
	@override String get filterBlocked => 'Bloqueado';
	@override String get filterReady => 'Pronto';
	@override String get blockedBy => 'Bloqueado por';
	@override String get addBlocker => 'Adicionar card bloqueador';
	@override String get searchCards => 'Buscar cards';
	@override String get unknownCard => 'desconhecido';
	@override String get boardView => 'Quadro';
	@override String get listView => 'Lista';
	@override String get refresh => 'Atualizar do disco';
	@override String get manageLabels => 'Marcadores';
	@override String get labelsTitle => 'Marcadores deste quadro';
	@override String get labelNamePlaceholder => 'nome do marcador';
	@override String labelUsage({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: '1 card',
		other: '${n} cards',
	);
	@override String get deleteLabel => 'Apagar marcador';
	@override String get newCard => 'novo card';
	@override String get newCardTitle => 'Novo card';
	@override String get newColumn => 'Nova coluna';
	@override String get columnNameTitle => 'Nome da coluna';
	@override String get dragColumn => 'Arrastar coluna';
	@override String get columnOptions => 'Opções da coluna';
	@override String get renameColumn => 'Renomear coluna';
	@override String get moveColumnLeft => 'Mover pra esquerda';
	@override String get moveColumnRight => 'Mover pra direita';
	@override String get deleteColumn => 'Apagar coluna';
	@override String get newCardHere => 'Novo card aqui';
	@override String get duplicateCard => 'Duplicar';
	@override String get cardLabels => 'Marcadores';
	@override String get deleteCard => 'Apagar card';
	@override String get advance => 'Passar pra próxima coluna';
	@override String get advanceHold => 'Mover para a próxima coluna (segurar: mover para a última)';
	@override String get advanceBack => 'Voltar uma coluna';
	@override String get emptyColumn => 'Sem cards';
	@override String cardCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: '1 card',
		other: '${n} cards',
	);
	@override String get notes => 'Nota';
	@override String get notesPlaceholder => 'Escreva uma nota';
	@override String get comments => 'Comentários';
	@override String get addComment => 'Adicionar comentário';
	@override String get commentPlaceholder => 'Escreva um comentário';
	@override String get noComments => 'Nenhum comentário ainda';
	@override String get closeDetail => 'Fechar';
	@override String get notABoard => 'Este arquivo ainda não tem colunas ## — ele abre como markdown.';
	@override String get startBoard => 'Começar um quadro';
	@override String get couldNotSave => 'Não deu pra salvar o quadro';
	@override String get unrecognizedBlock => 'Não reconhecido pelo parser — arrasta inteiro, sem edição inline.';
	@override late final _Translations$gsh$kanbanView$deleteColumnDialog$pt_BR deleteColumnDialog = _Translations$gsh$kanbanView$deleteColumnDialog$pt_BR._(_root);
}

// Path: gsh.dbPanel
class _Translations$gsh$dbPanel$pt_BR extends Translations$gsh$dbPanel$en {
	_Translations$gsh$dbPanel$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionDatabase => 'BANCO DE DADOS';
	@override String get edit => 'Editar…';
	@override String get copyName => 'Copiar nome';
	@override String get newQuery => 'Nova query';
	@override String get browseKeys => 'Ver chaves';
	@override String get deleteConnectionTitle => 'Excluir conexão';
	@override String deleteConnectionMessage({required Object name}) => 'Remover "${name}" deste workspace? Qualquer senha salva será descartada. Arquivos .dbq que fazem referência a ela não são afetados.';
	@override String footer({required Object n}) => '.gsh/databases.json · ${n} conexões';
	@override String get footerOne => '.gsh/databases.json · 1 conexão';
	@override String get noConnections => 'Nenhuma conexão ainda.';
	@override String get passwordRequired => 'Senha não encontrada no host. Abra esta conexão e digite-a de novo — ela fica salva na máquina que executa o banco, não nesta.';
}

// Path: gsh.dbMongoView
class _Translations$gsh$dbMongoView$pt_BR extends Translations$gsh$dbMongoView$en {
	_Translations$gsh$dbMongoView$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get deleteDocumentTitle => 'Excluir documento';
	@override String deleteDocumentMessage({required Object id, required Object collection}) => 'Excluir o documento com _id ${id} de "${collection}"?';
	@override String get filterHint => 'Filtro — JSON, ex.: {"status": "active"}';
	@override String docCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: '1 doc',
		other: '${n} docs',
	);
	@override String get refresh => 'Atualizar';
	@override String get insertDocument => 'Inserir documento';
	@override String get noDocuments => 'Nenhum documento nesta coleção.';
	@override String get noDocumentsMatch => 'Nenhum documento corresponde a este filtro.';
	@override String get loadMore => 'Carregar mais';
	@override String get edit => 'Editar';
	@override String get insert => 'Inserir';
}

// Path: gsh.dbConnectionDialog
class _Translations$gsh$dbConnectionDialog$pt_BR extends Translations$gsh$dbConnectionDialog$en {
	_Translations$gsh$dbConnectionDialog$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get chooseFileTitle => 'Escolher banco SQLite';
	@override String get file => 'Arquivo';
	@override String get chooseFilePlaceholder => 'Escolha um arquivo SQLite…';
	@override String get name => 'Nome';
	@override String get password => 'Senha';
	@override String get savePassword => 'Salvar senha';
	@override String get allowWrites => 'Permitir escrita (agentes)';
	@override String get allowWritesHint => 'desligado = agentes só leem via CLI';
	@override String get visibleToAgents => 'Visível para agentes';
	@override String get visibleToAgentsHint => 'desligado = oculto da CLI, só na GUI';
	@override String get testing => 'Testando conexão…';
	@override String get connectionOk => 'Conexão OK';
	@override String get connectionFailed => 'Falha na conexão';
	@override String get editTitle => 'Editar conexão';
	@override String get newTitle => 'Nova conexão';
	@override String get connectionString => 'Connection string';
	@override String get invalidUrl => 'URL de conexão inválida.';
	@override String get sshTunnel => 'Túnel SSH';
	@override String get sshHost => 'Host SSH';
	@override String get sshPort => 'Porta SSH';
	@override String get sshUser => 'Usuário SSH';
	@override String get privateKey => 'Chave privada';
	@override String get choosePrivateKeyPlaceholder => 'Escolha uma chave privada…';
	@override String get choosePrivateKeyDialogTitle => 'Escolher chave privada SSH';
	@override String get keyPassphrase => 'Senha da chave';
	@override String get savePassphrase => 'Salvar senha da chave';
	@override String get passwordOnHost => 'A senha fica salva no host, não nesta máquina.';
}

// Path: gsh.sshPrompts
class _Translations$gsh$sshPrompts$pt_BR extends Translations$gsh$sshPrompts$en {
	_Translations$gsh$sshPrompts$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get unknownSshHostTitle => 'Host SSH desconhecido';
	@override String neverConnected({required Object endpoint}) => 'O GSH Desktop nunca se conectou a ${endpoint} antes.';
	@override String get trustHint => 'Confie apenas se esta fingerprint corresponder ao servidor. Você pode verificar no servidor com:';
	@override String get trust => 'Confiar';
	@override String get sshKeyPassphraseTitle => 'Senha da chave SSH';
	@override String unlockMessage({required Object keyPath, required Object connectionName}) => 'Desbloqueie ${keyPath} para conectar "${connectionName}".';
	@override String get keptInMemoryHint => 'Mantida em memória até o GSH Desktop fechar. Para permitir que agentes usem esta conexão, ative "Salvar senha da chave" na conexão.';
	@override String get unlock => 'Desbloquear';
}

// Path: gsh.projectsRail
class _Translations$gsh$projectsRail$pt_BR extends Translations$gsh$projectsRail$en {
	_Translations$gsh$projectsRail$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get workspaces => 'Workspaces';
	@override String get keepAwakeOn => 'Mantendo este computador acordado para acesso remoto. Clique para deixá-lo dormir de novo.';
	@override String get keepAwakeOff => 'Manter este computador acordado para acesso remoto. Desliga sozinho quando o GSH Desktop reinicia.';
	@override String get keepAwakeBattery => 'Acordado na bateria. Isso consome a bateria.';
	@override String get keepAwakeLid => 'Fechar a tampa do notebook continua colocando-o para dormir.';
	@override String get newWorkspace => 'Novo workspace';
	@override String get settings => 'Configurações';
	@override String get mergeToParent => 'Mesclar no pai';
	@override String get updateFromParent => 'Atualizar a partir do pai';
	@override String get forkWorktree => 'Criar worktree derivada';
	@override String get copyBranch => 'Copiar branch';
	@override String get remove => 'Remover';
	@override String get moveToRealm => 'Mover para realm';
	@override String get copyWorkspaceId => 'Copiar id do workspace';
	@override String get rename => 'Renomear';
	@override String get close => 'Fechar';
	@override String get newRealm => 'Novo realm…';
	@override String get manageRealms => 'Gerenciar realms…';
	@override String get noWorkspaces => 'Nenhum workspace ainda.';
	@override String get sync => 'Sincronizar';
	@override String get pull => 'Pull';
	@override String get push => 'Push';
	@override String get createWorktree => 'Criar worktree';
	@override String worktreeCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: '1 worktree',
		other: '${n} worktrees',
	);
	@override String get expandWorktrees => 'Expandir worktrees';
	@override String get collapseWorktrees => 'Recolher worktrees';
}

// Path: gsh.findBar
class _Translations$gsh$findBar$pt_BR extends Translations$gsh$findBar$en {
	_Translations$gsh$findBar$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get find => 'Buscar';
	@override String get matchCase => 'Diferenciar maiúsculas';
	@override String get wholeWord => 'Palavra inteira';
	@override String get useRegex => 'Usar expressão regular';
	@override String get previous => 'Anterior (⇧⏎)';
	@override String get next => 'Próximo (⏎)';
	@override String get close => 'Fechar (Esc)';
	@override String get badPattern => 'Padrão inválido';
	@override String get noResults => 'Nenhum resultado';
}

// Path: gsh.contentSearch
class _Translations$gsh$contentSearch$pt_BR extends Translations$gsh$contentSearch$en {
	_Translations$gsh$contentSearch$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionSearch => 'BUSCA';
	@override String get searchInFiles => 'Buscar nos arquivos';
	@override String get matchCase => 'Diferenciar maiúsculas';
	@override String get wholeWord => 'Palavra inteira';
	@override String get useRegex => 'Usar expressão regular';
	@override String get invalidRegex => 'Expressão regular inválida.';
	@override String get typeToSearch => 'Digite para buscar em todos os arquivos.';
	@override String get searching => 'Buscando…';
	@override String get noResults => 'Nenhum resultado.';
}

// Path: gsh.topbar
class _Translations$gsh$topbar$pt_BR extends Translations$gsh$topbar$en {
	_Translations$gsh$topbar$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get collapseSidebar => 'Recolher barra lateral';
	@override String get toggleFiles => 'Mostrar/ocultar arquivos';
	@override String get filesUnavailable => 'Arquivos indisponíveis no GSH Desktop';
	@override String get hideKeyboard => 'Baixar teclado';
	@override String get visualizeAgents => 'Visualizar agentes';
	@override String get openFarm => 'Fazenda de agentes';
	@override String get openChat => 'Chat com o Claude (beta)';
}

// Path: gsh.tasks
class _Translations$gsh$tasks$pt_BR extends Translations$gsh$tasks$en {
	_Translations$gsh$tasks$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get hotReload => 'Hot reload';
	@override String get hotRestart => 'Hot restart';
	@override String get toggleDebugPaint => 'Alternar debug paint';
	@override String get togglePlatform => 'Alternar plataforma';
	@override String get quit => 'Sair';
}

// Path: gsh.notifications
class _Translations$gsh$notifications$pt_BR extends Translations$gsh$notifications$en {
	_Translations$gsh$notifications$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get agentFinished => 'Agente terminou';
	@override String get open => 'Abrir';
	@override String get agentNeedsAction => 'Agente precisa de você';
}

// Path: gsh.terminalLink
class _Translations$gsh$terminalLink$pt_BR extends Translations$gsh$terminalLink$en {
	_Translations$gsh$terminalLink$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get open => 'Abrir';
	@override String get revealFinder => 'Mostrar no Finder';
	@override String get revealExplorer => 'Mostrar no Explorer';
	@override String get revealFolder => 'Abrir pasta';
	@override String get copyPath => 'Copiar caminho';
	@override String get openLink => 'Abrir link';
	@override String get copyLink => 'Copiar link';
}

// Path: gsh.terminal
class _Translations$gsh$terminal$pt_BR extends Translations$gsh$terminal$en {
	_Translations$gsh$terminal$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String cwdFallbackWarning({required Object requested, required Object path}) => 'Aviso: a pasta "${requested}" não existe. Este terminal abriu em "${path}".';
	@override String workspaceEnvTracked({required Object keys}) => 'Aviso: o .env.gsh está rastreado pelo git (veio com o repositório). Injetado: ${keys}';
}

// Path: gsh.remoteHost
class _Translations$gsh$remoteHost$pt_BR extends Translations$gsh$remoteHost$en {
	_Translations$gsh$remoteHost$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get addHost => 'Adicionar host remoto';
	@override String get hostName => 'Nome';
	@override String get sshTarget => 'Destino SSH (usuário@host)';
	@override String connecting({required Object host}) => 'Conectando a ${host}…';
	@override String get openingTunnel => 'Túnel SSH';
	@override String get installingServer => 'Instalando servidor';
	@override String handshake({required Object version}) => 'Servidor ${version}';
	@override String get loadingWorkspace => 'Carregando workspace…';
	@override String reconnecting({required Object host}) => 'Reconectando a ${host}…';
	@override String offline({required Object host}) => '${host} offline';
	@override String get remove => 'Remover';
	@override String get reconnect => 'Reconectar';
	@override String get installServer => 'Instalar servidor';
	@override String errSshUnreachable({required Object host}) => 'Não foi possível alcançar ${host} via SSH. Está ligado e com o Login Remoto ativado?';
	@override String errInstallFailed({required Object host}) => 'Não foi possível instalar o servidor em ${host}.';
	@override String get errVersionMismatch => 'Versão do servidor incompatível; atualize-o.';
	@override String errDetail({required Object detail}) => 'Detalhes: ${detail}';
	@override String pickFolderTitle({required Object host}) => 'Abrir pasta em ${host}';
	@override String get openHere => 'Abrir aqui';
	@override String get emptyFolder => 'Sem subpastas';
	@override String get newLocal => 'Local';
	@override String get newRemote => 'Remoto';
	@override String get chooseHost => 'Escolher um host';
	@override String get newHostEntry => 'Novo host…';
	@override String get editHost => 'Editar host';
	@override String get userLabel => 'Usuário';
	@override String get hostLabel => 'Host / IP';
	@override String get portLabel => 'Porta';
	@override String get authLabel => 'Autenticação';
	@override String get authKey => 'Chave SSH';
	@override String get authPassword => 'Senha';
	@override String get passwordLabel => 'Senha';
	@override String get passwordKeep => 'Deixe em branco para manter a atual';
	@override String get errUser => 'Usuário obrigatório';
	@override String get errHost => 'Host obrigatório';
	@override String get errPassword => 'Senha obrigatória';
	@override String get identityChoose => 'Escolher…';
	@override String get identityEmpty => 'Nenhuma chave selecionada';
	@override String get identityDialogTitle => 'Selecione a chave privada SSH';
	@override String get errIdentity => 'Escolha a chave privada para autenticar.';
	@override String errHostKeyUnknown({required Object host}) => 'O GSH Desktop ainda não confia em ${host}. Conecte de novo e confirme o fingerprint.';
	@override String errHostKeyChanged({required Object host}) => '${host} está apresentando uma chave SSH diferente da guardada. Se você não reinstalou essa máquina, pare e verifique — se reinstalou, remova a entrada antiga do ~/.ssh/known_hosts.';
	@override String errHostBundleMissing({required Object host}) => '${host} é Windows mas não tem o GSH Desktop instalado. O servidor remoto é instalado a partir do bundle do GSH Desktop que já está naquela máquina — instale o GSH Desktop lá e tente de novo.';
	@override String errHostUnknownOs({required Object host}) => 'Não foi possível identificar o sistema de ${host}. A conta pode ter shell restrito, ou nenhum shell.';
	@override String get errIdentityPublic => 'Só a chave pública está aqui. Isso só funciona se a privada estiver no seu agente SSH; senão, escolha a privada (mesmo nome, sem .pub).';
	@override String get errIdentityNotKey => 'Esse arquivo não parece uma chave privada.';
	@override String get errIdentityMissingFile => 'Esse arquivo não existe mais.';
	@override String get errIdentityUnreadable => 'Não foi possível ler esse arquivo.';
}

// Path: gsh.browserPane
class _Translations$gsh$browserPane$pt_BR extends Translations$gsh$browserPane$en {
	_Translations$gsh$browserPane$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get back => 'Voltar';
	@override String get forward => 'Avançar';
	@override String get reload => 'Recarregar';
	@override String get urlHint => 'Digite a URL ou endereço';
	@override String get go => 'Ir';
}

// Path: gsh.documentWindow
class _Translations$gsh$documentWindow$pt_BR extends Translations$gsh$documentWindow$en {
	_Translations$gsh$documentWindow$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get mediaNotSupported => 'Áudio e vídeo abrem na janela principal do GSH Desktop.';
	@override String fileNotFound({required Object path}) => 'Arquivo não encontrado: ${path}';
}

// Path: gsh.gallery
class _Translations$gsh$gallery$pt_BR extends Translations$gsh$gallery$en {
	_Translations$gsh$gallery$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get intro => 'Documentos especiais do GSH Desktop para que você tenha o visual do que o agente de IA esteja fazendo.';
	@override String get createErrorTitle => 'Não foi possível criar o arquivo';
	@override late final _Translations$gsh$gallery$dbQuery$pt_BR dbQuery = _Translations$gsh$gallery$dbQuery$pt_BR._(_root);
	@override late final _Translations$gsh$gallery$kanban$pt_BR kanban = _Translations$gsh$gallery$kanban$pt_BR._(_root);
	@override late final _Translations$gsh$gallery$layout$pt_BR layout = _Translations$gsh$gallery$layout$pt_BR._(_root);
	@override late final _Translations$gsh$gallery$httpRequest$pt_BR httpRequest = _Translations$gsh$gallery$httpRequest$pt_BR._(_root);
	@override late final _Translations$gsh$gallery$html$pt_BR html = _Translations$gsh$gallery$html$pt_BR._(_root);
	@override late final _Translations$gsh$gallery$tasks$pt_BR tasks = _Translations$gsh$gallery$tasks$pt_BR._(_root);
	@override late final _Translations$gsh$gallery$notebook$pt_BR notebook = _Translations$gsh$gallery$notebook$pt_BR._(_root);
	@override late final _Translations$gsh$gallery$workspaceEnv$pt_BR workspaceEnv = _Translations$gsh$gallery$workspaceEnv$pt_BR._(_root);
	@override late final _Translations$gsh$gallery$panel$pt_BR panel = _Translations$gsh$gallery$panel$pt_BR._(_root);
}

// Path: gsh.notebook
class _Translations$gsh$notebook$pt_BR extends Translations$gsh$notebook$en {
	_Translations$gsh$notebook$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get notes => 'Notas';
	@override String get newNote => 'Nova nota';
	@override String get searchPlaceholder => 'Buscar notas';
	@override String get empty => 'Nenhuma nota ainda. Crie uma, ou peça pro agente escrever aqui.';
	@override String get noMatch => 'Nenhuma nota bate com o filtro.';
	@override String get selectNote => 'Selecione uma nota';
	@override String get reload => 'Recarregar do disco';
	@override String get untagged => 'sem tag';
	@override String get saveFailed => 'Não foi possível salvar a nota';
	@override String get createFailed => 'Não foi possível criar a nota';
	@override String get addTag => 'adicionar tag';
	@override String get untitled => 'Sem título';
	@override String get deleteNote => 'Apagar nota';
	@override String deleteConfirm({required Object name}) => 'Mover “${name}” pra lixeira?';
	@override String get imageFailed => 'Não foi possível salvar a imagem';
	@override late final _Translations$gsh$notebook$format$pt_BR format = _Translations$gsh$notebook$format$pt_BR._(_root);
	@override String get backlinks => 'Citada em';
	@override String get renameTag => 'Renomear tag';
	@override String get deleteTag => 'Apagar tag';
	@override String deleteTagConfirm({required Object name, required Object count}) => 'Remover “${name}” de ${count} notas? As notas ficam.';
	@override String get showList => 'Mostrar lista de notas';
	@override String get hideList => 'Ocultar lista de notas';
}

// Path: gsh.layoutPreview
class _Translations$gsh$layoutPreview$pt_BR extends Translations$gsh$layoutPreview$en {
	_Translations$gsh$layoutPreview$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get applyFailedTitle => 'Não foi possível aplicar o layout';
	@override String get applyInGsh => 'Aplicar no GSH Desktop';
	@override String get applyNewWorkspace => 'Abrir como novo workspace';
	@override String applyTo({required Object workspace}) => 'Aplicar em ${workspace}';
	@override String get autorunWorktree => 'autorun: worktree. Este layout também é aplicado sozinho quando você cria uma worktree do workspace onde ele está.';
	@override String get command => 'Comando';
	@override String get folder => 'Pasta';
	@override String get noCommand => 'sem comando, abre um shell';
	@override String get replaceConfirm => 'Substituir layout';
	@override String replaceMessage({required Object n}) => '${n} abas abertas deste workspace serão fechadas, inclusive as com trabalho em andamento.';
	@override String replaceTitle({required Object workspace}) => 'Substituir o layout de ${workspace}?';
	@override String get skippedTitle => 'Não criados neste sistema';
	@override String get splitDown => 'divide abaixo';
	@override String get splitRight => 'divide à direita';
	@override String get splitTab => 'aba';
	@override String subtitle({required Object n}) => 'Este layout abre ${n} terminais. Leia os comandos antes de aplicar.';
}

// Path: gsh.telemetry
class _Translations$gsh$telemetry$pt_BR extends Translations$gsh$telemetry$en {
	_Translations$gsh$telemetry$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Telemetria';
	@override String get title => 'Telemetria';
	@override String liveRuns({required Object n}) => '${n} ativos';
	@override String get noWorkspace => 'Abra um workspace para ver a telemetria dele.';
	@override String get empty => 'Nada aqui ainda.';
	@override String get emptyFiltered => 'Nada aqui ainda.';
	@override String get searchHint => 'Filtrar casos';
	@override String get chipOpen => 'Abertos';
	@override String get chipNew => 'Novos';
	@override String get chipResolved => 'Resolvidos';
	@override String get chipIgnored => 'Ignorados';
	@override String get chipWarnings => 'Avisos';
	@override String get tagNew => 'novo';
	@override String get tagRegression => 'regressão';
	@override String get tagResolved => 'resolvido';
	@override String get tagIgnored => 'ignorado';
	@override String get srcTask => 'task';
	@override String get srcWrapper => 'gsh telemetry';
	@override String run({required Object id}) => 'run ${id}';
	@override String get resolve => 'Marcar resolvido';
	@override String get ignore => 'Ignorar (some para os agentes também)';
	@override String get reopen => 'Reabrir';
	@override String get clear => 'Limpar ocorrências';
	@override String get clearRun => 'Limpar este run';
	@override String get clearProject => 'Limpar projeto';
	@override String openFile({required Object location}) => 'Abrir ${location}';
	@override String get showInTerminal => 'Ver no terminal';
	@override String get copyCommand => 'Copiar comando da CLI';
	@override String get copied => 'Copiado';
	@override String get statusOpen => 'Aberto';
	@override String get statusResolved => 'Resolvido';
	@override String get statusIgnored => 'Ignorado';
	@override String get occurrences => 'Ocorrências';
	@override String inRuns({required Object n}) => 'em ${n} runs';
	@override String get first => 'Primeira';
	@override String get last => 'Última';
	@override String get origin => 'Origem';
	@override String get sectionStack => 'Stack';
	@override String get stackHint => 'frames do projeto em destaque · clique abre o arquivo';
	@override String get sectionCorrelated => 'Log correlacionado';
	@override String get correlatedHint => 'o JSON mais próximo antes do erro, no mesmo run';
	@override String get none => 'nenhum';
	@override String get sectionRuns => 'Ocorrências por run';
	@override String get runsHint => 'mesma chave (cwd, comando): é assim que novo e regressão são calculados';
	@override String get sectionContext => 'Contexto cru';
	@override String get contextHint => 'linhas do terminal ao redor da última ocorrência';
	@override String get current => 'atual';
	@override String fingerprintHint({required Object location}) => 'fingerprint = tipo + mensagem normalizada + ${location}';
	@override String get blameUncommitted => 'alterado no working tree';
	@override String blameCommit({required Object ago, required Object sha}) => 'alterado ${ago} (${sha})';
	@override String get justNow => 'agora';
	@override String minutesAgo({required Object n}) => 'há ${n} min';
	@override String hoursAgo({required Object n}) => 'há ${n} h';
	@override String daysAgo({required Object n}) => 'há ${n} d';
	@override String get resolvedToast => 'Resolvido. Se voltar num run futuro, reaparece como regressão.';
	@override String get ignoredToast => 'Ignorado. Os agentes não veem mais (salvo --include-ignored).';
	@override String get clearedToast => 'Ocorrências apagadas. As regras de triagem ficam.';
	@override String get byHuman => 'por você';
	@override String get byAgent => 'pelo agente';
	@override String caseTabTitle({required Object type, required Object file}) => '${type} · ${file}';
	@override String get srcApp => 'App';
	@override String get chipApp => 'GSH Desktop';
}

// Path: gsh.panelView
class _Translations$gsh$panelView$pt_BR extends Translations$gsh$panelView$en {
	_Translations$gsh$panelView$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get unavailable => 'Painéis precisam da web view embutida, que ainda não existe no Linux.';
	@override String get openInBrowser => 'Abrir no navegador';
	@override String get openAsHtml => 'Abrir como HTML';
}

// Path: gsh.chat
class _Translations$gsh$chat$pt_BR extends Translations$gsh$chat$en {
	_Translations$gsh$chat$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get tabTitle => 'Chat';
	@override String get emptyTitle => 'Nova conversa';
	@override String emptySubtitle({required Object folder}) => 'Claude Code em ${folder}, com o seu login.';
	@override String get emptyHintSend => 'Enter envia; Shift+Enter quebra linha.';
	@override String get emptyHintPaste => 'Cole um print com Ctrl+V ou solte arquivos no chat.';
	@override String get emptyHintMode => 'Escolha o modo de permissão embaixo do campo: pedir, aceitar edições, planejar ou ignorar.';
	@override String get placeholder => 'Mensagem para o Claude… (Enter envia, Shift+Enter quebra linha)';
	@override String get send => 'Enviar';
	@override String get stop => 'Parar';
	@override String get working => 'trabalhando…';
	@override String get waitingYou => 'esperando você';
	@override String cost({required Object v}) => 'custo US\$ ${v}';
	@override String askPermission({required Object tool}) => 'Permitir ${tool}?';
	@override String get allow => 'Permitir';
	@override String get deny => 'Negar';
	@override String get allowed => 'Permitido';
	@override String get denied => 'Negado';
	@override String startFailed({required Object detail}) => 'Não consegui iniciar o claude: ${detail}';
	@override String engineExited({required Object code}) => 'O claude encerrou (código ${code}).';
	@override String turnFailed({required Object detail}) => 'O turno terminou com erro: ${detail}';
	@override String get handedOff => 'A conversa continua num terminal com Remote Control: abra no celular ou em claude.ai/code. O chat aqui fica pausado.';
	@override String peerMessageFrom({required Object name}) => 'Mensagem de ${name}';
	@override String get sessions => 'Sessões';
	@override String get noSessions => 'Nenhuma outra sessão do Claude Code rodando agora.';
	@override String sendToSession({required Object name}) => 'Mande esta mensagem para a sessão "${name}" com SendMessage e espere a resposta: ';
	@override String get remoteControl => 'Remote Control';
	@override String get remoteControlHint => 'Continuar esta conversa num terminal com Remote Control (celular, claude.ai/code). O motor do chat não suporta Remote Control.';
	@override String attachmentTooLarge({required Object name}) => '${name} é grande demais para enviar (imagem até 5 MB, PDF até 32 MB).';
	@override String get loadingHistory => 'Carregando a conversa…';
	@override String allowAlways({required Object rule}) => 'Sempre permitir ${rule}';
	@override String allowedAlways({required Object rule}) => 'Sempre permitido: ${rule}';
	@override String moreLines({required Object n}) => '… mais ${n} linhas';
	@override String get questionTitle => 'O agente está perguntando';
	@override String get other => 'Outro…';
	@override String get answer => 'Responder';
	@override String get planTitle => 'Plano do agente';
	@override String get planApprove => 'Aprovar e executar';
	@override String get planRefine => 'Continuar planejando';
	@override String get planRefineHint => 'O que mudar no plano?';
	@override String get planSendRefine => 'Enviar ajuste';
	@override String get planApproved => 'Plano aprovado';
	@override String get planRefined => 'Pediu para continuar planejando';
	@override String planRefinedWith({required Object text}) => 'Ajuste: ${text}';
	@override String get newChat => 'Nova conversa';
	@override String get attach => 'Anexar arquivos';
	@override String get modeDefault => 'Pedir permissão';
	@override String get modeAcceptEdits => 'Aceitar edições';
	@override String get modePlan => 'Planejar';
	@override String get modeBypass => 'Ignorar permissões';
	@override String editedFiles({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n,
		one: 'Editou 1 arquivo',
		other: 'Editou ${n} arquivos',
	);
	@override String get thinkingTitle => 'Raciocínio';
	@override String get thinkingLive => 'Pensando…';
	@override String get stateCompleted => 'Concluída';
	@override String get stateReviewReady => 'Pronta para revisão';
	@override String get stateBlocked => 'Bloqueada';
	@override String get stateFailed => 'Falhou';
}

// Path: gsh.farm
class _Translations$gsh$farm$pt_BR extends Translations$gsh$farm$en {
	_Translations$gsh$farm$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get tabTitle => 'Fazenda';
	@override String get title => 'Fazenda de agentes';
	@override String get emptyTitle => 'Nenhum agente rodando';
	@override String get emptyHint => 'Todo loop do Claude Code nesta máquina aparece aqui enquanto trabalha, inclusive subagentes e sessões fora do GSH Desktop.';
	@override String working({required Object n}) => '${n} trabalhando';
	@override String waiting({required Object n}) => '${n} precisam de você';
	@override String idle({required Object n}) => '${n} parados';
	@override String tokens({required Object n}) => '${n} tokens gerados';
	@override String tokensDetail({required Object out, required Object ctx}) => '${out} tokens gerados · contexto ${ctx}';
	@override String get clickToOpen => 'Clique para abrir o terminal';
	@override String get outsideGsh => 'Este agente está rodando fora do GSH Desktop. O terminal dele está em outra janela.';
	@override String agents({required Object n}) => '${n} agentes';
	@override String subagents({required Object n}) => '${n} subagentes';
	@override late final _Translations$gsh$farm$activity$pt_BR activity = _Translations$gsh$farm$activity$pt_BR._(_root);
}

// Path: gsh.agentGraph
class _Translations$gsh$agentGraph$pt_BR extends Translations$gsh$agentGraph$en {
	_Translations$gsh$agentGraph$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get tabTitle => 'Agentes';
	@override String get newAgent => 'Novo agente';
	@override String get emptyTitle => 'Nenhum agente neste workspace';
	@override String get emptyHint => 'Inicie um agente num terminal ou crie um aqui. Arraste da porta de um agente até outro para conectá-los.';
	@override String get statusWorking => 'Trabalhando';
	@override String get statusWaiting => 'Aguardando';
	@override String get statusIdle => 'Ocioso';
	@override String messageCount({required Object n}) => 'Mensagens: ${n}';
	@override String lastMessage({required Object preview}) => 'Última: ${preview}';
	@override String get linked => 'Conectado';
	@override String get removeLinkHint => 'Clique direito para remover a conexão';
	@override String get removeLink => 'Remover conexão';
	@override String get connectHint => 'Arraste até outro agente para conectar';
	@override String get quickStart => 'Início rápido';
	@override String get shell => 'Shell';
	@override String get tabDetails => 'Detalhes';
	@override String get tabAppearance => 'Aparência';
	@override String get tabAgent => 'Agente';
	@override String get name => 'Nome do terminal';
	@override String get namePlaceholder => 'ex.: Revisor';
	@override String get nameTaken => 'Outra aba já usa este nome. Os nomes precisam ser únicos para o `gsh msg --to` achar a aba.';
	@override String get command => 'Comando';
	@override String get commandPlaceholder => 'ex.: claude --model opus (vazio = shell)';
	@override String get cwd => 'Diretório de trabalho';
	@override String get browse => 'Procurar…';
	@override String get cwdMissing => 'Esta pasta não existe.';
	@override String get monitor => 'Monitorar atividade';
	@override String get monitorHint => 'Badge, som e notificação quando um turno termina.';
	@override String get maestro => 'Maestro';
	@override String get maestroTooltip => 'Promove este agente a maestro: ele fica conectado a todos os agentes do canvas e os coordena.';
	@override String maestroReplaces({required Object name}) => '${name} é o maestro atual e deixará de ser.';
	@override String get color => 'Cor';
	@override String get colorAuto => 'Automática';
	@override String get role => 'Papel / instruções';
	@override String get rolePlaceholder => 'Enviado como primeira mensagem assim que o agente estiver pronto.';
	@override String get task => 'Tarefa inicial';
	@override String get taskPlaceholder => 'Enviada logo depois do papel.';
	@override String get focus => 'Focar';
	@override String get rename => 'Renomear';
	@override String get renameTitle => 'Renomear agente';
	@override String get makeMaestro => 'Tornar maestro';
	@override String get removeMaestro => 'Remover maestro';
	@override String get closeTab => 'Fechar aba';
	@override String get removeFromCanvas => 'Remover do canvas';
	@override String get desktopApps => 'Apps desktop';
	@override String get desktopBadge => 'desktop';
	@override String get statusOnline => 'Online';
	@override String get statusOffline => 'Offline';
	@override String queued({required Object n}) => '${n} na fila';
	@override String get agentName => 'Nome';
	@override String get integration => 'Integração';
	@override String get integrationHint => 'O GSH Desktop adiciona um servidor MCP chamado "gsh" a este arquivo e salva um backup ao lado. Os outros servidores não são tocados.';
	@override String integrationConsent({required Object app}) => 'Adicionar o servidor MCP do GSH Desktop ao config do ${app}';
	@override String restartHint({required Object app}) => 'Reinicie o ${app} se ele já estava aberto, para carregar o servidor MCP do GSH Desktop; depois peça a ele para chamar wait_messages.';
	@override late final _Translations$gsh$agentGraph$integrationError$pt_BR integrationError = _Translations$gsh$agentGraph$integrationError$pt_BR._(_root);
}

// Path: settings.language
class _Translations$settings$language$pt_BR extends Translations$settings$language$en {
	_Translations$settings$language$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Idioma';
	@override String get system => 'Sistema';
	@override String get english => 'Inglês';
	@override String get portugueseBr => 'Português (BR)';
	@override String get spanish => 'Espanhol';
}

// Path: settings.page
class _Translations$settings$page$pt_BR extends Translations$settings$page$en {
	_Translations$settings$page$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$settings$page$header$pt_BR header = _Translations$settings$page$header$pt_BR._(_root);
	@override late final _Translations$settings$page$nav$pt_BR nav = _Translations$settings$page$nav$pt_BR._(_root);
	@override late final _Translations$settings$page$general$pt_BR general = _Translations$settings$page$general$pt_BR._(_root);
	@override late final _Translations$settings$page$diagnostics$pt_BR diagnostics = _Translations$settings$page$diagnostics$pt_BR._(_root);
	@override late final _Translations$settings$page$storage$pt_BR storage = _Translations$settings$page$storage$pt_BR._(_root);
	@override late final _Translations$settings$page$terminal$pt_BR terminal = _Translations$settings$page$terminal$pt_BR._(_root);
	@override late final _Translations$settings$page$appearance$pt_BR appearance = _Translations$settings$page$appearance$pt_BR._(_root);
	@override late final _Translations$settings$page$notifications$pt_BR notifications = _Translations$settings$page$notifications$pt_BR._(_root);
	@override late final _Translations$settings$page$shortcuts$pt_BR shortcuts = _Translations$settings$page$shortcuts$pt_BR._(_root);
	@override late final _Translations$settings$page$languages$pt_BR languages = _Translations$settings$page$languages$pt_BR._(_root);
	@override late final _Translations$settings$page$automations$pt_BR automations = _Translations$settings$page$automations$pt_BR._(_root);
	@override late final _Translations$settings$page$claudeCode$pt_BR claudeCode = _Translations$settings$page$claudeCode$pt_BR._(_root);
	@override late final _Translations$settings$page$placeholder$pt_BR placeholder = _Translations$settings$page$placeholder$pt_BR._(_root);
	@override late final _Translations$settings$page$claude$pt_BR claude = _Translations$settings$page$claude$pt_BR._(_root);
	@override late final _Translations$settings$page$account$pt_BR account = _Translations$settings$page$account$pt_BR._(_root);
	@override late final _Translations$settings$page$usage$pt_BR usage = _Translations$settings$page$usage$pt_BR._(_root);
	@override late final _Translations$settings$page$memory$pt_BR memory = _Translations$settings$page$memory$pt_BR._(_root);
	@override late final _Translations$settings$page$skills$pt_BR skills = _Translations$settings$page$skills$pt_BR._(_root);
	@override late final _Translations$settings$page$connectors$pt_BR connectors = _Translations$settings$page$connectors$pt_BR._(_root);
	@override late final _Translations$settings$page$plugins$pt_BR plugins = _Translations$settings$page$plugins$pt_BR._(_root);
	@override late final _Translations$settings$page$developer$pt_BR developer = _Translations$settings$page$developer$pt_BR._(_root);
	@override late final _Translations$settings$page$system$pt_BR system = _Translations$settings$page$system$pt_BR._(_root);
	@override late final _Translations$settings$page$catalog$pt_BR catalog = _Translations$settings$page$catalog$pt_BR._(_root);
	@override late final _Translations$settings$page$generalClaude$pt_BR generalClaude = _Translations$settings$page$generalClaude$pt_BR._(_root);
	@override late final _Translations$settings$page$privacy$pt_BR privacy = _Translations$settings$page$privacy$pt_BR._(_root);
	@override late final _Translations$settings$page$resources$pt_BR resources = _Translations$settings$page$resources$pt_BR._(_root);
	@override late final _Translations$settings$page$designSystems$pt_BR designSystems = _Translations$settings$page$designSystems$pt_BR._(_root);
}

// Path: settings.remoteHosts
class _Translations$settings$remoteHosts$pt_BR extends Translations$settings$remoteHosts$en {
	_Translations$settings$remoteHosts$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Hosts remotos';
	@override String get description => 'Máquinas que você acessa por SSH. Adicionar um host aqui é o mesmo que adicionar pelo menu "+" do workspace.';
	@override String get empty => 'Nenhum host remoto ainda.';
	@override String get add => 'Adicionar host';
	@override String get edit => 'Editar';
	@override String get reconnect => 'Reconectar';
	@override String get remove => 'Remover';
	@override String get removeTitle => 'Remover host';
	@override String removeMessage({required Object name}) => 'Remover "${name}" e todos os workspaces dele? Nada é apagado no host.';
	@override String workspacesCount({required Object count}) => '${count} workspace(s)';
	@override String get deviceKeyTitle => 'Chave deste dispositivo';
	@override String get deviceKeyDesc => 'Adicione esta chave pública ao ~/.ssh/authorized_keys do host para este dispositivo poder conectar.';
	@override String get deviceKeyCopy => 'Copiar chave pública';
	@override String get deviceKeyCopied => 'Chave pública copiada';
	@override String get statusConnected => 'Conectado';
	@override String get statusConnecting => 'Conectando…';
	@override String get statusReconnecting => 'Reconectando…';
	@override String get statusOffline => 'Offline';
	@override String get statusIdle => 'Não conectado';
	@override String get helpTitle => 'Como funciona';
	@override String get helpBody => 'O GSH Desktop conecta na sua máquina por SSH e fala com um servidor pequeno que roda os terminais, arquivos e git lá. O host precisa ter o GSH Desktop (desktop) ou o gsh-server instalado e rodando, e a chave pública deste dispositivo adicionada no ~/.ssh/authorized_keys dele.';
}

// Path: automation.error
class _Translations$automation$error$pt_BR extends Translations$automation$error$en {
	_Translations$automation$error$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String unavailable({required Object harness}) => '${harness} não está instalado ou não está no PATH.';
	@override String modelUnavailable({required Object model, required Object harness}) => 'O modelo "${model}" não está disponível para ${harness}. Escolha outro modelo em Configurações.';
	@override String authentication({required Object harness, required Object detail}) => '${harness}: ${detail}';
	@override String timeout({required Object harness, required Object seconds}) => '${harness} não respondeu em ${seconds} segundos.';
	@override String get cancelled => 'A geração da mensagem de commit foi cancelada.';
	@override String process({required Object harness, required Object detail}) => '${harness}: ${detail}';
	@override String processNoDetail({required Object harness}) => '${harness} não conseguiu gerar uma mensagem de commit.';
	@override String get invalidResponse => 'A automação devolveu uma mensagem de commit vazia.';
	@override String get busy => 'Já há uma mensagem de commit sendo gerada.';
	@override String get unknown => 'A automação não conseguiu gerar uma mensagem de commit.';
	@override String get noWorkspace => 'Nenhum workspace selecionado.';
	@override String get fileOutsideWorkspace => 'O arquivo está fora das raízes do workspace.';
	@override String fileUnreadable({required Object detail}) => 'Não foi possível ler o arquivo: ${detail}';
	@override String get binaryFile => 'Não é possível gerar mensagem de commit para um arquivo binário.';
	@override String get noFileChanges => 'Não há mudanças a descrever neste arquivo.';
	@override String get noStagedChanges => 'Não há mudanças no stage a descrever.';
	@override String get multipleRepositories => 'As mudanças no stage pertencem a repositórios diferentes. Gere uma de cada vez.';
	@override String get diffUnavailable => 'Não foi possível ler o diff.';
	@override String get notConfigured => 'Configure um harness de mensagem de commit em Configurações.';
}

// Path: fileOperation.error
class _Translations$fileOperation$error$pt_BR extends Translations$fileOperation$error$en {
	_Translations$fileOperation$error$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String alreadyExists({required Object name}) => 'Já existe: “${name}”.';
	@override String notFound({required Object name}) => 'Não encontrado: “${name}”.';
	@override String get invalidPath => 'Caminho inválido.';
	@override String get emptyName => 'O nome não pode ficar vazio.';
	@override String get noWorkspace => 'Nenhum workspace selecionado.';
	@override String get cannotMoveIntoItself => 'Não é possível mover uma pasta para dentro dela mesma.';
	@override String get clipboardEmpty => 'A área de transferência está vazia.';
	@override String get notScratchTab => 'Esta aba não é um arquivo temporário.';
	@override String get writeFailed => 'Não foi possível gravar o arquivo.';
	@override String get formatterEmptyCommand => 'Comando de formatação vazio.';
	@override String get formatterMissingPlaceholder => 'O comando de formatação precisa incluir o placeholder %FILE%.';
	@override String get formatterTimeout => 'O formatador excedeu o tempo limite.';
	@override String formatterExitCode({required Object code}) => 'O formatador saiu com código ${code}.';
	@override String get formatterFailed => 'Não foi possível executar o formatador.';
	@override String osFailure({required Object detail}) => '${detail}';
	@override String get nameHasSlash => 'O nome não pode conter “/”.';
	@override String get invalidName => 'Nome inválido.';
	@override String get remoteDropUnsupported => 'Soltar arquivos num workspace remoto ainda não é suportado.';
}

// Path: theme.error
class _Translations$theme$error$pt_BR extends Translations$theme$error$en {
	_Translations$theme$error$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get io => 'Não foi possível ler ou gravar o arquivo do tema.';
	@override String ioDetail({required Object detail}) => 'Não foi possível ler ou gravar o arquivo do tema: ${detail}';
	@override String malformedJson({required Object detail}) => 'Este arquivo não é um JSON válido: ${detail}';
	@override String get invalidTheme => 'Este arquivo não é um tema válido.';
	@override String get reservedId => 'Este tema usa o id de um tema nativo. Mude o "id" no arquivo e importe de novo.';
	@override String notAnObject({required Object field}) => 'Esperava um objeto em "${field}".';
	@override String missingField({required Object field}) => 'Falta o campo obrigatório "${field}".';
	@override String badColor({required Object value, required Object field}) => '"${value}" em "${field}" não é uma cor. Use #RGB, #RRGGBB ou #RRGGBBAA.';
	@override String unknownBase({required Object value}) => 'Tema base "${value}" desconhecido em "extends".';
	@override String get noVariants => 'O tema não declara nenhum variant. Adicione "dark", "light" ou os dois em "variants".';
}

// Path: gsh.httpView.error
class _Translations$gsh$httpView$error$pt_BR extends Translations$gsh$httpView$error$en {
	_Translations$gsh$httpView$error$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Falha no request';
	@override String get noRequest => 'Nenhum request encontrado na posição do cursor.';
	@override String invalidUrl({required Object url}) => 'URL inválida: ${url}';
	@override String unresolvedVariable({required Object name}) => 'A variável {{${name}}} não tem valor. Declare com @${name} = … neste arquivo.';
	@override String bodyFileMissing({required Object path}) => 'Arquivo de corpo não encontrado: ${path}';
	@override String bodyFileUnreadable({required Object path, required Object detail}) => 'Não foi possível ler o arquivo de corpo ${path}: ${detail}';
	@override String connectionFailed({required Object detail}) => 'Não foi possível alcançar o servidor: ${detail}';
	@override String get connectionFailedNoDetail => 'Não foi possível alcançar o servidor.';
	@override String timeout({required Object seconds}) => 'O request estourou o tempo limite de ${seconds}s.';
	@override String responseTooLarge({required Object bytes}) => 'A resposta passou do limite de ${bytes} bytes.';
}

// Path: gsh.kanbanView.deleteColumnDialog
class _Translations$gsh$kanbanView$deleteColumnDialog$pt_BR extends Translations$gsh$kanbanView$deleteColumnDialog$en {
	_Translations$gsh$kanbanView$deleteColumnDialog$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => 'Apagar “${name}”?';
	@override String message({required Object count}) => 'Esta coluna tem ${count}. Escolha o que acontece com eles.';
	@override String get moveCards => 'Mover pra coluna anterior';
	@override String get deleteAll => 'Apagar junto com a coluna';
	@override String get emptyMessage => 'Esta coluna está vazia.';
}

// Path: gsh.gallery.dbQuery
class _Translations$gsh$gallery$dbQuery$pt_BR extends Translations$gsh$gallery$dbQuery$en {
	_Translations$gsh$gallery$dbQuery$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Consulta de banco';
	@override String get description => 'Editor SQL com grid de resultado, usando uma das conexões registradas.';
}

// Path: gsh.gallery.kanban
class _Translations$gsh$gallery$kanban$pt_BR extends Translations$gsh$gallery$kanban$en {
	_Translations$gsh$gallery$kanban$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Quadro kanban';
	@override String get description => 'Colunas e cards gravados como markdown puro. Arraste, edite e comente.';
}

// Path: gsh.gallery.layout
class _Translations$gsh$gallery$layout$pt_BR extends Translations$gsh$gallery$layout$en {
	_Translations$gsh$gallery$layout$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Layout de panes';
	@override String get description => 'Terminais e splits para abrir de uma vez, estilo tmuxinator. Pode rodar sozinho em worktrees novas.';
}

// Path: gsh.gallery.httpRequest
class _Translations$gsh$gallery$httpRequest$pt_BR extends Translations$gsh$gallery$httpRequest$en {
	_Translations$gsh$gallery$httpRequest$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Requests HTTP';
	@override String get description => 'Escreva requests num arquivo e execute com a resposta ao lado.';
}

// Path: gsh.gallery.html
class _Translations$gsh$gallery$html$pt_BR extends Translations$gsh$gallery$html$en {
	_Translations$gsh$gallery$html$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Visual HTML';
	@override String get description => 'Uma página que o agente escreve e o GSH Desktop renderiza direto: mapa mental, diagrama, gráfico, o que precisar.';
}

// Path: gsh.gallery.tasks
class _Translations$gsh$gallery$tasks$pt_BR extends Translations$gsh$gallery$tasks$en {
	_Translations$gsh$gallery$tasks$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tarefas';
	@override String get description => 'Comandos para rodar pelo painel de Tasks, como dev server, testes e build. Fica em .gsh/tasks.json.';
}

// Path: gsh.gallery.notebook
class _Translations$gsh$gallery$notebook$pt_BR extends Translations$gsh$gallery$notebook$en {
	_Translations$gsh$gallery$notebook$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Caderno';
	@override String get description => 'Uma pasta de notas curtas com tags. O agente escreve, você lê e edita. Abre no Obsidian também.';
}

// Path: gsh.gallery.workspaceEnv
class _Translations$gsh$gallery$workspaceEnv$pt_BR extends Translations$gsh$gallery$workspaceEnv$en {
	_Translations$gsh$gallery$workspaceEnv$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Env do workspace';
	@override String get description => 'Variáveis injetadas em todo terminal deste workspace. Coloque tokens ou logins de API aqui em vez de colar no prompt do agente. Fica fora do git.';
}

// Path: gsh.gallery.panel
class _Translations$gsh$gallery$panel$pt_BR extends Translations$gsh$gallery$panel$en {
	_Translations$gsh$gallery$panel$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Painel';
	@override String get description => 'Uma página HTML com ponte para o app: os botões rodam comandos da CLI do GSH Desktop e do shell nesta máquina. Um playground para dashboards rápidos.';
}

// Path: gsh.notebook.format
class _Translations$gsh$notebook$format$pt_BR extends Translations$gsh$notebook$format$en {
	_Translations$gsh$notebook$format$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get bold => 'Negrito (⌘B)';
	@override String get italic => 'Itálico (⌘I)';
	@override String get strike => 'Riscado';
	@override String get heading1 => 'Título 1';
	@override String get heading2 => 'Título 2';
	@override String get heading3 => 'Título 3';
	@override String get bullets => 'Lista';
	@override String get numbered => 'Lista numerada';
	@override String get checklist => 'Checklist';
	@override String get quote => 'Citação';
	@override String get code => 'Código inline (⌘E)';
	@override String get codeBlock => 'Bloco de código';
	@override String get link => 'Link (⌘K)';
	@override String get rule => 'Divisor';
	@override String get noteLink => 'Link pra uma nota ([[…]])';
	@override String get noteLinkSearch => 'Buscar notas';
	@override String get image => 'Inserir imagem…';
}

// Path: gsh.farm.activity
class _Translations$gsh$farm$activity$pt_BR extends Translations$gsh$farm$activity$en {
	_Translations$gsh$farm$activity$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get thinking => 'pensando';
	@override String get reading => 'lendo';
	@override String get editing => 'editando';
	@override String get running => 'rodando comando';
	@override String get searching => 'pesquisando na web';
	@override String get delegating => 'delegando';
	@override String get tooling => 'usando ferramenta';
	@override String get waiting => 'esperando você';
	@override String get idle => 'ocioso';
	@override String get sleeping => 'dormindo';
	@override String get done => 'concluído';
}

// Path: gsh.agentGraph.integrationError
class _Translations$gsh$agentGraph$integrationError$pt_BR extends Translations$gsh$agentGraph$integrationError$en {
	_Translations$gsh$agentGraph$integrationError$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String invalidConfig({required Object path}) => '${path} não é um JSON/TOML simples que o GSH Desktop consiga editar com segurança (comentários ou outro formato). Nada foi alterado.';
	@override String cliMissing({required Object path}) => 'A CLI do GSH Desktop ainda não foi instalada (${path}). Reinicie o GSH Desktop e tente de novo.';
	@override String writeFailed({required Object detail}) => 'Não foi possível atualizar o config: ${detail}';
}

// Path: settings.page.header
class _Translations$settings$page$header$pt_BR extends Translations$settings$page$header$en {
	_Translations$settings$page$header$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get back => 'Voltar';
	@override String get title => 'Configurações';
}

// Path: settings.page.nav
class _Translations$settings$page$nav$pt_BR extends Translations$settings$page$nav$en {
	_Translations$settings$page$nav$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sideGsh => 'GSH Desktop';
	@override String get sideClaude => 'Claude';
	@override String get general => 'Geral';
	@override String get appearance => 'Aparência';
	@override String get terminal => 'Terminal';
	@override String get language => 'Linguagem';
	@override String get shortcuts => 'Atalhos';
	@override String get notifications => 'Notificações';
	@override String get automations => 'Automações';
	@override String get remoteHosts => 'Hosts remotos';
	@override String get claudeCode => 'Claude Code';
	@override String get search => 'Procurar';
	@override String get account => 'Conta';
	@override String get privacy => 'Privacidade';
	@override String get usage => 'Uso';
	@override String get resources => 'Recursos';
	@override String get memory => 'Memória';
	@override String get designSystems => 'Design systems';
	@override String get cowork => 'Cowork';
	@override String get system => 'Sistema';
	@override String get extensions => 'Extensões';
	@override String get developer => 'Desenvolvedor';
	@override String get skills => 'Skills';
	@override String get connectors => 'Conectores';
	@override String get plugins => 'Plugins';
	@override String get apiKeys => 'Chaves de API';
	@override late final _Translations$settings$page$nav$groups$pt_BR groups = _Translations$settings$page$nav$groups$pt_BR._(_root);
}

// Path: settings.page.general
class _Translations$settings$page$general$pt_BR extends Translations$settings$page$general$en {
	_Translations$settings$page$general$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionEditor => 'Editor';
	@override String get editorEngineTitle => 'Motor';
	@override String get editorEngineGsh => 'GSH Desktop (padrão)';
	@override String get editorEngineNeovim => 'Neovim';
	@override String get neovimChecking => 'Procurando o Neovim…';
	@override String get neovimNotFound => 'O Neovim não foi encontrado na PATH do seu shell.';
	@override String get neovimRefresh => 'Verificar novamente';
	@override String get showGshTitle => 'Mostrar terminal do GSH Desktop';
	@override String get showGshDesc => 'Mantém um workspace sem pasta, só de terminal, fixado no topo da barra lateral. Desligar fecha seus terminais.';
	@override String get launchAtStartupTitle => 'Iniciar ao ligar';
	@override String get launchAtStartupDesc => 'Inicia o GSH Desktop automaticamente quando você faz login no computador.';
	@override String get sectionUpdates => 'Atualizações';
	@override String get checkUpdatesTitle => 'Verificar atualizações';
	@override String get checkUpdatesDesc => 'Com que frequência o GSH Desktop deve procurar novas versões.';
	@override late final _Translations$settings$page$general$updateFrequency$pt_BR updateFrequency = _Translations$settings$page$general$updateFrequency$pt_BR._(_root);
	@override String get developerModeTitle => 'Modo desenvolvedor';
	@override String get developerModeDesc => 'Registra os erros e avisos do próprio GSH Desktop numa base separada da Telemetria (chip “GSH Desktop”) e liga as métricas de performance. Só serve a quem mantém o app.';
}

// Path: settings.page.diagnostics
class _Translations$settings$page$diagnostics$pt_BR extends Translations$settings$page$diagnostics$en {
	_Translations$settings$page$diagnostics$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionTitle => 'Diagnóstico';
	@override String get logFileTitle => 'Arquivo de log';
	@override String logFileDesc({required Object days, required Object path}) => 'Erros e eventos de inicialização são registrados aqui, mantidos por ${days} dias.\n${path}';
	@override String get unavailable => 'indisponível';
	@override String get reveal => 'Revelar';
	@override String get reportTitle => 'Reportar um problema';
	@override String get reportDesc => 'Abre uma issue pré-preenchida com sua versão, SO e log recente. Nada é enviado automaticamente — você revisa antes.';
	@override String get reportButton => 'Reportar…';
	@override String get reportDialogTitle => 'Relatório de problema';
	@override String get reportDialogError => 'Reportado manualmente pelas Configurações.';
	@override String get reportDialogDescription => 'Descreva o que deu errado na issue. O log recente está incluído abaixo e em "Copiar detalhes".';
}

// Path: settings.page.storage
class _Translations$settings$page$storage$pt_BR extends Translations$settings$page$storage$en {
	_Translations$settings$page$storage$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionTitle => 'Armazenamento';
	@override String get locationTitle => 'Local de armazenamento';
	@override String locationDesc({required Object root}) => 'O GSH Desktop guarda seus projetos, layouts e configurações aqui. Aponte para uma pasta sincronizada para fazer backup.\n${root}';
	@override String get useDefault => 'Usar padrão';
	@override String get working => 'Trabalhando…';
	@override String get change => 'Alterar…';
	@override String get resetTitle => 'Redefinir o GSH Desktop';
	@override String get resetDesc => 'Exclui todos os dados locais — projetos, layouts, configurações e histórico do terminal — e volta ao local padrão.';
	@override String get resetButton => 'Redefinir…';
	@override String get resetConfirm => 'Redefinir';
	@override String get resetDialogTitle => 'Redefinir o GSH Desktop?';
	@override String get resetDialogContent => 'Isso exclui permanentemente todos os dados locais do GSH Desktop — projetos, layouts, configurações e histórico do terminal. Isso não pode ser desfeito. O GSH Desktop será fechado para você começar do zero.';
	@override String get restartRequiredTitle => 'Reinicialização necessária';
	@override String restartChangeFolderMessage({required Object path}) => 'O GSH Desktop usará esta pasta a partir da próxima abertura:\n${path}';
	@override String get restartUseDefaultMessage => 'O GSH Desktop usará o local padrão do sistema a partir da próxima abertura. Seus dados na pasta personalizada permanecem intactos.';
	@override String get restartResetMessage => 'Todos os dados do GSH Desktop foram apagados. Reinicie para começar do zero.';
	@override String get later => 'Mais tarde';
	@override String get quitGsh => 'Sair do GSH Desktop';
	@override String get chooseFolderDialogTitle => 'Escolha uma pasta para os dados do GSH Desktop';
}

// Path: settings.page.terminal
class _Translations$settings$page$terminal$pt_BR extends Translations$settings$page$terminal$en {
	_Translations$settings$page$terminal$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionDefaultTerminal => 'Terminal padrão';
	@override String get engineTitle => 'Motor';
	@override String get engineDesc => 'Usado por novas abas de terminal e buffers de saída de tasks. Abas abertas mantêm o motor atual.';
	@override String get shellTitle => 'Shell';
	@override String get shellDesc => 'Qual shell novas abas de terminal abrem. A seta ao lado do + ainda abre qualquer outro, só para aquela aba.';
	@override String get noWslMessage => 'Nenhuma distro WSL encontrada. Instale uma (wsl.exe --install) e reinicie o GSH Desktop para vê-la listada aqui.';
	@override String get sectionBehavior => 'Comportamento';
	@override String get closeOnExitTitle => 'Fechar a aba quando o shell encerrar';
	@override String get closeOnExitDesc => 'Quando um shell termina sozinho (exit, Ctrl-D), fecha a aba em vez de deixar um terminal morto.';
}

// Path: settings.page.appearance
class _Translations$settings$page$appearance$pt_BR extends Translations$settings$page$appearance$en {
	_Translations$settings$page$appearance$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionTheme => 'Tema';
	@override String get themeTitle => 'Tema';
	@override String get themeDesc => 'Cores do app, realce de código e paleta do terminal.';
	@override String get modeTitle => 'Modo';
	@override String get modeDesc => 'Qual variante do tema usar.';
	@override String modeOnlyDark({required Object theme}) => '"${theme}" só traz a variante escura, então isto não tem efeito.';
	@override String modeOnlyLight({required Object theme}) => '"${theme}" só traz a variante clara, então isto não tem efeito.';
	@override String get themeFileTitle => 'Arquivo de tema';
	@override String get themeFileDesc => 'Importe um tema de um arquivo JSON, ou exporte o tema ativo.';
	@override String get previewCode => 'Código';
	@override String get previewTerminal => 'Terminal';
	@override String get themeSystem => 'Sistema';
	@override String get themeLight => 'Claro';
	@override String get themeDark => 'Escuro';
	@override String get sectionFonts => 'Fontes';
	@override String get interfaceFontTitle => 'Fonte da interface';
	@override String get interfaceFontDesc => 'Usada em todo o aplicativo. Vazio = padrão do sistema.';
	@override String get interfaceSizeTitle => 'Tamanho da interface';
	@override String get codeFontTitle => 'Fonte do código';
	@override String get codeFontDesc => 'Código e diffs. Vazio = padrão do sistema.';
	@override String get codeSizeTitle => 'Tamanho do código';
	@override String get terminalFontTitle => 'Fonte do terminal';
	@override String get terminalFontDesc => 'Só o terminal. Vazio = padrão do sistema.';
	@override String get terminalSizeTitle => 'Tamanho do terminal';
	@override String get terminalSizeDesc => 'Desligado = segue o tamanho do código.';
	@override String get terminalSizeInherit => 'Seguir o código';
	@override String get terminalWeightTitle => 'Peso do terminal';
	@override String get terminalWeightDesc => 'Telas de baixa densidade engrossam os traços. O automático afina só nelas e não mexe no Retina.';
	@override String get terminalWeightAuto => 'Automático (pela tela)';
	@override String get terminalWeightLight => 'Fino';
	@override String get terminalWeightNormal => 'Normal';
	@override String get terminalWeightMedium => 'Médio';
	@override String get terminalWeightSemiBold => 'Seminegrito';
	@override String get sectionConversation => 'Conversa';
	@override String get pinUserMessageTitle => 'Fixar mensagem do usuário';
	@override String get pinUserMessageDesc => 'A pergunta fica fixa no topo enquanto a resposta rola.';
	@override String get importTheme => 'Importar…';
	@override String get exportTheme => 'Exportar…';
	@override String get deleteTheme => 'Remover';
	@override String get importThemeDialog => 'Escolha um arquivo de tema';
	@override String get exportThemeDialog => 'Salvar tema como';
	@override String themeImported({required Object name}) => 'Tema "${name}" importado.';
	@override String get themeExported => 'Tema salvo.';
	@override String get themeDeleted => 'Tema removido.';
	@override String get fontPickerTitle => 'Escolher uma fonte';
	@override String get fontPickerSearch => 'Buscar fontes';
	@override String get fontPickerEmpty => 'Nenhuma fonte correspondente nesta máquina.';
	@override String get fontPickerBundled => 'inclusa';
	@override String get fontPickerCustom => 'Não está na lista? Digite o nome exato da família.';
	@override String get fontPickerCustomHint => 'Nome da família';
	@override String get fontPickerUse => 'Usar';
	@override String get fontPickerDefault => 'Padrão';
	@override String get fontMissing => 'Não encontrada nesta máquina — usando o fallback.';
	@override String get sectionLayout => 'Layout';
	@override String get swapPanelsTitle => 'Inverter panes';
	@override String get swapPanelsDesc => 'Coloca os workspaces à direita e arquivos, busca, git e banco à esquerda.';
}

// Path: settings.page.notifications
class _Translations$settings$page$notifications$pt_BR extends Translations$settings$page$notifications$en {
	_Translations$settings$page$notifications$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionTitle => 'Notificações';
	@override String get enableTitle => 'Ativar notificações';
	@override String get enableDesc => 'Avisar quando um agente terminar uma resposta e a janela não estiver em foco.';
	@override String get systemPermissionTitle => 'Permissão do sistema';
	@override String get grantedDesc => 'O GSH Desktop tem permissão para enviar notificações.';
	@override String get notGrantedDesc => 'O macOS ainda não concedeu acesso a notificações.';
	@override String get granted => 'Concedido';
	@override String get requestPermission => 'Solicitar permissão';
	@override String get soundsTitle => 'Sons';
	@override String get soundVolumeTitle => 'Volume';
	@override String get soundTurnDone => 'Turno concluído';
	@override String get soundTurnDoneDesc => 'Um agente terminou o turno.';
	@override String get soundActionRequired => 'Ação necessária';
	@override String get soundActionRequiredDesc => 'Um agente está esperando sua aprovação ou resposta.';
	@override String get soundDefault => 'Padrão';
	@override String soundCustom({required Object name}) => 'Personalizado: ${name}';
	@override String get soundChooseFile => 'Escolher arquivo';
	@override String get soundReset => 'Voltar ao padrão';
	@override String get soundOnActiveTab => 'Tocar também com a aba ativa';
	@override String get soundPreview => 'Ouvir';
}

// Path: settings.page.shortcuts
class _Translations$settings$page$shortcuts$pt_BR extends Translations$settings$page$shortcuts$en {
	_Translations$settings$page$shortcuts$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get notCustomizable => 'Os atalhos de teclado ainda não são personalizáveis.';
}

// Path: settings.page.languages
class _Translations$settings$page$languages$pt_BR extends Translations$settings$page$languages$en {
	_Translations$settings$page$languages$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionFormatting => 'FORMATAÇÃO';
	@override String get formatOnSaveTitle => 'Formatar ao salvar';
	@override String get formatOnSaveDesc => 'Formata o arquivo automaticamente ao salvar (⌘S).';
	@override String get sectionLanguageServers => 'SERVIDORES DE LINGUAGEM';
	@override String get footerNote => 'Erros e formatação usam o language server de cada linguagem. O GSH Desktop não instala servidores — ele usa o que já está na sua máquina. ● responde · ○ não encontrado ou comando inválido (instale o servidor ou ajuste o comando).';
	@override String get serverCommandLabel => 'Comando do language server';
	@override String get formatterCommandLabel => 'Comando do formatador (opcional)';
	@override String get formatterHint => 'Formatador externo com o placeholder %FILE%. Tem prioridade sobre o formatador do LSP quando definido.';
	@override String get resetToDefault => 'Redefinir para o padrão';
	@override String get saveAndRestart => 'Salvar e reiniciar';
	@override String get statusResponds => 'Servidor responde';
	@override String get statusNotFound => 'Servidor não encontrado ou comando inválido';
}

// Path: settings.page.automations
class _Translations$settings$page$automations$pt_BR extends Translations$settings$page$automations$en {
	_Translations$settings$page$automations$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionCommitMessages => 'Mensagens de commit';
	@override String get harness => 'Harness';
	@override String get harnessDiscovering => 'Procurando harnesses de linha de comando instalados…';
	@override String get harnessNoneFound => 'Nenhum harness compatível foi encontrado no PATH.';
	@override String harnessConfiguredUnavailable({required Object harness}) => '${harness} está configurado, mas indisponível.';
	@override String get harnessChoose => 'Escolha a CLI usada para gerar mensagens de commit.';
	@override String get harnessRefresh => 'Atualizar harnesses instalados';
	@override String get notConfigured => 'Não configurado';
	@override String get model => 'Modelo';
	@override String get modelUnavailable => 'A lista de modelos fica indisponível até o harness ser encontrado.';
	@override String get modelCliOnly => 'Este harness usa o modelo padrão da própria CLI.';
	@override String get modelCliDefault => 'Padrão da CLI';
	@override String get modelAuto => 'Auto';
	@override String modelSearch({required Object count}) => 'Buscar entre ${count} modelos…';
	@override String get modelAutoRouted => 'Este harness escolhe o modelo automaticamente.';
	@override String get modelAccountOnly => 'Só aparecem os modelos liberados na sua conta.';
	@override String get generateFromSourceControl => 'Gerar pelo Controle de Versão';
	@override String get generateFromSourceControlDescription => 'O GSH Desktop envia apenas o diff selecionado e os assuntos dos commits recentes. Padrões comuns de credenciais e arquivos sensíveis são redigidos antes de o harness rodar.';
	@override String get discoveryFailed => 'Não foi possível descobrir os harnesses de automação instalados.';
	@override String staleModel({required Object model, required Object harness}) => 'O modelo "${model}" não está mais disponível para ${harness}. Usando o padrão da CLI; escolha outro modelo em Configurações se precisar.';
	@override String get recommendedSuffix => 'Recomendado';
}

// Path: settings.page.claudeCode
class _Translations$settings$page$claudeCode$pt_BR extends Translations$settings$page$claudeCode$en {
	_Translations$settings$page$claudeCode$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionGeneral => 'Geral';
	@override String get classifyTitle => 'Classificar estados das sessões';
	@override String get classifyDesc => 'Mostra no cabeçalho do chat o estado que o Claude Code atribui ao fim de cada turno: concluída, pronta para revisão ou bloqueada. O Claude Code classifica de qualquer jeito; desligar só esconde o selo.';
	@override String get switchModelsTitle => 'Alternar modelos quando uma mensagem for sinalizada';
	@override String get switchModelsDesc => 'Quando as salvaguardas sinalizarem uma mensagem, alternar automaticamente para um modelo diferente para continuar a conversa. Quando desativado, sua sessão será pausada. Fica no ~/.claude/settings.json (switchModelsOnFlag).';
	@override String get sectionCodeAppearance => 'Aparência do código';
	@override String get followTheme => 'Do tema ativo';
	@override String get codeThemeLightHint => 'Cores do código no modo claro';
	@override String get codeThemeDarkHint => 'Cores do código no modo escuro';
	@override String get codeFontTitle => 'Fonte de código';
	@override String get codeFontDesc => 'Defina uma fonte monoespaçada personalizada para código: viewer, editor, diffs e blocos de código do chat. O terminal tem fonte própria em Aparência.';
	@override String get codeFontPlaceholder => 'ex.: JetBrains Mono';
	@override String get sectionAppearance => 'Aparência';
	@override String get transcriptTitle => 'Visualização padrão da transcrição';
	@override String get transcriptDesc => 'A visualização com que novas conversas do chat abrem. Conversas já abertas mantêm a delas.';
	@override String get viewNormal => 'Normal';
	@override String get viewThinking => 'Raciocínio';
	@override String get viewVerbose => 'Detalhado';
	@override String get sectionRemoteControl => 'Remote Control';
	@override String get remoteControlTitle => 'Conectar novas sessões ao Remote Control';
	@override String get remoteControlDesc => 'Toda sessão do claude que você iniciar num terminal se conecta ao Remote Control, para continuar no celular ou em claude.ai/code. Fica no ~/.claude/settings.json (remoteControlAtStartup). Exige login claude.ai (Pro, Max, Team ou Enterprise).';
	@override String saveFailed({required Object detail}) => 'Não consegui salvar: ${detail}';
	@override String get sectionSessions => 'Sessões';
	@override String get promptSuggestionsTitle => 'Sugestões de prompts';
	@override String get promptSuggestionsDesc => 'Mostrar uma sugestão de próximo prompt depois que o Claude responder. As sugestões consomem um pouco do seu uso.';
	@override String get outputStyleTitle => 'Estilo de saída';
	@override String get outputStyleDesc => 'Como o Claude estrutura suas respostas nas sessões do Code. Aplica-se a novas sessões.';
	@override String get outputStyleDefault => 'Padrão';
	@override String get crossSessionTitle => 'Mensagens de outras sessões';
	@override String get crossSessionDesc => 'O que fazer quando outra sessão do Claude Code manda mensagem para esta (SendMessage). Padrão: entrega só quando as duas usam o mesmo tipo de modo de permissão; senão fica retida para você aprovar. Fica em crossSessionInbound.';
	@override String get crossSessionDefault => 'Padrão';
	@override String get crossSessionAccept => 'Aceitar';
	@override String get crossSessionHold => 'Segurar para aprovar';
	@override String get crossSessionRefuse => 'Recusar';
	@override String get sandboxTitle => 'Sandbox local';
	@override String get sandboxDesc => 'Executa os comandos bash do Claude Code num sandbox isolado. Aplica-se a novas sessões.';
	@override String get sandboxStrictTitle => 'Modo sandbox estrito';
	@override String get sandboxStrictDesc => 'Bloqueia comandos que não podem ser executados dentro do sandbox em vez de executá-los fora dele.';
	@override String get sectionBrowser => 'Navegador';
	@override String get linksInAppTitle => 'Abrir links no navegador integrado';
	@override String get linksInAppDesc => 'Links clicados nos terminais abrem numa aba de navegador do GSH em vez do seu navegador padrão.';
}

// Path: settings.page.placeholder
class _Translations$settings$page$placeholder$pt_BR extends Translations$settings$page$placeholder$en {
	_Translations$settings$page$placeholder$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get cowork1 => 'O Cowork é um recurso do Claude Desktop (tarefas que rodam neste computador com arquivos locais, navegador e MCPs).';
	@override String get cowork2 => 'No GSH, o equivalente é o chat com o Claude num workspace e a Fazenda, onde os loops de agente rodam em terminais.';
	@override String get extensionsDesc => 'Permitir que o Claude interaja diretamente com aplicativos, dados e ferramentas no seu computador.';
	@override String get extensionsEmpty => 'Nenhuma extensão instalada';
	@override String get extensions => 'Extensões .MCPB/.DXT são do Claude Desktop. No GSH, os servidores MCP ficam em Conectores e Desenvolvedor.';
}

// Path: settings.page.claude
class _Translations$settings$page$claude$pt_BR extends Translations$settings$page$claude$en {
	_Translations$settings$page$claude$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Atualizar';
	@override String get loading => 'Carregando…';
	@override String get terminalTitle => 'Abrir um terminal';
	@override String get noWorkspace => 'Abra um workspace local antes: isto roda a CLI `claude` num terminal dele, para você acompanhar.';
	@override String get months => 'jan.|fev.|mar.|abr.|mai.|jun.|jul.|ago.|set.|out.|nov.|dez.';
	@override String get weekdays => 'seg.|ter.|qua.|qui.|sex.|sáb.|dom.';
	@override String dateShort({required Object day, required Object month}) => '${day} de ${month}';
	@override late final _Translations$settings$page$claude$error$pt_BR error = _Translations$settings$page$claude$error$pt_BR._(_root);
}

// Path: settings.page.account
class _Translations$settings$page$account$pt_BR extends Translations$settings$page$account$en {
	_Translations$settings$page$account$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Conta';
	@override String get profile => 'Perfil';
	@override String get instructions => 'Instruções para o Claude';
	@override String get instructionsDesc => 'Gravado em ~/.claude/CLAUDE.md: o Claude Code carrega em toda sessão deste computador.';
	@override String get instructionsHint => 'ex.: manter explicações breves e diretas';
	@override String get loggedIn => 'Conectado';
	@override String get loggedOut => 'Desconectado';
	@override String get loggedInDesc => 'O Claude Code deste computador usa esta conta.';
	@override String get loggedOutDesc => 'Entre para usar sua assinatura do Claude no Claude Code.';
	@override String get login => 'Entrar';
	@override String get logout => 'Sair';
	@override String get logoutConfirmTitle => 'Sair do Claude Code?';
	@override String get logoutConfirmMessage => 'Roda `claude auth logout`. As sessões deste computador deixam de usar sua assinatura até você entrar de novo.';
	@override String get email => 'E-mail';
	@override String get organization => 'Organização';
	@override String get orgId => 'ID da organização';
	@override String get plan => 'Plano';
	@override String get method => 'Método de login';
}

// Path: settings.page.usage
class _Translations$settings$page$usage$pt_BR extends Translations$settings$page$usage$en {
	_Translations$settings$page$usage$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Seus limites de uso';
	@override String get weeklyTitle => 'Limites semanais';
	@override String get unavailable => 'Limites de plano não se aplicam a este login (chave de API ou provedor terceiro).';
	@override String get windowSession => 'Sessão atual';
	@override String get windowWeekly => 'Todos os modelos';
	@override String resetsIn({required Object when}) => 'Reinicia em ${when}';
	@override String resetsAt({required Object when}) => 'Reinicia ${when}';
	@override String percentUsed({required Object pct}) => '${pct}% usado';
	@override String updated({required Object when}) => 'Última atualização: ${when}';
	@override String get justNow => 'há menos de um minuto';
	@override String minutesAgo({required Object n}) => 'há ${n} min';
	@override String minutes({required Object m}) => '${m} min';
	@override String hoursMinutes({required Object h, required Object m}) => '${h} h ${m} min';
	@override late final _Translations$settings$page$usage$plans$pt_BR plans = _Translations$settings$page$usage$plans$pt_BR._(_root);
}

// Path: settings.page.memory
class _Translations$settings$page$memory$pt_BR extends Translations$settings$page$memory$en {
	_Translations$settings$page$memory$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Memória';
	@override String get intro => 'O que uma sessão do Claude Code no workspace ativo carrega: suas instruções e a memória que o próprio Claude grava. Clique para abrir o arquivo.';
	@override String get instructionsTitle => 'Instruções';
	@override String get autoTitle => 'Memória automática';
	@override String get empty => 'Nenhum CLAUDE.md encontrado.';
	@override String get autoEmpty => 'O Claude ainda não gravou memórias para este workspace.';
	@override String get scopeUser => 'Usuário (todos os projetos)';
	@override String get scopeProject => 'Projeto';
	@override String updated({required Object when}) => 'Atualizado ${when}';
}

// Path: settings.page.skills
class _Translations$settings$page$skills$pt_BR extends Translations$settings$page$skills$en {
	_Translations$settings$page$skills$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get groupUser => 'Criado por você';
	@override String get groupProject => 'Do projeto';
	@override String get groupPlugins => 'Dos plugins';
	@override String get byYou => 'por você';
	@override String get byProject => 'do projeto';
	@override String get empty => 'Nenhuma skill instalada.';
}

// Path: settings.page.connectors
class _Translations$settings$page$connectors$pt_BR extends Translations$settings$page$connectors$en {
	_Translations$settings$page$connectors$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Verificando cada servidor… pode levar alguns segundos.';
	@override String get empty => 'Nenhum servidor MCP configurado.';
	@override String get addServer => 'Adicionar servidor MCP';
	@override String get colConnector => 'Conector';
	@override String get colType => 'Tipo';
	@override String get colStatus => 'Status';
	@override String fromPlugin({required Object plugin}) => 'Fornecido pelo plugin ${plugin}';
	@override String get typeWeb => 'Web';
	@override String get typeLocal => 'Local';
	@override String get originPlugin => 'Plugin';
	@override String get link => 'Vincular';
	@override String get discoverIntro => 'O diretório de conectores do claude.ai não tem API pública, então o GSH não o lista. Adicione qualquer servidor MCP aqui: o GSH roda `claude mcp add` num terminal.';
	@override String get formName => 'Nome';
	@override String get formType => 'Tipo';
	@override String get formUrl => 'URL';
	@override String get formCommand => 'Comando';
	@override String get formScope => 'Escopo';
	@override String get formScopeDesc => 'Usuário = todos os projetos; Local = só o projeto do terminal.';
	@override String get scopeUser => 'Usuário';
	@override String get scopeLocal => 'Local';
	@override String get docs => 'Docs de MCP';
	@override String get addInTerminal => 'Adicionar no terminal';
	@override late final _Translations$settings$page$connectors$status$pt_BR status = _Translations$settings$page$connectors$status$pt_BR._(_root);
}

// Path: settings.page.plugins
class _Translations$settings$page$plugins$pt_BR extends Translations$settings$page$plugins$en {
	_Translations$settings$page$plugins$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get search => 'Pesquisar skills e plugins';
	@override String get groupProject => 'Neste projeto';
	@override String get groupMarketplaces => 'Dos marketplaces que você adicionou';
	@override String get noWorkspace => 'Abra um workspace para ver os plugins habilitados nele.';
	@override String get projectEmpty => 'Nenhum plugin habilitado no .claude/settings.json deste projeto.';
	@override String get empty => 'Nenhum plugin instalado.';
	@override String get disabled => 'Desabilitado';
}

// Path: settings.page.developer
class _Translations$settings$page$developer$pt_BR extends Translations$settings$page$developer$en {
	_Translations$settings$page$developer$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Desenvolvedor';
	@override String get mcpTitle => 'Servidores MCP locais';
	@override String get mcpDesc => 'Servidores MCP stdio que o Claude Code sobe neste computador. Eles ficam no ~/.claude.json.';
	@override String get mcpEmpty => 'Nenhum servidor MCP local.';
	@override String get editConfig => 'Editar configuração';
	@override String get command => 'Comando';
	@override String get arguments => 'Argumentos';
	@override String get error => 'Erro';
	@override String get telemetryTitle => 'Telemetria';
	@override String get telemetryDesc => 'Erros e logs dos processos do workspace ficam no painel Telemetria do shell; com o modo desenvolvedor ele mostra também os do próprio GSH Desktop.';
	@override String get claudeSettingsTitle => 'Arquivo de configurações do Claude Code';
	@override String get claudeSettingsDesc => '~/.claude/settings.json — permissões, hooks, ambiente e modelo.';
	@override String get apiKeyTitle => 'Quer uma chave de API?';
	@override String get apiKeyDesc => 'Crie chaves e veja o uso no Claude Console. Isso requer outra conta, e o uso da API é cobrado separadamente.';
	@override String get apiKeyButton => 'Ir para o Console';
}

// Path: settings.page.system
class _Translations$settings$page$system$pt_BR extends Translations$settings$page$system$en {
	_Translations$settings$page$system$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sistema';
	@override String get version => 'Versão do aplicativo';
	@override String get keepAwakeTitle => 'Manter computador ativo';
	@override String get keepAwakeDesc => 'Impede a suspensão por inatividade enquanto ligado (o mesmo botão de raio do rail). Desliga ao fechar o app; fechar a tampa ainda suspende.';
}

// Path: settings.page.catalog
class _Translations$settings$page$catalog$pt_BR extends Translations$settings$page$catalog$en {
	_Translations$settings$page$catalog$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get mine => 'Meus';
	@override String get discover => 'Descobrir';
	@override String get add => 'Adicionar';
	@override String get all => 'Todos';
	@override String by({required Object author}) => 'por ${author}';
	@override String get newSkill => 'Nova skill…';
	@override String get addMarketplace => 'Adicionar marketplace…';
}

// Path: settings.page.generalClaude
class _Translations$settings$page$generalClaude$pt_BR extends Translations$settings$page$generalClaude$en {
	_Translations$settings$page$generalClaude$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionAppearance => 'Aparência';
	@override String get theme => 'Tema';
	@override String get themeSystem => 'Sistema';
	@override String get themeLight => 'Claro';
	@override String get themeDark => 'Escuro';
	@override String get uiFont => 'Fonte da interface';
	@override String get uiFontDesc => 'Fonte para toda a interface — menus, barras laterais e painéis.';
	@override String get chatFont => 'Fonte do chat';
	@override String get chatFontDesc => 'Texto da conversa no chat com o Claude.';
	@override String get chatFontDefault => 'Mesma da interface';
	@override String get textSize => 'Tamanho do texto da conversa';
	@override String get textSizeDesc => 'Tamanho base do texto do app (o mesmo ajuste de Aparência).';
	@override String get sizeSmall => 'Pequeno';
	@override String get sizeMedium => 'Médio';
	@override String get sizeLarge => 'Grande';
	@override String get transcriptWidth => 'Largura da transcrição';
	@override String get transcriptWidthDesc => 'Largura máxima das colunas da transcrição e do campo de mensagem.';
	@override String get widthNarrow => 'Estreito';
	@override String get widthMedium => 'Médio';
	@override String get widthWide => 'Largo';
	@override String get reducedMotion => 'Movimento reduzido';
	@override String get reducedMotionDesc => 'Menos animações no Claude Code (brilho do spinner, piscadas). Gravado como prefersReducedMotion no ~/.claude/settings.json.';
	@override String get sectionNotifications => 'Notificações';
	@override String get notifyTurnDone => 'Conclusão de respostas';
	@override String get notifyTurnDoneDesc => 'Receba uma notificação quando um agente terminar uma resposta e a janela não estiver em foco.';
	@override String get notifyPermission => 'Solicitações de permissão do Code';
	@override String get notifyPermissionDesc => 'Toca um som quando um agente estiver esperando sua aprovação ou resposta.';
	@override String get pushInputNeeded => 'Push no celular quando precisar de você';
	@override String get pushInputNeededDesc => 'O Claude Code manda um push quando uma permissão ou pergunta estiver esperando (inputNeededNotifEnabled).';
	@override String get pushAgent => 'Notificações proativas no celular';
	@override String get pushAgentDesc => 'Deixa o Claude avisar no celular sobre atualizações importantes de uma sessão (agentPushNotifEnabled).';
}

// Path: settings.page.privacy
class _Translations$settings$page$privacy$pt_BR extends Translations$settings$page$privacy$en {
	_Translations$settings$page$privacy$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dados';
	@override String get gshTelemetry => 'Telemetria do GSH';
	@override String get gshTelemetryDesc => 'Só local: erros e logs ficam num SQLite deste computador e nunca são enviados.';
	@override String get ccTelemetry => 'Desligar a telemetria do Claude Code';
	@override String get ccTelemetryDesc => 'Define DISABLE_TELEMETRY no env do ~/.claude/settings.json (métricas de uso não são enviadas).';
	@override String get ccErrors => 'Desligar relatórios de erro do Claude Code';
	@override String get ccErrorsDesc => 'Define DISABLE_ERROR_REPORTING no env do ~/.claude/settings.json.';
}

// Path: settings.page.resources
class _Translations$settings$page$resources$pt_BR extends Translations$settings$page$resources$en {
	_Translations$settings$page$resources$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get sectionGeneral => 'Geral';
	@override String get sectionShell => 'Recursos do GSH';
	@override String get chat => 'Chat com o Claude (beta)';
	@override String get chatDesc => 'Botão de chat na barra do workspace (Claude Code em stream-json).';
	@override String get farm => 'Fazenda';
	@override String get farmDesc => 'Loops de agente lidos dos transcripts do Claude Code.';
	@override String get graph => 'Grafo de agentes';
	@override String get graphDesc => 'Visualiza os agentes do workspace e quem fala com quem.';
	@override String get browser => 'Navegador embutido';
	@override String get browserDesc => 'Aba "Navegador" no menu da pane (onde a plataforma tem webview embutida).';
	@override String get skillsMoved => 'As Skills foram movidas para ';
}

// Path: settings.page.designSystems
class _Translations$settings$page$designSystems$pt_BR extends Translations$settings$page$designSystems$en {
	_Translations$settings$page$designSystems$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Design systems';
	@override String get desc => 'No GSH, são os temas: cores da interface, do terminal e do código num pacote só.';
	@override String get add => 'Novo design system';
	@override String get search => 'Pesquisar por nome';
	@override String showing({required Object n, required Object total}) => 'Exibindo ${n} de ${total}';
	@override String get colName => 'Nome';
	@override String get colOrigin => 'Origem';
	@override String get colAuthor => 'Autor';
	@override String get active => 'Ativo';
	@override String get imported => 'Importado';
	@override String get builtIn => 'Embutido';
	@override String get activate => 'Usar este tema';
	@override String get remove => 'Remover';
}

// Path: settings.page.nav.groups
class _Translations$settings$page$nav$groups$pt_BR extends Translations$settings$page$nav$groups$en {
	_Translations$settings$page$nav$groups$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Configurações';
	@override String get thisComputer => 'Este computador';
	@override String get personalization => 'Personalização';
	@override String get platform => 'Plataforma';
	@override String get app => 'GSH Desktop';
}

// Path: settings.page.general.updateFrequency
class _Translations$settings$page$general$updateFrequency$pt_BR extends Translations$settings$page$general$updateFrequency$en {
	_Translations$settings$page$general$updateFrequency$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get daily => 'Diariamente';
	@override String get weekly => 'Semanalmente';
	@override String get monthly => 'Mensalmente';
	@override String get never => 'Nunca';
}

// Path: settings.page.claude.error
class _Translations$settings$page$claude$error$pt_BR extends Translations$settings$page$claude$error$en {
	_Translations$settings$page$claude$error$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get cliMissing => 'CLI do Claude Code (`claude`) não encontrada neste computador.';
	@override String get timeout => 'A CLI `claude` demorou demais para responder.';
	@override String failed({required Object detail}) => 'A CLI `claude` falhou: ${detail}';
}

// Path: settings.page.usage.plans
class _Translations$settings$page$usage$plans$pt_BR extends Translations$settings$page$usage$plans$en {
	_Translations$settings$page$usage$plans$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get pro => 'Pro';
	@override String get max => 'Max';
	@override String get team => 'Equipe';
	@override String get enterprise => 'Empresa';
}

// Path: settings.page.connectors.status
class _Translations$settings$page$connectors$status$pt_BR extends Translations$settings$page$connectors$status$en {
	_Translations$settings$page$connectors$status$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get connected => 'Conectado';
	@override String get needsAuth => 'Precisa autenticar';
	@override String get failed => 'Falhou';
	@override String get pending => 'Aprovação pendente';
	@override String get unknown => 'Desconhecido';
}

/// The flat map containing all translations for locale <pt-BR>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsPtBr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'core.bootstrapError.title' => 'Falha ao inicializar o GSH Desktop',
			'core.bootstrapError.retry' => 'Tentar novamente',
			'core.macosNotifications.title' => 'Ativar notificações no macOS',
			'core.macosNotifications.intro' => 'As notificações estão desativadas nas configurações do sistema. Siga os passos abaixo para ativá-las:',
			'core.macosNotifications.step1' => 'Abra as Configurações do Sistema no seu Mac.',
			'core.macosNotifications.step2' => 'Acesse a seção Notificações na barra lateral esquerda.',
			'core.macosNotifications.step3' => 'Encontre e selecione o aplicativo GSH Desktop na lista.',
			'core.macosNotifications.step4' => 'Ative a opção Permitir Notificações.',
			'core.macosNotifications.tip' => 'Dica: se o aplicativo não aparecer na lista, feche e reabra-o para acionar seu registro no sistema.',
			'core.macosNotifications.gotIt' => 'Entendi',
			'core.appErrorView.renderFailed' => 'Esta parte do aplicativo falhou ao renderizar',
			'core.appErrorView.details' => 'Detalhes',
			'core.appErrorView.renderErrorTitle' => 'Erro de renderização',
			'core.errorReportDialog.defaultDescription' => 'Algo deu errado. Os detalhes abaixo foram salvos no log — você pode reportá-los para que isso seja corrigido.',
			'core.errorReportDialog.copyDetails' => 'Copiar detalhes',
			'core.errorReportDialog.reportIssue' => 'Reportar problema',
			'core.windowControls.minimize' => 'Minimizar',
			'core.windowControls.maximize' => 'Maximizar',
			'core.windowControls.close' => 'Fechar',
			'core.crash.title' => 'Encerramento inesperado',
			'core.crash.bannerTitle' => 'O GSH Desktop fechou inesperadamente',
			'core.crash.report' => 'Reportar',
			'core.crash.dismiss' => 'Dispensar',
			'core.crash.crashMessage' => ({required Object version}) => 'A sessão anterior (versão ${version}) terminou sem encerrar corretamente. Quer reportar? O log vai junto e você pode revisar tudo antes de enviar.',
			'core.crash.crashError' => ({required Object startedAt, required Object pid}) => 'A sessão iniciada em ${startedAt} (pid ${pid}) terminou sem encerramento limpo.',
			'core.crash.crashDescription' => 'Nenhum erro foi capturado: o app foi encerrado pelo sistema. O log abaixo é dessa sessão e é a parte mais útil.',
			'core.menu.settings' => 'Configurações…',
			'core.menu.checkForUpdates' => 'Verificar Atualizações…',
			'core.menu.file' => 'Arquivo',
			'core.menu.newTerminal' => 'Novo Terminal',
			'core.menu.openWorkspace' => 'Abrir Workspace',
			'core.menu.save' => 'Salvar',
			'core.menu.discard' => 'Descartar',
			'core.menu.format' => 'Formatar',
			'core.menu.view' => 'Exibir',
			'core.menu.toggleWorkspacePanel' => 'Alternar Painel de Workspaces',
			'core.menu.toggleFiles' => 'Alternar Arquivos',
			'core.menu.splitRight' => 'Dividir à Direita',
			'core.menu.splitDown' => 'Dividir Abaixo',
			'core.menu.focusPane' => 'Focar Painel',
			'core.menu.focusLeft' => 'Esquerda  (⌘⌥←)',
			'core.menu.focusRight' => 'Direita  (⌘⌥→)',
			'core.menu.focusUp' => 'Acima  (⌘⌥↑)',
			'core.menu.focusDown' => 'Abaixo  (⌘⌥↓)',
			'core.menu.selectTab' => 'Selecionar Aba',
			'core.menu.tabN' => ({required Object n}) => 'Aba ${n}',
			'core.menu.lastTab' => 'Última Aba',
			'core.menu.previousWorkspace' => 'Workspace Anterior',
			'core.menu.nextWorkspace' => 'Próximo Workspace',
			'core.menu.zoomIn' => 'Aumentar Zoom',
			'core.menu.zoomOut' => 'Diminuir Zoom',
			'core.menu.actualSize' => 'Tamanho Real',
			'core.menu.window' => 'Janela',
			'core.menu.quit' => 'Sair',
			'core.menu.minimize' => 'Minimizar',
			'core.menu.zoom' => 'Zoom',
			'common.cancel' => 'Cancelar',
			'common.confirm' => 'Confirmar',
			'common.create' => 'Criar',
			'common.gotIt' => 'Entendi',
			'common.save' => 'Salvar',
			'common.close' => 'Fechar',
			'common.delete' => 'Excluir',
			'common.done' => 'Concluído',
			'common.add' => 'Adicionar',
			'common.test' => 'Testar',
			'common.ok' => 'OK',
			'common.loading' => 'Carregando…',
			'common.checking' => 'Verificando…',
			'common.remove' => 'Remover',
			'common.restart' => 'Reiniciar',
			'common.settings' => 'Configurações',
			'common.send' => 'Enviar',
			'common.open' => 'Abrir',
			'common.dismiss' => 'Dispensar',
			'common.report' => 'Reportar',
			'common.copyCode' => 'Copiar código',
			'common.search' => 'Buscar',
			'common.noResults' => 'Nenhum resultado',
			'gsh.confirmDialog.unsavedChangesTitle' => 'Alterações não salvas',
			'gsh.confirmDialog.unsavedChangesMessage' => ({required Object fileName}) => '“${fileName}” tem alterações não salvas. Salvar antes de fechar?',
			'gsh.confirmDialog.dontSave' => 'Não salvar',
			'gsh.confirmDialog.saveAndClose' => 'Salvar e fechar',
			'gsh.neovim.unavailable' => 'O Neovim não está disponível. Abrindo no GSH Desktop.',
			'gsh.neovim.openFailed' => 'Não foi possível acessar o Neovim. Abrindo no GSH Desktop.',
			'gsh.neovim.unsavedTitle' => 'Buffers não salvos no Neovim',
			'gsh.neovim.unsavedMessage' => 'O Neovim tem buffers modificados. Fechar a aba e descartar essas alterações?',
			'gsh.neovim.closeAnyway' => 'Fechar mesmo assim',
			'gsh.worktreeCreateDialog.forkTitle' => 'Fork da worktree',
			'gsh.worktreeCreateDialog.createTitle' => 'Criar worktree',
			'gsh.worktreeCreateDialog.forkSubtitle' => ({required Object root}) => 'Nova worktree ramificada a partir de ${root}.',
			'gsh.worktreeCreateDialog.createSubtitle' => ({required Object root}) => 'Nova feature em ${root} — novo branch a partir do HEAD atual.',
			'gsh.worktreeCreateDialog.namePlaceholder' => 'feat/minha-feature',
			'gsh.worktreeCreateDialog.errorWhitespace' => 'Sem espaços no nome.',
			'gsh.worktreeCreateDialog.errorInvalidChar' => 'Caractere inválido para nome de branch.',
			'gsh.worktreeCreateDialog.errorInvalidSequence' => 'Sequência inválida (ex.: "..", "//", começar/terminar com "/").',
			'gsh.worktreeCreateDialog.errorReserved' => 'Posição reservada (não comece com "-"/"." nem termine com ".lock").',
			'gsh.worktreeCreateDialog.errorDuplicateBranch' => 'Já existe um branch com esse nome.',
			'gsh.worktreeCreateDialog.errorDuplicateWorktree' => 'Já existe uma worktree com esse nome.',
			'gsh.worktreeCreateDialog.errorBranchHierarchyConflict' => ({required Object target, required Object existing}) => 'Não é possível criar o branch \'${target}\' porque ele conflita com o branch \'${existing}\' já existente.',
			'gsh.worktreeCreateDialog.errorBranchHierarchicalConflictGeneral' => 'Já existe um branch com uma hierarquia conflitante.',
			'gsh.worktreeCreateDialog.fork' => 'Fork',
			'gsh.worktreeCreateDialog.postCheckoutHint' => 'Este repositório tem um hook post-checkout.',
			'gsh.worktreeCreateDialog.running' => 'Executando…',
			'gsh.worktreeCreateDialog.advancedSettings' => 'Configurações Avançadas',
			'gsh.worktreeCreateDialog.copyIgnored' => 'Copiar arquivos ignorados (.gitignore)',
			'gsh.worktreeCreateDialog.copyIgnoredDesc' => 'Copia arquivos ignorados pelo .gitignore (ex: .env, chaves locais) para a nova pasta.',
			'gsh.worktreeCreateDialog.copyUntracked' => 'Copiar arquivos não rastreados',
			'gsh.worktreeCreateDialog.copyUntrackedDesc' => 'Copia arquivos novos ou modificados que ainda não foram adicionados ao stage.',
			'gsh.worktreeCreateDialog.baseBranch' => 'Branch base',
			'gsh.worktreeCreateDialog.baseBranchDesc' => 'O branch de onde a nova worktree e branch serão ramificados.',
			'gsh.worktreeCreateDialog.fetchRemote' => 'Sincronizar branch remota (fetch)',
			'gsh.worktreeCreateDialog.fetchRemoteDesc' => 'Roda git fetch para garantir que a branch base esteja confirmada antes de criar a worktree.',
			'gsh.worktreeCreateDialog.searchBranch' => 'Buscar branch...',
			'gsh.worktreeCreateDialog.back' => 'Voltar',
			'gsh.commitMessageDialog.commitTitle' => 'Commit',
			'gsh.commitMessageDialog.stageAndCommitTitle' => 'Stage e Commit',
			'gsh.commitMessageDialog.scopeNote' => ({required Object fileName}) => 'Commit apenas de "${fileName}".',
			'gsh.commitMessageDialog.placeholder' => 'fix: resumo curto da mudança',
			'gsh.commitMessageDialog.errorEmptySubject' => 'A primeira linha (assunto) não pode ficar vazia.',
			'gsh.commitMessageDialog.errorTooShort' => ({required Object min}) => 'Assunto muito curto (mín. ${min} caracteres).',
			'gsh.commitMessageDialog.errorTooLong' => ({required Object max}) => 'Assunto muito longo (máx. ${max} caracteres).',
			'gsh.commitMessageDialog.errorTrailingPeriod' => 'O assunto não deve terminar com ponto.',
			'gsh.commitMessageDialog.errorControlChars' => 'O assunto contém caracteres de controle.',
			'gsh.commitMessageDialog.errorBlankSecondLine' => 'Deixe a segunda linha em branco (separador entre assunto e corpo do git).',
			'gsh.commitMessageDialog.generate' => 'Gerar mensagem de commit',
			'gsh.commitMessageDialog.generateWith' => ({required Object harness}) => 'Gerar com ${harness}',
			'gsh.commitMessageDialog.generating' => 'Gerando…',
			'gsh.commitMessageDialog.cancelGeneration' => 'Cancelar geração',
			'gsh.tasksPanel.reloadTasksTooltip' => 'Recarregar tasks',
			'gsh.tasksPanel.restartTooltip' => 'Reiniciar',
			'gsh.tasksPanel.stopTooltip' => 'Parar',
			'gsh.tasksPanel.runTooltip' => 'Executar',
			'gsh.tasksPanel.sendsKeyTooltip' => ({required Object label, required Object key}) => '${label} (envia \'${key}\')',
			'gsh.tasksPanel.startingTooltip' => 'Iniciando…',
			'gsh.tasksPanel.stoppingTooltip' => 'Parando…',
			'gsh.tasksPanel.switchProfileTooltip' => 'Trocar perfil',
			'gsh.tasksPanel.moreKeysTooltip' => 'Mais teclas',
			'gsh.tasksPanel.sectionTasks' => 'TAREFAS',
			'gsh.tasksPanel.noTasks' => 'Nenhuma tarefa detectada neste projeto.',
			'gsh.tasksPanel.createTasksJson' => 'Criar tasks.json',
			'gsh.tasksPanel.generateComposeTasks' => 'Gerar tasks do Compose',
			'gsh.tasksPanel.selectComposeEngine' => 'Escolha uma engine Compose',
			'gsh.tasksPanel.noComposeEngine' => 'Docker Compose ou Podman Compose não foi encontrado.',
			'gsh.tasksPanel.invalidComposeFile' => 'O arquivo ativo não é um Compose válido com services.',
			'gsh.tasksPanel.invalidTasksJson' => 'tasks.json é inválido. Nenhuma alteração foi gravada.',
			'gsh.tasksPanel.composeConflicts' => ({required Object labels}) => 'Tasks não Compose com rótulos conflitantes foram mantidas: ${labels}',
			'gsh.gshPage.chooseProjectFolderDialogTitle' => 'Escolha a pasta do projeto',
			'gsh.gshPage.chooseWorkspaceFolderDialogTitle' => 'Escolha a pasta do workspace',
			'gsh.gshPage.workspaceRenamedTitle' => 'Workspace renomeado',
			'gsh.gshPage.workspaceRenamedMessage' => ({required Object name}) => 'O novo nome "${name}" só será enviado aos agentes após reiniciar o workspace ou o aplicativo.',
			'gsh.gshPage.syncTitle' => ({required Object label}) => 'Sync — ${label}',
			'gsh.gshPage.pullTitle' => ({required Object label}) => 'Pull — ${label}',
			'gsh.gshPage.pushTitle' => ({required Object label}) => 'Push — ${label}',
			'gsh.gshPage.updateFromParentTitle' => ({required Object name}) => 'Atualizar a partir do Pai — ${name}',
			'gsh.gshPage.mergeToParentTitle' => ({required Object name}) => 'Merge para o Pai — ${name}',
			'gsh.gshPage.worktreeMergedAndRemoved' => 'Worktree mesclada e removida.',
			'gsh.gshPage.nothingWasChanged' => 'Nada foi alterado.',
			'gsh.gshPage.newRealmTitle' => 'Novo realm',
			'gsh.gshPage.closeWorkspaceTitle' => 'Fechar workspace',
			'gsh.gshPage.closeWorkspaceMessage' => ({required Object name}) => 'Fechar "${name}"? Os agentes deste workspace serão encerrados. A pasta no disco é mantida.',
			'gsh.gshPage.closeAction' => 'Fechar',
			'gsh.gshPage.removeWorktreeTitle' => 'Remover worktree',
			'gsh.gshPage.removeWorktreeMessage' => ({required Object name, required Object warn}) => 'Remover "${name}"? A pasta da worktree e o branch serão excluídos e os agentes deste fork serão encerrados.${warn}',
			'gsh.gshPage.removeWorktreeWarning' => ({required Object name}) => '\n\nAviso: o branch "${name}" ainda não foi mesclado — removê-lo (git branch -D) descarta o trabalho não mesclado.',
			'gsh.gshPage.failedToRemoveWorktreeTitle' => 'Falha ao remover a worktree',
			'gsh.gshPage.openLayoutTitle' => 'Abrir layout',
			'gsh.gshPage.replaceLayoutTitle' => 'Substituir o layout atual?',
			'gsh.gshPage.replaceLayoutMessage' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: '1 aba será fechada, e ela tem um processo em execução.', other: '${n} abas serão fechadas, inclusive as com processos em execução.', ), 
			'gsh.gshPage.replaceLayoutConfirm' => 'Substituir',
			'gsh.gshPage.restartServerTooltip' => 'Reiniciar servidor',
			'gsh.gshPage.noLspAvailable' => 'Nenhum LSP disponível',
			'gsh.gshPage.lspRunning' => 'em execução',
			'gsh.gshPage.lspStopped' => 'parado',
			'gsh.welcomeView.title' => 'Bem-vindo ao GSH Desktop',
			'gsh.welcomeView.subtitle' => 'Abra uma pasta ou conecte a um host remoto para começar.',
			'gsh.welcomeView.createWorkspace' => 'Criar workspace',
			'gsh.welcomeView.openLocalFolder' => 'Abrir pasta local',
			'gsh.welcomeView.connectHost' => 'Conectar a um host',
			'gsh.welcomeView.configureHost' => 'Configurar host',
			'gsh.welcomeView.addWorkspace' => 'Adicionar workspace',
			'gsh.paneView.closePaneTitle' => 'Fechar painel?',
			'gsh.paneView.closePaneMessage' => ({required Object count}) => 'Isso fecha todas as ${count} aba(s) deste painel e encerra os agentes/terminais nele.',
			'gsh.paneView.close' => 'Fechar',
			'gsh.paneView.closeOtherTabs' => 'Fechar as outras',
			'gsh.paneView.closeTabsToTheRight' => 'Fechar à direita',
			'gsh.paneView.closeAllTabs' => 'Fechar todas',
			'gsh.paneView.closeTabsTitle' => 'Fechar abas?',
			'gsh.paneView.closeTabsMessage' => ({required Object count}) => 'Isso fecha ${count} aba(s) e encerra os agentes/terminais nelas.',
			'gsh.paneView.allTabs' => 'Todas as abas',
			'gsh.paneView.pinTab' => 'Fixar aba',
			'gsh.paneView.openInNewWindow' => 'Abrir em nova janela',
			'gsh.paneView.rename' => 'Renomear',
			'gsh.paneView.openAsMarkdown' => 'Abrir como markdown',
			'gsh.paneView.openAsBoard' => 'Abrir como quadro',
			'gsh.paneView.resetTitle' => 'Redefinir título',
			'gsh.paneView.copyId' => 'Copiar Id',
			'gsh.paneView.restartTab' => 'Reiniciar',
			'gsh.paneView.newTab' => 'Nova aba',
			'gsh.paneView.newTerminal' => 'Novo terminal…',
			'gsh.paneView.splitRight' => 'Dividir à direita',
			'gsh.paneView.splitDown' => 'Dividir abaixo',
			'gsh.paneView.closePane' => 'Fechar painel',
			'gsh.paneView.dropHereToMove' => 'Solte aqui para mover a aba',
			'gsh.paneView.dockAsTab' => 'Encaixar como aba',
			'gsh.paneView.openBrowser' => 'Abrir navegador',
			'gsh.paneView.openTerminal' => 'Abrir terminal',
			'gsh.paneView.openAsLayout' => 'Abrir como layout',
			'gsh.paneView.openAsYaml' => 'Abrir como YAML',
			'gsh.paneView.openAsPanel' => 'Abrir como painel',
			'gsh.paneView.openAsHtml' => 'Abrir como HTML',
			'gsh.fileTreePanel.viewDiff' => 'Ver Diff',
			'gsh.fileTreePanel.commit' => 'Commit',
			'gsh.fileTreePanel.stageAndCommit' => 'Stage e Commit',
			'gsh.fileTreePanel.unstage' => 'Tirar do stage',
			'gsh.fileTreePanel.stageChanges' => 'Colocar no stage',
			'gsh.fileTreePanel.discardChanges' => 'Descartar alterações',
			'gsh.fileTreePanel.enterCommitMessage' => 'Digite uma mensagem de commit.',
			'gsh.fileTreePanel.commitUnavailable' => 'Commit indisponível para este workspace.',
			'gsh.fileTreePanel.gitErrorTitle' => 'Erro do Git',
			'gsh.fileTreePanel.deleteNewFileTitle' => 'Excluir arquivo novo?',
			'gsh.fileTreePanel.discardChangesTitle' => 'Descartar alterações?',
			'gsh.fileTreePanel.deleteNewFileMessage' => ({required Object name}) => '"${name}" é um arquivo novo e não pode ser restaurado. Excluir?',
			'gsh.fileTreePanel.discardOneMessage' => ({required Object name}) => 'Descartar todas as alterações em "${name}"? Arquivos excluídos serão restaurados.',
			'gsh.fileTreePanel.discard' => 'Descartar',
			'gsh.fileTreePanel.deleteAllNewFilesTitle' => 'Excluir todos os arquivos novos?',
			'gsh.fileTreePanel.allNewFilesMessage' => ({required Object count}) => 'Todos os ${count} arquivos são novos e serão excluídos. Isso não pode ser desfeito.',
			'gsh.fileTreePanel.discardTrackedMessage' => ({required Object count, required Object extra}) => 'Descartar alterações em ${count} arquivo(s) rastreado(s)?${extra}',
			'gsh.fileTreePanel.discardTrackedExtra' => ({required Object count}) => ' ${count} arquivo(s) novo(s) será(ão) mantido(s).',
			'gsh.fileTreePanel.deleteAll' => 'Excluir tudo',
			'gsh.fileTreePanel.deleteQuestionTitle' => 'Excluir?',
			'gsh.fileTreePanel.moveToTrash' => ({required Object name}) => 'Mover “${name}” para a Lixeira?',
			'gsh.fileTreePanel.permanentlyDelete' => ({required Object name}) => 'Excluir “${name}” permanentemente? Isso não pode ser desfeito.',
			'gsh.fileTreePanel.couldNotDeleteTitle' => 'Não foi possível excluir',
			'gsh.fileTreePanel.moveQuestionTitle' => 'Mover?',
			'gsh.fileTreePanel.moveMessage' => ({required Object name, required Object dest}) => 'Mover “${name}” para “${dest}”?',
			'gsh.fileTreePanel.moveAction' => 'Mover',
			'gsh.fileTreePanel.couldNotMoveTitle' => 'Não foi possível mover',
			'gsh.fileTreePanel.couldNotPasteTitle' => 'Não foi possível colar',
			'gsh.fileTreePanel.filesTooltip' => 'Arquivos',
			'gsh.fileTreePanel.searchTooltip' => 'Buscar',
			'gsh.fileTreePanel.sourceControlTooltip' => 'Controle de versão',
			'gsh.fileTreePanel.databaseTooltip' => 'Banco de dados',
			'gsh.fileTreePanel.sectionFiles' => 'ARQUIVOS',
			'gsh.fileTreePanel.newFile' => 'Novo arquivo',
			'gsh.fileTreePanel.newFolder' => 'Nova pasta',
			'gsh.fileTreePanel.refreshTooltip' => 'Atualizar',
			'gsh.fileTreePanel.agentFilterTooltip' => 'Filtrar por agente',
			'gsh.fileTreePanel.allAgents' => 'Todos os agentes',
			'gsh.fileTreePanel.trackingUnavailable' => 'rastreio indisponível',
			'gsh.fileTreePanel.editedBy' => ({required Object label, required Object time}) => 'Editado por ${label} · ${time}',
			'gsh.fileTreePanel.inferredSuffix' => '(inferido)',
			'gsh.fileTreePanel.noTouchedFiles' => 'Nenhum arquivo tocado por este agente ainda',
			'gsh.fileTreePanel.concurrentAgentEdits' => 'Editado por 2+ agentes nos últimos 10 minutos',
			'gsh.fileTreePanel.collapseAll' => 'Recolher todas as pastas',
			'gsh.fileTreePanel.sectionSourceControl' => 'CONTROLE DE VERSÃO',
			'gsh.fileTreePanel.viewAsList' => 'Ver como lista',
			'gsh.fileTreePanel.viewAsTree' => 'Ver como árvore',
			'gsh.fileTreePanel.noFolderMessage' => 'Nenhuma pasta — abra um workspace.',
			'gsh.fileTreePanel.amend' => 'Amend',
			'gsh.fileTreePanel.commitMessagePlaceholder' => 'Mensagem do commit',
			'gsh.fileTreePanel.amendCommit' => 'Amend do commit',
			'gsh.fileTreePanel.lastCommit' => 'último commit',
			'gsh.fileTreePanel.openInFinder' => 'Abrir no Finder',
			'gsh.fileTreePanel.openInExplorer' => 'Abrir no Explorer',
			'gsh.fileTreePanel.openInFileManager' => 'Abrir no gerenciador de arquivos',
			'gsh.fileTreePanel.open' => 'Abrir',
			'gsh.fileTreePanel.openWith' => 'Abrir com',
			'gsh.fileTreePanel.openInNewWindow' => 'Abrir em nova janela',
			'gsh.fileTreePanel.openLayout' => 'Abrir layout',
			'gsh.fileTreePanel.openAsMarkdown' => 'Abrir como markdown',
			'gsh.fileTreePanel.showGitDiff' => 'Mostrar diff do git',
			'gsh.fileTreePanel.createTerminal' => 'Abrir no terminal',
			'gsh.fileTreePanel.rename' => 'Renomear',
			'gsh.fileTreePanel.copy' => 'Copiar',
			'gsh.fileTreePanel.cut' => 'Recortar',
			'gsh.fileTreePanel.paste' => 'Colar',
			'gsh.fileTreePanel.copyRelativePath' => 'Copiar caminho relativo',
			'gsh.fileTreePanel.copyAbsolutePath' => 'Copiar caminho absoluto',
			'gsh.fileTreePanel.renameFailed' => 'Falha ao renomear.',
			'gsh.fileTreePanel.noChanges' => 'Nenhuma alteração.',
			'gsh.fileTreePanel.stagedChangesHeader' => ({required Object count}) => 'ALTERAÇÕES EM STAGE (${count})',
			'gsh.fileTreePanel.changesHeader' => ({required Object count}) => 'ALTERAÇÕES (${count})',
			'gsh.fileTreePanel.discardAllChanges' => 'Descartar todas as alterações',
			'gsh.fileTreePanel.unstageAllChanges' => 'Tirar tudo do stage',
			'gsh.fileTreePanel.stageAllChanges' => 'Colocar tudo no stage',
			'gsh.fileTreePanel.discardFolderChanges' => 'Descartar alterações da pasta',
			'gsh.fileTreePanel.unstageFolderChanges' => 'Tirar pasta do stage',
			'gsh.fileTreePanel.stageFolderChanges' => 'Colocar pasta no stage',
			'gsh.fileTreePanel.generateCommitMessage' => 'Gerar mensagem de commit',
			'gsh.fileTreePanel.generateWith' => ({required Object harness}) => 'Gerar com ${harness}',
			'gsh.fileTreePanel.generateUnavailableWhileAmending' => 'Indisponível durante o amend de um commit',
			'gsh.fileTreePanel.cancelGeneration' => 'Cancelar geração',
			'gsh.fileTreePanel.changes' => 'Alteracoes',
			'gsh.fileTreePanel.history' => 'Historico',
			'gsh.fileTreePanel.historyRepository' => 'Repositorio',
			'gsh.fileTreePanel.historyNoRepository' => 'Nenhum repositorio Git disponivel.',
			'gsh.fileTreePanel.historyEmpty' => 'Nenhum commit encontrado.',
			'gsh.fileTreePanel.historyLoadFailed' => 'Nao foi possivel carregar o historico Git.',
			'gsh.fileTreePanel.historyUntitledCommit' => 'Commit sem titulo',
			'gsh.fileTreePanel.historyNow' => 'agora',
			'gsh.fileTreePanel.historyMinutesAgo' => ({required Object count}) => 'ha ${count} min',
			'gsh.fileTreePanel.historyHoursAgo' => ({required Object count}) => 'ha ${count} h',
			'gsh.fileTreePanel.historyYesterday' => 'ontem',
			'gsh.fileTreePanel.historyDayAgo' => 'ha 1 dia',
			'gsh.fileTreePanel.historyDaysAgo' => ({required Object count}) => 'ha ${count} dias',
			'gsh.fileTreePanel.historyFiles' => 'Arquivos alterados',
			'gsh.fileTreePanel.historyFilesEmpty' => 'Nenhum arquivo alterado.',
			'gsh.fileTreePanel.historyFilesLoadFailed' => 'Nao foi possivel carregar os arquivos alterados.',
			'gsh.fileTreePanel.diffEmptyTree' => 'Arvore vazia',
			'gsh.fileTreePanel.diffOriginal' => ({required Object ref}) => 'Original ${ref}',
			'gsh.fileTreePanel.diffModified' => ({required Object ref}) => 'Modificado ${ref}',
			'gsh.fileTreePanel.diffWorkingTree' => 'Diretorio de trabalho',
			'gsh.fileTreePanel.diffBinaryFile' => 'Arquivo binario - sem diff de texto.',
			'gsh.fileTreePanel.diffNoChanges' => 'Sem alteracoes.',
			'gsh.fileTreePanel.diffError' => ({required Object detail}) => 'Não foi possível ler o diff: ${detail}',
			'gsh.fileTreePanel.galleryTooltip' => 'Galeria',
			'gsh.fileTreePanel.sectionGallery' => 'GALERIA',
			'gsh.fileTreePanel.openAsHtml' => 'Abrir como HTML',
			'gsh.fileTreePanel.importQuestionTitle' => 'Copiar aqui?',
			'gsh.fileTreePanel.importMessage' => ({required Object count, required Object dest}) => 'Copiar ${count} itens para “${dest}”?',
			'gsh.fileTreePanel.importAction' => 'Copiar',
			'gsh.fileTreePanel.couldNotImportTitle' => 'Não foi possível copiar',
			'gsh.fileTreePanel.openInAgent' => ({required Object harness}) => 'Abrir no ${harness}',
			'gsh.fileViewer.cantOpen' => 'Não é possível abrir este arquivo.',
			'gsh.fileViewer.couldNotLoadImage' => 'Não foi possível carregar a imagem.',
			'gsh.fileViewer.preview' => 'Pré-visualização',
			'gsh.fileViewer.source' => 'Código-fonte',
			'gsh.fileViewer.reload' => 'Recarregar',
			'gsh.workspaceSettingsDialog.choosePhotoTitle' => 'Escolher foto do workspace',
			'gsh.workspaceSettingsDialog.title' => 'Configurações do workspace',
			'gsh.workspaceSettingsDialog.namePlaceholder' => 'Nome do workspace',
			'gsh.workspaceSettingsDialog.addPhoto' => 'Adicionar foto',
			'gsh.workspaceSettingsDialog.changePhoto' => 'Alterar foto',
			'gsh.workspaceSettingsDialog.remove' => 'Remover',
			'gsh.workspaceSettingsDialog.color' => 'Cor',
			'gsh.workspaceSettingsDialog.host' => 'Host',
			'gsh.workspaceSettingsDialog.folder' => 'Pasta',
			'gsh.realmDialogs.namePlaceholder' => 'Nome do realm',
			'gsh.realmDialogs.duplicateName' => 'Já existe um realm com esse nome.',
			'gsh.realmDialogs.newRealmTitle' => 'Novo realm',
			'gsh.realmDialogs.renameRealmTitle' => 'Renomear realm',
			'gsh.realmDialogs.rename' => 'Renomear',
			'gsh.realmDialogs.deleteRealmTitle' => 'Excluir realm',
			'gsh.realmDialogs.deleteMessage' => ({required Object name, required Object suffix}) => 'Excluir "${name}"? Nenhum workspace é excluído — só a lista de pastas muda.${suffix}',
			'gsh.realmDialogs.deleteSuffixOne' => ' O workspace dele irá para o Padrão.',
			'gsh.realmDialogs.deleteSuffixMany' => ({required Object count}) => ' Os ${count} workspaces dele irão para o Padrão.',
			'gsh.realmDialogs.manageRealmsTitle' => 'Gerenciar realms',
			'gsh.realmDialogs.workspaceCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: '1 workspace', other: '${n} workspaces', ), 
			'gsh.dbRedisTable.deleteKeyTitle' => 'Excluir chave',
			'gsh.dbRedisTable.deleteKeyMessage' => ({required Object key}) => 'Excluir "${key}" deste banco Redis?',
			'gsh.dbRedisTable.refresh' => 'Atualizar',
			'gsh.dbRedisTable.newKey' => 'Nova chave',
			'gsh.dbRedisTable.columnKey' => 'CHAVE',
			'gsh.dbRedisTable.columnValue' => 'VALOR',
			'gsh.dbRedisTable.columnType' => 'TIPO',
			'gsh.dbRedisTable.columnTtl' => 'TTL',
			'gsh.dbRedisTable.keyCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: '1 chave', other: '${n} chaves', ), 
			'gsh.dbRedisTable.noKeys' => 'Nenhuma chave neste banco de dados.',
			'gsh.dbRedisTable.noKeysMatch' => ({required Object pattern}) => 'Nenhuma chave corresponde a "${pattern}".',
			'gsh.dbRedisTable.loadMore' => 'Carregar mais',
			'gsh.dbRedisTable.loadingFullValue' => 'Carregando valor completo…',
			'gsh.dbRedisTable.ttlMustBeNumber' => 'TTL deve ser um número de segundos.',
			'gsh.dbRedisTable.addKey' => 'Adicionar chave',
			'gsh.dbRedisTable.keyFieldHint' => 'chave',
			'gsh.dbRedisTable.ttlFieldHint' => 'ttl (s, opcional)',
			'gsh.dbRedisTable.valueFieldHint' => 'valor',
			'gsh.dbRedisTable.searchHint' => 'Buscar — padrão, ex.: user:*',
			'gsh.dbQueryView.saveQueryAs' => 'Salvar query como',
			'gsh.dbQueryView.couldNotSave' => 'Não foi possível salvar',
			'gsh.dbQueryView.selectDatabase' => 'Selecionar banco de dados',
			'gsh.dbQueryView.noSqlConnections' => 'Nenhuma conexão SQL',
			'gsh.dbQueryView.running' => 'Executando…',
			'gsh.dbQueryView.runSelection' => 'Executar seleção',
			'gsh.dbQueryView.run' => 'Executar',
			'gsh.dbQueryView.pickDatabaseHint' => 'Escolha um banco de dados acima e depois Executar (⌘↵).',
			'gsh.dbQueryView.runQueryHint' => 'Execute a query (⌘↵) para ver os resultados aqui.',
			'gsh.dbQueryView.noRows' => 'Nenhuma linha.',
			'gsh.dbQueryView.rowsAffected' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: '1 linha afetada', other: '${n} linhas afetadas', ), 
			'gsh.dbQueryView.rowsFooter' => ({required Object n}) => '${n} linhas',
			'gsh.dbQueryView.truncatedSuffix' => ' · truncado (aumente -- limit)',
			'gsh.dbQueryView.table' => 'Tabela',
			'gsh.dbQueryView.json' => 'JSON',
			'gsh.dbQueryView.unsaved' => 'não salvo',
			'gsh.dbQueryView.saved' => 'salvo',
			'gsh.dbQueryView.copied' => 'Copiado',
			'gsh.dbQueryView.copy' => 'Copiar',
			'gsh.httpView.saveRequestAs' => 'Salvar request como',
			'gsh.httpView.couldNotSave' => 'Não foi possível salvar',
			'gsh.httpView.run' => 'Executar',
			'gsh.httpView.running' => 'Executando…',
			'gsh.httpView.noRequests' => 'Nenhum request neste arquivo — escreva um, ex.: GET https://example.com',
			'gsh.httpView.selectRequest' => 'Selecionar request',
			'gsh.httpView.requestCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: '1 request', other: '${n} requests', ), 
			'gsh.httpView.runHint' => 'Execute o request (⌘↵) para ver a resposta aqui.',
			'gsh.httpView.emptyBody' => 'Corpo da resposta vazio.',
			'gsh.httpView.body' => 'JSON',
			'gsh.httpView.headers' => 'Headers',
			'gsh.httpView.raw' => 'Text',
			'gsh.httpView.truncatedSuffix' => ' · truncado (resposta grande demais)',
			'gsh.httpView.error.title' => 'Falha no request',
			'gsh.httpView.error.noRequest' => 'Nenhum request encontrado na posição do cursor.',
			'gsh.httpView.error.invalidUrl' => ({required Object url}) => 'URL inválida: ${url}',
			'gsh.httpView.error.unresolvedVariable' => ({required Object name}) => 'A variável {{${name}}} não tem valor. Declare com @${name} = … neste arquivo.',
			'gsh.httpView.error.bodyFileMissing' => ({required Object path}) => 'Arquivo de corpo não encontrado: ${path}',
			'gsh.httpView.error.bodyFileUnreadable' => ({required Object path, required Object detail}) => 'Não foi possível ler o arquivo de corpo ${path}: ${detail}',
			'gsh.httpView.error.connectionFailed' => ({required Object detail}) => 'Não foi possível alcançar o servidor: ${detail}',
			'gsh.httpView.error.connectionFailedNoDetail' => 'Não foi possível alcançar o servidor.',
			'gsh.httpView.error.timeout' => ({required Object seconds}) => 'O request estourou o tempo limite de ${seconds}s.',
			'gsh.httpView.error.responseTooLarge' => ({required Object bytes}) => 'A resposta passou do limite de ${bytes} bytes.',
			'gsh.kanbanView.filter' => 'Filtrar',
			'gsh.kanbanView.filterTitlePlaceholder' => 'Buscar por título',
			'gsh.kanbanView.filterLabels' => 'Marcadores',
			'gsh.kanbanView.filterClear' => 'Limpar',
			'gsh.kanbanView.filterDependencies' => 'Dependências',
			'gsh.kanbanView.filterBlocked' => 'Bloqueado',
			'gsh.kanbanView.filterReady' => 'Pronto',
			'gsh.kanbanView.blockedBy' => 'Bloqueado por',
			'gsh.kanbanView.addBlocker' => 'Adicionar card bloqueador',
			'gsh.kanbanView.searchCards' => 'Buscar cards',
			'gsh.kanbanView.unknownCard' => 'desconhecido',
			'gsh.kanbanView.boardView' => 'Quadro',
			'gsh.kanbanView.listView' => 'Lista',
			'gsh.kanbanView.refresh' => 'Atualizar do disco',
			'gsh.kanbanView.manageLabels' => 'Marcadores',
			'gsh.kanbanView.labelsTitle' => 'Marcadores deste quadro',
			'gsh.kanbanView.labelNamePlaceholder' => 'nome do marcador',
			'gsh.kanbanView.labelUsage' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: '1 card', other: '${n} cards', ), 
			'gsh.kanbanView.deleteLabel' => 'Apagar marcador',
			'gsh.kanbanView.newCard' => 'novo card',
			'gsh.kanbanView.newCardTitle' => 'Novo card',
			'gsh.kanbanView.newColumn' => 'Nova coluna',
			'gsh.kanbanView.columnNameTitle' => 'Nome da coluna',
			'gsh.kanbanView.dragColumn' => 'Arrastar coluna',
			'gsh.kanbanView.columnOptions' => 'Opções da coluna',
			'gsh.kanbanView.renameColumn' => 'Renomear coluna',
			'gsh.kanbanView.moveColumnLeft' => 'Mover pra esquerda',
			'gsh.kanbanView.moveColumnRight' => 'Mover pra direita',
			'gsh.kanbanView.deleteColumn' => 'Apagar coluna',
			'gsh.kanbanView.newCardHere' => 'Novo card aqui',
			'gsh.kanbanView.duplicateCard' => 'Duplicar',
			'gsh.kanbanView.cardLabels' => 'Marcadores',
			'gsh.kanbanView.deleteCard' => 'Apagar card',
			'gsh.kanbanView.advance' => 'Passar pra próxima coluna',
			'gsh.kanbanView.advanceHold' => 'Mover para a próxima coluna (segurar: mover para a última)',
			'gsh.kanbanView.advanceBack' => 'Voltar uma coluna',
			'gsh.kanbanView.emptyColumn' => 'Sem cards',
			'gsh.kanbanView.cardCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: '1 card', other: '${n} cards', ), 
			'gsh.kanbanView.notes' => 'Nota',
			'gsh.kanbanView.notesPlaceholder' => 'Escreva uma nota',
			'gsh.kanbanView.comments' => 'Comentários',
			'gsh.kanbanView.addComment' => 'Adicionar comentário',
			'gsh.kanbanView.commentPlaceholder' => 'Escreva um comentário',
			'gsh.kanbanView.noComments' => 'Nenhum comentário ainda',
			'gsh.kanbanView.closeDetail' => 'Fechar',
			'gsh.kanbanView.notABoard' => 'Este arquivo ainda não tem colunas ## — ele abre como markdown.',
			'gsh.kanbanView.startBoard' => 'Começar um quadro',
			'gsh.kanbanView.couldNotSave' => 'Não deu pra salvar o quadro',
			'gsh.kanbanView.unrecognizedBlock' => 'Não reconhecido pelo parser — arrasta inteiro, sem edição inline.',
			'gsh.kanbanView.deleteColumnDialog.title' => ({required Object name}) => 'Apagar “${name}”?',
			'gsh.kanbanView.deleteColumnDialog.message' => ({required Object count}) => 'Esta coluna tem ${count}. Escolha o que acontece com eles.',
			'gsh.kanbanView.deleteColumnDialog.moveCards' => 'Mover pra coluna anterior',
			'gsh.kanbanView.deleteColumnDialog.deleteAll' => 'Apagar junto com a coluna',
			'gsh.kanbanView.deleteColumnDialog.emptyMessage' => 'Esta coluna está vazia.',
			'gsh.dbPanel.sectionDatabase' => 'BANCO DE DADOS',
			'gsh.dbPanel.edit' => 'Editar…',
			'gsh.dbPanel.copyName' => 'Copiar nome',
			'gsh.dbPanel.newQuery' => 'Nova query',
			'gsh.dbPanel.browseKeys' => 'Ver chaves',
			'gsh.dbPanel.deleteConnectionTitle' => 'Excluir conexão',
			'gsh.dbPanel.deleteConnectionMessage' => ({required Object name}) => 'Remover "${name}" deste workspace? Qualquer senha salva será descartada. Arquivos .dbq que fazem referência a ela não são afetados.',
			'gsh.dbPanel.footer' => ({required Object n}) => '.gsh/databases.json · ${n} conexões',
			'gsh.dbPanel.footerOne' => '.gsh/databases.json · 1 conexão',
			'gsh.dbPanel.noConnections' => 'Nenhuma conexão ainda.',
			'gsh.dbPanel.passwordRequired' => 'Senha não encontrada no host. Abra esta conexão e digite-a de novo — ela fica salva na máquina que executa o banco, não nesta.',
			'gsh.dbMongoView.deleteDocumentTitle' => 'Excluir documento',
			'gsh.dbMongoView.deleteDocumentMessage' => ({required Object id, required Object collection}) => 'Excluir o documento com _id ${id} de "${collection}"?',
			'gsh.dbMongoView.filterHint' => 'Filtro — JSON, ex.: {"status": "active"}',
			'gsh.dbMongoView.docCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: '1 doc', other: '${n} docs', ), 
			'gsh.dbMongoView.refresh' => 'Atualizar',
			'gsh.dbMongoView.insertDocument' => 'Inserir documento',
			'gsh.dbMongoView.noDocuments' => 'Nenhum documento nesta coleção.',
			'gsh.dbMongoView.noDocumentsMatch' => 'Nenhum documento corresponde a este filtro.',
			'gsh.dbMongoView.loadMore' => 'Carregar mais',
			'gsh.dbMongoView.edit' => 'Editar',
			'gsh.dbMongoView.insert' => 'Inserir',
			'gsh.dbConnectionDialog.chooseFileTitle' => 'Escolher banco SQLite',
			'gsh.dbConnectionDialog.file' => 'Arquivo',
			'gsh.dbConnectionDialog.chooseFilePlaceholder' => 'Escolha um arquivo SQLite…',
			'gsh.dbConnectionDialog.name' => 'Nome',
			'gsh.dbConnectionDialog.password' => 'Senha',
			'gsh.dbConnectionDialog.savePassword' => 'Salvar senha',
			'gsh.dbConnectionDialog.allowWrites' => 'Permitir escrita (agentes)',
			'gsh.dbConnectionDialog.allowWritesHint' => 'desligado = agentes só leem via CLI',
			'gsh.dbConnectionDialog.visibleToAgents' => 'Visível para agentes',
			'gsh.dbConnectionDialog.visibleToAgentsHint' => 'desligado = oculto da CLI, só na GUI',
			'gsh.dbConnectionDialog.testing' => 'Testando conexão…',
			'gsh.dbConnectionDialog.connectionOk' => 'Conexão OK',
			'gsh.dbConnectionDialog.connectionFailed' => 'Falha na conexão',
			'gsh.dbConnectionDialog.editTitle' => 'Editar conexão',
			'gsh.dbConnectionDialog.newTitle' => 'Nova conexão',
			'gsh.dbConnectionDialog.connectionString' => 'Connection string',
			'gsh.dbConnectionDialog.invalidUrl' => 'URL de conexão inválida.',
			'gsh.dbConnectionDialog.sshTunnel' => 'Túnel SSH',
			'gsh.dbConnectionDialog.sshHost' => 'Host SSH',
			'gsh.dbConnectionDialog.sshPort' => 'Porta SSH',
			'gsh.dbConnectionDialog.sshUser' => 'Usuário SSH',
			'gsh.dbConnectionDialog.privateKey' => 'Chave privada',
			'gsh.dbConnectionDialog.choosePrivateKeyPlaceholder' => 'Escolha uma chave privada…',
			'gsh.dbConnectionDialog.choosePrivateKeyDialogTitle' => 'Escolher chave privada SSH',
			'gsh.dbConnectionDialog.keyPassphrase' => 'Senha da chave',
			'gsh.dbConnectionDialog.savePassphrase' => 'Salvar senha da chave',
			_ => null,
		} ?? switch (path) {
			'gsh.dbConnectionDialog.passwordOnHost' => 'A senha fica salva no host, não nesta máquina.',
			'gsh.sshPrompts.unknownSshHostTitle' => 'Host SSH desconhecido',
			'gsh.sshPrompts.neverConnected' => ({required Object endpoint}) => 'O GSH Desktop nunca se conectou a ${endpoint} antes.',
			'gsh.sshPrompts.trustHint' => 'Confie apenas se esta fingerprint corresponder ao servidor. Você pode verificar no servidor com:',
			'gsh.sshPrompts.trust' => 'Confiar',
			'gsh.sshPrompts.sshKeyPassphraseTitle' => 'Senha da chave SSH',
			'gsh.sshPrompts.unlockMessage' => ({required Object keyPath, required Object connectionName}) => 'Desbloqueie ${keyPath} para conectar "${connectionName}".',
			'gsh.sshPrompts.keptInMemoryHint' => 'Mantida em memória até o GSH Desktop fechar. Para permitir que agentes usem esta conexão, ative "Salvar senha da chave" na conexão.',
			'gsh.sshPrompts.unlock' => 'Desbloquear',
			'gsh.projectsRail.workspaces' => 'Workspaces',
			'gsh.projectsRail.keepAwakeOn' => 'Mantendo este computador acordado para acesso remoto. Clique para deixá-lo dormir de novo.',
			'gsh.projectsRail.keepAwakeOff' => 'Manter este computador acordado para acesso remoto. Desliga sozinho quando o GSH Desktop reinicia.',
			'gsh.projectsRail.keepAwakeBattery' => 'Acordado na bateria. Isso consome a bateria.',
			'gsh.projectsRail.keepAwakeLid' => 'Fechar a tampa do notebook continua colocando-o para dormir.',
			'gsh.projectsRail.newWorkspace' => 'Novo workspace',
			'gsh.projectsRail.settings' => 'Configurações',
			'gsh.projectsRail.mergeToParent' => 'Mesclar no pai',
			'gsh.projectsRail.updateFromParent' => 'Atualizar a partir do pai',
			'gsh.projectsRail.forkWorktree' => 'Criar worktree derivada',
			'gsh.projectsRail.copyBranch' => 'Copiar branch',
			'gsh.projectsRail.remove' => 'Remover',
			'gsh.projectsRail.moveToRealm' => 'Mover para realm',
			'gsh.projectsRail.copyWorkspaceId' => 'Copiar id do workspace',
			'gsh.projectsRail.rename' => 'Renomear',
			'gsh.projectsRail.close' => 'Fechar',
			'gsh.projectsRail.newRealm' => 'Novo realm…',
			'gsh.projectsRail.manageRealms' => 'Gerenciar realms…',
			'gsh.projectsRail.noWorkspaces' => 'Nenhum workspace ainda.',
			'gsh.projectsRail.sync' => 'Sincronizar',
			'gsh.projectsRail.pull' => 'Pull',
			'gsh.projectsRail.push' => 'Push',
			'gsh.projectsRail.createWorktree' => 'Criar worktree',
			'gsh.projectsRail.worktreeCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: '1 worktree', other: '${n} worktrees', ), 
			'gsh.projectsRail.expandWorktrees' => 'Expandir worktrees',
			'gsh.projectsRail.collapseWorktrees' => 'Recolher worktrees',
			'gsh.findBar.find' => 'Buscar',
			'gsh.findBar.matchCase' => 'Diferenciar maiúsculas',
			'gsh.findBar.wholeWord' => 'Palavra inteira',
			'gsh.findBar.useRegex' => 'Usar expressão regular',
			'gsh.findBar.previous' => 'Anterior (⇧⏎)',
			'gsh.findBar.next' => 'Próximo (⏎)',
			'gsh.findBar.close' => 'Fechar (Esc)',
			'gsh.findBar.badPattern' => 'Padrão inválido',
			'gsh.findBar.noResults' => 'Nenhum resultado',
			'gsh.contentSearch.sectionSearch' => 'BUSCA',
			'gsh.contentSearch.searchInFiles' => 'Buscar nos arquivos',
			'gsh.contentSearch.matchCase' => 'Diferenciar maiúsculas',
			'gsh.contentSearch.wholeWord' => 'Palavra inteira',
			'gsh.contentSearch.useRegex' => 'Usar expressão regular',
			'gsh.contentSearch.invalidRegex' => 'Expressão regular inválida.',
			'gsh.contentSearch.typeToSearch' => 'Digite para buscar em todos os arquivos.',
			'gsh.contentSearch.searching' => 'Buscando…',
			'gsh.contentSearch.noResults' => 'Nenhum resultado.',
			'gsh.topbar.collapseSidebar' => 'Recolher barra lateral',
			'gsh.topbar.toggleFiles' => 'Mostrar/ocultar arquivos',
			'gsh.topbar.filesUnavailable' => 'Arquivos indisponíveis no GSH Desktop',
			'gsh.topbar.hideKeyboard' => 'Baixar teclado',
			'gsh.topbar.visualizeAgents' => 'Visualizar agentes',
			'gsh.topbar.openFarm' => 'Fazenda de agentes',
			'gsh.topbar.openChat' => 'Chat com o Claude (beta)',
			'gsh.tasks.hotReload' => 'Hot reload',
			'gsh.tasks.hotRestart' => 'Hot restart',
			'gsh.tasks.toggleDebugPaint' => 'Alternar debug paint',
			'gsh.tasks.togglePlatform' => 'Alternar plataforma',
			'gsh.tasks.quit' => 'Sair',
			'gsh.notifications.agentFinished' => 'Agente terminou',
			'gsh.notifications.open' => 'Abrir',
			'gsh.notifications.agentNeedsAction' => 'Agente precisa de você',
			'gsh.terminalLink.open' => 'Abrir',
			'gsh.terminalLink.revealFinder' => 'Mostrar no Finder',
			'gsh.terminalLink.revealExplorer' => 'Mostrar no Explorer',
			'gsh.terminalLink.revealFolder' => 'Abrir pasta',
			'gsh.terminalLink.copyPath' => 'Copiar caminho',
			'gsh.terminalLink.openLink' => 'Abrir link',
			'gsh.terminalLink.copyLink' => 'Copiar link',
			'gsh.terminal.cwdFallbackWarning' => ({required Object requested, required Object path}) => 'Aviso: a pasta "${requested}" não existe. Este terminal abriu em "${path}".',
			'gsh.terminal.workspaceEnvTracked' => ({required Object keys}) => 'Aviso: o .env.gsh está rastreado pelo git (veio com o repositório). Injetado: ${keys}',
			'gsh.remoteHost.addHost' => 'Adicionar host remoto',
			'gsh.remoteHost.hostName' => 'Nome',
			'gsh.remoteHost.sshTarget' => 'Destino SSH (usuário@host)',
			'gsh.remoteHost.connecting' => ({required Object host}) => 'Conectando a ${host}…',
			'gsh.remoteHost.openingTunnel' => 'Túnel SSH',
			'gsh.remoteHost.installingServer' => 'Instalando servidor',
			'gsh.remoteHost.handshake' => ({required Object version}) => 'Servidor ${version}',
			'gsh.remoteHost.loadingWorkspace' => 'Carregando workspace…',
			'gsh.remoteHost.reconnecting' => ({required Object host}) => 'Reconectando a ${host}…',
			'gsh.remoteHost.offline' => ({required Object host}) => '${host} offline',
			'gsh.remoteHost.remove' => 'Remover',
			'gsh.remoteHost.reconnect' => 'Reconectar',
			'gsh.remoteHost.installServer' => 'Instalar servidor',
			'gsh.remoteHost.errSshUnreachable' => ({required Object host}) => 'Não foi possível alcançar ${host} via SSH. Está ligado e com o Login Remoto ativado?',
			'gsh.remoteHost.errInstallFailed' => ({required Object host}) => 'Não foi possível instalar o servidor em ${host}.',
			'gsh.remoteHost.errVersionMismatch' => 'Versão do servidor incompatível; atualize-o.',
			'gsh.remoteHost.errDetail' => ({required Object detail}) => 'Detalhes: ${detail}',
			'gsh.remoteHost.pickFolderTitle' => ({required Object host}) => 'Abrir pasta em ${host}',
			'gsh.remoteHost.openHere' => 'Abrir aqui',
			'gsh.remoteHost.emptyFolder' => 'Sem subpastas',
			'gsh.remoteHost.newLocal' => 'Local',
			'gsh.remoteHost.newRemote' => 'Remoto',
			'gsh.remoteHost.chooseHost' => 'Escolher um host',
			'gsh.remoteHost.newHostEntry' => 'Novo host…',
			'gsh.remoteHost.editHost' => 'Editar host',
			'gsh.remoteHost.userLabel' => 'Usuário',
			'gsh.remoteHost.hostLabel' => 'Host / IP',
			'gsh.remoteHost.portLabel' => 'Porta',
			'gsh.remoteHost.authLabel' => 'Autenticação',
			'gsh.remoteHost.authKey' => 'Chave SSH',
			'gsh.remoteHost.authPassword' => 'Senha',
			'gsh.remoteHost.passwordLabel' => 'Senha',
			'gsh.remoteHost.passwordKeep' => 'Deixe em branco para manter a atual',
			'gsh.remoteHost.errUser' => 'Usuário obrigatório',
			'gsh.remoteHost.errHost' => 'Host obrigatório',
			'gsh.remoteHost.errPassword' => 'Senha obrigatória',
			'gsh.remoteHost.identityChoose' => 'Escolher…',
			'gsh.remoteHost.identityEmpty' => 'Nenhuma chave selecionada',
			'gsh.remoteHost.identityDialogTitle' => 'Selecione a chave privada SSH',
			'gsh.remoteHost.errIdentity' => 'Escolha a chave privada para autenticar.',
			'gsh.remoteHost.errHostKeyUnknown' => ({required Object host}) => 'O GSH Desktop ainda não confia em ${host}. Conecte de novo e confirme o fingerprint.',
			'gsh.remoteHost.errHostKeyChanged' => ({required Object host}) => '${host} está apresentando uma chave SSH diferente da guardada. Se você não reinstalou essa máquina, pare e verifique — se reinstalou, remova a entrada antiga do ~/.ssh/known_hosts.',
			'gsh.remoteHost.errHostBundleMissing' => ({required Object host}) => '${host} é Windows mas não tem o GSH Desktop instalado. O servidor remoto é instalado a partir do bundle do GSH Desktop que já está naquela máquina — instale o GSH Desktop lá e tente de novo.',
			'gsh.remoteHost.errHostUnknownOs' => ({required Object host}) => 'Não foi possível identificar o sistema de ${host}. A conta pode ter shell restrito, ou nenhum shell.',
			'gsh.remoteHost.errIdentityPublic' => 'Só a chave pública está aqui. Isso só funciona se a privada estiver no seu agente SSH; senão, escolha a privada (mesmo nome, sem .pub).',
			'gsh.remoteHost.errIdentityNotKey' => 'Esse arquivo não parece uma chave privada.',
			'gsh.remoteHost.errIdentityMissingFile' => 'Esse arquivo não existe mais.',
			'gsh.remoteHost.errIdentityUnreadable' => 'Não foi possível ler esse arquivo.',
			'gsh.browserPane.back' => 'Voltar',
			'gsh.browserPane.forward' => 'Avançar',
			'gsh.browserPane.reload' => 'Recarregar',
			'gsh.browserPane.urlHint' => 'Digite a URL ou endereço',
			'gsh.browserPane.go' => 'Ir',
			'gsh.documentWindow.mediaNotSupported' => 'Áudio e vídeo abrem na janela principal do GSH Desktop.',
			'gsh.documentWindow.fileNotFound' => ({required Object path}) => 'Arquivo não encontrado: ${path}',
			'gsh.gallery.intro' => 'Documentos especiais do GSH Desktop para que você tenha o visual do que o agente de IA esteja fazendo.',
			'gsh.gallery.createErrorTitle' => 'Não foi possível criar o arquivo',
			'gsh.gallery.dbQuery.title' => 'Consulta de banco',
			'gsh.gallery.dbQuery.description' => 'Editor SQL com grid de resultado, usando uma das conexões registradas.',
			'gsh.gallery.kanban.title' => 'Quadro kanban',
			'gsh.gallery.kanban.description' => 'Colunas e cards gravados como markdown puro. Arraste, edite e comente.',
			'gsh.gallery.layout.title' => 'Layout de panes',
			'gsh.gallery.layout.description' => 'Terminais e splits para abrir de uma vez, estilo tmuxinator. Pode rodar sozinho em worktrees novas.',
			'gsh.gallery.httpRequest.title' => 'Requests HTTP',
			'gsh.gallery.httpRequest.description' => 'Escreva requests num arquivo e execute com a resposta ao lado.',
			'gsh.gallery.html.title' => 'Visual HTML',
			'gsh.gallery.html.description' => 'Uma página que o agente escreve e o GSH Desktop renderiza direto: mapa mental, diagrama, gráfico, o que precisar.',
			'gsh.gallery.tasks.title' => 'Tarefas',
			'gsh.gallery.tasks.description' => 'Comandos para rodar pelo painel de Tasks, como dev server, testes e build. Fica em .gsh/tasks.json.',
			'gsh.gallery.notebook.title' => 'Caderno',
			'gsh.gallery.notebook.description' => 'Uma pasta de notas curtas com tags. O agente escreve, você lê e edita. Abre no Obsidian também.',
			'gsh.gallery.workspaceEnv.title' => 'Env do workspace',
			'gsh.gallery.workspaceEnv.description' => 'Variáveis injetadas em todo terminal deste workspace. Coloque tokens ou logins de API aqui em vez de colar no prompt do agente. Fica fora do git.',
			'gsh.gallery.panel.title' => 'Painel',
			'gsh.gallery.panel.description' => 'Uma página HTML com ponte para o app: os botões rodam comandos da CLI do GSH Desktop e do shell nesta máquina. Um playground para dashboards rápidos.',
			'gsh.notebook.notes' => 'Notas',
			'gsh.notebook.newNote' => 'Nova nota',
			'gsh.notebook.searchPlaceholder' => 'Buscar notas',
			'gsh.notebook.empty' => 'Nenhuma nota ainda. Crie uma, ou peça pro agente escrever aqui.',
			'gsh.notebook.noMatch' => 'Nenhuma nota bate com o filtro.',
			'gsh.notebook.selectNote' => 'Selecione uma nota',
			'gsh.notebook.reload' => 'Recarregar do disco',
			'gsh.notebook.untagged' => 'sem tag',
			'gsh.notebook.saveFailed' => 'Não foi possível salvar a nota',
			'gsh.notebook.createFailed' => 'Não foi possível criar a nota',
			'gsh.notebook.addTag' => 'adicionar tag',
			'gsh.notebook.untitled' => 'Sem título',
			'gsh.notebook.deleteNote' => 'Apagar nota',
			'gsh.notebook.deleteConfirm' => ({required Object name}) => 'Mover “${name}” pra lixeira?',
			'gsh.notebook.imageFailed' => 'Não foi possível salvar a imagem',
			'gsh.notebook.format.bold' => 'Negrito (⌘B)',
			'gsh.notebook.format.italic' => 'Itálico (⌘I)',
			'gsh.notebook.format.strike' => 'Riscado',
			'gsh.notebook.format.heading1' => 'Título 1',
			'gsh.notebook.format.heading2' => 'Título 2',
			'gsh.notebook.format.heading3' => 'Título 3',
			'gsh.notebook.format.bullets' => 'Lista',
			'gsh.notebook.format.numbered' => 'Lista numerada',
			'gsh.notebook.format.checklist' => 'Checklist',
			'gsh.notebook.format.quote' => 'Citação',
			'gsh.notebook.format.code' => 'Código inline (⌘E)',
			'gsh.notebook.format.codeBlock' => 'Bloco de código',
			'gsh.notebook.format.link' => 'Link (⌘K)',
			'gsh.notebook.format.rule' => 'Divisor',
			'gsh.notebook.format.noteLink' => 'Link pra uma nota ([[…]])',
			'gsh.notebook.format.noteLinkSearch' => 'Buscar notas',
			'gsh.notebook.format.image' => 'Inserir imagem…',
			'gsh.notebook.backlinks' => 'Citada em',
			'gsh.notebook.renameTag' => 'Renomear tag',
			'gsh.notebook.deleteTag' => 'Apagar tag',
			'gsh.notebook.deleteTagConfirm' => ({required Object name, required Object count}) => 'Remover “${name}” de ${count} notas? As notas ficam.',
			'gsh.notebook.showList' => 'Mostrar lista de notas',
			'gsh.notebook.hideList' => 'Ocultar lista de notas',
			'gsh.layoutPreview.applyFailedTitle' => 'Não foi possível aplicar o layout',
			'gsh.layoutPreview.applyInGsh' => 'Aplicar no GSH Desktop',
			'gsh.layoutPreview.applyNewWorkspace' => 'Abrir como novo workspace',
			'gsh.layoutPreview.applyTo' => ({required Object workspace}) => 'Aplicar em ${workspace}',
			'gsh.layoutPreview.autorunWorktree' => 'autorun: worktree. Este layout também é aplicado sozinho quando você cria uma worktree do workspace onde ele está.',
			'gsh.layoutPreview.command' => 'Comando',
			'gsh.layoutPreview.folder' => 'Pasta',
			'gsh.layoutPreview.noCommand' => 'sem comando, abre um shell',
			'gsh.layoutPreview.replaceConfirm' => 'Substituir layout',
			'gsh.layoutPreview.replaceMessage' => ({required Object n}) => '${n} abas abertas deste workspace serão fechadas, inclusive as com trabalho em andamento.',
			'gsh.layoutPreview.replaceTitle' => ({required Object workspace}) => 'Substituir o layout de ${workspace}?',
			'gsh.layoutPreview.skippedTitle' => 'Não criados neste sistema',
			'gsh.layoutPreview.splitDown' => 'divide abaixo',
			'gsh.layoutPreview.splitRight' => 'divide à direita',
			'gsh.layoutPreview.splitTab' => 'aba',
			'gsh.layoutPreview.subtitle' => ({required Object n}) => 'Este layout abre ${n} terminais. Leia os comandos antes de aplicar.',
			'gsh.telemetry.tooltip' => 'Telemetria',
			'gsh.telemetry.title' => 'Telemetria',
			'gsh.telemetry.liveRuns' => ({required Object n}) => '${n} ativos',
			'gsh.telemetry.noWorkspace' => 'Abra um workspace para ver a telemetria dele.',
			'gsh.telemetry.empty' => 'Nada aqui ainda.',
			'gsh.telemetry.emptyFiltered' => 'Nada aqui ainda.',
			'gsh.telemetry.searchHint' => 'Filtrar casos',
			'gsh.telemetry.chipOpen' => 'Abertos',
			'gsh.telemetry.chipNew' => 'Novos',
			'gsh.telemetry.chipResolved' => 'Resolvidos',
			'gsh.telemetry.chipIgnored' => 'Ignorados',
			'gsh.telemetry.chipWarnings' => 'Avisos',
			'gsh.telemetry.tagNew' => 'novo',
			'gsh.telemetry.tagRegression' => 'regressão',
			'gsh.telemetry.tagResolved' => 'resolvido',
			'gsh.telemetry.tagIgnored' => 'ignorado',
			'gsh.telemetry.srcTask' => 'task',
			'gsh.telemetry.srcWrapper' => 'gsh telemetry',
			'gsh.telemetry.run' => ({required Object id}) => 'run ${id}',
			'gsh.telemetry.resolve' => 'Marcar resolvido',
			'gsh.telemetry.ignore' => 'Ignorar (some para os agentes também)',
			'gsh.telemetry.reopen' => 'Reabrir',
			'gsh.telemetry.clear' => 'Limpar ocorrências',
			'gsh.telemetry.clearRun' => 'Limpar este run',
			'gsh.telemetry.clearProject' => 'Limpar projeto',
			'gsh.telemetry.openFile' => ({required Object location}) => 'Abrir ${location}',
			'gsh.telemetry.showInTerminal' => 'Ver no terminal',
			'gsh.telemetry.copyCommand' => 'Copiar comando da CLI',
			'gsh.telemetry.copied' => 'Copiado',
			'gsh.telemetry.statusOpen' => 'Aberto',
			'gsh.telemetry.statusResolved' => 'Resolvido',
			'gsh.telemetry.statusIgnored' => 'Ignorado',
			'gsh.telemetry.occurrences' => 'Ocorrências',
			'gsh.telemetry.inRuns' => ({required Object n}) => 'em ${n} runs',
			'gsh.telemetry.first' => 'Primeira',
			'gsh.telemetry.last' => 'Última',
			'gsh.telemetry.origin' => 'Origem',
			'gsh.telemetry.sectionStack' => 'Stack',
			'gsh.telemetry.stackHint' => 'frames do projeto em destaque · clique abre o arquivo',
			'gsh.telemetry.sectionCorrelated' => 'Log correlacionado',
			'gsh.telemetry.correlatedHint' => 'o JSON mais próximo antes do erro, no mesmo run',
			'gsh.telemetry.none' => 'nenhum',
			'gsh.telemetry.sectionRuns' => 'Ocorrências por run',
			'gsh.telemetry.runsHint' => 'mesma chave (cwd, comando): é assim que novo e regressão são calculados',
			'gsh.telemetry.sectionContext' => 'Contexto cru',
			'gsh.telemetry.contextHint' => 'linhas do terminal ao redor da última ocorrência',
			'gsh.telemetry.current' => 'atual',
			'gsh.telemetry.fingerprintHint' => ({required Object location}) => 'fingerprint = tipo + mensagem normalizada + ${location}',
			'gsh.telemetry.blameUncommitted' => 'alterado no working tree',
			'gsh.telemetry.blameCommit' => ({required Object ago, required Object sha}) => 'alterado ${ago} (${sha})',
			'gsh.telemetry.justNow' => 'agora',
			'gsh.telemetry.minutesAgo' => ({required Object n}) => 'há ${n} min',
			'gsh.telemetry.hoursAgo' => ({required Object n}) => 'há ${n} h',
			'gsh.telemetry.daysAgo' => ({required Object n}) => 'há ${n} d',
			'gsh.telemetry.resolvedToast' => 'Resolvido. Se voltar num run futuro, reaparece como regressão.',
			'gsh.telemetry.ignoredToast' => 'Ignorado. Os agentes não veem mais (salvo --include-ignored).',
			'gsh.telemetry.clearedToast' => 'Ocorrências apagadas. As regras de triagem ficam.',
			'gsh.telemetry.byHuman' => 'por você',
			'gsh.telemetry.byAgent' => 'pelo agente',
			'gsh.telemetry.caseTabTitle' => ({required Object type, required Object file}) => '${type} · ${file}',
			'gsh.telemetry.srcApp' => 'App',
			'gsh.telemetry.chipApp' => 'GSH Desktop',
			'gsh.panelView.unavailable' => 'Painéis precisam da web view embutida, que ainda não existe no Linux.',
			'gsh.panelView.openInBrowser' => 'Abrir no navegador',
			'gsh.panelView.openAsHtml' => 'Abrir como HTML',
			'gsh.chat.tabTitle' => 'Chat',
			'gsh.chat.emptyTitle' => 'Nova conversa',
			'gsh.chat.emptySubtitle' => ({required Object folder}) => 'Claude Code em ${folder}, com o seu login.',
			'gsh.chat.emptyHintSend' => 'Enter envia; Shift+Enter quebra linha.',
			'gsh.chat.emptyHintPaste' => 'Cole um print com Ctrl+V ou solte arquivos no chat.',
			'gsh.chat.emptyHintMode' => 'Escolha o modo de permissão embaixo do campo: pedir, aceitar edições, planejar ou ignorar.',
			'gsh.chat.placeholder' => 'Mensagem para o Claude… (Enter envia, Shift+Enter quebra linha)',
			'gsh.chat.send' => 'Enviar',
			'gsh.chat.stop' => 'Parar',
			'gsh.chat.working' => 'trabalhando…',
			'gsh.chat.waitingYou' => 'esperando você',
			'gsh.chat.cost' => ({required Object v}) => 'custo US\$ ${v}',
			'gsh.chat.askPermission' => ({required Object tool}) => 'Permitir ${tool}?',
			'gsh.chat.allow' => 'Permitir',
			'gsh.chat.deny' => 'Negar',
			'gsh.chat.allowed' => 'Permitido',
			'gsh.chat.denied' => 'Negado',
			'gsh.chat.startFailed' => ({required Object detail}) => 'Não consegui iniciar o claude: ${detail}',
			'gsh.chat.engineExited' => ({required Object code}) => 'O claude encerrou (código ${code}).',
			'gsh.chat.turnFailed' => ({required Object detail}) => 'O turno terminou com erro: ${detail}',
			'gsh.chat.handedOff' => 'A conversa continua num terminal com Remote Control: abra no celular ou em claude.ai/code. O chat aqui fica pausado.',
			'gsh.chat.peerMessageFrom' => ({required Object name}) => 'Mensagem de ${name}',
			'gsh.chat.sessions' => 'Sessões',
			'gsh.chat.noSessions' => 'Nenhuma outra sessão do Claude Code rodando agora.',
			'gsh.chat.sendToSession' => ({required Object name}) => 'Mande esta mensagem para a sessão "${name}" com SendMessage e espere a resposta: ',
			'gsh.chat.remoteControl' => 'Remote Control',
			'gsh.chat.remoteControlHint' => 'Continuar esta conversa num terminal com Remote Control (celular, claude.ai/code). O motor do chat não suporta Remote Control.',
			'gsh.chat.attachmentTooLarge' => ({required Object name}) => '${name} é grande demais para enviar (imagem até 5 MB, PDF até 32 MB).',
			'gsh.chat.loadingHistory' => 'Carregando a conversa…',
			'gsh.chat.allowAlways' => ({required Object rule}) => 'Sempre permitir ${rule}',
			'gsh.chat.allowedAlways' => ({required Object rule}) => 'Sempre permitido: ${rule}',
			'gsh.chat.moreLines' => ({required Object n}) => '… mais ${n} linhas',
			'gsh.chat.questionTitle' => 'O agente está perguntando',
			'gsh.chat.other' => 'Outro…',
			'gsh.chat.answer' => 'Responder',
			'gsh.chat.planTitle' => 'Plano do agente',
			'gsh.chat.planApprove' => 'Aprovar e executar',
			'gsh.chat.planRefine' => 'Continuar planejando',
			'gsh.chat.planRefineHint' => 'O que mudar no plano?',
			'gsh.chat.planSendRefine' => 'Enviar ajuste',
			'gsh.chat.planApproved' => 'Plano aprovado',
			'gsh.chat.planRefined' => 'Pediu para continuar planejando',
			'gsh.chat.planRefinedWith' => ({required Object text}) => 'Ajuste: ${text}',
			'gsh.chat.newChat' => 'Nova conversa',
			'gsh.chat.attach' => 'Anexar arquivos',
			'gsh.chat.modeDefault' => 'Pedir permissão',
			'gsh.chat.modeAcceptEdits' => 'Aceitar edições',
			'gsh.chat.modePlan' => 'Planejar',
			'gsh.chat.modeBypass' => 'Ignorar permissões',
			'gsh.chat.editedFiles' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('pt'))(n, one: 'Editou 1 arquivo', other: 'Editou ${n} arquivos', ), 
			'gsh.chat.thinkingTitle' => 'Raciocínio',
			'gsh.chat.thinkingLive' => 'Pensando…',
			'gsh.chat.stateCompleted' => 'Concluída',
			'gsh.chat.stateReviewReady' => 'Pronta para revisão',
			'gsh.chat.stateBlocked' => 'Bloqueada',
			'gsh.chat.stateFailed' => 'Falhou',
			'gsh.farm.tabTitle' => 'Fazenda',
			'gsh.farm.title' => 'Fazenda de agentes',
			'gsh.farm.emptyTitle' => 'Nenhum agente rodando',
			'gsh.farm.emptyHint' => 'Todo loop do Claude Code nesta máquina aparece aqui enquanto trabalha, inclusive subagentes e sessões fora do GSH Desktop.',
			'gsh.farm.working' => ({required Object n}) => '${n} trabalhando',
			'gsh.farm.waiting' => ({required Object n}) => '${n} precisam de você',
			'gsh.farm.idle' => ({required Object n}) => '${n} parados',
			'gsh.farm.tokens' => ({required Object n}) => '${n} tokens gerados',
			'gsh.farm.tokensDetail' => ({required Object out, required Object ctx}) => '${out} tokens gerados · contexto ${ctx}',
			'gsh.farm.clickToOpen' => 'Clique para abrir o terminal',
			'gsh.farm.outsideGsh' => 'Este agente está rodando fora do GSH Desktop. O terminal dele está em outra janela.',
			'gsh.farm.agents' => ({required Object n}) => '${n} agentes',
			'gsh.farm.subagents' => ({required Object n}) => '${n} subagentes',
			'gsh.farm.activity.thinking' => 'pensando',
			'gsh.farm.activity.reading' => 'lendo',
			'gsh.farm.activity.editing' => 'editando',
			'gsh.farm.activity.running' => 'rodando comando',
			'gsh.farm.activity.searching' => 'pesquisando na web',
			'gsh.farm.activity.delegating' => 'delegando',
			'gsh.farm.activity.tooling' => 'usando ferramenta',
			'gsh.farm.activity.waiting' => 'esperando você',
			'gsh.farm.activity.idle' => 'ocioso',
			'gsh.farm.activity.sleeping' => 'dormindo',
			'gsh.farm.activity.done' => 'concluído',
			'gsh.agentGraph.tabTitle' => 'Agentes',
			'gsh.agentGraph.newAgent' => 'Novo agente',
			'gsh.agentGraph.emptyTitle' => 'Nenhum agente neste workspace',
			'gsh.agentGraph.emptyHint' => 'Inicie um agente num terminal ou crie um aqui. Arraste da porta de um agente até outro para conectá-los.',
			'gsh.agentGraph.statusWorking' => 'Trabalhando',
			'gsh.agentGraph.statusWaiting' => 'Aguardando',
			'gsh.agentGraph.statusIdle' => 'Ocioso',
			'gsh.agentGraph.messageCount' => ({required Object n}) => 'Mensagens: ${n}',
			'gsh.agentGraph.lastMessage' => ({required Object preview}) => 'Última: ${preview}',
			'gsh.agentGraph.linked' => 'Conectado',
			'gsh.agentGraph.removeLinkHint' => 'Clique direito para remover a conexão',
			'gsh.agentGraph.removeLink' => 'Remover conexão',
			'gsh.agentGraph.connectHint' => 'Arraste até outro agente para conectar',
			'gsh.agentGraph.quickStart' => 'Início rápido',
			'gsh.agentGraph.shell' => 'Shell',
			'gsh.agentGraph.tabDetails' => 'Detalhes',
			'gsh.agentGraph.tabAppearance' => 'Aparência',
			'gsh.agentGraph.tabAgent' => 'Agente',
			'gsh.agentGraph.name' => 'Nome do terminal',
			'gsh.agentGraph.namePlaceholder' => 'ex.: Revisor',
			'gsh.agentGraph.nameTaken' => 'Outra aba já usa este nome. Os nomes precisam ser únicos para o `gsh msg --to` achar a aba.',
			'gsh.agentGraph.command' => 'Comando',
			'gsh.agentGraph.commandPlaceholder' => 'ex.: claude --model opus (vazio = shell)',
			'gsh.agentGraph.cwd' => 'Diretório de trabalho',
			'gsh.agentGraph.browse' => 'Procurar…',
			'gsh.agentGraph.cwdMissing' => 'Esta pasta não existe.',
			'gsh.agentGraph.monitor' => 'Monitorar atividade',
			'gsh.agentGraph.monitorHint' => 'Badge, som e notificação quando um turno termina.',
			'gsh.agentGraph.maestro' => 'Maestro',
			'gsh.agentGraph.maestroTooltip' => 'Promove este agente a maestro: ele fica conectado a todos os agentes do canvas e os coordena.',
			'gsh.agentGraph.maestroReplaces' => ({required Object name}) => '${name} é o maestro atual e deixará de ser.',
			'gsh.agentGraph.color' => 'Cor',
			'gsh.agentGraph.colorAuto' => 'Automática',
			'gsh.agentGraph.role' => 'Papel / instruções',
			'gsh.agentGraph.rolePlaceholder' => 'Enviado como primeira mensagem assim que o agente estiver pronto.',
			'gsh.agentGraph.task' => 'Tarefa inicial',
			'gsh.agentGraph.taskPlaceholder' => 'Enviada logo depois do papel.',
			'gsh.agentGraph.focus' => 'Focar',
			'gsh.agentGraph.rename' => 'Renomear',
			'gsh.agentGraph.renameTitle' => 'Renomear agente',
			'gsh.agentGraph.makeMaestro' => 'Tornar maestro',
			'gsh.agentGraph.removeMaestro' => 'Remover maestro',
			'gsh.agentGraph.closeTab' => 'Fechar aba',
			'gsh.agentGraph.removeFromCanvas' => 'Remover do canvas',
			'gsh.agentGraph.desktopApps' => 'Apps desktop',
			'gsh.agentGraph.desktopBadge' => 'desktop',
			'gsh.agentGraph.statusOnline' => 'Online',
			'gsh.agentGraph.statusOffline' => 'Offline',
			'gsh.agentGraph.queued' => ({required Object n}) => '${n} na fila',
			'gsh.agentGraph.agentName' => 'Nome',
			'gsh.agentGraph.integration' => 'Integração',
			'gsh.agentGraph.integrationHint' => 'O GSH Desktop adiciona um servidor MCP chamado "gsh" a este arquivo e salva um backup ao lado. Os outros servidores não são tocados.',
			'gsh.agentGraph.integrationConsent' => ({required Object app}) => 'Adicionar o servidor MCP do GSH Desktop ao config do ${app}',
			'gsh.agentGraph.restartHint' => ({required Object app}) => 'Reinicie o ${app} se ele já estava aberto, para carregar o servidor MCP do GSH Desktop; depois peça a ele para chamar wait_messages.',
			'gsh.agentGraph.integrationError.invalidConfig' => ({required Object path}) => '${path} não é um JSON/TOML simples que o GSH Desktop consiga editar com segurança (comentários ou outro formato). Nada foi alterado.',
			'gsh.agentGraph.integrationError.cliMissing' => ({required Object path}) => 'A CLI do GSH Desktop ainda não foi instalada (${path}). Reinicie o GSH Desktop e tente de novo.',
			'gsh.agentGraph.integrationError.writeFailed' => ({required Object detail}) => 'Não foi possível atualizar o config: ${detail}',
			'settings.language.title' => 'Idioma',
			'settings.language.system' => 'Sistema',
			'settings.language.english' => 'Inglês',
			'settings.language.portugueseBr' => 'Português (BR)',
			'settings.language.spanish' => 'Espanhol',
			'settings.page.header.back' => 'Voltar',
			'settings.page.header.title' => 'Configurações',
			'settings.page.nav.sideGsh' => 'GSH Desktop',
			'settings.page.nav.sideClaude' => 'Claude',
			'settings.page.nav.general' => 'Geral',
			'settings.page.nav.appearance' => 'Aparência',
			'settings.page.nav.terminal' => 'Terminal',
			'settings.page.nav.language' => 'Linguagem',
			'settings.page.nav.shortcuts' => 'Atalhos',
			'settings.page.nav.notifications' => 'Notificações',
			'settings.page.nav.automations' => 'Automações',
			'settings.page.nav.remoteHosts' => 'Hosts remotos',
			'settings.page.nav.claudeCode' => 'Claude Code',
			'settings.page.nav.search' => 'Procurar',
			'settings.page.nav.account' => 'Conta',
			'settings.page.nav.privacy' => 'Privacidade',
			'settings.page.nav.usage' => 'Uso',
			'settings.page.nav.resources' => 'Recursos',
			'settings.page.nav.memory' => 'Memória',
			'settings.page.nav.designSystems' => 'Design systems',
			'settings.page.nav.cowork' => 'Cowork',
			'settings.page.nav.system' => 'Sistema',
			'settings.page.nav.extensions' => 'Extensões',
			'settings.page.nav.developer' => 'Desenvolvedor',
			'settings.page.nav.skills' => 'Skills',
			'settings.page.nav.connectors' => 'Conectores',
			'settings.page.nav.plugins' => 'Plugins',
			'settings.page.nav.apiKeys' => 'Chaves de API',
			'settings.page.nav.groups.settings' => 'Configurações',
			'settings.page.nav.groups.thisComputer' => 'Este computador',
			'settings.page.nav.groups.personalization' => 'Personalização',
			'settings.page.nav.groups.platform' => 'Plataforma',
			'settings.page.nav.groups.app' => 'GSH Desktop',
			'settings.page.general.sectionEditor' => 'Editor',
			'settings.page.general.editorEngineTitle' => 'Motor',
			'settings.page.general.editorEngineGsh' => 'GSH Desktop (padrão)',
			'settings.page.general.editorEngineNeovim' => 'Neovim',
			'settings.page.general.neovimChecking' => 'Procurando o Neovim…',
			'settings.page.general.neovimNotFound' => 'O Neovim não foi encontrado na PATH do seu shell.',
			'settings.page.general.neovimRefresh' => 'Verificar novamente',
			'settings.page.general.showGshTitle' => 'Mostrar terminal do GSH Desktop',
			'settings.page.general.showGshDesc' => 'Mantém um workspace sem pasta, só de terminal, fixado no topo da barra lateral. Desligar fecha seus terminais.',
			'settings.page.general.launchAtStartupTitle' => 'Iniciar ao ligar',
			'settings.page.general.launchAtStartupDesc' => 'Inicia o GSH Desktop automaticamente quando você faz login no computador.',
			'settings.page.general.sectionUpdates' => 'Atualizações',
			'settings.page.general.checkUpdatesTitle' => 'Verificar atualizações',
			'settings.page.general.checkUpdatesDesc' => 'Com que frequência o GSH Desktop deve procurar novas versões.',
			'settings.page.general.updateFrequency.daily' => 'Diariamente',
			'settings.page.general.updateFrequency.weekly' => 'Semanalmente',
			'settings.page.general.updateFrequency.monthly' => 'Mensalmente',
			'settings.page.general.updateFrequency.never' => 'Nunca',
			'settings.page.general.developerModeTitle' => 'Modo desenvolvedor',
			'settings.page.general.developerModeDesc' => 'Registra os erros e avisos do próprio GSH Desktop numa base separada da Telemetria (chip “GSH Desktop”) e liga as métricas de performance. Só serve a quem mantém o app.',
			'settings.page.diagnostics.sectionTitle' => 'Diagnóstico',
			'settings.page.diagnostics.logFileTitle' => 'Arquivo de log',
			'settings.page.diagnostics.logFileDesc' => ({required Object days, required Object path}) => 'Erros e eventos de inicialização são registrados aqui, mantidos por ${days} dias.\n${path}',
			'settings.page.diagnostics.unavailable' => 'indisponível',
			'settings.page.diagnostics.reveal' => 'Revelar',
			'settings.page.diagnostics.reportTitle' => 'Reportar um problema',
			'settings.page.diagnostics.reportDesc' => 'Abre uma issue pré-preenchida com sua versão, SO e log recente. Nada é enviado automaticamente — você revisa antes.',
			'settings.page.diagnostics.reportButton' => 'Reportar…',
			'settings.page.diagnostics.reportDialogTitle' => 'Relatório de problema',
			'settings.page.diagnostics.reportDialogError' => 'Reportado manualmente pelas Configurações.',
			'settings.page.diagnostics.reportDialogDescription' => 'Descreva o que deu errado na issue. O log recente está incluído abaixo e em "Copiar detalhes".',
			'settings.page.storage.sectionTitle' => 'Armazenamento',
			'settings.page.storage.locationTitle' => 'Local de armazenamento',
			'settings.page.storage.locationDesc' => ({required Object root}) => 'O GSH Desktop guarda seus projetos, layouts e configurações aqui. Aponte para uma pasta sincronizada para fazer backup.\n${root}',
			'settings.page.storage.useDefault' => 'Usar padrão',
			'settings.page.storage.working' => 'Trabalhando…',
			'settings.page.storage.change' => 'Alterar…',
			'settings.page.storage.resetTitle' => 'Redefinir o GSH Desktop',
			'settings.page.storage.resetDesc' => 'Exclui todos os dados locais — projetos, layouts, configurações e histórico do terminal — e volta ao local padrão.',
			'settings.page.storage.resetButton' => 'Redefinir…',
			'settings.page.storage.resetConfirm' => 'Redefinir',
			'settings.page.storage.resetDialogTitle' => 'Redefinir o GSH Desktop?',
			'settings.page.storage.resetDialogContent' => 'Isso exclui permanentemente todos os dados locais do GSH Desktop — projetos, layouts, configurações e histórico do terminal. Isso não pode ser desfeito. O GSH Desktop será fechado para você começar do zero.',
			'settings.page.storage.restartRequiredTitle' => 'Reinicialização necessária',
			'settings.page.storage.restartChangeFolderMessage' => ({required Object path}) => 'O GSH Desktop usará esta pasta a partir da próxima abertura:\n${path}',
			'settings.page.storage.restartUseDefaultMessage' => 'O GSH Desktop usará o local padrão do sistema a partir da próxima abertura. Seus dados na pasta personalizada permanecem intactos.',
			'settings.page.storage.restartResetMessage' => 'Todos os dados do GSH Desktop foram apagados. Reinicie para começar do zero.',
			'settings.page.storage.later' => 'Mais tarde',
			'settings.page.storage.quitGsh' => 'Sair do GSH Desktop',
			'settings.page.storage.chooseFolderDialogTitle' => 'Escolha uma pasta para os dados do GSH Desktop',
			'settings.page.terminal.sectionDefaultTerminal' => 'Terminal padrão',
			'settings.page.terminal.engineTitle' => 'Motor',
			'settings.page.terminal.engineDesc' => 'Usado por novas abas de terminal e buffers de saída de tasks. Abas abertas mantêm o motor atual.',
			'settings.page.terminal.shellTitle' => 'Shell',
			'settings.page.terminal.shellDesc' => 'Qual shell novas abas de terminal abrem. A seta ao lado do + ainda abre qualquer outro, só para aquela aba.',
			'settings.page.terminal.noWslMessage' => 'Nenhuma distro WSL encontrada. Instale uma (wsl.exe --install) e reinicie o GSH Desktop para vê-la listada aqui.',
			'settings.page.terminal.sectionBehavior' => 'Comportamento',
			'settings.page.terminal.closeOnExitTitle' => 'Fechar a aba quando o shell encerrar',
			'settings.page.terminal.closeOnExitDesc' => 'Quando um shell termina sozinho (exit, Ctrl-D), fecha a aba em vez de deixar um terminal morto.',
			'settings.page.appearance.sectionTheme' => 'Tema',
			'settings.page.appearance.themeTitle' => 'Tema',
			'settings.page.appearance.themeDesc' => 'Cores do app, realce de código e paleta do terminal.',
			'settings.page.appearance.modeTitle' => 'Modo',
			'settings.page.appearance.modeDesc' => 'Qual variante do tema usar.',
			'settings.page.appearance.modeOnlyDark' => ({required Object theme}) => '"${theme}" só traz a variante escura, então isto não tem efeito.',
			'settings.page.appearance.modeOnlyLight' => ({required Object theme}) => '"${theme}" só traz a variante clara, então isto não tem efeito.',
			_ => null,
		} ?? switch (path) {
			'settings.page.appearance.themeFileTitle' => 'Arquivo de tema',
			'settings.page.appearance.themeFileDesc' => 'Importe um tema de um arquivo JSON, ou exporte o tema ativo.',
			'settings.page.appearance.previewCode' => 'Código',
			'settings.page.appearance.previewTerminal' => 'Terminal',
			'settings.page.appearance.themeSystem' => 'Sistema',
			'settings.page.appearance.themeLight' => 'Claro',
			'settings.page.appearance.themeDark' => 'Escuro',
			'settings.page.appearance.sectionFonts' => 'Fontes',
			'settings.page.appearance.interfaceFontTitle' => 'Fonte da interface',
			'settings.page.appearance.interfaceFontDesc' => 'Usada em todo o aplicativo. Vazio = padrão do sistema.',
			'settings.page.appearance.interfaceSizeTitle' => 'Tamanho da interface',
			'settings.page.appearance.codeFontTitle' => 'Fonte do código',
			'settings.page.appearance.codeFontDesc' => 'Código e diffs. Vazio = padrão do sistema.',
			'settings.page.appearance.codeSizeTitle' => 'Tamanho do código',
			'settings.page.appearance.terminalFontTitle' => 'Fonte do terminal',
			'settings.page.appearance.terminalFontDesc' => 'Só o terminal. Vazio = padrão do sistema.',
			'settings.page.appearance.terminalSizeTitle' => 'Tamanho do terminal',
			'settings.page.appearance.terminalSizeDesc' => 'Desligado = segue o tamanho do código.',
			'settings.page.appearance.terminalSizeInherit' => 'Seguir o código',
			'settings.page.appearance.terminalWeightTitle' => 'Peso do terminal',
			'settings.page.appearance.terminalWeightDesc' => 'Telas de baixa densidade engrossam os traços. O automático afina só nelas e não mexe no Retina.',
			'settings.page.appearance.terminalWeightAuto' => 'Automático (pela tela)',
			'settings.page.appearance.terminalWeightLight' => 'Fino',
			'settings.page.appearance.terminalWeightNormal' => 'Normal',
			'settings.page.appearance.terminalWeightMedium' => 'Médio',
			'settings.page.appearance.terminalWeightSemiBold' => 'Seminegrito',
			'settings.page.appearance.sectionConversation' => 'Conversa',
			'settings.page.appearance.pinUserMessageTitle' => 'Fixar mensagem do usuário',
			'settings.page.appearance.pinUserMessageDesc' => 'A pergunta fica fixa no topo enquanto a resposta rola.',
			'settings.page.appearance.importTheme' => 'Importar…',
			'settings.page.appearance.exportTheme' => 'Exportar…',
			'settings.page.appearance.deleteTheme' => 'Remover',
			'settings.page.appearance.importThemeDialog' => 'Escolha um arquivo de tema',
			'settings.page.appearance.exportThemeDialog' => 'Salvar tema como',
			'settings.page.appearance.themeImported' => ({required Object name}) => 'Tema "${name}" importado.',
			'settings.page.appearance.themeExported' => 'Tema salvo.',
			'settings.page.appearance.themeDeleted' => 'Tema removido.',
			'settings.page.appearance.fontPickerTitle' => 'Escolher uma fonte',
			'settings.page.appearance.fontPickerSearch' => 'Buscar fontes',
			'settings.page.appearance.fontPickerEmpty' => 'Nenhuma fonte correspondente nesta máquina.',
			'settings.page.appearance.fontPickerBundled' => 'inclusa',
			'settings.page.appearance.fontPickerCustom' => 'Não está na lista? Digite o nome exato da família.',
			'settings.page.appearance.fontPickerCustomHint' => 'Nome da família',
			'settings.page.appearance.fontPickerUse' => 'Usar',
			'settings.page.appearance.fontPickerDefault' => 'Padrão',
			'settings.page.appearance.fontMissing' => 'Não encontrada nesta máquina — usando o fallback.',
			'settings.page.appearance.sectionLayout' => 'Layout',
			'settings.page.appearance.swapPanelsTitle' => 'Inverter panes',
			'settings.page.appearance.swapPanelsDesc' => 'Coloca os workspaces à direita e arquivos, busca, git e banco à esquerda.',
			'settings.page.notifications.sectionTitle' => 'Notificações',
			'settings.page.notifications.enableTitle' => 'Ativar notificações',
			'settings.page.notifications.enableDesc' => 'Avisar quando um agente terminar uma resposta e a janela não estiver em foco.',
			'settings.page.notifications.systemPermissionTitle' => 'Permissão do sistema',
			'settings.page.notifications.grantedDesc' => 'O GSH Desktop tem permissão para enviar notificações.',
			'settings.page.notifications.notGrantedDesc' => 'O macOS ainda não concedeu acesso a notificações.',
			'settings.page.notifications.granted' => 'Concedido',
			'settings.page.notifications.requestPermission' => 'Solicitar permissão',
			'settings.page.notifications.soundsTitle' => 'Sons',
			'settings.page.notifications.soundVolumeTitle' => 'Volume',
			'settings.page.notifications.soundTurnDone' => 'Turno concluído',
			'settings.page.notifications.soundTurnDoneDesc' => 'Um agente terminou o turno.',
			'settings.page.notifications.soundActionRequired' => 'Ação necessária',
			'settings.page.notifications.soundActionRequiredDesc' => 'Um agente está esperando sua aprovação ou resposta.',
			'settings.page.notifications.soundDefault' => 'Padrão',
			'settings.page.notifications.soundCustom' => ({required Object name}) => 'Personalizado: ${name}',
			'settings.page.notifications.soundChooseFile' => 'Escolher arquivo',
			'settings.page.notifications.soundReset' => 'Voltar ao padrão',
			'settings.page.notifications.soundOnActiveTab' => 'Tocar também com a aba ativa',
			'settings.page.notifications.soundPreview' => 'Ouvir',
			'settings.page.shortcuts.notCustomizable' => 'Os atalhos de teclado ainda não são personalizáveis.',
			'settings.page.languages.sectionFormatting' => 'FORMATAÇÃO',
			'settings.page.languages.formatOnSaveTitle' => 'Formatar ao salvar',
			'settings.page.languages.formatOnSaveDesc' => 'Formata o arquivo automaticamente ao salvar (⌘S).',
			'settings.page.languages.sectionLanguageServers' => 'SERVIDORES DE LINGUAGEM',
			'settings.page.languages.footerNote' => 'Erros e formatação usam o language server de cada linguagem. O GSH Desktop não instala servidores — ele usa o que já está na sua máquina. ● responde · ○ não encontrado ou comando inválido (instale o servidor ou ajuste o comando).',
			'settings.page.languages.serverCommandLabel' => 'Comando do language server',
			'settings.page.languages.formatterCommandLabel' => 'Comando do formatador (opcional)',
			'settings.page.languages.formatterHint' => 'Formatador externo com o placeholder %FILE%. Tem prioridade sobre o formatador do LSP quando definido.',
			'settings.page.languages.resetToDefault' => 'Redefinir para o padrão',
			'settings.page.languages.saveAndRestart' => 'Salvar e reiniciar',
			'settings.page.languages.statusResponds' => 'Servidor responde',
			'settings.page.languages.statusNotFound' => 'Servidor não encontrado ou comando inválido',
			'settings.page.automations.sectionCommitMessages' => 'Mensagens de commit',
			'settings.page.automations.harness' => 'Harness',
			'settings.page.automations.harnessDiscovering' => 'Procurando harnesses de linha de comando instalados…',
			'settings.page.automations.harnessNoneFound' => 'Nenhum harness compatível foi encontrado no PATH.',
			'settings.page.automations.harnessConfiguredUnavailable' => ({required Object harness}) => '${harness} está configurado, mas indisponível.',
			'settings.page.automations.harnessChoose' => 'Escolha a CLI usada para gerar mensagens de commit.',
			'settings.page.automations.harnessRefresh' => 'Atualizar harnesses instalados',
			'settings.page.automations.notConfigured' => 'Não configurado',
			'settings.page.automations.model' => 'Modelo',
			'settings.page.automations.modelUnavailable' => 'A lista de modelos fica indisponível até o harness ser encontrado.',
			'settings.page.automations.modelCliOnly' => 'Este harness usa o modelo padrão da própria CLI.',
			'settings.page.automations.modelCliDefault' => 'Padrão da CLI',
			'settings.page.automations.modelAuto' => 'Auto',
			'settings.page.automations.modelSearch' => ({required Object count}) => 'Buscar entre ${count} modelos…',
			'settings.page.automations.modelAutoRouted' => 'Este harness escolhe o modelo automaticamente.',
			'settings.page.automations.modelAccountOnly' => 'Só aparecem os modelos liberados na sua conta.',
			'settings.page.automations.generateFromSourceControl' => 'Gerar pelo Controle de Versão',
			'settings.page.automations.generateFromSourceControlDescription' => 'O GSH Desktop envia apenas o diff selecionado e os assuntos dos commits recentes. Padrões comuns de credenciais e arquivos sensíveis são redigidos antes de o harness rodar.',
			'settings.page.automations.discoveryFailed' => 'Não foi possível descobrir os harnesses de automação instalados.',
			'settings.page.automations.staleModel' => ({required Object model, required Object harness}) => 'O modelo "${model}" não está mais disponível para ${harness}. Usando o padrão da CLI; escolha outro modelo em Configurações se precisar.',
			'settings.page.automations.recommendedSuffix' => 'Recomendado',
			'settings.page.claudeCode.sectionGeneral' => 'Geral',
			'settings.page.claudeCode.classifyTitle' => 'Classificar estados das sessões',
			'settings.page.claudeCode.classifyDesc' => 'Mostra no cabeçalho do chat o estado que o Claude Code atribui ao fim de cada turno: concluída, pronta para revisão ou bloqueada. O Claude Code classifica de qualquer jeito; desligar só esconde o selo.',
			'settings.page.claudeCode.switchModelsTitle' => 'Alternar modelos quando uma mensagem for sinalizada',
			'settings.page.claudeCode.switchModelsDesc' => 'Quando as salvaguardas sinalizarem uma mensagem, alternar automaticamente para um modelo diferente para continuar a conversa. Quando desativado, sua sessão será pausada. Fica no ~/.claude/settings.json (switchModelsOnFlag).',
			'settings.page.claudeCode.sectionCodeAppearance' => 'Aparência do código',
			'settings.page.claudeCode.followTheme' => 'Do tema ativo',
			'settings.page.claudeCode.codeThemeLightHint' => 'Cores do código no modo claro',
			'settings.page.claudeCode.codeThemeDarkHint' => 'Cores do código no modo escuro',
			'settings.page.claudeCode.codeFontTitle' => 'Fonte de código',
			'settings.page.claudeCode.codeFontDesc' => 'Defina uma fonte monoespaçada personalizada para código: viewer, editor, diffs e blocos de código do chat. O terminal tem fonte própria em Aparência.',
			'settings.page.claudeCode.codeFontPlaceholder' => 'ex.: JetBrains Mono',
			'settings.page.claudeCode.sectionAppearance' => 'Aparência',
			'settings.page.claudeCode.transcriptTitle' => 'Visualização padrão da transcrição',
			'settings.page.claudeCode.transcriptDesc' => 'A visualização com que novas conversas do chat abrem. Conversas já abertas mantêm a delas.',
			'settings.page.claudeCode.viewNormal' => 'Normal',
			'settings.page.claudeCode.viewThinking' => 'Raciocínio',
			'settings.page.claudeCode.viewVerbose' => 'Detalhado',
			'settings.page.claudeCode.sectionRemoteControl' => 'Remote Control',
			'settings.page.claudeCode.remoteControlTitle' => 'Conectar novas sessões ao Remote Control',
			'settings.page.claudeCode.remoteControlDesc' => 'Toda sessão do claude que você iniciar num terminal se conecta ao Remote Control, para continuar no celular ou em claude.ai/code. Fica no ~/.claude/settings.json (remoteControlAtStartup). Exige login claude.ai (Pro, Max, Team ou Enterprise).',
			'settings.page.claudeCode.saveFailed' => ({required Object detail}) => 'Não consegui salvar: ${detail}',
			'settings.page.claudeCode.sectionSessions' => 'Sessões',
			'settings.page.claudeCode.promptSuggestionsTitle' => 'Sugestões de prompts',
			'settings.page.claudeCode.promptSuggestionsDesc' => 'Mostrar uma sugestão de próximo prompt depois que o Claude responder. As sugestões consomem um pouco do seu uso.',
			'settings.page.claudeCode.outputStyleTitle' => 'Estilo de saída',
			'settings.page.claudeCode.outputStyleDesc' => 'Como o Claude estrutura suas respostas nas sessões do Code. Aplica-se a novas sessões.',
			'settings.page.claudeCode.outputStyleDefault' => 'Padrão',
			'settings.page.claudeCode.crossSessionTitle' => 'Mensagens de outras sessões',
			'settings.page.claudeCode.crossSessionDesc' => 'O que fazer quando outra sessão do Claude Code manda mensagem para esta (SendMessage). Padrão: entrega só quando as duas usam o mesmo tipo de modo de permissão; senão fica retida para você aprovar. Fica em crossSessionInbound.',
			'settings.page.claudeCode.crossSessionDefault' => 'Padrão',
			'settings.page.claudeCode.crossSessionAccept' => 'Aceitar',
			'settings.page.claudeCode.crossSessionHold' => 'Segurar para aprovar',
			'settings.page.claudeCode.crossSessionRefuse' => 'Recusar',
			'settings.page.claudeCode.sandboxTitle' => 'Sandbox local',
			'settings.page.claudeCode.sandboxDesc' => 'Executa os comandos bash do Claude Code num sandbox isolado. Aplica-se a novas sessões.',
			'settings.page.claudeCode.sandboxStrictTitle' => 'Modo sandbox estrito',
			'settings.page.claudeCode.sandboxStrictDesc' => 'Bloqueia comandos que não podem ser executados dentro do sandbox em vez de executá-los fora dele.',
			'settings.page.claudeCode.sectionBrowser' => 'Navegador',
			'settings.page.claudeCode.linksInAppTitle' => 'Abrir links no navegador integrado',
			'settings.page.claudeCode.linksInAppDesc' => 'Links clicados nos terminais abrem numa aba de navegador do GSH em vez do seu navegador padrão.',
			'settings.page.placeholder.cowork1' => 'O Cowork é um recurso do Claude Desktop (tarefas que rodam neste computador com arquivos locais, navegador e MCPs).',
			'settings.page.placeholder.cowork2' => 'No GSH, o equivalente é o chat com o Claude num workspace e a Fazenda, onde os loops de agente rodam em terminais.',
			'settings.page.placeholder.extensionsDesc' => 'Permitir que o Claude interaja diretamente com aplicativos, dados e ferramentas no seu computador.',
			'settings.page.placeholder.extensionsEmpty' => 'Nenhuma extensão instalada',
			'settings.page.placeholder.extensions' => 'Extensões .MCPB/.DXT são do Claude Desktop. No GSH, os servidores MCP ficam em Conectores e Desenvolvedor.',
			'settings.page.claude.refresh' => 'Atualizar',
			'settings.page.claude.loading' => 'Carregando…',
			'settings.page.claude.terminalTitle' => 'Abrir um terminal',
			'settings.page.claude.noWorkspace' => 'Abra um workspace local antes: isto roda a CLI `claude` num terminal dele, para você acompanhar.',
			'settings.page.claude.months' => 'jan.|fev.|mar.|abr.|mai.|jun.|jul.|ago.|set.|out.|nov.|dez.',
			'settings.page.claude.weekdays' => 'seg.|ter.|qua.|qui.|sex.|sáb.|dom.',
			'settings.page.claude.dateShort' => ({required Object day, required Object month}) => '${day} de ${month}',
			'settings.page.claude.error.cliMissing' => 'CLI do Claude Code (`claude`) não encontrada neste computador.',
			'settings.page.claude.error.timeout' => 'A CLI `claude` demorou demais para responder.',
			'settings.page.claude.error.failed' => ({required Object detail}) => 'A CLI `claude` falhou: ${detail}',
			'settings.page.account.title' => 'Conta',
			'settings.page.account.profile' => 'Perfil',
			'settings.page.account.instructions' => 'Instruções para o Claude',
			'settings.page.account.instructionsDesc' => 'Gravado em ~/.claude/CLAUDE.md: o Claude Code carrega em toda sessão deste computador.',
			'settings.page.account.instructionsHint' => 'ex.: manter explicações breves e diretas',
			'settings.page.account.loggedIn' => 'Conectado',
			'settings.page.account.loggedOut' => 'Desconectado',
			'settings.page.account.loggedInDesc' => 'O Claude Code deste computador usa esta conta.',
			'settings.page.account.loggedOutDesc' => 'Entre para usar sua assinatura do Claude no Claude Code.',
			'settings.page.account.login' => 'Entrar',
			'settings.page.account.logout' => 'Sair',
			'settings.page.account.logoutConfirmTitle' => 'Sair do Claude Code?',
			'settings.page.account.logoutConfirmMessage' => 'Roda `claude auth logout`. As sessões deste computador deixam de usar sua assinatura até você entrar de novo.',
			'settings.page.account.email' => 'E-mail',
			'settings.page.account.organization' => 'Organização',
			'settings.page.account.orgId' => 'ID da organização',
			'settings.page.account.plan' => 'Plano',
			'settings.page.account.method' => 'Método de login',
			'settings.page.usage.title' => 'Seus limites de uso',
			'settings.page.usage.weeklyTitle' => 'Limites semanais',
			'settings.page.usage.unavailable' => 'Limites de plano não se aplicam a este login (chave de API ou provedor terceiro).',
			'settings.page.usage.windowSession' => 'Sessão atual',
			'settings.page.usage.windowWeekly' => 'Todos os modelos',
			'settings.page.usage.resetsIn' => ({required Object when}) => 'Reinicia em ${when}',
			'settings.page.usage.resetsAt' => ({required Object when}) => 'Reinicia ${when}',
			'settings.page.usage.percentUsed' => ({required Object pct}) => '${pct}% usado',
			'settings.page.usage.updated' => ({required Object when}) => 'Última atualização: ${when}',
			'settings.page.usage.justNow' => 'há menos de um minuto',
			'settings.page.usage.minutesAgo' => ({required Object n}) => 'há ${n} min',
			'settings.page.usage.minutes' => ({required Object m}) => '${m} min',
			'settings.page.usage.hoursMinutes' => ({required Object h, required Object m}) => '${h} h ${m} min',
			'settings.page.usage.plans.pro' => 'Pro',
			'settings.page.usage.plans.max' => 'Max',
			'settings.page.usage.plans.team' => 'Equipe',
			'settings.page.usage.plans.enterprise' => 'Empresa',
			'settings.page.memory.title' => 'Memória',
			'settings.page.memory.intro' => 'O que uma sessão do Claude Code no workspace ativo carrega: suas instruções e a memória que o próprio Claude grava. Clique para abrir o arquivo.',
			'settings.page.memory.instructionsTitle' => 'Instruções',
			'settings.page.memory.autoTitle' => 'Memória automática',
			'settings.page.memory.empty' => 'Nenhum CLAUDE.md encontrado.',
			'settings.page.memory.autoEmpty' => 'O Claude ainda não gravou memórias para este workspace.',
			'settings.page.memory.scopeUser' => 'Usuário (todos os projetos)',
			'settings.page.memory.scopeProject' => 'Projeto',
			'settings.page.memory.updated' => ({required Object when}) => 'Atualizado ${when}',
			'settings.page.skills.groupUser' => 'Criado por você',
			'settings.page.skills.groupProject' => 'Do projeto',
			'settings.page.skills.groupPlugins' => 'Dos plugins',
			'settings.page.skills.byYou' => 'por você',
			'settings.page.skills.byProject' => 'do projeto',
			'settings.page.skills.empty' => 'Nenhuma skill instalada.',
			'settings.page.connectors.checking' => 'Verificando cada servidor… pode levar alguns segundos.',
			'settings.page.connectors.empty' => 'Nenhum servidor MCP configurado.',
			'settings.page.connectors.addServer' => 'Adicionar servidor MCP',
			'settings.page.connectors.colConnector' => 'Conector',
			'settings.page.connectors.colType' => 'Tipo',
			'settings.page.connectors.colStatus' => 'Status',
			'settings.page.connectors.fromPlugin' => ({required Object plugin}) => 'Fornecido pelo plugin ${plugin}',
			'settings.page.connectors.typeWeb' => 'Web',
			'settings.page.connectors.typeLocal' => 'Local',
			'settings.page.connectors.originPlugin' => 'Plugin',
			'settings.page.connectors.link' => 'Vincular',
			'settings.page.connectors.discoverIntro' => 'O diretório de conectores do claude.ai não tem API pública, então o GSH não o lista. Adicione qualquer servidor MCP aqui: o GSH roda `claude mcp add` num terminal.',
			'settings.page.connectors.formName' => 'Nome',
			'settings.page.connectors.formType' => 'Tipo',
			'settings.page.connectors.formUrl' => 'URL',
			'settings.page.connectors.formCommand' => 'Comando',
			'settings.page.connectors.formScope' => 'Escopo',
			'settings.page.connectors.formScopeDesc' => 'Usuário = todos os projetos; Local = só o projeto do terminal.',
			'settings.page.connectors.scopeUser' => 'Usuário',
			'settings.page.connectors.scopeLocal' => 'Local',
			'settings.page.connectors.docs' => 'Docs de MCP',
			'settings.page.connectors.addInTerminal' => 'Adicionar no terminal',
			'settings.page.connectors.status.connected' => 'Conectado',
			'settings.page.connectors.status.needsAuth' => 'Precisa autenticar',
			'settings.page.connectors.status.failed' => 'Falhou',
			'settings.page.connectors.status.pending' => 'Aprovação pendente',
			'settings.page.connectors.status.unknown' => 'Desconhecido',
			'settings.page.plugins.search' => 'Pesquisar skills e plugins',
			'settings.page.plugins.groupProject' => 'Neste projeto',
			'settings.page.plugins.groupMarketplaces' => 'Dos marketplaces que você adicionou',
			'settings.page.plugins.noWorkspace' => 'Abra um workspace para ver os plugins habilitados nele.',
			'settings.page.plugins.projectEmpty' => 'Nenhum plugin habilitado no .claude/settings.json deste projeto.',
			'settings.page.plugins.empty' => 'Nenhum plugin instalado.',
			'settings.page.plugins.disabled' => 'Desabilitado',
			'settings.page.developer.title' => 'Desenvolvedor',
			'settings.page.developer.mcpTitle' => 'Servidores MCP locais',
			'settings.page.developer.mcpDesc' => 'Servidores MCP stdio que o Claude Code sobe neste computador. Eles ficam no ~/.claude.json.',
			'settings.page.developer.mcpEmpty' => 'Nenhum servidor MCP local.',
			'settings.page.developer.editConfig' => 'Editar configuração',
			'settings.page.developer.command' => 'Comando',
			'settings.page.developer.arguments' => 'Argumentos',
			'settings.page.developer.error' => 'Erro',
			'settings.page.developer.telemetryTitle' => 'Telemetria',
			'settings.page.developer.telemetryDesc' => 'Erros e logs dos processos do workspace ficam no painel Telemetria do shell; com o modo desenvolvedor ele mostra também os do próprio GSH Desktop.',
			'settings.page.developer.claudeSettingsTitle' => 'Arquivo de configurações do Claude Code',
			'settings.page.developer.claudeSettingsDesc' => '~/.claude/settings.json — permissões, hooks, ambiente e modelo.',
			'settings.page.developer.apiKeyTitle' => 'Quer uma chave de API?',
			'settings.page.developer.apiKeyDesc' => 'Crie chaves e veja o uso no Claude Console. Isso requer outra conta, e o uso da API é cobrado separadamente.',
			'settings.page.developer.apiKeyButton' => 'Ir para o Console',
			'settings.page.system.title' => 'Sistema',
			'settings.page.system.version' => 'Versão do aplicativo',
			'settings.page.system.keepAwakeTitle' => 'Manter computador ativo',
			'settings.page.system.keepAwakeDesc' => 'Impede a suspensão por inatividade enquanto ligado (o mesmo botão de raio do rail). Desliga ao fechar o app; fechar a tampa ainda suspende.',
			'settings.page.catalog.mine' => 'Meus',
			'settings.page.catalog.discover' => 'Descobrir',
			'settings.page.catalog.add' => 'Adicionar',
			'settings.page.catalog.all' => 'Todos',
			'settings.page.catalog.by' => ({required Object author}) => 'por ${author}',
			'settings.page.catalog.newSkill' => 'Nova skill…',
			'settings.page.catalog.addMarketplace' => 'Adicionar marketplace…',
			'settings.page.generalClaude.sectionAppearance' => 'Aparência',
			'settings.page.generalClaude.theme' => 'Tema',
			'settings.page.generalClaude.themeSystem' => 'Sistema',
			'settings.page.generalClaude.themeLight' => 'Claro',
			'settings.page.generalClaude.themeDark' => 'Escuro',
			'settings.page.generalClaude.uiFont' => 'Fonte da interface',
			'settings.page.generalClaude.uiFontDesc' => 'Fonte para toda a interface — menus, barras laterais e painéis.',
			'settings.page.generalClaude.chatFont' => 'Fonte do chat',
			'settings.page.generalClaude.chatFontDesc' => 'Texto da conversa no chat com o Claude.',
			'settings.page.generalClaude.chatFontDefault' => 'Mesma da interface',
			'settings.page.generalClaude.textSize' => 'Tamanho do texto da conversa',
			'settings.page.generalClaude.textSizeDesc' => 'Tamanho base do texto do app (o mesmo ajuste de Aparência).',
			'settings.page.generalClaude.sizeSmall' => 'Pequeno',
			'settings.page.generalClaude.sizeMedium' => 'Médio',
			'settings.page.generalClaude.sizeLarge' => 'Grande',
			'settings.page.generalClaude.transcriptWidth' => 'Largura da transcrição',
			'settings.page.generalClaude.transcriptWidthDesc' => 'Largura máxima das colunas da transcrição e do campo de mensagem.',
			'settings.page.generalClaude.widthNarrow' => 'Estreito',
			'settings.page.generalClaude.widthMedium' => 'Médio',
			'settings.page.generalClaude.widthWide' => 'Largo',
			'settings.page.generalClaude.reducedMotion' => 'Movimento reduzido',
			'settings.page.generalClaude.reducedMotionDesc' => 'Menos animações no Claude Code (brilho do spinner, piscadas). Gravado como prefersReducedMotion no ~/.claude/settings.json.',
			'settings.page.generalClaude.sectionNotifications' => 'Notificações',
			'settings.page.generalClaude.notifyTurnDone' => 'Conclusão de respostas',
			'settings.page.generalClaude.notifyTurnDoneDesc' => 'Receba uma notificação quando um agente terminar uma resposta e a janela não estiver em foco.',
			'settings.page.generalClaude.notifyPermission' => 'Solicitações de permissão do Code',
			'settings.page.generalClaude.notifyPermissionDesc' => 'Toca um som quando um agente estiver esperando sua aprovação ou resposta.',
			'settings.page.generalClaude.pushInputNeeded' => 'Push no celular quando precisar de você',
			'settings.page.generalClaude.pushInputNeededDesc' => 'O Claude Code manda um push quando uma permissão ou pergunta estiver esperando (inputNeededNotifEnabled).',
			'settings.page.generalClaude.pushAgent' => 'Notificações proativas no celular',
			'settings.page.generalClaude.pushAgentDesc' => 'Deixa o Claude avisar no celular sobre atualizações importantes de uma sessão (agentPushNotifEnabled).',
			'settings.page.privacy.title' => 'Dados',
			'settings.page.privacy.gshTelemetry' => 'Telemetria do GSH',
			'settings.page.privacy.gshTelemetryDesc' => 'Só local: erros e logs ficam num SQLite deste computador e nunca são enviados.',
			'settings.page.privacy.ccTelemetry' => 'Desligar a telemetria do Claude Code',
			'settings.page.privacy.ccTelemetryDesc' => 'Define DISABLE_TELEMETRY no env do ~/.claude/settings.json (métricas de uso não são enviadas).',
			'settings.page.privacy.ccErrors' => 'Desligar relatórios de erro do Claude Code',
			'settings.page.privacy.ccErrorsDesc' => 'Define DISABLE_ERROR_REPORTING no env do ~/.claude/settings.json.',
			'settings.page.resources.sectionGeneral' => 'Geral',
			'settings.page.resources.sectionShell' => 'Recursos do GSH',
			'settings.page.resources.chat' => 'Chat com o Claude (beta)',
			'settings.page.resources.chatDesc' => 'Botão de chat na barra do workspace (Claude Code em stream-json).',
			'settings.page.resources.farm' => 'Fazenda',
			'settings.page.resources.farmDesc' => 'Loops de agente lidos dos transcripts do Claude Code.',
			'settings.page.resources.graph' => 'Grafo de agentes',
			'settings.page.resources.graphDesc' => 'Visualiza os agentes do workspace e quem fala com quem.',
			'settings.page.resources.browser' => 'Navegador embutido',
			'settings.page.resources.browserDesc' => 'Aba "Navegador" no menu da pane (onde a plataforma tem webview embutida).',
			'settings.page.resources.skillsMoved' => 'As Skills foram movidas para ',
			'settings.page.designSystems.title' => 'Design systems',
			'settings.page.designSystems.desc' => 'No GSH, são os temas: cores da interface, do terminal e do código num pacote só.',
			'settings.page.designSystems.add' => 'Novo design system',
			'settings.page.designSystems.search' => 'Pesquisar por nome',
			'settings.page.designSystems.showing' => ({required Object n, required Object total}) => 'Exibindo ${n} de ${total}',
			'settings.page.designSystems.colName' => 'Nome',
			'settings.page.designSystems.colOrigin' => 'Origem',
			'settings.page.designSystems.colAuthor' => 'Autor',
			'settings.page.designSystems.active' => 'Ativo',
			'settings.page.designSystems.imported' => 'Importado',
			'settings.page.designSystems.builtIn' => 'Embutido',
			'settings.page.designSystems.activate' => 'Usar este tema',
			'settings.page.designSystems.remove' => 'Remover',
			'settings.remoteHosts.title' => 'Hosts remotos',
			'settings.remoteHosts.description' => 'Máquinas que você acessa por SSH. Adicionar um host aqui é o mesmo que adicionar pelo menu "+" do workspace.',
			'settings.remoteHosts.empty' => 'Nenhum host remoto ainda.',
			'settings.remoteHosts.add' => 'Adicionar host',
			'settings.remoteHosts.edit' => 'Editar',
			'settings.remoteHosts.reconnect' => 'Reconectar',
			'settings.remoteHosts.remove' => 'Remover',
			'settings.remoteHosts.removeTitle' => 'Remover host',
			'settings.remoteHosts.removeMessage' => ({required Object name}) => 'Remover "${name}" e todos os workspaces dele? Nada é apagado no host.',
			'settings.remoteHosts.workspacesCount' => ({required Object count}) => '${count} workspace(s)',
			'settings.remoteHosts.deviceKeyTitle' => 'Chave deste dispositivo',
			'settings.remoteHosts.deviceKeyDesc' => 'Adicione esta chave pública ao ~/.ssh/authorized_keys do host para este dispositivo poder conectar.',
			'settings.remoteHosts.deviceKeyCopy' => 'Copiar chave pública',
			'settings.remoteHosts.deviceKeyCopied' => 'Chave pública copiada',
			'settings.remoteHosts.statusConnected' => 'Conectado',
			'settings.remoteHosts.statusConnecting' => 'Conectando…',
			'settings.remoteHosts.statusReconnecting' => 'Reconectando…',
			'settings.remoteHosts.statusOffline' => 'Offline',
			'settings.remoteHosts.statusIdle' => 'Não conectado',
			'settings.remoteHosts.helpTitle' => 'Como funciona',
			'settings.remoteHosts.helpBody' => 'O GSH Desktop conecta na sua máquina por SSH e fala com um servidor pequeno que roda os terminais, arquivos e git lá. O host precisa ter o GSH Desktop (desktop) ou o gsh-server instalado e rodando, e a chave pública deste dispositivo adicionada no ~/.ssh/authorized_keys dele.',
			'automation.error.unavailable' => ({required Object harness}) => '${harness} não está instalado ou não está no PATH.',
			'automation.error.modelUnavailable' => ({required Object model, required Object harness}) => 'O modelo "${model}" não está disponível para ${harness}. Escolha outro modelo em Configurações.',
			'automation.error.authentication' => ({required Object harness, required Object detail}) => '${harness}: ${detail}',
			'automation.error.timeout' => ({required Object harness, required Object seconds}) => '${harness} não respondeu em ${seconds} segundos.',
			'automation.error.cancelled' => 'A geração da mensagem de commit foi cancelada.',
			'automation.error.process' => ({required Object harness, required Object detail}) => '${harness}: ${detail}',
			'automation.error.processNoDetail' => ({required Object harness}) => '${harness} não conseguiu gerar uma mensagem de commit.',
			'automation.error.invalidResponse' => 'A automação devolveu uma mensagem de commit vazia.',
			'automation.error.busy' => 'Já há uma mensagem de commit sendo gerada.',
			'automation.error.unknown' => 'A automação não conseguiu gerar uma mensagem de commit.',
			'automation.error.noWorkspace' => 'Nenhum workspace selecionado.',
			'automation.error.fileOutsideWorkspace' => 'O arquivo está fora das raízes do workspace.',
			'automation.error.fileUnreadable' => ({required Object detail}) => 'Não foi possível ler o arquivo: ${detail}',
			'automation.error.binaryFile' => 'Não é possível gerar mensagem de commit para um arquivo binário.',
			'automation.error.noFileChanges' => 'Não há mudanças a descrever neste arquivo.',
			'automation.error.noStagedChanges' => 'Não há mudanças no stage a descrever.',
			'automation.error.multipleRepositories' => 'As mudanças no stage pertencem a repositórios diferentes. Gere uma de cada vez.',
			'automation.error.diffUnavailable' => 'Não foi possível ler o diff.',
			'automation.error.notConfigured' => 'Configure um harness de mensagem de commit em Configurações.',
			'fileOperation.error.alreadyExists' => ({required Object name}) => 'Já existe: “${name}”.',
			'fileOperation.error.notFound' => ({required Object name}) => 'Não encontrado: “${name}”.',
			'fileOperation.error.invalidPath' => 'Caminho inválido.',
			'fileOperation.error.emptyName' => 'O nome não pode ficar vazio.',
			'fileOperation.error.noWorkspace' => 'Nenhum workspace selecionado.',
			'fileOperation.error.cannotMoveIntoItself' => 'Não é possível mover uma pasta para dentro dela mesma.',
			'fileOperation.error.clipboardEmpty' => 'A área de transferência está vazia.',
			'fileOperation.error.notScratchTab' => 'Esta aba não é um arquivo temporário.',
			'fileOperation.error.writeFailed' => 'Não foi possível gravar o arquivo.',
			'fileOperation.error.formatterEmptyCommand' => 'Comando de formatação vazio.',
			'fileOperation.error.formatterMissingPlaceholder' => 'O comando de formatação precisa incluir o placeholder %FILE%.',
			'fileOperation.error.formatterTimeout' => 'O formatador excedeu o tempo limite.',
			'fileOperation.error.formatterExitCode' => ({required Object code}) => 'O formatador saiu com código ${code}.',
			'fileOperation.error.formatterFailed' => 'Não foi possível executar o formatador.',
			'fileOperation.error.osFailure' => ({required Object detail}) => '${detail}',
			'fileOperation.error.nameHasSlash' => 'O nome não pode conter “/”.',
			'fileOperation.error.invalidName' => 'Nome inválido.',
			'fileOperation.error.remoteDropUnsupported' => 'Soltar arquivos num workspace remoto ainda não é suportado.',
			'theme.error.io' => 'Não foi possível ler ou gravar o arquivo do tema.',
			'theme.error.ioDetail' => ({required Object detail}) => 'Não foi possível ler ou gravar o arquivo do tema: ${detail}',
			'theme.error.malformedJson' => ({required Object detail}) => 'Este arquivo não é um JSON válido: ${detail}',
			'theme.error.invalidTheme' => 'Este arquivo não é um tema válido.',
			'theme.error.reservedId' => 'Este tema usa o id de um tema nativo. Mude o "id" no arquivo e importe de novo.',
			'theme.error.notAnObject' => ({required Object field}) => 'Esperava um objeto em "${field}".',
			'theme.error.missingField' => ({required Object field}) => 'Falta o campo obrigatório "${field}".',
			'theme.error.badColor' => ({required Object value, required Object field}) => '"${value}" em "${field}" não é uma cor. Use #RGB, #RRGGBB ou #RRGGBBAA.',
			'theme.error.unknownBase' => ({required Object value}) => 'Tema base "${value}" desconhecido em "extends".',
			'theme.error.noVariants' => 'O tema não declara nenhum variant. Adicione "dark", "light" ou os dois em "variants".',
			_ => null,
		};
	}
}
