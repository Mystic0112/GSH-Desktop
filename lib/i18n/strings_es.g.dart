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
class TranslationsEs extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsEs _root = this; // ignore: unused_field

	@override 
	TranslationsEs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEs(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$core$es core = _Translations$core$es._(_root);
	@override late final _Translations$common$es common = _Translations$common$es._(_root);
	@override late final _Translations$gsh$es gsh = _Translations$gsh$es._(_root);
	@override late final _Translations$settings$es settings = _Translations$settings$es._(_root);
	@override late final _Translations$automation$es automation = _Translations$automation$es._(_root);
	@override late final _Translations$fileOperation$es fileOperation = _Translations$fileOperation$es._(_root);
	@override late final _Translations$theme$es theme = _Translations$theme$es._(_root);
}

// Path: core
class _Translations$core$es extends Translations$core$en {
	_Translations$core$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$core$bootstrapError$es bootstrapError = _Translations$core$bootstrapError$es._(_root);
	@override late final _Translations$core$macosNotifications$es macosNotifications = _Translations$core$macosNotifications$es._(_root);
	@override late final _Translations$core$appErrorView$es appErrorView = _Translations$core$appErrorView$es._(_root);
	@override late final _Translations$core$errorReportDialog$es errorReportDialog = _Translations$core$errorReportDialog$es._(_root);
	@override late final _Translations$core$windowControls$es windowControls = _Translations$core$windowControls$es._(_root);
	@override late final _Translations$core$crash$es crash = _Translations$core$crash$es._(_root);
	@override late final _Translations$core$menu$es menu = _Translations$core$menu$es._(_root);
}

// Path: common
class _Translations$common$es extends Translations$common$en {
	_Translations$common$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get confirm => 'Confirmar';
	@override String get create => 'Crear';
	@override String get gotIt => 'Entendido';
	@override String get save => 'Guardar';
	@override String get close => 'Cerrar';
	@override String get delete => 'Eliminar';
	@override String get done => 'Listo';
	@override String get add => 'Añadir';
	@override String get test => 'Probar';
	@override String get ok => 'OK';
	@override String get loading => 'Cargando…';
	@override String get checking => 'Comprobando…';
	@override String get remove => 'Quitar';
	@override String get restart => 'Reiniciar';
	@override String get settings => 'Configuración';
	@override String get send => 'Enviar';
	@override String get open => 'Abrir';
	@override String get dismiss => 'Descartar';
	@override String get report => 'Reportar';
	@override String get copyCode => 'Copiar código';
	@override String get search => 'Buscar';
	@override String get noResults => 'Sin resultados';
}

// Path: gsh
class _Translations$gsh$es extends Translations$gsh$en {
	_Translations$gsh$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$gsh$confirmDialog$es confirmDialog = _Translations$gsh$confirmDialog$es._(_root);
	@override late final _Translations$gsh$neovim$es neovim = _Translations$gsh$neovim$es._(_root);
	@override late final _Translations$gsh$worktreeCreateDialog$es worktreeCreateDialog = _Translations$gsh$worktreeCreateDialog$es._(_root);
	@override late final _Translations$gsh$commitMessageDialog$es commitMessageDialog = _Translations$gsh$commitMessageDialog$es._(_root);
	@override late final _Translations$gsh$tasksPanel$es tasksPanel = _Translations$gsh$tasksPanel$es._(_root);
	@override late final _Translations$gsh$gshPage$es gshPage = _Translations$gsh$gshPage$es._(_root);
	@override late final _Translations$gsh$welcomeView$es welcomeView = _Translations$gsh$welcomeView$es._(_root);
	@override late final _Translations$gsh$paneView$es paneView = _Translations$gsh$paneView$es._(_root);
	@override late final _Translations$gsh$fileTreePanel$es fileTreePanel = _Translations$gsh$fileTreePanel$es._(_root);
	@override late final _Translations$gsh$fileViewer$es fileViewer = _Translations$gsh$fileViewer$es._(_root);
	@override late final _Translations$gsh$workspaceSettingsDialog$es workspaceSettingsDialog = _Translations$gsh$workspaceSettingsDialog$es._(_root);
	@override late final _Translations$gsh$realmDialogs$es realmDialogs = _Translations$gsh$realmDialogs$es._(_root);
	@override late final _Translations$gsh$dbRedisTable$es dbRedisTable = _Translations$gsh$dbRedisTable$es._(_root);
	@override late final _Translations$gsh$dbQueryView$es dbQueryView = _Translations$gsh$dbQueryView$es._(_root);
	@override late final _Translations$gsh$httpView$es httpView = _Translations$gsh$httpView$es._(_root);
	@override late final _Translations$gsh$kanbanView$es kanbanView = _Translations$gsh$kanbanView$es._(_root);
	@override late final _Translations$gsh$dbPanel$es dbPanel = _Translations$gsh$dbPanel$es._(_root);
	@override late final _Translations$gsh$dbMongoView$es dbMongoView = _Translations$gsh$dbMongoView$es._(_root);
	@override late final _Translations$gsh$dbConnectionDialog$es dbConnectionDialog = _Translations$gsh$dbConnectionDialog$es._(_root);
	@override late final _Translations$gsh$sshPrompts$es sshPrompts = _Translations$gsh$sshPrompts$es._(_root);
	@override late final _Translations$gsh$projectsRail$es projectsRail = _Translations$gsh$projectsRail$es._(_root);
	@override late final _Translations$gsh$findBar$es findBar = _Translations$gsh$findBar$es._(_root);
	@override late final _Translations$gsh$contentSearch$es contentSearch = _Translations$gsh$contentSearch$es._(_root);
	@override late final _Translations$gsh$topbar$es topbar = _Translations$gsh$topbar$es._(_root);
	@override late final _Translations$gsh$tasks$es tasks = _Translations$gsh$tasks$es._(_root);
	@override late final _Translations$gsh$notifications$es notifications = _Translations$gsh$notifications$es._(_root);
	@override late final _Translations$gsh$terminalLink$es terminalLink = _Translations$gsh$terminalLink$es._(_root);
	@override late final _Translations$gsh$terminal$es terminal = _Translations$gsh$terminal$es._(_root);
	@override late final _Translations$gsh$remoteHost$es remoteHost = _Translations$gsh$remoteHost$es._(_root);
	@override late final _Translations$gsh$browserPane$es browserPane = _Translations$gsh$browserPane$es._(_root);
	@override late final _Translations$gsh$documentWindow$es documentWindow = _Translations$gsh$documentWindow$es._(_root);
	@override late final _Translations$gsh$gallery$es gallery = _Translations$gsh$gallery$es._(_root);
	@override late final _Translations$gsh$notebook$es notebook = _Translations$gsh$notebook$es._(_root);
	@override late final _Translations$gsh$layoutPreview$es layoutPreview = _Translations$gsh$layoutPreview$es._(_root);
	@override late final _Translations$gsh$telemetry$es telemetry = _Translations$gsh$telemetry$es._(_root);
	@override late final _Translations$gsh$panelView$es panelView = _Translations$gsh$panelView$es._(_root);
	@override late final _Translations$gsh$chat$es chat = _Translations$gsh$chat$es._(_root);
	@override late final _Translations$gsh$harness$es harness = _Translations$gsh$harness$es._(_root);
	@override late final _Translations$gsh$farm$es farm = _Translations$gsh$farm$es._(_root);
	@override late final _Translations$gsh$agentGraph$es agentGraph = _Translations$gsh$agentGraph$es._(_root);
}

// Path: settings
class _Translations$settings$es extends Translations$settings$en {
	_Translations$settings$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$settings$language$es language = _Translations$settings$language$es._(_root);
	@override late final _Translations$settings$page$es page = _Translations$settings$page$es._(_root);
	@override late final _Translations$settings$remoteHosts$es remoteHosts = _Translations$settings$remoteHosts$es._(_root);
}

// Path: automation
class _Translations$automation$es extends Translations$automation$en {
	_Translations$automation$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$automation$error$es error = _Translations$automation$error$es._(_root);
}

// Path: fileOperation
class _Translations$fileOperation$es extends Translations$fileOperation$en {
	_Translations$fileOperation$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$fileOperation$error$es error = _Translations$fileOperation$error$es._(_root);
}

// Path: theme
class _Translations$theme$es extends Translations$theme$en {
	_Translations$theme$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$theme$error$es error = _Translations$theme$error$es._(_root);
}

// Path: core.bootstrapError
class _Translations$core$bootstrapError$es extends Translations$core$bootstrapError$en {
	_Translations$core$bootstrapError$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'No se pudo inicializar GSH Desktop';
	@override String get retry => 'Reintentar';
}

// Path: core.macosNotifications
class _Translations$core$macosNotifications$es extends Translations$core$macosNotifications$en {
	_Translations$core$macosNotifications$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Activar notificaciones en macOS';
	@override String get intro => 'Las notificaciones están desactivadas en la configuración del sistema. Sigue los pasos a continuación para activarlas:';
	@override String get step1 => 'Abre los Ajustes del Sistema en tu Mac.';
	@override String get step2 => 'Ve a la sección Notificaciones en la barra lateral izquierda.';
	@override String get step3 => 'Busca y selecciona la aplicación GSH Desktop en la lista.';
	@override String get step4 => 'Activa el interruptor Permitir Notificaciones.';
	@override String get tip => 'Consejo: si la aplicación no aparece en la lista, ciérrala y vuelve a abrirla para activar su registro en el sistema.';
	@override String get gotIt => 'Entendido';
}

// Path: core.appErrorView
class _Translations$core$appErrorView$es extends Translations$core$appErrorView$en {
	_Translations$core$appErrorView$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get renderFailed => 'Esta parte de la aplicación no se pudo renderizar';
	@override String get details => 'Detalles';
	@override String get renderErrorTitle => 'Error de renderizado';
}

// Path: core.errorReportDialog
class _Translations$core$errorReportDialog$es extends Translations$core$errorReportDialog$en {
	_Translations$core$errorReportDialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get defaultDescription => 'Algo salió mal. Los detalles a continuación se guardaron en el registro — puedes reportarlos para que se solucione.';
	@override String get copyDetails => 'Copiar detalles';
	@override String get reportIssue => 'Reportar problema';
}

// Path: core.windowControls
class _Translations$core$windowControls$es extends Translations$core$windowControls$en {
	_Translations$core$windowControls$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get minimize => 'Minimizar';
	@override String get maximize => 'Maximizar';
	@override String get close => 'Cerrar';
}

// Path: core.crash
class _Translations$core$crash$es extends Translations$core$crash$en {
	_Translations$core$crash$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cierre inesperado';
	@override String get bannerTitle => 'GSH Desktop se cerró inesperadamente';
	@override String get report => 'Reportar';
	@override String get dismiss => 'Descartar';
	@override String crashMessage({required Object version}) => 'La sesión anterior (versión ${version}) terminó sin cerrarse correctamente. ¿Quieres reportarlo? El log se incluye y puedes revisar todo antes de enviar.';
	@override String crashError({required Object startedAt, required Object pid}) => 'La sesión iniciada el ${startedAt} (pid ${pid}) terminó sin un cierre limpio.';
	@override String get crashDescription => 'No se capturó ningún error: el sistema terminó la app. El log de abajo es de esa sesión y es la parte más útil.';
}

// Path: core.menu
class _Translations$core$menu$es extends Translations$core$menu$en {
	_Translations$core$menu$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Configuración…';
	@override String get checkForUpdates => 'Buscar Actualizaciones…';
	@override String get file => 'Archivo';
	@override String get newTerminal => 'Nueva Terminal';
	@override String get newChat => 'Nuevo Chat';
	@override String get newChatRight => 'Nuevo Chat a la Derecha';
	@override String get openWorkspace => 'Abrir Workspace';
	@override String get save => 'Guardar';
	@override String get discard => 'Descartar';
	@override String get format => 'Formatear';
	@override String get view => 'Ver';
	@override String get toggleWorkspacePanel => 'Alternar Panel de Workspaces';
	@override String get toggleFiles => 'Alternar Archivos';
	@override String get splitRight => 'Dividir a la Derecha';
	@override String get splitDown => 'Dividir Abajo';
	@override String get focusPane => 'Enfocar Panel';
	@override String get focusLeft => 'Izquierda  (⌘⌥←)';
	@override String get focusRight => 'Derecha  (⌘⌥→)';
	@override String get focusUp => 'Arriba  (⌘⌥↑)';
	@override String get focusDown => 'Abajo  (⌘⌥↓)';
	@override String get selectTab => 'Seleccionar Pestaña';
	@override String tabN({required Object n}) => 'Pestaña ${n}';
	@override String get lastTab => 'Última Pestaña';
	@override String get previousWorkspace => 'Workspace Anterior';
	@override String get nextWorkspace => 'Siguiente Workspace';
	@override String get zoomIn => 'Acercar';
	@override String get zoomOut => 'Alejar';
	@override String get actualSize => 'Tamaño Real';
	@override String get window => 'Ventana';
	@override String get quit => 'Salir';
	@override String get minimize => 'Minimizar';
	@override String get zoom => 'Zoom';
}

// Path: gsh.confirmDialog
class _Translations$gsh$confirmDialog$es extends Translations$gsh$confirmDialog$en {
	_Translations$gsh$confirmDialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get unsavedChangesTitle => 'Cambios sin guardar';
	@override String unsavedChangesMessage({required Object fileName}) => '“${fileName}” tiene cambios sin guardar. ¿Guardarlos antes de cerrar?';
	@override String get dontSave => 'No guardar';
	@override String get saveAndClose => 'Guardar y cerrar';
}

// Path: gsh.neovim
class _Translations$gsh$neovim$es extends Translations$gsh$neovim$en {
	_Translations$gsh$neovim$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get unavailable => 'Neovim no está disponible. Abriendo en GSH Desktop.';
	@override String get openFailed => 'No se pudo acceder a Neovim. Abriendo en GSH Desktop.';
	@override String get unsavedTitle => 'Búferes de Neovim sin guardar';
	@override String get unsavedMessage => 'Neovim tiene búferes modificados. ¿Cerrar la pestaña y descartar esos cambios?';
	@override String get closeAnyway => 'Cerrar de todos modos';
}

// Path: gsh.worktreeCreateDialog
class _Translations$gsh$worktreeCreateDialog$es extends Translations$gsh$worktreeCreateDialog$en {
	_Translations$gsh$worktreeCreateDialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get forkTitle => 'Fork del worktree';
	@override String get createTitle => 'Crear worktree';
	@override String forkSubtitle({required Object root}) => 'Nueva worktree ramificada desde ${root}.';
	@override String createSubtitle({required Object root}) => 'Nueva feature en ${root} — nueva branch desde el HEAD actual.';
	@override String get namePlaceholder => 'feat/mi-feature';
	@override String get errorWhitespace => 'Sin espacios en el nombre.';
	@override String get errorInvalidChar => 'Carácter inválido para un nombre de branch.';
	@override String get errorInvalidSequence => 'Secuencia inválida (ej.: "..", "//", empezar/terminar con "/").';
	@override String get errorReserved => 'Posición reservada (no empieces con "-"/"." ni termines con ".lock").';
	@override String get errorDuplicateBranch => 'Ya existe una branch con ese nombre.';
	@override String get errorDuplicateWorktree => 'Ya existe un worktree con ese nombre.';
	@override String errorBranchHierarchyConflict({required Object target, required Object existing}) => 'No se puede crear la branch \'${target}\' porque entra en conflicto con la branch \'${existing}\' ya existente.';
	@override String get errorBranchHierarchicalConflictGeneral => 'Ya existe una branch con una jerarquía conflictiva.';
	@override String get fork => 'Fork';
	@override String get postCheckoutHint => 'Este repositorio tiene un hook post-checkout.';
	@override String get running => 'Ejecutando…';
	@override String get advancedSettings => 'Configuración Avanzada';
	@override String get copyIgnored => 'Copiar archivos ignorados (.gitignore)';
	@override String get copyIgnoredDesc => 'Copia los archivos ignorados por .gitignore (ej. .env, claves locales) al nuevo worktree.';
	@override String get copyUntracked => 'Copiar archivos no rastreados';
	@override String get copyUntrackedDesc => 'Copia los archivos nuevos o modificados que aún no se han agregado al stage.';
	@override String get baseBranch => 'Branch base';
	@override String get baseBranchDesc => 'La branch desde la cual se creará el nuevo worktree y branch.';
	@override String get fetchRemote => 'Sincronizar branch remota (fetch)';
	@override String get fetchRemoteDesc => 'Ejecuta git fetch para garantizar que la branch base esté confirmada antes de crear el worktree.';
	@override String get searchBranch => 'Buscar branch...';
	@override String get back => 'Atrás';
}

// Path: gsh.commitMessageDialog
class _Translations$gsh$commitMessageDialog$es extends Translations$gsh$commitMessageDialog$en {
	_Translations$gsh$commitMessageDialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get commitTitle => 'Commit';
	@override String get stageAndCommitTitle => 'Stage y Commit';
	@override String scopeNote({required Object fileName}) => 'Commit solo de "${fileName}".';
	@override String get placeholder => 'fix: resumen breve del cambio';
	@override String get errorEmptySubject => 'La primera línea (asunto) no puede estar vacía.';
	@override String errorTooShort({required Object min}) => 'Asunto demasiado corto (mín. ${min} caracteres).';
	@override String errorTooLong({required Object max}) => 'Asunto demasiado largo (máx. ${max} caracteres).';
	@override String get errorTrailingPeriod => 'El asunto no debe terminar con un punto.';
	@override String get errorControlChars => 'El asunto contiene caracteres de control.';
	@override String get errorBlankSecondLine => 'Deja la segunda línea en blanco (separador entre asunto y cuerpo de git).';
	@override String get generate => 'Generar mensaje de commit';
	@override String generateWith({required Object harness}) => 'Generar con ${harness}';
	@override String get generating => 'Generando…';
	@override String get cancelGeneration => 'Cancelar generación';
}

// Path: gsh.tasksPanel
class _Translations$gsh$tasksPanel$es extends Translations$gsh$tasksPanel$en {
	_Translations$gsh$tasksPanel$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get reloadTasksTooltip => 'Recargar tasks';
	@override String get restartTooltip => 'Reiniciar';
	@override String get stopTooltip => 'Detener';
	@override String get runTooltip => 'Ejecutar';
	@override String sendsKeyTooltip({required Object label, required Object key}) => '${label} (envía \'${key}\')';
	@override String get startingTooltip => 'Iniciando…';
	@override String get stoppingTooltip => 'Deteniendo…';
	@override String get switchProfileTooltip => 'Cambiar perfil';
	@override String get moreKeysTooltip => 'Más teclas';
	@override String get sectionTasks => 'TAREAS';
	@override String get noTasks => 'No se detectaron tareas en este proyecto.';
	@override String get createTasksJson => 'Crear tasks.json';
	@override String get generateComposeTasks => 'Generar tareas de Compose';
	@override String get selectComposeEngine => 'Elige un motor de Compose';
	@override String get noComposeEngine => 'No se encontró Docker Compose ni Podman Compose.';
	@override String get invalidComposeFile => 'El archivo activo no es un Compose válido con servicios.';
	@override String get invalidTasksJson => 'tasks.json no es válido. No se guardaron cambios.';
	@override String composeConflicts({required Object labels}) => 'Se conservaron tareas que no son Compose con etiquetas en conflicto: ${labels}';
}

// Path: gsh.gshPage
class _Translations$gsh$gshPage$es extends Translations$gsh$gshPage$en {
	_Translations$gsh$gshPage$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get chooseProjectFolderDialogTitle => 'Elige la carpeta del proyecto';
	@override String get chooseWorkspaceFolderDialogTitle => 'Elige la carpeta del workspace';
	@override String get workspaceRenamedTitle => 'Workspace renombrado';
	@override String workspaceRenamedMessage({required Object name}) => 'El nuevo nombre "${name}" solo se enviará a los agentes tras reiniciar el workspace o la aplicación.';
	@override String syncTitle({required Object label}) => 'Sync — ${label}';
	@override String pullTitle({required Object label}) => 'Pull — ${label}';
	@override String pushTitle({required Object label}) => 'Push — ${label}';
	@override String updateFromParentTitle({required Object name}) => 'Actualizar desde el Padre — ${name}';
	@override String mergeToParentTitle({required Object name}) => 'Merge al Padre — ${name}';
	@override String get worktreeMergedAndRemoved => 'Worktree fusionado y eliminado.';
	@override String get nothingWasChanged => 'No se realizaron cambios.';
	@override String get newRealmTitle => 'Nuevo realm';
	@override String get closeWorkspaceTitle => 'Cerrar workspace';
	@override String closeWorkspaceMessage({required Object name}) => '¿Cerrar "${name}"? Los agentes de este workspace se cerrarán. La carpeta en el disco se conserva.';
	@override String get closeAction => 'Cerrar';
	@override String get removeWorktreeTitle => 'Quitar worktree';
	@override String removeWorktreeMessage({required Object name, required Object warn}) => '¿Quitar "${name}"? La carpeta del worktree y la branch se eliminarán y los agentes de este fork se cerrarán.${warn}';
	@override String removeWorktreeWarning({required Object name}) => '\n\nAdvertencia: la branch "${name}" aún no se ha fusionado — eliminarla (git branch -D) descarta el trabajo no fusionado.';
	@override String get failedToRemoveWorktreeTitle => 'No se pudo quitar el worktree';
	@override String get openLayoutTitle => 'Abrir layout';
	@override String get replaceLayoutTitle => '¿Reemplazar el layout actual?';
	@override String replaceLayoutMessage({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: 'Se cerrará 1 pestaña, y tiene un proceso en ejecución.',
		other: 'Se cerrarán ${n} pestañas, incluidas las que tienen procesos en ejecución.',
	);
	@override String get replaceLayoutConfirm => 'Reemplazar';
	@override String get restartServerTooltip => 'Reiniciar servidor';
	@override String get noLspAvailable => 'Ningún LSP disponible';
	@override String get lspRunning => 'en ejecución';
	@override String get lspStopped => 'detenido';
}

// Path: gsh.welcomeView
class _Translations$gsh$welcomeView$es extends Translations$gsh$welcomeView$en {
	_Translations$gsh$welcomeView$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Bienvenido a GSH Desktop';
	@override String get subtitle => 'Abre una carpeta o conéctate a un host remoto para empezar.';
	@override String get createWorkspace => 'Crear workspace';
	@override String get openLocalFolder => 'Abrir carpeta local';
	@override String get connectHost => 'Conectar a un host';
	@override String get configureHost => 'Configurar host';
	@override String get addWorkspace => 'Añadir workspace';
}

// Path: gsh.paneView
class _Translations$gsh$paneView$es extends Translations$gsh$paneView$en {
	_Translations$gsh$paneView$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get closePaneTitle => '¿Cerrar panel?';
	@override String closePaneMessage({required Object count}) => 'Esto cierra todas las ${count} pestaña(s) de este panel y finaliza los agentes/terminales en él.';
	@override String get close => 'Cerrar';
	@override String get closeOtherTabs => 'Cerrar las otras';
	@override String get closeTabsToTheRight => 'Cerrar a la derecha';
	@override String get closeAllTabs => 'Cerrar todas';
	@override String get closeTabsTitle => '¿Cerrar pestañas?';
	@override String closeTabsMessage({required Object count}) => 'Esto cierra ${count} pestaña(s) y finaliza los agentes/terminales en ellas.';
	@override String get allTabs => 'Todas las pestañas';
	@override String get pinTab => 'Fijar pestaña';
	@override String get openInNewWindow => 'Abrir en ventana nueva';
	@override String get rename => 'Renombrar';
	@override String get openAsMarkdown => 'Abrir como markdown';
	@override String get openAsBoard => 'Abrir como tablero';
	@override String get resetTitle => 'Restablecer título';
	@override String get copyId => 'Copiar Id';
	@override String get restartTab => 'Reiniciar';
	@override String get newTab => 'Nueva pestaña';
	@override String get newTerminal => 'Nueva terminal…';
	@override String get splitRight => 'Dividir a la derecha';
	@override String get splitDown => 'Dividir abajo';
	@override String get closePane => 'Cerrar panel';
	@override String get dropHereToMove => 'Suelta aquí para mover la pestaña';
	@override String get dockAsTab => 'Acoplar como pestaña';
	@override String get openBrowser => 'Abrir navegador';
	@override String get openTerminal => 'Abrir terminal';
	@override String get openAsLayout => 'Abrir como diseño';
	@override String get openAsYaml => 'Abrir como YAML';
	@override String get openAsPanel => 'Abrir como panel';
	@override String get openAsHtml => 'Abrir como HTML';
}

// Path: gsh.fileTreePanel
class _Translations$gsh$fileTreePanel$es extends Translations$gsh$fileTreePanel$en {
	_Translations$gsh$fileTreePanel$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get viewDiff => 'Ver Diff';
	@override String get commit => 'Commit';
	@override String get stageAndCommit => 'Stage y Commit';
	@override String get unstage => 'Quitar del stage';
	@override String get stageChanges => 'Poner en stage';
	@override String get discardChanges => 'Descartar cambios';
	@override String get enterCommitMessage => 'Escribe un mensaje de commit.';
	@override String get commitUnavailable => 'Commit no disponible para este workspace.';
	@override String get gitErrorTitle => 'Error de Git';
	@override String get deleteNewFileTitle => '¿Eliminar archivo nuevo?';
	@override String get discardChangesTitle => '¿Descartar cambios?';
	@override String deleteNewFileMessage({required Object name}) => '"${name}" es un archivo nuevo y no se puede restaurar. ¿Eliminarlo?';
	@override String discardOneMessage({required Object name}) => '¿Descartar todos los cambios en "${name}"? Los archivos eliminados se restaurarán.';
	@override String get discard => 'Descartar';
	@override String get deleteAllNewFilesTitle => '¿Eliminar todos los archivos nuevos?';
	@override String allNewFilesMessage({required Object count}) => 'Los ${count} archivos son nuevos y se eliminarán. Esto no se puede deshacer.';
	@override String discardTrackedMessage({required Object count, required Object extra}) => '¿Descartar cambios en ${count} archivo(s) rastreado(s)?${extra}';
	@override String discardTrackedExtra({required Object count}) => ' Se mantendrán ${count} archivo(s) nuevo(s).';
	@override String get deleteAll => 'Eliminar todo';
	@override String get deleteQuestionTitle => '¿Eliminar?';
	@override String moveToTrash({required Object name}) => '¿Mover “${name}” a la Papelera?';
	@override String permanentlyDelete({required Object name}) => '¿Eliminar “${name}” de forma permanente? Esto no se puede deshacer.';
	@override String get couldNotDeleteTitle => 'No se pudo eliminar';
	@override String get moveQuestionTitle => '¿Mover?';
	@override String moveMessage({required Object name, required Object dest}) => '¿Mover “${name}” a “${dest}”?';
	@override String get moveAction => 'Mover';
	@override String get couldNotMoveTitle => 'No se pudo mover';
	@override String get couldNotPasteTitle => 'No se pudo pegar';
	@override String get filesTooltip => 'Archivos';
	@override String get searchTooltip => 'Buscar';
	@override String get sourceControlTooltip => 'Control de versiones';
	@override String get databaseTooltip => 'Base de datos';
	@override String get sectionFiles => 'ARCHIVOS';
	@override String get newFile => 'Nuevo archivo';
	@override String get newFolder => 'Nueva carpeta';
	@override String get refreshTooltip => 'Actualizar';
	@override String get agentFilterTooltip => 'Filtrar por agente';
	@override String get allAgents => 'Todos los agentes';
	@override String get trackingUnavailable => 'seguimiento no disponible';
	@override String editedBy({required Object label, required Object time}) => 'Editado por ${label} · ${time}';
	@override String get inferredSuffix => '(inferido)';
	@override String get noTouchedFiles => 'Ningún archivo tocado por este agente todavía';
	@override String get concurrentAgentEdits => 'Editado por 2+ agentes en los últimos 10 minutos';
	@override String get collapseAll => 'Contraer todas las carpetas';
	@override String get sectionSourceControl => 'CONTROL DE VERSIONES';
	@override String get viewAsList => 'Ver como lista';
	@override String get viewAsTree => 'Ver como árbol';
	@override String get noFolderMessage => 'Ninguna carpeta — abre un workspace.';
	@override String get amend => 'Amend';
	@override String get commitMessagePlaceholder => 'Mensaje del commit';
	@override String get amendCommit => 'Amend del commit';
	@override String get lastCommit => 'último commit';
	@override String get openInFinder => 'Abrir en Finder';
	@override String get openInExplorer => 'Abrir en el Explorador';
	@override String get openInFileManager => 'Abrir en el gestor de archivos';
	@override String get open => 'Abrir';
	@override String get openWith => 'Abrir con';
	@override String get openInNewWindow => 'Abrir en ventana nueva';
	@override String get openLayout => 'Abrir layout';
	@override String get openAsMarkdown => 'Abrir como markdown';
	@override String get showGitDiff => 'Mostrar diff de git';
	@override String get createTerminal => 'Abrir en terminal';
	@override String get rename => 'Renombrar';
	@override String get copy => 'Copiar';
	@override String get cut => 'Cortar';
	@override String get paste => 'Pegar';
	@override String get copyRelativePath => 'Copiar ruta relativa';
	@override String get copyAbsolutePath => 'Copiar ruta absoluta';
	@override String get renameFailed => 'No se pudo renombrar.';
	@override String get noChanges => 'Sin cambios.';
	@override String stagedChangesHeader({required Object count}) => 'CAMBIOS EN STAGE (${count})';
	@override String changesHeader({required Object count}) => 'CAMBIOS (${count})';
	@override String get discardAllChanges => 'Descartar todos los cambios';
	@override String get unstageAllChanges => 'Quitar todo del stage';
	@override String get stageAllChanges => 'Poner todo en stage';
	@override String get discardFolderChanges => 'Descartar cambios de la carpeta';
	@override String get unstageFolderChanges => 'Quitar carpeta del stage';
	@override String get stageFolderChanges => 'Poner carpeta en stage';
	@override String get generateCommitMessage => 'Generar mensaje de commit';
	@override String generateWith({required Object harness}) => 'Generar con ${harness}';
	@override String get generateUnavailableWhileAmending => 'No disponible mientras se enmienda un commit';
	@override String get cancelGeneration => 'Cancelar generación';
	@override String get changes => 'Cambios';
	@override String get history => 'Historial';
	@override String get historyRepository => 'Repositorio';
	@override String get historyNoRepository => 'No hay ningun repositorio Git disponible.';
	@override String get historyEmpty => 'No se encontraron commits.';
	@override String get historyLoadFailed => 'No se pudo cargar el historial de Git.';
	@override String get historyUntitledCommit => 'Commit sin titulo';
	@override String get historyNow => 'ahora';
	@override String historyMinutesAgo({required Object count}) => 'hace ${count} min';
	@override String historyHoursAgo({required Object count}) => 'hace ${count} h';
	@override String get historyYesterday => 'ayer';
	@override String get historyDayAgo => 'hace 1 dia';
	@override String historyDaysAgo({required Object count}) => 'hace ${count} dias';
	@override String get historyFiles => 'Archivos modificados';
	@override String get historyFilesEmpty => 'No hay archivos modificados.';
	@override String get historyFilesLoadFailed => 'No se pudieron cargar los archivos modificados.';
	@override String get diffEmptyTree => 'Arbol vacio';
	@override String diffOriginal({required Object ref}) => 'Original ${ref}';
	@override String diffModified({required Object ref}) => 'Modificado ${ref}';
	@override String get diffWorkingTree => 'Directorio de trabajo';
	@override String get diffBinaryFile => 'Archivo binario - sin diff de texto.';
	@override String get diffNoChanges => 'Sin cambios.';
	@override String diffError({required Object detail}) => 'No se pudo leer el diff: ${detail}';
	@override String get galleryTooltip => 'Galería';
	@override String get sectionGallery => 'GALERÍA';
	@override String get openAsHtml => 'Abrir como HTML';
	@override String get importQuestionTitle => '¿Copiar aquí?';
	@override String importMessage({required Object count, required Object dest}) => '¿Copiar ${count} elementos en “${dest}”?';
	@override String get importAction => 'Copiar';
	@override String get couldNotImportTitle => 'No se pudo copiar';
	@override String openInAgent({required Object harness}) => 'Abrir en ${harness}';
}

// Path: gsh.fileViewer
class _Translations$gsh$fileViewer$es extends Translations$gsh$fileViewer$en {
	_Translations$gsh$fileViewer$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cantOpen => 'No se puede abrir este archivo.';
	@override String get couldNotLoadImage => 'No se pudo cargar la imagen.';
	@override String get preview => 'Vista previa';
	@override String get source => 'Código fuente';
	@override String get reload => 'Recargar';
}

// Path: gsh.workspaceSettingsDialog
class _Translations$gsh$workspaceSettingsDialog$es extends Translations$gsh$workspaceSettingsDialog$en {
	_Translations$gsh$workspaceSettingsDialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get choosePhotoTitle => 'Elegir foto del workspace';
	@override String get title => 'Configuración del workspace';
	@override String get namePlaceholder => 'Nombre del workspace';
	@override String get addPhoto => 'Añadir foto';
	@override String get changePhoto => 'Cambiar foto';
	@override String get remove => 'Quitar';
	@override String get color => 'Color';
	@override String get host => 'Host';
	@override String get folder => 'Carpeta';
}

// Path: gsh.realmDialogs
class _Translations$gsh$realmDialogs$es extends Translations$gsh$realmDialogs$en {
	_Translations$gsh$realmDialogs$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get namePlaceholder => 'Nombre del realm';
	@override String get duplicateName => 'Ya existe un realm con ese nombre.';
	@override String get newRealmTitle => 'Nuevo realm';
	@override String get renameRealmTitle => 'Renombrar realm';
	@override String get rename => 'Renombrar';
	@override String get deleteRealmTitle => 'Eliminar realm';
	@override String deleteMessage({required Object name, required Object suffix}) => '¿Eliminar "${name}"? Ningún workspace se elimina — solo cambia la lista de carpetas.${suffix}';
	@override String get deleteSuffixOne => ' Su workspace se moverá a Predeterminado.';
	@override String deleteSuffixMany({required Object count}) => ' Sus ${count} workspaces se moverán a Predeterminado.';
	@override String get manageRealmsTitle => 'Gestionar realms';
	@override String workspaceCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 workspace',
		other: '${n} workspaces',
	);
}

// Path: gsh.dbRedisTable
class _Translations$gsh$dbRedisTable$es extends Translations$gsh$dbRedisTable$en {
	_Translations$gsh$dbRedisTable$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get deleteKeyTitle => 'Eliminar clave';
	@override String deleteKeyMessage({required Object key}) => '¿Eliminar "${key}" de esta base de datos Redis?';
	@override String get refresh => 'Actualizar';
	@override String get newKey => 'Nueva clave';
	@override String get columnKey => 'CLAVE';
	@override String get columnValue => 'VALOR';
	@override String get columnType => 'TIPO';
	@override String get columnTtl => 'TTL';
	@override String keyCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 clave',
		other: '${n} claves',
	);
	@override String get noKeys => 'No hay claves en esta base de datos.';
	@override String noKeysMatch({required Object pattern}) => 'Ninguna clave coincide con "${pattern}".';
	@override String get loadMore => 'Cargar más';
	@override String get loadingFullValue => 'Cargando valor completo…';
	@override String get ttlMustBeNumber => 'El TTL debe ser un número de segundos.';
	@override String get addKey => 'Añadir clave';
	@override String get keyFieldHint => 'clave';
	@override String get ttlFieldHint => 'ttl (s, opcional)';
	@override String get valueFieldHint => 'valor';
	@override String get searchHint => 'Buscar — patrón, ej.: user:*';
}

// Path: gsh.dbQueryView
class _Translations$gsh$dbQueryView$es extends Translations$gsh$dbQueryView$en {
	_Translations$gsh$dbQueryView$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get saveQueryAs => 'Guardar query como';
	@override String get couldNotSave => 'No se pudo guardar';
	@override String get selectDatabase => 'Seleccionar base de datos';
	@override String get noSqlConnections => 'Sin conexiones SQL';
	@override String get running => 'Ejecutando…';
	@override String get runSelection => 'Ejecutar selección';
	@override String get run => 'Ejecutar';
	@override String get pickDatabaseHint => 'Elige una base de datos arriba y luego Ejecutar (⌘↵).';
	@override String get runQueryHint => 'Ejecuta la query (⌘↵) para ver los resultados aquí.';
	@override String get noRows => 'Sin filas.';
	@override String rowsAffected({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 fila afectada',
		other: '${n} filas afectadas',
	);
	@override String rowsFooter({required Object n}) => '${n} filas';
	@override String get truncatedSuffix => ' · truncado (aumenta -- limit)';
	@override String get table => 'Tabla';
	@override String get json => 'JSON';
	@override String get unsaved => 'sin guardar';
	@override String get saved => 'guardado';
	@override String get copied => 'Copiado';
	@override String get copy => 'Copiar';
}

// Path: gsh.httpView
class _Translations$gsh$httpView$es extends Translations$gsh$httpView$en {
	_Translations$gsh$httpView$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get saveRequestAs => 'Guardar request como';
	@override String get couldNotSave => 'No se pudo guardar';
	@override String get run => 'Ejecutar';
	@override String get running => 'Ejecutando…';
	@override String get noRequests => 'Ningún request en este archivo — escribe uno, p. ej.: GET https://example.com';
	@override String get selectRequest => 'Seleccionar request';
	@override String requestCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 request',
		other: '${n} requests',
	);
	@override String get runHint => 'Ejecuta el request (⌘↵) para ver la respuesta aquí.';
	@override String get emptyBody => 'Cuerpo de la respuesta vacío.';
	@override String get body => 'JSON';
	@override String get headers => 'Headers';
	@override String get raw => 'Text';
	@override String get truncatedSuffix => ' · truncado (respuesta demasiado grande)';
	@override late final _Translations$gsh$httpView$error$es error = _Translations$gsh$httpView$error$es._(_root);
}

// Path: gsh.kanbanView
class _Translations$gsh$kanbanView$es extends Translations$gsh$kanbanView$en {
	_Translations$gsh$kanbanView$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get filter => 'Filtrar';
	@override String get filterTitlePlaceholder => 'Buscar por título';
	@override String get filterLabels => 'Etiquetas';
	@override String get filterClear => 'Limpiar';
	@override String get filterDependencies => 'Dependencias';
	@override String get filterBlocked => 'Bloqueado';
	@override String get filterReady => 'Listo';
	@override String get blockedBy => 'Bloqueado por';
	@override String get addBlocker => 'Agregar tarjeta bloqueante';
	@override String get searchCards => 'Buscar tarjetas';
	@override String get unknownCard => 'desconocida';
	@override String get boardView => 'Tablero';
	@override String get listView => 'Lista';
	@override String get refresh => 'Actualizar desde el disco';
	@override String get manageLabels => 'Etiquetas';
	@override String get labelsTitle => 'Etiquetas de este tablero';
	@override String get labelNamePlaceholder => 'nombre de la etiqueta';
	@override String labelUsage({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 tarjeta',
		other: '${n} tarjetas',
	);
	@override String get deleteLabel => 'Eliminar etiqueta';
	@override String get newCard => 'nueva tarjeta';
	@override String get newCardTitle => 'Nueva tarjeta';
	@override String get newColumn => 'Nueva columna';
	@override String get columnNameTitle => 'Nombre de la columna';
	@override String get dragColumn => 'Arrastrar columna';
	@override String get columnOptions => 'Opciones de la columna';
	@override String get renameColumn => 'Renombrar columna';
	@override String get moveColumnLeft => 'Mover a la izquierda';
	@override String get moveColumnRight => 'Mover a la derecha';
	@override String get deleteColumn => 'Eliminar columna';
	@override String get newCardHere => 'Nueva tarjeta aquí';
	@override String get duplicateCard => 'Duplicar';
	@override String get cardLabels => 'Etiquetas';
	@override String get deleteCard => 'Eliminar tarjeta';
	@override String get advance => 'Pasar a la siguiente columna';
	@override String get advanceHold => 'Mover a la siguiente columna (mantener: mover a la última)';
	@override String get advanceBack => 'Volver una columna';
	@override String get emptyColumn => 'Sin tarjetas';
	@override String cardCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 tarjeta',
		other: '${n} tarjetas',
	);
	@override String get notes => 'Nota';
	@override String get notesPlaceholder => 'Escribe una nota';
	@override String get comments => 'Comentarios';
	@override String get addComment => 'Añadir comentario';
	@override String get commentPlaceholder => 'Escribe un comentario';
	@override String get noComments => 'Aún no hay comentarios';
	@override String get closeDetail => 'Cerrar';
	@override String get notABoard => 'Este archivo aún no tiene columnas ## — se abre como markdown.';
	@override String get startBoard => 'Empezar un tablero';
	@override String get couldNotSave => 'No se pudo guardar el tablero';
	@override String get unrecognizedBlock => 'No reconocido por el analizador — se arrastra entero, sin edición en línea.';
	@override late final _Translations$gsh$kanbanView$deleteColumnDialog$es deleteColumnDialog = _Translations$gsh$kanbanView$deleteColumnDialog$es._(_root);
}

// Path: gsh.dbPanel
class _Translations$gsh$dbPanel$es extends Translations$gsh$dbPanel$en {
	_Translations$gsh$dbPanel$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionDatabase => 'BASE DE DATOS';
	@override String get edit => 'Editar…';
	@override String get copyName => 'Copiar nombre';
	@override String get newQuery => 'Nueva query';
	@override String get browseKeys => 'Ver claves';
	@override String get deleteConnectionTitle => 'Eliminar conexión';
	@override String deleteConnectionMessage({required Object name}) => '¿Quitar "${name}" de este workspace? Cualquier contraseña guardada se descartará. Los archivos .dbq que la referencian no se modifican.';
	@override String footer({required Object n}) => '.gsh/databases.json · ${n} conexiones';
	@override String get footerOne => '.gsh/databases.json · 1 conexión';
	@override String get noConnections => 'Aún no hay conexiones.';
	@override String get passwordRequired => 'Contraseña no encontrada en el host. Abre esta conexión y vuelve a escribirla — se guarda en la máquina que ejecuta la base de datos, no en esta.';
}

// Path: gsh.dbMongoView
class _Translations$gsh$dbMongoView$es extends Translations$gsh$dbMongoView$en {
	_Translations$gsh$dbMongoView$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get deleteDocumentTitle => 'Eliminar documento';
	@override String deleteDocumentMessage({required Object id, required Object collection}) => '¿Eliminar el documento con _id ${id} de "${collection}"?';
	@override String get filterHint => 'Filtro — JSON, ej.: {"status": "active"}';
	@override String docCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 doc',
		other: '${n} docs',
	);
	@override String get refresh => 'Actualizar';
	@override String get insertDocument => 'Insertar documento';
	@override String get noDocuments => 'No hay documentos en esta colección.';
	@override String get noDocumentsMatch => 'Ningún documento coincide con este filtro.';
	@override String get loadMore => 'Cargar más';
	@override String get edit => 'Editar';
	@override String get insert => 'Insertar';
}

// Path: gsh.dbConnectionDialog
class _Translations$gsh$dbConnectionDialog$es extends Translations$gsh$dbConnectionDialog$en {
	_Translations$gsh$dbConnectionDialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get chooseFileTitle => 'Elegir base de datos SQLite';
	@override String get file => 'Archivo';
	@override String get chooseFilePlaceholder => 'Elige un archivo SQLite…';
	@override String get name => 'Nombre';
	@override String get password => 'Contraseña';
	@override String get savePassword => 'Guardar contraseña';
	@override String get allowWrites => 'Permitir escritura (agentes)';
	@override String get allowWritesHint => 'desactivado = los agentes solo leen vía CLI';
	@override String get visibleToAgents => 'Visible para agentes';
	@override String get visibleToAgentsHint => 'desactivado = oculto en la CLI, solo en la GUI';
	@override String get testing => 'Probando conexión…';
	@override String get connectionOk => 'Conexión OK';
	@override String get connectionFailed => 'Fallo en la conexión';
	@override String get editTitle => 'Editar conexión';
	@override String get newTitle => 'Nueva conexión';
	@override String get connectionString => 'Connection string';
	@override String get invalidUrl => 'URL de conexión no válida.';
	@override String get sshTunnel => 'Túnel SSH';
	@override String get sshHost => 'Host SSH';
	@override String get sshPort => 'Puerto SSH';
	@override String get sshUser => 'Usuario SSH';
	@override String get privateKey => 'Clave privada';
	@override String get choosePrivateKeyPlaceholder => 'Elige una clave privada…';
	@override String get choosePrivateKeyDialogTitle => 'Elegir clave privada SSH';
	@override String get keyPassphrase => 'Frase de contraseña de la clave';
	@override String get savePassphrase => 'Guardar frase de contraseña';
	@override String get passwordOnHost => 'La contraseña se guarda en el host, no en esta máquina.';
}

// Path: gsh.sshPrompts
class _Translations$gsh$sshPrompts$es extends Translations$gsh$sshPrompts$en {
	_Translations$gsh$sshPrompts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get unknownSshHostTitle => 'Host SSH desconocido';
	@override String neverConnected({required Object endpoint}) => 'GSH Desktop nunca se ha conectado a ${endpoint} antes.';
	@override String get trustHint => 'Confía solo si esta fingerprint coincide con el servidor. Puedes verificarla en el servidor con:';
	@override String get trust => 'Confiar';
	@override String get sshKeyPassphraseTitle => 'Frase de contraseña de la clave SSH';
	@override String unlockMessage({required Object keyPath, required Object connectionName}) => 'Desbloquea ${keyPath} para conectar "${connectionName}".';
	@override String get keptInMemoryHint => 'Se mantiene en memoria hasta que GSH Desktop se cierre. Para que los agentes usen esta conexión, activa "Guardar frase de contraseña" en la conexión.';
	@override String get unlock => 'Desbloquear';
}

// Path: gsh.projectsRail
class _Translations$gsh$projectsRail$es extends Translations$gsh$projectsRail$en {
	_Translations$gsh$projectsRail$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get workspaces => 'Workspaces';
	@override String get keepAwakeOn => 'Manteniendo este equipo despierto para acceso remoto. Haz clic para dejarlo dormir de nuevo.';
	@override String get keepAwakeOff => 'Mantener este equipo despierto para acceso remoto. Se apaga solo cuando GSH Desktop se reinicia.';
	@override String get keepAwakeBattery => 'Despierto con batería. Esto consume la batería.';
	@override String get keepAwakeLid => 'Cerrar la tapa del portátil sigue poniéndolo a dormir.';
	@override String get newWorkspace => 'Nuevo workspace';
	@override String get settings => 'Configuración';
	@override String get mergeToParent => 'Fusionar en el padre';
	@override String get updateFromParent => 'Actualizar desde el padre';
	@override String get forkWorktree => 'Crear worktree derivada';
	@override String get copyBranch => 'Copiar branch';
	@override String get remove => 'Quitar';
	@override String get moveToRealm => 'Mover a realm';
	@override String get copyWorkspaceId => 'Copiar id del workspace';
	@override String get rename => 'Renombrar';
	@override String get close => 'Cerrar';
	@override String get newRealm => 'Nuevo realm…';
	@override String get manageRealms => 'Gestionar realms…';
	@override String get noWorkspaces => 'Aún no hay workspaces.';
	@override String get sync => 'Sincronizar';
	@override String get pull => 'Pull';
	@override String get push => 'Push';
	@override String get createWorktree => 'Crear worktree';
	@override String worktreeCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: '1 worktree',
		other: '${n} worktrees',
	);
	@override String get expandWorktrees => 'Expandir worktrees';
	@override String get collapseWorktrees => 'Contraer worktrees';
}

// Path: gsh.findBar
class _Translations$gsh$findBar$es extends Translations$gsh$findBar$en {
	_Translations$gsh$findBar$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get find => 'Buscar';
	@override String get matchCase => 'Coincidir mayúsculas';
	@override String get wholeWord => 'Palabra completa';
	@override String get useRegex => 'Usar expresión regular';
	@override String get previous => 'Anterior (⇧⏎)';
	@override String get next => 'Siguiente (⏎)';
	@override String get close => 'Cerrar (Esc)';
	@override String get badPattern => 'Patrón inválido';
	@override String get noResults => 'Sin resultados';
}

// Path: gsh.contentSearch
class _Translations$gsh$contentSearch$es extends Translations$gsh$contentSearch$en {
	_Translations$gsh$contentSearch$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionSearch => 'BÚSQUEDA';
	@override String get searchInFiles => 'Buscar en los archivos';
	@override String get matchCase => 'Coincidir mayúsculas';
	@override String get wholeWord => 'Palabra completa';
	@override String get useRegex => 'Usar expresión regular';
	@override String get invalidRegex => 'Expresión regular inválida.';
	@override String get typeToSearch => 'Escribe para buscar en todos los archivos.';
	@override String get searching => 'Buscando…';
	@override String get noResults => 'Sin resultados.';
}

// Path: gsh.topbar
class _Translations$gsh$topbar$es extends Translations$gsh$topbar$en {
	_Translations$gsh$topbar$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get collapseSidebar => 'Contraer barra lateral';
	@override String get toggleFiles => 'Mostrar/ocultar archivos';
	@override String get filesUnavailable => 'Archivos no disponibles en GSH Desktop';
	@override String get hideKeyboard => 'Ocultar teclado';
	@override String get visualizeAgents => 'Visualizar agentes';
	@override String get openHarness => 'Harness del workspace';
	@override String get openFarm => 'Granja de agentes';
	@override String get openChat => 'Chat con Claude (beta)';
}

// Path: gsh.tasks
class _Translations$gsh$tasks$es extends Translations$gsh$tasks$en {
	_Translations$gsh$tasks$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get hotReload => 'Hot reload';
	@override String get hotRestart => 'Hot restart';
	@override String get toggleDebugPaint => 'Alternar debug paint';
	@override String get togglePlatform => 'Alternar plataforma';
	@override String get quit => 'Salir';
}

// Path: gsh.notifications
class _Translations$gsh$notifications$es extends Translations$gsh$notifications$en {
	_Translations$gsh$notifications$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get agentFinished => 'El agente terminó';
	@override String get open => 'Abrir';
	@override String get agentNeedsAction => 'El agente necesita tu acción';
}

// Path: gsh.terminalLink
class _Translations$gsh$terminalLink$es extends Translations$gsh$terminalLink$en {
	_Translations$gsh$terminalLink$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get open => 'Abrir';
	@override String get revealFinder => 'Mostrar en Finder';
	@override String get revealExplorer => 'Mostrar en el Explorador';
	@override String get revealFolder => 'Abrir carpeta contenedora';
	@override String get copyPath => 'Copiar ruta';
	@override String get openLink => 'Abrir enlace';
	@override String get copyLink => 'Copiar enlace';
}

// Path: gsh.terminal
class _Translations$gsh$terminal$es extends Translations$gsh$terminal$en {
	_Translations$gsh$terminal$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String cwdFallbackWarning({required Object requested, required Object path}) => 'Aviso: la carpeta "${requested}" no existe. Esta terminal se abrió en "${path}".';
	@override String workspaceEnvTracked({required Object keys}) => 'Aviso: el .env.gsh está rastreado por git (vino con el repositorio). Inyectado: ${keys}';
}

// Path: gsh.remoteHost
class _Translations$gsh$remoteHost$es extends Translations$gsh$remoteHost$en {
	_Translations$gsh$remoteHost$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get addHost => 'Añadir host remoto';
	@override String get hostName => 'Nombre';
	@override String get sshTarget => 'Destino SSH (usuario@host)';
	@override String connecting({required Object host}) => 'Conectando a ${host}…';
	@override String get openingTunnel => 'Túnel SSH';
	@override String get installingServer => 'Instalando servidor';
	@override String handshake({required Object version}) => 'Servidor ${version}';
	@override String get loadingWorkspace => 'Cargando workspace…';
	@override String reconnecting({required Object host}) => 'Reconectando a ${host}…';
	@override String offline({required Object host}) => '${host} sin conexión';
	@override String get remove => 'Quitar';
	@override String get reconnect => 'Reconectar';
	@override String get installServer => 'Instalar servidor';
	@override String errSshUnreachable({required Object host}) => 'No se puede llegar a ${host} por SSH. ¿Está encendido y con Inicio de sesión remoto activado?';
	@override String errInstallFailed({required Object host}) => 'No se pudo instalar el servidor en ${host}.';
	@override String get errVersionMismatch => 'Versión del servidor incompatible; actualízalo.';
	@override String errDetail({required Object detail}) => 'Detalles: ${detail}';
	@override String pickFolderTitle({required Object host}) => 'Abrir carpeta en ${host}';
	@override String get openHere => 'Abrir aquí';
	@override String get emptyFolder => 'Sin subcarpetas';
	@override String get newLocal => 'Local';
	@override String get newRemote => 'Remoto';
	@override String get chooseHost => 'Elegir un host';
	@override String get newHostEntry => 'Nuevo host…';
	@override String get editHost => 'Editar host';
	@override String get userLabel => 'Usuario';
	@override String get hostLabel => 'Host / IP';
	@override String get portLabel => 'Puerto';
	@override String get authLabel => 'Autenticación';
	@override String get authKey => 'Clave SSH';
	@override String get authPassword => 'Contraseña';
	@override String get passwordLabel => 'Contraseña';
	@override String get passwordKeep => 'Deja en blanco para mantener la actual';
	@override String get errUser => 'Usuario obligatorio';
	@override String get errHost => 'Host obligatorio';
	@override String get errPassword => 'Contraseña obligatoria';
	@override String get identityChoose => 'Elegir…';
	@override String get identityEmpty => 'Ninguna clave seleccionada';
	@override String get identityDialogTitle => 'Selecciona la clave privada SSH';
	@override String get errIdentity => 'Elige la clave privada para autenticarte.';
	@override String errHostKeyUnknown({required Object host}) => 'GSH Desktop todavía no confía en ${host}. Conecta de nuevo y confirma la huella.';
	@override String errHostKeyChanged({required Object host}) => '${host} presenta una clave SSH distinta de la guardada. Si no reinstalaste esa máquina, detente y compruébalo; si la reinstalaste, elimina la entrada antigua de ~/.ssh/known_hosts.';
	@override String errHostBundleMissing({required Object host}) => '${host} es Windows pero no tiene GSH Desktop instalado. El servidor remoto se instala desde el bundle de GSH Desktop que ya está en esa máquina — instálalo allí e inténtalo de nuevo.';
	@override String errHostUnknownOs({required Object host}) => 'No se pudo identificar el sistema de ${host}. La cuenta puede tener un shell restringido, o ninguno.';
	@override String get errIdentityPublic => 'Solo está la clave pública. Eso funciona solo si la privada está en tu agente SSH; si no, elige la privada (mismo nombre, sin .pub).';
	@override String get errIdentityNotKey => 'Ese archivo no parece una clave privada.';
	@override String get errIdentityMissingFile => 'Ese archivo ya no existe.';
	@override String get errIdentityUnreadable => 'No se pudo leer ese archivo.';
}

// Path: gsh.browserPane
class _Translations$gsh$browserPane$es extends Translations$gsh$browserPane$en {
	_Translations$gsh$browserPane$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get back => 'Atrás';
	@override String get forward => 'Adelante';
	@override String get reload => 'Recargar';
	@override String get urlHint => 'Escribe la URL o dirección';
	@override String get go => 'Ir';
}

// Path: gsh.documentWindow
class _Translations$gsh$documentWindow$es extends Translations$gsh$documentWindow$en {
	_Translations$gsh$documentWindow$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get mediaNotSupported => 'Audio y video se abren en la ventana principal de GSH Desktop.';
	@override String fileNotFound({required Object path}) => 'Archivo no encontrado: ${path}';
}

// Path: gsh.gallery
class _Translations$gsh$gallery$es extends Translations$gsh$gallery$en {
	_Translations$gsh$gallery$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get intro => 'Documentos especiales de GSH Desktop para que veas lo que el agente de IA está haciendo.';
	@override String get createErrorTitle => 'No se pudo crear el archivo';
	@override late final _Translations$gsh$gallery$dbQuery$es dbQuery = _Translations$gsh$gallery$dbQuery$es._(_root);
	@override late final _Translations$gsh$gallery$kanban$es kanban = _Translations$gsh$gallery$kanban$es._(_root);
	@override late final _Translations$gsh$gallery$layout$es layout = _Translations$gsh$gallery$layout$es._(_root);
	@override late final _Translations$gsh$gallery$httpRequest$es httpRequest = _Translations$gsh$gallery$httpRequest$es._(_root);
	@override late final _Translations$gsh$gallery$html$es html = _Translations$gsh$gallery$html$es._(_root);
	@override late final _Translations$gsh$gallery$tasks$es tasks = _Translations$gsh$gallery$tasks$es._(_root);
	@override late final _Translations$gsh$gallery$notebook$es notebook = _Translations$gsh$gallery$notebook$es._(_root);
	@override late final _Translations$gsh$gallery$workspaceEnv$es workspaceEnv = _Translations$gsh$gallery$workspaceEnv$es._(_root);
	@override late final _Translations$gsh$gallery$panel$es panel = _Translations$gsh$gallery$panel$es._(_root);
}

// Path: gsh.notebook
class _Translations$gsh$notebook$es extends Translations$gsh$notebook$en {
	_Translations$gsh$notebook$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get notes => 'Notas';
	@override String get newNote => 'Nueva nota';
	@override String get searchPlaceholder => 'Buscar notas';
	@override String get empty => 'Aún no hay notas. Crea una, o pídele al agente que escriba aquí.';
	@override String get noMatch => 'Ninguna nota coincide.';
	@override String get selectNote => 'Selecciona una nota';
	@override String get reload => 'Recargar del disco';
	@override String get untagged => 'sin tag';
	@override String get saveFailed => 'No se pudo guardar la nota';
	@override String get createFailed => 'No se pudo crear la nota';
	@override String get addTag => 'añadir tag';
	@override String get untitled => 'Sin título';
	@override String get deleteNote => 'Eliminar nota';
	@override String deleteConfirm({required Object name}) => '¿Mover “${name}” a la papelera?';
	@override String get imageFailed => 'No se pudo guardar la imagen';
	@override late final _Translations$gsh$notebook$format$es format = _Translations$gsh$notebook$format$es._(_root);
	@override String get backlinks => 'Enlazada desde';
	@override String get renameTag => 'Renombrar tag';
	@override String get deleteTag => 'Eliminar tag';
	@override String deleteTagConfirm({required Object name, required Object count}) => '¿Quitar “${name}” de ${count} notas? Las notas se conservan.';
	@override String get showList => 'Mostrar lista de notas';
	@override String get hideList => 'Ocultar lista de notas';
}

// Path: gsh.layoutPreview
class _Translations$gsh$layoutPreview$es extends Translations$gsh$layoutPreview$en {
	_Translations$gsh$layoutPreview$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get applyFailedTitle => 'No se pudo aplicar el diseño';
	@override String get applyInGsh => 'Aplicar en GSH Desktop';
	@override String get applyNewWorkspace => 'Abrir como nuevo espacio de trabajo';
	@override String applyTo({required Object workspace}) => 'Aplicar en ${workspace}';
	@override String get autorunWorktree => 'autorun: worktree. Este diseño también se aplica solo al crear un worktree del espacio de trabajo que lo contiene.';
	@override String get command => 'Comando';
	@override String get folder => 'Carpeta';
	@override String get noCommand => 'sin comando, abre un shell';
	@override String get replaceConfirm => 'Reemplazar diseño';
	@override String replaceMessage({required Object n}) => 'Se cerrarán ${n} pestañas abiertas de este espacio de trabajo, incluidas las que tienen trabajo en curso.';
	@override String replaceTitle({required Object workspace}) => '¿Reemplazar el diseño de ${workspace}?';
	@override String get skippedTitle => 'No se crean en este sistema';
	@override String get splitDown => 'divide abajo';
	@override String get splitRight => 'divide a la derecha';
	@override String get splitTab => 'pestaña';
	@override String subtitle({required Object n}) => 'Este diseño abre ${n} terminales. Lee los comandos antes de aplicarlo.';
}

// Path: gsh.telemetry
class _Translations$gsh$telemetry$es extends Translations$gsh$telemetry$en {
	_Translations$gsh$telemetry$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tooltip => 'Telemetría';
	@override String get title => 'Telemetría';
	@override String liveRuns({required Object n}) => '${n} activos';
	@override String get noWorkspace => 'Abre un workspace para ver su telemetría.';
	@override String get empty => 'Nada por aquí todavía.';
	@override String get emptyFiltered => 'Nada por aquí todavía.';
	@override String get searchHint => 'Filtrar casos';
	@override String get chipOpen => 'Abiertos';
	@override String get chipNew => 'Nuevos';
	@override String get chipResolved => 'Resueltos';
	@override String get chipIgnored => 'Ignorados';
	@override String get chipWarnings => 'Avisos';
	@override String get tagNew => 'nuevo';
	@override String get tagRegression => 'regresión';
	@override String get tagResolved => 'resuelto';
	@override String get tagIgnored => 'ignorado';
	@override String get srcTask => 'task';
	@override String get srcWrapper => 'gsh telemetry';
	@override String run({required Object id}) => 'run ${id}';
	@override String get resolve => 'Marcar resuelto';
	@override String get ignore => 'Ignorar (también se oculta a los agentes)';
	@override String get reopen => 'Reabrir';
	@override String get clear => 'Limpiar ocurrencias';
	@override String get clearRun => 'Limpiar este run';
	@override String get clearProject => 'Limpiar proyecto';
	@override String openFile({required Object location}) => 'Abrir ${location}';
	@override String get showInTerminal => 'Ver en la terminal';
	@override String get copyCommand => 'Copiar comando de la CLI';
	@override String get copied => 'Copiado';
	@override String get statusOpen => 'Abierto';
	@override String get statusResolved => 'Resuelto';
	@override String get statusIgnored => 'Ignorado';
	@override String get occurrences => 'Ocurrencias';
	@override String inRuns({required Object n}) => 'en ${n} runs';
	@override String get first => 'Primera';
	@override String get last => 'Última';
	@override String get origin => 'Origen';
	@override String get sectionStack => 'Stack';
	@override String get stackHint => 'frames del proyecto destacados · clic abre el archivo';
	@override String get sectionCorrelated => 'Log correlacionado';
	@override String get correlatedHint => 'el JSON más cercano antes del error, en el mismo run';
	@override String get none => 'ninguno';
	@override String get sectionRuns => 'Ocurrencias por run';
	@override String get runsHint => 'misma clave (cwd, comando): así se calculan nuevo y regresión';
	@override String get sectionContext => 'Contexto crudo';
	@override String get contextHint => 'líneas de la terminal alrededor de la última ocurrencia';
	@override String get current => 'actual';
	@override String fingerprintHint({required Object location}) => 'fingerprint = tipo + mensaje normalizado + ${location}';
	@override String get blameUncommitted => 'cambiado en el working tree';
	@override String blameCommit({required Object ago, required Object sha}) => 'cambiado ${ago} (${sha})';
	@override String get justNow => 'ahora';
	@override String minutesAgo({required Object n}) => 'hace ${n} min';
	@override String hoursAgo({required Object n}) => 'hace ${n} h';
	@override String daysAgo({required Object n}) => 'hace ${n} d';
	@override String get resolvedToast => 'Resuelto. Si vuelve en un run futuro, reaparece como regresión.';
	@override String get ignoredToast => 'Ignorado. Los agentes ya no lo ven (salvo --include-ignored).';
	@override String get clearedToast => 'Ocurrencias borradas. Las reglas de triaje se mantienen.';
	@override String get byHuman => 'por ti';
	@override String get byAgent => 'por el agente';
	@override String caseTabTitle({required Object type, required Object file}) => '${type} · ${file}';
	@override String get srcApp => 'App';
	@override String get chipApp => 'GSH Desktop';
}

// Path: gsh.panelView
class _Translations$gsh$panelView$es extends Translations$gsh$panelView$en {
	_Translations$gsh$panelView$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get unavailable => 'Los paneles necesitan la web view integrada, que todavía no existe en Linux.';
	@override String get openInBrowser => 'Abrir en el navegador';
	@override String get openAsHtml => 'Abrir como HTML';
}

// Path: gsh.chat
class _Translations$gsh$chat$es extends Translations$gsh$chat$en {
	_Translations$gsh$chat$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tabTitle => 'Chat';
	@override String get emptyTitle => 'Nueva conversación';
	@override String emptySubtitle({required Object folder}) => 'Claude Code en ${folder}, con tu propio login.';
	@override String get emptyHintSend => 'Enter envía; Shift+Enter agrega una línea.';
	@override String get emptyHintPaste => 'Pega una captura con Ctrl+V o suelta archivos en el chat.';
	@override String get emptyHintMode => 'Elige el modo de permiso debajo del campo: pedir, aceptar ediciones, planificar o ignorar.';
	@override String get placeholder => 'Mensaje para Claude… (Enter envía, Shift+Enter nueva línea)';
	@override String get send => 'Enviar';
	@override String get stop => 'Detener';
	@override String get working => 'trabajando…';
	@override String get waitingYou => 'esperándote';
	@override String cost({required Object v}) => 'costo US\$ ${v}';
	@override String askPermission({required Object tool}) => '¿Permitir ${tool}?';
	@override String get allow => 'Permitir';
	@override String get deny => 'Denegar';
	@override String get allowed => 'Permitido';
	@override String get denied => 'Denegado';
	@override String startFailed({required Object detail}) => 'No pude iniciar claude: ${detail}';
	@override String engineExited({required Object code}) => 'claude terminó (código ${code}).';
	@override String turnFailed({required Object detail}) => 'El turno terminó con error: ${detail}';
	@override String get handedOff => 'La conversación sigue en una terminal con Remote Control: ábrela en el celular o en claude.ai/code. El chat aquí queda en pausa.';
	@override String peerMessageFrom({required Object name}) => 'Mensaje de ${name}';
	@override String get sessions => 'Sesiones';
	@override String get noSessions => 'Ninguna otra sesión de Claude Code en ejecución ahora.';
	@override String get listAllSessions => 'Listar todas las sesiones (pregunta al agente)…';
	@override String get askListSessions => 'Lista las sesiones a las que puedo enviar mensaje, con ListAgents, y espera a que elija una. ';
	@override String sendToSession({required Object name}) => 'Envía este mensaje a la sesión "${name}" con SendMessage y espera su respuesta: ';
	@override String get remoteControl => 'Remote Control';
	@override String get remoteControlHint => 'Continuar esta conversación en una terminal con Remote Control (celular, claude.ai/code). El motor del chat no soporta Remote Control.';
	@override String get usage => 'Uso';
	@override String usageContext({required Object used, required Object window}) => 'Contexto: ${used} de ${window}';
	@override String get usageContextNone => 'Contexto: aparece después de la primera respuesta';
	@override String get usageSession => 'Sesión (5 h)';
	@override String get usageWeek => 'Semana';
	@override String usageModelWeek({required Object model}) => '${model} esta semana';
	@override String usageResetsToday({required Object time}) => 'se reinicia a las ${time}';
	@override String usageResetsOn({required Object date, required Object time}) => 'se reinicia el ${date} a las ${time}';
	@override String get usageUnavailable => 'Uso del plan no disponible ahora.';
	@override String remoteControlActive({required Object url}) => 'Esta conversación ya está en Remote Control: continúa en el móvil o en ${url}';
	@override String get remoteControlNoSession => 'Envía un mensaje primero: Remote Control continúa una conversación existente.';
	@override String get remoteControlBusy => 'Espera a que el agente termine este turno e inténtalo de nuevo.';
	@override String get remoteControlFailed => 'No pude abrir la terminal en este workspace.';
	@override String attachmentTooLarge({required Object name}) => '${name} es demasiado grande para enviar (imágenes hasta 5 MB, PDF hasta 32 MB).';
	@override String get loadingHistory => 'Cargando la conversación…';
	@override String allowAlways({required Object rule}) => 'Permitir siempre ${rule}';
	@override String allowedAlways({required Object rule}) => 'Siempre permitido: ${rule}';
	@override String moreLines({required Object n}) => '… ${n} líneas más';
	@override String get questionTitle => 'El agente pregunta';
	@override String get other => 'Otro…';
	@override String get answer => 'Responder';
	@override String get planTitle => 'Plan del agente';
	@override String get planApprove => 'Aprobar y ejecutar';
	@override String get planRefine => 'Seguir planificando';
	@override String get planRefineHint => '¿Qué cambiar en el plan?';
	@override String get planSendRefine => 'Enviar ajuste';
	@override String get planApproved => 'Plan aprobado';
	@override String get planRefined => 'Pidió seguir planificando';
	@override String planRefinedWith({required Object text}) => 'Ajuste: ${text}';
	@override String get newChat => 'Nueva conversación';
	@override String get attach => 'Adjuntar archivos';
	@override String get modeDefault => 'Pedir permiso';
	@override String get modeAcceptEdits => 'Aceptar ediciones';
	@override String get modePlan => 'Planificar';
	@override String get modeBypass => 'Omitir permisos';
	@override String editedFiles({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n,
		one: 'Editó 1 archivo',
		other: 'Editó ${n} archivos',
	);
	@override String get thinkingTitle => 'Razonamiento';
	@override String get thinkingLive => 'Pensando…';
	@override String get stateCompleted => 'Completada';
	@override String get stateReviewReady => 'Lista para revisión';
	@override String get stateBlocked => 'Bloqueada';
	@override String get stateFailed => 'Falló';
}

// Path: gsh.harness
class _Translations$gsh$harness$es extends Translations$gsh$harness$en {
	_Translations$gsh$harness$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tabTitle => 'Harness';
	@override String subtitle({required Object path}) => 'Lo que el agente carga al ejecutarse en ${path}';
	@override String get refresh => 'Leer de nuevo';
	@override String get memory => 'Instrucciones';
	@override String get memoryDesc => 'Los CLAUDE.md que lee una sesión aquí (de esta carpeta hacia arriba), el tuyo de usuario y AGENTS.md (Codex).';
	@override String get memoryNew => 'Crear CLAUDE.md';
	@override String get skills => 'Skills';
	@override String get skillsDesc => 'Capacidades que el agente activa solo cuando la descripción coincide con la tarea.';
	@override String get agents => 'Subagentes';
	@override String get agentsDesc => 'Especialistas a los que el agente delega (con herramientas y modelo propios).';
	@override String get commands => 'Comandos';
	@override String get commandsDesc => 'Atajos /nombre que escribes en la sesión.';
	@override String get hooks => 'Hooks';
	@override String get hooksDesc => 'Comandos que se ejecutan en eventos de la sesión (antes de una herramienta, al parar...).';
	@override String get permissions => 'Permisos';
	@override String get permissionsDesc => 'Reglas de herramientas: permitir, preguntar o bloquear.';
	@override String get mcp => 'MCP';
	@override String get mcpDesc => 'Servidores de herramientas extra. Los de usuario y los locales vienen de ~/.claude.json (cámbialos con claude mcp).';
	@override String get newItem => 'Nuevo';
	@override String get editFile => 'Editar archivo';
	@override String newTitle({required Object section}) => 'Nuevo elemento en ${section}';
	@override String get create => 'Crear';
	@override String get namePlaceholder => 'nombre (se vuelve el nombre del archivo)';
	@override String get empty => 'Nada aquí todavía.';
	@override String get scopeUser => 'Usuario';
	@override String get scopeProject => 'Proyecto';
	@override String get scopeLocal => 'Local';
	@override String get allow => 'permitir';
	@override String get ask => 'preguntar';
	@override String get deny => 'bloquear';
	@override String get readOnly => 'Solo lectura aquí: usa claude mcp add/remove';
	@override String get costTitle => 'Costo fijo por turno';
	@override String costValue({required Object tokens}) => '≈ ${tokens} tokens';
	@override String get costHint => 'Lo que entra en el contexto en cada mensaje, antes de cualquier trabajo: las instrucciones completas y el nombre + descripción de cada skill, subagente y comando. Las herramientas MCP no se cuentan.';
	@override String get costTip => 'Para reducirlo: lo que solo vale a veces sale del CLAUDE.md y se vuelve skill; borra skills y comandos que nadie usa.';
	@override String perTurn({required Object tokens}) => '≈ ${tokens}/turno';
	@override String issues({required Object n}) => 'Avisos: ${n}';
	@override String get issueNoDescription => 'Sin descripción: el agente no sabe cuándo usarlo.';
	@override String get issueMissingScript => 'El script que ejecuta este hook no existe.';
	@override String get issueTooLarge => 'Demasiado grande: pesa en cada mensaje (Claude Code avisa por encima de 40 mil caracteres).';
	@override String invalidJson({required Object file}) => '${file}: JSON inválido — Claude Code ignora este archivo entero.';
	@override String showAll({required Object n}) => 'Mostrar todos (${n})';
	@override String get showLess => 'Mostrar menos';
}

// Path: gsh.farm
class _Translations$gsh$farm$es extends Translations$gsh$farm$en {
	_Translations$gsh$farm$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tabTitle => 'Granja';
	@override String get title => 'Granja de agentes';
	@override String get emptyTitle => 'Ningún agente en ejecución';
	@override String get emptyHint => 'Cada loop de Claude Code en esta máquina aparece aquí mientras trabaja, incluidos subagentes y sesiones fuera de GSH Desktop.';
	@override String working({required Object n}) => '${n} trabajando';
	@override String waiting({required Object n}) => '${n} te necesitan';
	@override String get waitingOne => '1 te necesita';
	@override String idle({required Object n}) => '${n} inactivos';
	@override String get doorTitle => 'Llamando a tu puerta';
	@override String doorMessage({required Object name, required Object agent, required Object target}) => '${name} (agente ${agent}) quiere hablar con tu agente ${target}';
	@override String doorFile({required Object name, required Object agent, required Object file, required Object target}) => '${name} (agente ${agent}) quiere entregar ${file} a tu agente ${target}';
	@override String get doorOpen => 'Abrir la puerta';
	@override String get doorRefuse => 'Rechazar';
	@override String peerOf({required Object name}) => 'de ${name}';
	@override String peerBanner({required Object name}) => 'Granja de ${name}';
	@override String spent({required Object total}) => 'Gastó ${total} tokens';
	@override String spentDetail({required Object input, required Object cache, required Object out}) => '${input} entrada · ${cache} caché · ${out} generados';
	@override String context({required Object ctx}) => 'contexto ${ctx}';
	@override String spentHud({required Object n}) => '${n} tokens gastados';
	@override String get clickToOpen => 'Haz clic para abrir su terminal';
	@override String get outsideGsh => 'Este agente se ejecuta fuera de GSH Desktop. Su terminal está en otra ventana.';
	@override String agents({required Object n}) => '${n} agentes';
	@override String subagents({required Object n}) => '${n} subagentes';
	@override late final _Translations$gsh$farm$activity$es activity = _Translations$gsh$farm$activity$es._(_root);
}

// Path: gsh.agentGraph
class _Translations$gsh$agentGraph$es extends Translations$gsh$agentGraph$en {
	_Translations$gsh$agentGraph$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get tabTitle => 'Agentes';
	@override String get newAgent => 'Nuevo agente';
	@override String get emptyTitle => 'No hay agentes en este workspace';
	@override String get emptyHint => 'Inicia un agente en una terminal o crea uno aquí. Arrastra desde el puerto de un agente hasta otro para conectarlos.';
	@override String get statusWorking => 'Trabajando';
	@override String get statusWaiting => 'Esperando';
	@override String get statusIdle => 'Inactivo';
	@override String messageCount({required Object n}) => 'Mensajes: ${n}';
	@override String lastMessage({required Object preview}) => 'Último: ${preview}';
	@override String get linked => 'Conectado';
	@override String get removeLinkHint => 'Clic derecho para quitar la conexión';
	@override String get removeLink => 'Quitar conexión';
	@override String get connectHint => 'Arrastra hasta otro agente para conectar';
	@override String get quickStart => 'Inicio rápido';
	@override String get shell => 'Shell';
	@override String get tabDetails => 'Detalles';
	@override String get tabAppearance => 'Apariencia';
	@override String get tabAgent => 'Agente';
	@override String get name => 'Nombre del terminal';
	@override String get namePlaceholder => 'p. ej. Revisor';
	@override String get nameTaken => 'Otra pestaña ya usa este nombre. Los nombres deben ser únicos para que `gsh msg --to` la encuentre.';
	@override String get command => 'Comando';
	@override String get commandPlaceholder => 'p. ej. claude --model opus (vacío = shell)';
	@override String get cwd => 'Directorio de trabajo';
	@override String get browse => 'Examinar…';
	@override String get cwdMissing => 'Esta carpeta no existe.';
	@override String get monitor => 'Monitorear actividad';
	@override String get monitorHint => 'Insignia, sonido y notificación cuando termina un turno.';
	@override String get maestro => 'Maestro';
	@override String get maestroTooltip => 'Promueve este agente a maestro: queda conectado a todos los agentes del lienzo y los coordina.';
	@override String maestroReplaces({required Object name}) => '${name} es el maestro actual y dejará de serlo.';
	@override String get color => 'Color';
	@override String get colorAuto => 'Automático';
	@override String get role => 'Rol / instrucciones';
	@override String get rolePlaceholder => 'Se envía como primer mensaje cuando el agente esté listo.';
	@override String get task => 'Tarea inicial';
	@override String get taskPlaceholder => 'Se envía justo después del rol.';
	@override String get focus => 'Enfocar';
	@override String get rename => 'Renombrar';
	@override String get renameTitle => 'Renombrar agente';
	@override String get makeMaestro => 'Hacer maestro';
	@override String get removeMaestro => 'Quitar maestro';
	@override String get closeTab => 'Cerrar pestaña';
	@override String get removeFromCanvas => 'Quitar del lienzo';
	@override String get desktopApps => 'Apps de escritorio';
	@override String get desktopBadge => 'escritorio';
	@override String get statusOnline => 'En línea';
	@override String get statusOffline => 'Desconectado';
	@override String queued({required Object n}) => '${n} en cola';
	@override String get agentName => 'Nombre';
	@override String get integration => 'Integración';
	@override String get integrationHint => 'GSH Desktop agrega un servidor MCP llamado "gsh" a este archivo y guarda una copia de seguridad al lado. Los demás servidores no se tocan.';
	@override String integrationConsent({required Object app}) => 'Agregar el servidor MCP de GSH Desktop a la configuración de ${app}';
	@override String restartHint({required Object app}) => 'Reinicia ${app} si ya estaba abierto para que cargue el servidor MCP de GSH Desktop; luego pídele que llame a wait_messages.';
	@override late final _Translations$gsh$agentGraph$integrationError$es integrationError = _Translations$gsh$agentGraph$integrationError$es._(_root);
}

// Path: settings.language
class _Translations$settings$language$es extends Translations$settings$language$en {
	_Translations$settings$language$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Idioma';
	@override String get system => 'Sistema';
	@override String get english => 'Inglés';
	@override String get portugueseBr => 'Portugués (BR)';
	@override String get spanish => 'Español';
}

// Path: settings.page
class _Translations$settings$page$es extends Translations$settings$page$en {
	_Translations$settings$page$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _Translations$settings$page$header$es header = _Translations$settings$page$header$es._(_root);
	@override late final _Translations$settings$page$nav$es nav = _Translations$settings$page$nav$es._(_root);
	@override late final _Translations$settings$page$general$es general = _Translations$settings$page$general$es._(_root);
	@override late final _Translations$settings$page$diagnostics$es diagnostics = _Translations$settings$page$diagnostics$es._(_root);
	@override late final _Translations$settings$page$storage$es storage = _Translations$settings$page$storage$es._(_root);
	@override late final _Translations$settings$page$terminal$es terminal = _Translations$settings$page$terminal$es._(_root);
	@override late final _Translations$settings$page$appearance$es appearance = _Translations$settings$page$appearance$es._(_root);
	@override late final _Translations$settings$page$notifications$es notifications = _Translations$settings$page$notifications$es._(_root);
	@override late final _Translations$settings$page$shortcuts$es shortcuts = _Translations$settings$page$shortcuts$es._(_root);
	@override late final _Translations$settings$page$languages$es languages = _Translations$settings$page$languages$es._(_root);
	@override late final _Translations$settings$page$automations$es automations = _Translations$settings$page$automations$es._(_root);
	@override late final _Translations$settings$page$claudeCode$es claudeCode = _Translations$settings$page$claudeCode$es._(_root);
	@override late final _Translations$settings$page$placeholder$es placeholder = _Translations$settings$page$placeholder$es._(_root);
	@override late final _Translations$settings$page$claude$es claude = _Translations$settings$page$claude$es._(_root);
	@override late final _Translations$settings$page$account$es account = _Translations$settings$page$account$es._(_root);
	@override late final _Translations$settings$page$usage$es usage = _Translations$settings$page$usage$es._(_root);
	@override late final _Translations$settings$page$memory$es memory = _Translations$settings$page$memory$es._(_root);
	@override late final _Translations$settings$page$skills$es skills = _Translations$settings$page$skills$es._(_root);
	@override late final _Translations$settings$page$connectors$es connectors = _Translations$settings$page$connectors$es._(_root);
	@override late final _Translations$settings$page$plugins$es plugins = _Translations$settings$page$plugins$es._(_root);
	@override late final _Translations$settings$page$developer$es developer = _Translations$settings$page$developer$es._(_root);
	@override late final _Translations$settings$page$system$es system = _Translations$settings$page$system$es._(_root);
	@override late final _Translations$settings$page$catalog$es catalog = _Translations$settings$page$catalog$es._(_root);
	@override late final _Translations$settings$page$generalClaude$es generalClaude = _Translations$settings$page$generalClaude$es._(_root);
	@override late final _Translations$settings$page$privacy$es privacy = _Translations$settings$page$privacy$es._(_root);
	@override late final _Translations$settings$page$resources$es resources = _Translations$settings$page$resources$es._(_root);
	@override late final _Translations$settings$page$designSystems$es designSystems = _Translations$settings$page$designSystems$es._(_root);
}

// Path: settings.remoteHosts
class _Translations$settings$remoteHosts$es extends Translations$settings$remoteHosts$en {
	_Translations$settings$remoteHosts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Hosts remotos';
	@override String get description => 'Máquinas a las que accedes por SSH. Añadir un host aquí es lo mismo que hacerlo desde el menú "+" del workspace.';
	@override String get empty => 'Aún no hay hosts remotos.';
	@override String get add => 'Añadir host';
	@override String get edit => 'Editar';
	@override String get reconnect => 'Reconectar';
	@override String get remove => 'Eliminar';
	@override String get removeTitle => 'Eliminar host';
	@override String removeMessage({required Object name}) => '¿Eliminar "${name}" y todos sus workspaces? No se borra nada en el host.';
	@override String workspacesCount({required Object count}) => '${count} workspace(s)';
	@override String get deviceKeyTitle => 'Clave de este dispositivo';
	@override String get deviceKeyDesc => 'Añade esta clave pública a ~/.ssh/authorized_keys del host para que este dispositivo pueda conectarse.';
	@override String get deviceKeyCopy => 'Copiar clave pública';
	@override String get deviceKeyCopied => 'Clave pública copiada';
	@override String get statusConnected => 'Conectado';
	@override String get statusConnecting => 'Conectando…';
	@override String get statusReconnecting => 'Reconectando…';
	@override String get statusOffline => 'Sin conexión';
	@override String get statusIdle => 'No conectado';
	@override String get helpTitle => 'Cómo funciona';
	@override String get helpBody => 'GSH Desktop se conecta a tu máquina por SSH y habla con un pequeño servidor que ejecuta las terminales, archivos y git allí. El host debe tener GSH Desktop (escritorio) o el gsh-server instalado y en ejecución, y la clave pública de este dispositivo añadida en su ~/.ssh/authorized_keys.';
}

// Path: automation.error
class _Translations$automation$error$es extends Translations$automation$error$en {
	_Translations$automation$error$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String unavailable({required Object harness}) => '${harness} no está instalado o no está en el PATH.';
	@override String modelUnavailable({required Object model, required Object harness}) => 'El modelo "${model}" no está disponible para ${harness}. Elige otro modelo en Configuración.';
	@override String authentication({required Object harness, required Object detail}) => '${harness}: ${detail}';
	@override String timeout({required Object harness, required Object seconds}) => '${harness} no respondió en ${seconds} segundos.';
	@override String get cancelled => 'Se canceló la generación del mensaje de commit.';
	@override String process({required Object harness, required Object detail}) => '${harness}: ${detail}';
	@override String processNoDetail({required Object harness}) => '${harness} no pudo generar un mensaje de commit.';
	@override String get invalidResponse => 'La automatización devolvió un mensaje de commit vacío.';
	@override String get busy => 'Ya se está generando otro mensaje de commit.';
	@override String get unknown => 'La automatización no pudo generar un mensaje de commit.';
	@override String get noWorkspace => 'Ningún workspace seleccionado.';
	@override String get fileOutsideWorkspace => 'El archivo está fuera de las raíces del workspace.';
	@override String fileUnreadable({required Object detail}) => 'No se pudo leer el archivo: ${detail}';
	@override String get binaryFile => 'No se puede generar un mensaje de commit para un archivo binario.';
	@override String get noFileChanges => 'No hay cambios que describir en este archivo.';
	@override String get noStagedChanges => 'No hay cambios en stage que describir.';
	@override String get multipleRepositories => 'Los cambios en stage pertenecen a varios repositorios. Genéralos por separado.';
	@override String get diffUnavailable => 'No se pudo leer el diff.';
	@override String get notConfigured => 'Configura un harness de mensajes de commit en Configuración.';
}

// Path: fileOperation.error
class _Translations$fileOperation$error$es extends Translations$fileOperation$error$en {
	_Translations$fileOperation$error$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String alreadyExists({required Object name}) => 'Ya existe: “${name}”.';
	@override String notFound({required Object name}) => 'No se encontró: “${name}”.';
	@override String get invalidPath => 'Ruta inválida.';
	@override String get emptyName => 'El nombre no puede estar vacío.';
	@override String get noWorkspace => 'Ningún workspace seleccionado.';
	@override String get cannotMoveIntoItself => 'No se puede mover una carpeta dentro de sí misma.';
	@override String get clipboardEmpty => 'El portapapeles está vacío.';
	@override String get notScratchTab => 'Esta pestaña no es un archivo temporal.';
	@override String get writeFailed => 'No se pudo escribir el archivo.';
	@override String get formatterEmptyCommand => 'Comando de formato vacío.';
	@override String get formatterMissingPlaceholder => 'El comando de formato debe incluir el marcador %FILE%.';
	@override String get formatterTimeout => 'El formateador agotó el tiempo de espera.';
	@override String formatterExitCode({required Object code}) => 'El formateador terminó con el código ${code}.';
	@override String get formatterFailed => 'No se pudo ejecutar el formateador.';
	@override String osFailure({required Object detail}) => '${detail}';
	@override String get nameHasSlash => 'El nombre no puede contener “/”.';
	@override String get invalidName => 'Nombre inválido.';
	@override String get remoteDropUnsupported => 'Soltar archivos en un workspace remoto todavía no está soportado.';
}

// Path: theme.error
class _Translations$theme$error$es extends Translations$theme$error$en {
	_Translations$theme$error$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get io => 'No se pudo leer o escribir el archivo del tema.';
	@override String ioDetail({required Object detail}) => 'No se pudo leer o escribir el archivo del tema: ${detail}';
	@override String malformedJson({required Object detail}) => 'Este archivo no es JSON válido: ${detail}';
	@override String get invalidTheme => 'Este archivo no es un tema válido.';
	@override String get reservedId => 'Este tema usa el id de un tema nativo. Cambia el "id" en el archivo e impórtalo de nuevo.';
	@override String notAnObject({required Object field}) => 'Se esperaba un objeto en "${field}".';
	@override String missingField({required Object field}) => 'Falta el campo obligatorio "${field}".';
	@override String badColor({required Object value, required Object field}) => '"${value}" en "${field}" no es un color. Usa #RGB, #RRGGBB o #RRGGBBAA.';
	@override String unknownBase({required Object value}) => 'Tema base "${value}" desconocido en "extends".';
	@override String get noVariants => 'El tema no declara ningún variant. Añade "dark", "light" o ambos en "variants".';
}

// Path: gsh.httpView.error
class _Translations$gsh$httpView$error$es extends Translations$gsh$httpView$error$en {
	_Translations$gsh$httpView$error$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Falló el request';
	@override String get noRequest => 'No se encontró ningún request en la posición del cursor.';
	@override String invalidUrl({required Object url}) => 'URL inválida: ${url}';
	@override String unresolvedVariable({required Object name}) => 'La variable {{${name}}} no tiene valor. Declárala con @${name} = … en este archivo.';
	@override String bodyFileMissing({required Object path}) => 'Archivo de cuerpo no encontrado: ${path}';
	@override String bodyFileUnreadable({required Object path, required Object detail}) => 'No se pudo leer el archivo de cuerpo ${path}: ${detail}';
	@override String connectionFailed({required Object detail}) => 'No se pudo alcanzar el servidor: ${detail}';
	@override String get connectionFailedNoDetail => 'No se pudo alcanzar el servidor.';
	@override String timeout({required Object seconds}) => 'El request superó el tiempo límite de ${seconds}s.';
	@override String responseTooLarge({required Object bytes}) => 'La respuesta superó el límite de ${bytes} bytes.';
}

// Path: gsh.kanbanView.deleteColumnDialog
class _Translations$gsh$kanbanView$deleteColumnDialog$es extends Translations$gsh$kanbanView$deleteColumnDialog$en {
	_Translations$gsh$kanbanView$deleteColumnDialog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => '¿Eliminar «${name}»?';
	@override String message({required Object count}) => 'Esta columna tiene ${count}. Elige qué pasa con ellas.';
	@override String get moveCards => 'Mover a la columna anterior';
	@override String get deleteAll => 'Eliminar junto con la columna';
	@override String get emptyMessage => 'Esta columna está vacía.';
}

// Path: gsh.gallery.dbQuery
class _Translations$gsh$gallery$dbQuery$es extends Translations$gsh$gallery$dbQuery$en {
	_Translations$gsh$gallery$dbQuery$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Consulta de base de datos';
	@override String get description => 'Editor SQL con grilla de resultados, usando una de las conexiones registradas.';
}

// Path: gsh.gallery.kanban
class _Translations$gsh$gallery$kanban$es extends Translations$gsh$gallery$kanban$en {
	_Translations$gsh$gallery$kanban$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tablero kanban';
	@override String get description => 'Columnas y tarjetas guardadas como markdown puro. Arrastra, edita y comenta.';
}

// Path: gsh.gallery.layout
class _Translations$gsh$gallery$layout$es extends Translations$gsh$gallery$layout$en {
	_Translations$gsh$gallery$layout$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Layout de paneles';
	@override String get description => 'Terminales y splits para abrir de una vez, estilo tmuxinator. Puede ejecutarse solo en worktrees nuevos.';
}

// Path: gsh.gallery.httpRequest
class _Translations$gsh$gallery$httpRequest$es extends Translations$gsh$gallery$httpRequest$en {
	_Translations$gsh$gallery$httpRequest$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Requests HTTP';
	@override String get description => 'Escribe requests en un archivo y ejecútalos con la respuesta al lado.';
}

// Path: gsh.gallery.html
class _Translations$gsh$gallery$html$es extends Translations$gsh$gallery$html$en {
	_Translations$gsh$gallery$html$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Vista HTML';
	@override String get description => 'Una página que el agente escribe y GSH Desktop renderiza directo: mapa mental, diagrama, gráfico, lo que necesites.';
}

// Path: gsh.gallery.tasks
class _Translations$gsh$gallery$tasks$es extends Translations$gsh$gallery$tasks$en {
	_Translations$gsh$gallery$tasks$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tareas';
	@override String get description => 'Comandos para ejecutar desde el panel de Tasks, como dev server, tests y build. Vive en .gsh/tasks.json.';
}

// Path: gsh.gallery.notebook
class _Translations$gsh$gallery$notebook$es extends Translations$gsh$gallery$notebook$en {
	_Translations$gsh$gallery$notebook$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cuaderno';
	@override String get description => 'Una carpeta de notas cortas con tags. El agente escribe, tú lees y editas. También abre en Obsidian.';
}

// Path: gsh.gallery.workspaceEnv
class _Translations$gsh$gallery$workspaceEnv$es extends Translations$gsh$gallery$workspaceEnv$en {
	_Translations$gsh$gallery$workspaceEnv$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Env del workspace';
	@override String get description => 'Variables inyectadas en cada terminal de este workspace. Pon tokens o credenciales de API aquí en vez de pegarlos en el prompt del agente. Queda fuera de git.';
}

// Path: gsh.gallery.panel
class _Translations$gsh$gallery$panel$es extends Translations$gsh$gallery$panel$en {
	_Translations$gsh$gallery$panel$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Panel';
	@override String get description => 'Una página HTML con puente a la app: sus botones ejecutan comandos de la CLI de GSH Desktop y del shell en esta máquina. Un playground para dashboards rápidos.';
}

// Path: gsh.notebook.format
class _Translations$gsh$notebook$format$es extends Translations$gsh$notebook$format$en {
	_Translations$gsh$notebook$format$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get bold => 'Negrita (⌘B)';
	@override String get italic => 'Cursiva (⌘I)';
	@override String get strike => 'Tachado';
	@override String get heading1 => 'Título 1';
	@override String get heading2 => 'Título 2';
	@override String get heading3 => 'Título 3';
	@override String get bullets => 'Lista';
	@override String get numbered => 'Lista numerada';
	@override String get checklist => 'Checklist';
	@override String get quote => 'Cita';
	@override String get code => 'Código inline (⌘E)';
	@override String get codeBlock => 'Bloque de código';
	@override String get link => 'Enlace (⌘K)';
	@override String get rule => 'Divisor';
	@override String get noteLink => 'Enlace a una nota ([[…]])';
	@override String get noteLinkSearch => 'Buscar notas';
	@override String get image => 'Insertar imagen…';
}

// Path: gsh.farm.activity
class _Translations$gsh$farm$activity$es extends Translations$gsh$farm$activity$en {
	_Translations$gsh$farm$activity$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get thinking => 'pensando';
	@override String get reading => 'leyendo';
	@override String get editing => 'editando';
	@override String get running => 'ejecutando comando';
	@override String get searching => 'buscando en la web';
	@override String get delegating => 'delegando';
	@override String get tooling => 'usando herramienta';
	@override String get waiting => 'esperándote';
	@override String get idle => 'inactivo';
	@override String get sleeping => 'dormido';
	@override String get done => 'terminado';
}

// Path: gsh.agentGraph.integrationError
class _Translations$gsh$agentGraph$integrationError$es extends Translations$gsh$agentGraph$integrationError$en {
	_Translations$gsh$agentGraph$integrationError$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String invalidConfig({required Object path}) => '${path} no es un JSON/TOML simple que GSH Desktop pueda editar con seguridad (comentarios u otro formato). No se cambió nada.';
	@override String cliMissing({required Object path}) => 'La CLI de GSH Desktop aún no está instalada (${path}). Reinicia GSH Desktop e inténtalo de nuevo.';
	@override String writeFailed({required Object detail}) => 'No se pudo actualizar la configuración: ${detail}';
}

// Path: settings.page.header
class _Translations$settings$page$header$es extends Translations$settings$page$header$en {
	_Translations$settings$page$header$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get back => 'Atrás';
	@override String get title => 'Configuración';
}

// Path: settings.page.nav
class _Translations$settings$page$nav$es extends Translations$settings$page$nav$en {
	_Translations$settings$page$nav$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sideGsh => 'GSH Desktop';
	@override String get sideClaude => 'Claude';
	@override String get general => 'General';
	@override String get appearance => 'Apariencia';
	@override String get terminal => 'Terminal';
	@override String get language => 'Lenguaje';
	@override String get shortcuts => 'Atajos';
	@override String get notifications => 'Notificaciones';
	@override String get automations => 'Automatizaciones';
	@override String get remoteHosts => 'Hosts remotos';
	@override String get claudeCode => 'Claude Code';
	@override String get search => 'Buscar';
	@override String get account => 'Cuenta';
	@override String get privacy => 'Privacidad';
	@override String get usage => 'Uso';
	@override String get resources => 'Recursos';
	@override String get memory => 'Memoria';
	@override String get designSystems => 'Design systems';
	@override String get cowork => 'Cowork';
	@override String get system => 'Sistema';
	@override String get extensions => 'Extensiones';
	@override String get developer => 'Desarrollador';
	@override String get skills => 'Skills';
	@override String get connectors => 'Conectores';
	@override String get plugins => 'Plugins';
	@override String get apiKeys => 'Claves de API';
	@override late final _Translations$settings$page$nav$groups$es groups = _Translations$settings$page$nav$groups$es._(_root);
}

// Path: settings.page.general
class _Translations$settings$page$general$es extends Translations$settings$page$general$en {
	_Translations$settings$page$general$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionEditor => 'Editor';
	@override String get editorEngineTitle => 'Motor';
	@override String get editorEngineGsh => 'GSH Desktop (predeterminado)';
	@override String get editorEngineNeovim => 'Neovim';
	@override String get neovimChecking => 'Buscando Neovim…';
	@override String get neovimNotFound => 'Neovim no se encontró en la PATH de tu shell.';
	@override String get neovimRefresh => 'Comprobar de nuevo';
	@override String get showGshTitle => 'Mostrar terminal de GSH Desktop';
	@override String get showGshDesc => 'Mantiene un workspace sin carpeta, solo de terminal, fijado en la parte superior de la barra lateral. Desactivarlo cierra sus terminales.';
	@override String get launchAtStartupTitle => 'Iniciar al arrancar';
	@override String get launchAtStartupDesc => 'Inicia GSH Desktop automáticamente cuando inicias sesión en tu computadora.';
	@override String get sectionUpdates => 'Actualizaciones';
	@override String get checkUpdatesTitle => 'Buscar actualizaciones';
	@override String get checkUpdatesDesc => 'Con qué frecuencia GSH Desktop debe buscar nuevas versiones.';
	@override late final _Translations$settings$page$general$updateFrequency$es updateFrequency = _Translations$settings$page$general$updateFrequency$es._(_root);
	@override String get developerModeTitle => 'Modo desarrollador';
	@override String get developerModeDesc => 'Registra los errores y avisos del propio GSH Desktop en una base aparte de la Telemetría (chip “GSH Desktop”) y activa las métricas de rendimiento. Solo sirve a quien mantiene la app.';
}

// Path: settings.page.diagnostics
class _Translations$settings$page$diagnostics$es extends Translations$settings$page$diagnostics$en {
	_Translations$settings$page$diagnostics$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionTitle => 'Diagnóstico';
	@override String get logFileTitle => 'Archivo de registro';
	@override String logFileDesc({required Object days, required Object path}) => 'Los errores y eventos de inicio se registran aquí, y se conservan durante ${days} días.\n${path}';
	@override String get unavailable => 'no disponible';
	@override String get reveal => 'Mostrar';
	@override String get reportTitle => 'Reportar un problema';
	@override String get reportDesc => 'Abre un issue prellenado con tu versión, SO y registro reciente. Nada se envía automáticamente — lo revisas antes.';
	@override String get reportButton => 'Reportar…';
	@override String get reportDialogTitle => 'Informe de problema';
	@override String get reportDialogError => 'Reportado manualmente desde Configuración.';
	@override String get reportDialogDescription => 'Describe qué salió mal en el issue. El registro reciente está incluido abajo y en "Copiar detalles".';
}

// Path: settings.page.storage
class _Translations$settings$page$storage$es extends Translations$settings$page$storage$en {
	_Translations$settings$page$storage$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionTitle => 'Almacenamiento';
	@override String get locationTitle => 'Ubicación de almacenamiento';
	@override String locationDesc({required Object root}) => 'GSH Desktop guarda aquí sus proyectos, diseños y configuración. Apúntalo a una carpeta sincronizada para respaldarlo.\n${root}';
	@override String get useDefault => 'Usar predeterminado';
	@override String get working => 'Procesando…';
	@override String get change => 'Cambiar…';
	@override String get resetTitle => 'Restablecer GSH Desktop';
	@override String get resetDesc => 'Elimina todos los datos locales — proyectos, diseños, configuración e historial de terminal — y vuelve a la ubicación predeterminada.';
	@override String get resetButton => 'Restablecer…';
	@override String get resetConfirm => 'Restablecer';
	@override String get resetDialogTitle => '¿Restablecer GSH Desktop?';
	@override String get resetDialogContent => 'Esto elimina permanentemente todos los datos locales de GSH Desktop — proyectos, diseños, configuración e historial de terminal. Esto no se puede deshacer. GSH Desktop se cerrará para que puedas empezar de nuevo.';
	@override String get restartRequiredTitle => 'Reinicio necesario';
	@override String restartChangeFolderMessage({required Object path}) => 'GSH Desktop usará esta carpeta a partir del próximo inicio:\n${path}';
	@override String get restartUseDefaultMessage => 'GSH Desktop usará la ubicación predeterminada del sistema a partir del próximo inicio. Tus datos en la carpeta personalizada permanecen intactos.';
	@override String get restartResetMessage => 'Se borraron todos los datos de GSH Desktop. Reinicia para empezar de nuevo.';
	@override String get later => 'Más tarde';
	@override String get quitGsh => 'Salir de GSH Desktop';
	@override String get chooseFolderDialogTitle => 'Elige una carpeta para los datos de GSH Desktop';
}

// Path: settings.page.terminal
class _Translations$settings$page$terminal$es extends Translations$settings$page$terminal$en {
	_Translations$settings$page$terminal$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionDefaultTerminal => 'Terminal predeterminado';
	@override String get engineTitle => 'Motor';
	@override String get engineDesc => 'Usado por nuevas pestañas de terminal y buffers de salida de tasks. Las pestañas abiertas mantienen su motor actual.';
	@override String get shellTitle => 'Shell';
	@override String get shellDesc => 'Qué shell abren las nuevas pestañas de terminal. La flecha junto al + sigue abriendo cualquier otro, solo para esa pestaña.';
	@override String get noWslMessage => 'No se encontraron distros de WSL. Instala una (wsl.exe --install) y reinicia GSH Desktop para verla listada aquí.';
	@override String get sectionBehavior => 'Comportamiento';
	@override String get closeOnExitTitle => 'Cerrar la pestaña cuando el shell termine';
	@override String get closeOnExitDesc => 'Cuando un shell termina por sí solo (exit, Ctrl-D), cierra su pestaña en lugar de dejar un terminal muerto.';
}

// Path: settings.page.appearance
class _Translations$settings$page$appearance$es extends Translations$settings$page$appearance$en {
	_Translations$settings$page$appearance$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionTheme => 'Tema';
	@override String get themeTitle => 'Tema';
	@override String get themeDesc => 'Colores de la app, resaltado de código y paleta del terminal.';
	@override String get modeTitle => 'Modo';
	@override String get modeDesc => 'Qué variante del tema usar.';
	@override String modeOnlyDark({required Object theme}) => '"${theme}" solo trae la variante oscura, así que esto no tiene efecto.';
	@override String modeOnlyLight({required Object theme}) => '"${theme}" solo trae la variante clara, así que esto no tiene efecto.';
	@override String get themeFileTitle => 'Archivo de tema';
	@override String get themeFileDesc => 'Importa un tema desde un archivo JSON, o exporta el activo.';
	@override String get previewCode => 'Código';
	@override String get previewTerminal => 'Terminal';
	@override String get themeSystem => 'Sistema';
	@override String get themeLight => 'Claro';
	@override String get themeDark => 'Oscuro';
	@override String get sectionFonts => 'Fuentes';
	@override String get interfaceFontTitle => 'Fuente de la interfaz';
	@override String get interfaceFontDesc => 'Se usa en toda la aplicación. Vacío = predeterminado del sistema.';
	@override String get interfaceSizeTitle => 'Tamaño de la interfaz';
	@override String get codeFontTitle => 'Fuente del código';
	@override String get codeFontDesc => 'Código y diffs. Vacío = predeterminado del sistema.';
	@override String get codeSizeTitle => 'Tamaño del código';
	@override String get terminalFontTitle => 'Fuente del terminal';
	@override String get terminalFontDesc => 'Solo la terminal. Vacío = predeterminado del sistema.';
	@override String get terminalSizeTitle => 'Tamaño de la terminal';
	@override String get terminalSizeDesc => 'Apagado = sigue el tamaño del código.';
	@override String get terminalSizeInherit => 'Seguir el código';
	@override String get terminalWeightTitle => 'Grosor de la terminal';
	@override String get terminalWeightDesc => 'Las pantallas de baja densidad engrosan los trazos. El automático los afina solo ahí y no toca la Retina.';
	@override String get terminalWeightAuto => 'Automático (según la pantalla)';
	@override String get terminalWeightLight => 'Fino';
	@override String get terminalWeightNormal => 'Normal';
	@override String get terminalWeightMedium => 'Medio';
	@override String get terminalWeightSemiBold => 'Seminegrita';
	@override String get sectionConversation => 'Conversación';
	@override String get pinUserMessageTitle => 'Fijar mensaje del usuario';
	@override String get pinUserMessageDesc => 'La pregunta permanece fija arriba mientras la respuesta se desplaza.';
	@override String get importTheme => 'Importar…';
	@override String get exportTheme => 'Exportar…';
	@override String get deleteTheme => 'Eliminar';
	@override String get importThemeDialog => 'Elige un archivo de tema';
	@override String get exportThemeDialog => 'Guardar tema como';
	@override String themeImported({required Object name}) => 'Tema "${name}" importado.';
	@override String get themeExported => 'Tema guardado.';
	@override String get themeDeleted => 'Tema eliminado.';
	@override String get fontPickerTitle => 'Elegir una fuente';
	@override String get fontPickerSearch => 'Buscar fuentes';
	@override String get fontPickerEmpty => 'No hay ninguna fuente coincidente en esta máquina.';
	@override String get fontPickerBundled => 'incluida';
	@override String get fontPickerCustom => '¿No está en la lista? Escribe el nombre exacto de la familia.';
	@override String get fontPickerCustomHint => 'Nombre de la familia';
	@override String get fontPickerUse => 'Usar';
	@override String get fontPickerDefault => 'Predeterminada';
	@override String get fontMissing => 'No se encontró en esta máquina — usando el respaldo.';
	@override String get sectionLayout => 'Diseño';
	@override String get swapPanelsTitle => 'Invertir paneles';
	@override String get swapPanelsDesc => 'Coloca los workspaces a la derecha y archivos, búsqueda, git y base de datos a la izquierda.';
}

// Path: settings.page.notifications
class _Translations$settings$page$notifications$es extends Translations$settings$page$notifications$en {
	_Translations$settings$page$notifications$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionTitle => 'Notificaciones';
	@override String get enableTitle => 'Activar notificaciones';
	@override String get enableDesc => 'Avisarme cuando un agente termine un turno y la ventana no esté enfocada.';
	@override String get systemPermissionTitle => 'Permiso del sistema';
	@override String get grantedDesc => 'GSH Desktop tiene permiso para enviar notificaciones.';
	@override String get notGrantedDesc => 'macOS aún no ha concedido acceso a las notificaciones.';
	@override String get granted => 'Concedido';
	@override String get requestPermission => 'Solicitar permiso';
	@override String get soundsTitle => 'Sonidos';
	@override String get soundVolumeTitle => 'Volumen';
	@override String get soundTurnDone => 'Turno completado';
	@override String get soundTurnDoneDesc => 'Un agente terminó su turno.';
	@override String get soundActionRequired => 'Acción requerida';
	@override String get soundActionRequiredDesc => 'Un agente está esperando tu aprobación o respuesta.';
	@override String get soundDefault => 'Predeterminado';
	@override String soundCustom({required Object name}) => 'Personalizado: ${name}';
	@override String get soundChooseFile => 'Elegir archivo';
	@override String get soundReset => 'Volver al predeterminado';
	@override String get soundOnActiveTab => 'Reproducir también con la pestaña activa';
	@override String get soundPreview => 'Escuchar';
}

// Path: settings.page.shortcuts
class _Translations$settings$page$shortcuts$es extends Translations$settings$page$shortcuts$en {
	_Translations$settings$page$shortcuts$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get notCustomizable => 'Los atajos de teclado aún no se pueden personalizar.';
}

// Path: settings.page.languages
class _Translations$settings$page$languages$es extends Translations$settings$page$languages$en {
	_Translations$settings$page$languages$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionFormatting => 'FORMATO';
	@override String get formatOnSaveTitle => 'Formatear al guardar';
	@override String get formatOnSaveDesc => 'Formatea el archivo automáticamente al guardar (⌘S).';
	@override String get sectionLanguageServers => 'SERVIDORES DE LENGUAJE';
	@override String get footerNote => 'Los errores y el formato usan el language server de cada lenguaje. GSH Desktop no instala servidores — usa lo que ya está en tu máquina. ● responde · ○ no encontrado o comando inválido (instala el servidor o ajusta el comando).';
	@override String get serverCommandLabel => 'Comando del language server';
	@override String get formatterCommandLabel => 'Comando del formateador (opcional)';
	@override String get formatterHint => 'Formateador externo con el marcador %FILE%. Tiene prioridad sobre el formateador del LSP cuando está definido.';
	@override String get resetToDefault => 'Restablecer al predeterminado';
	@override String get saveAndRestart => 'Guardar y reiniciar';
	@override String get statusResponds => 'El servidor responde';
	@override String get statusNotFound => 'Servidor no encontrado o comando inválido';
}

// Path: settings.page.automations
class _Translations$settings$page$automations$es extends Translations$settings$page$automations$en {
	_Translations$settings$page$automations$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionCommitMessages => 'Mensajes de commit';
	@override String get harness => 'Harness';
	@override String get harnessDiscovering => 'Buscando harnesses de línea de comandos instalados…';
	@override String get harnessNoneFound => 'No se encontró ningún harness compatible en el PATH.';
	@override String harnessConfiguredUnavailable({required Object harness}) => '${harness} está configurado, pero no disponible.';
	@override String get harnessChoose => 'Elige la CLI usada para generar mensajes de commit.';
	@override String get harnessRefresh => 'Actualizar harnesses instalados';
	@override String get notConfigured => 'Sin configurar';
	@override String get model => 'Modelo';
	@override String get modelUnavailable => 'La lista de modelos no está disponible hasta encontrar el harness.';
	@override String get modelCliOnly => 'Este harness usa el modelo predeterminado de su CLI.';
	@override String get modelCliDefault => 'Predeterminado de la CLI';
	@override String get modelAuto => 'Auto';
	@override String modelSearch({required Object count}) => 'Buscar entre ${count} modelos…';
	@override String get modelAutoRouted => 'Este harness elige el modelo automáticamente.';
	@override String get modelAccountOnly => 'Solo se muestran los modelos disponibles en tu cuenta.';
	@override String get generateFromSourceControl => 'Generar desde Control de versiones';
	@override String get generateFromSourceControlDescription => 'GSH Desktop envía solo el diff seleccionado y los asuntos de los commits recientes. Los patrones habituales de credenciales y los archivos sensibles se redactan antes de ejecutar el harness.';
	@override String get discoveryFailed => 'No se pudieron descubrir los harnesses de automatización instalados.';
	@override String staleModel({required Object model, required Object harness}) => 'El modelo "${model}" ya no está disponible para ${harness}. Se usará el predeterminado de la CLI; elige otro modelo en Configuración si lo necesitas.';
	@override String get recommendedSuffix => 'Recomendado';
}

// Path: settings.page.claudeCode
class _Translations$settings$page$claudeCode$es extends Translations$settings$page$claudeCode$en {
	_Translations$settings$page$claudeCode$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionGeneral => 'General';
	@override String get classifyTitle => 'Clasificar estados de las sesiones';
	@override String get classifyDesc => 'Muestra en el encabezado del chat el estado que Claude Code asigna al final de cada turno: completada, lista para revisión o bloqueada. Claude Code clasifica igual; desactivarlo solo oculta la insignia.';
	@override String get switchModelsTitle => 'Cambiar de modelo cuando se marque un mensaje';
	@override String get switchModelsDesc => 'Cuando las salvaguardas marquen un mensaje, cambiar automáticamente a otro modelo para continuar la conversación. Si está desactivado, tu sesión se pausará. Se guarda en ~/.claude/settings.json (switchModelsOnFlag).';
	@override String get sectionCodeAppearance => 'Apariencia del código';
	@override String get followTheme => 'Del tema activo';
	@override String get codeThemeLightHint => 'Colores del código en modo claro';
	@override String get codeThemeDarkHint => 'Colores del código en modo oscuro';
	@override String get codeFontTitle => 'Fuente de código';
	@override String get codeFontDesc => 'Define una fuente monoespaciada personalizada para el código: visor, editor, diffs y bloques de código del chat. La terminal tiene su propia fuente en Apariencia.';
	@override String get codeFontPlaceholder => 'p. ej.: JetBrains Mono';
	@override String get sectionAppearance => 'Apariencia';
	@override String get transcriptTitle => 'Vista predeterminada de la transcripción';
	@override String get transcriptDesc => 'La vista con la que abren las nuevas conversaciones del chat. Las conversaciones ya abiertas mantienen la suya.';
	@override String get viewNormal => 'Normal';
	@override String get viewThinking => 'Razonamiento';
	@override String get viewVerbose => 'Detallada';
	@override String get sectionRemoteControl => 'Remote Control';
	@override String get chatRemoteControlTitle => 'Chat con Remote Control (experimental)';
	@override String get chatRemoteControlDesc => 'El chat de GSH ejecuta el claude interactivo en una terminal oculta, conectada a Remote Control: la conversación aparece en el móvil y en claude.ai/code, y las sesiones de otras máquinas la ven. La respuesta llega por mensaje (sin aparecer letra a letra). Vale para los chats abiertos después del cambio; desactívalo para volver al motor rápido.';
	@override String get remoteControlTitle => 'Conectar nuevas sesiones a Remote Control';
	@override String get remoteControlDesc => 'Cada sesión de claude que inicies en una terminal se conecta a Remote Control, para seguir en el celular o en claude.ai/code. Se guarda en ~/.claude/settings.json (remoteControlAtStartup). Requiere login de claude.ai (Pro, Max, Team o Enterprise).';
	@override String saveFailed({required Object detail}) => 'No pude guardar: ${detail}';
	@override String get sectionSessions => 'Sesiones';
	@override String get promptSuggestionsTitle => 'Sugerencias de prompts';
	@override String get promptSuggestionsDesc => 'Mostrar una sugerencia del siguiente prompt después de que Claude responda. Las sugerencias consumen un poco de tu uso.';
	@override String get outputStyleTitle => 'Estilo de salida';
	@override String get outputStyleDesc => 'Cómo Claude estructura sus respuestas en las sesiones de Code. Se aplica a sesiones nuevas.';
	@override String get outputStyleDefault => 'Predeterminado';
	@override String get crossSessionTitle => 'Mensajes de otras sesiones';
	@override String get crossSessionDesc => 'Qué hacer cuando otra sesión de Claude Code le envía un mensaje a esta (SendMessage). GSH deja Aceptar para toda sesión de la máquina; Retener la guarda para tu aprobación, Rechazar la descarta. Se guarda en crossSessionInbound.';
	@override String get crossSessionDefault => 'Por defecto';
	@override String get crossSessionAccept => 'Aceptar';
	@override String get crossSessionHold => 'Retener para aprobar';
	@override String get crossSessionRefuse => 'Rechazar';
	@override String get sandboxTitle => 'Sandbox local';
	@override String get sandboxDesc => 'Ejecuta los comandos bash de Claude Code en un sandbox aislado. Se aplica a sesiones nuevas.';
	@override String get sandboxStrictTitle => 'Modo sandbox estricto';
	@override String get sandboxStrictDesc => 'Bloquea los comandos que no pueden ejecutarse dentro del sandbox en lugar de ejecutarlos fuera.';
	@override String get sectionSecurity => 'Seguridad';
	@override String get protectedHostsTitle => 'Hosts protegidos';
	@override String get protectedHostsDesc => 'Hosts que ningún agente puede tocar desde un comando: ssh, scp, workspace remoto, cualquier cosa que los nombre. GSH bloquea el comando antes de ejecutarlo, en toda sesión de Claude Code y Codex en esta máquina, y le dice al agente que te pregunte. Separados por coma; palabra completa (prod bloquea "ssh prod" y "prod.x.com", no "production"). Se guarda en ~/.gsh/protected-hosts.json.';
	@override String get sectionBrowser => 'Navegador';
	@override String get linksInAppTitle => 'Abrir enlaces en el navegador integrado';
	@override String get linksInAppDesc => 'Los enlaces de las terminales se abren en una pestaña de navegador de GSH en lugar de tu navegador predeterminado.';
}

// Path: settings.page.placeholder
class _Translations$settings$page$placeholder$es extends Translations$settings$page$placeholder$en {
	_Translations$settings$page$placeholder$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cowork1 => 'Cowork es una función de Claude Desktop (tareas que se ejecutan en este equipo con archivos locales, navegador y MCPs).';
	@override String get cowork2 => 'En GSH, el equivalente es el chat con Claude en un workspace y la Granja, donde los loops de agentes corren en terminales.';
	@override String get extensionsDesc => 'Permitir que Claude interactúe directamente con aplicaciones, datos y herramientas de tu equipo.';
	@override String get extensionsEmpty => 'Ninguna extensión instalada';
	@override String get extensions => 'Las extensiones .MCPB/.DXT son de Claude Desktop. En GSH, los servidores MCP están en Conectores y Desarrollador.';
}

// Path: settings.page.claude
class _Translations$settings$page$claude$es extends Translations$settings$page$claude$en {
	_Translations$settings$page$claude$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Actualizar';
	@override String get loading => 'Cargando…';
	@override String get terminalTitle => 'Abrir una terminal';
	@override String get noWorkspace => 'Abre primero un workspace local: esto ejecuta la CLI `claude` en una de sus terminales para que la sigas.';
	@override String get months => 'ene.|feb.|mar.|abr.|may.|jun.|jul.|ago.|sept.|oct.|nov.|dic.';
	@override String get weekdays => 'lun.|mar.|mié.|jue.|vie.|sáb.|dom.';
	@override String dateShort({required Object day, required Object month}) => '${day} de ${month}';
	@override late final _Translations$settings$page$claude$error$es error = _Translations$settings$page$claude$error$es._(_root);
}

// Path: settings.page.account
class _Translations$settings$page$account$es extends Translations$settings$page$account$en {
	_Translations$settings$page$account$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cuenta';
	@override String get profile => 'Perfil';
	@override String get instructions => 'Instrucciones para Claude';
	@override String get instructionsDesc => 'Se guarda en ~/.claude/CLAUDE.md: Claude Code lo carga en cada sesión de este equipo.';
	@override String get instructionsHint => 'p. ej.: mantener las explicaciones breves y directas';
	@override String get loggedIn => 'Conectado';
	@override String get loggedOut => 'Desconectado';
	@override String get loggedInDesc => 'Claude Code en este equipo usa esta cuenta.';
	@override String get loggedOutDesc => 'Inicia sesión para usar tu suscripción de Claude en Claude Code.';
	@override String get login => 'Iniciar sesión';
	@override String get logout => 'Cerrar sesión';
	@override String get logoutConfirmTitle => '¿Cerrar sesión en Claude Code?';
	@override String get logoutConfirmMessage => 'Ejecuta `claude auth logout`. Las sesiones de este equipo dejan de usar tu suscripción hasta que vuelvas a iniciar sesión.';
	@override String get email => 'Correo';
	@override String get organization => 'Organización';
	@override String get orgId => 'ID de la organización';
	@override String get plan => 'Plan';
	@override String get method => 'Método de inicio de sesión';
}

// Path: settings.page.usage
class _Translations$settings$page$usage$es extends Translations$settings$page$usage$en {
	_Translations$settings$page$usage$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Tus límites de uso';
	@override String get weeklyTitle => 'Límites semanales';
	@override String get unavailable => 'Los límites del plan no se aplican a este inicio de sesión (clave de API o proveedor externo).';
	@override String get windowSession => 'Sesión actual';
	@override String get windowWeekly => 'Todos los modelos';
	@override String resetsIn({required Object when}) => 'Se restablece en ${when}';
	@override String resetsAt({required Object when}) => 'Se restablece ${when}';
	@override String percentUsed({required Object pct}) => '${pct}% usado';
	@override String updated({required Object when}) => 'Última actualización: ${when}';
	@override String get justNow => 'hace menos de un minuto';
	@override String minutesAgo({required Object n}) => 'hace ${n} min';
	@override String minutes({required Object m}) => '${m} min';
	@override String hoursMinutes({required Object h, required Object m}) => '${h} h ${m} min';
	@override late final _Translations$settings$page$usage$plans$es plans = _Translations$settings$page$usage$plans$es._(_root);
}

// Path: settings.page.memory
class _Translations$settings$page$memory$es extends Translations$settings$page$memory$en {
	_Translations$settings$page$memory$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Memoria';
	@override String get intro => 'Lo que carga una sesión de Claude Code en el workspace activo: tus instrucciones y la memoria que Claude escribe por su cuenta. Haz clic para abrir el archivo.';
	@override String get instructionsTitle => 'Instrucciones';
	@override String get autoTitle => 'Memoria automática';
	@override String get empty => 'No se encontró ningún CLAUDE.md.';
	@override String get autoEmpty => 'Claude aún no guardó memorias para este workspace.';
	@override String get scopeUser => 'Usuario (todos los proyectos)';
	@override String get scopeProject => 'Proyecto';
	@override String updated({required Object when}) => 'Actualizado ${when}';
}

// Path: settings.page.skills
class _Translations$settings$page$skills$es extends Translations$settings$page$skills$en {
	_Translations$settings$page$skills$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get groupUser => 'Creado por ti';
	@override String get groupProject => 'Del proyecto';
	@override String get groupPlugins => 'De los plugins';
	@override String get byYou => 'por ti';
	@override String get byProject => 'del proyecto';
	@override String get empty => 'No hay skills instaladas.';
}

// Path: settings.page.connectors
class _Translations$settings$page$connectors$es extends Translations$settings$page$connectors$en {
	_Translations$settings$page$connectors$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get checking => 'Verificando cada servidor… puede tardar unos segundos.';
	@override String get empty => 'No hay servidores MCP configurados.';
	@override String get addServer => 'Añadir servidor MCP';
	@override String get colConnector => 'Conector';
	@override String get colType => 'Tipo';
	@override String get colStatus => 'Estado';
	@override String fromPlugin({required Object plugin}) => 'Proporcionado por el plugin ${plugin}';
	@override String get typeWeb => 'Web';
	@override String get typeLocal => 'Local';
	@override String get originPlugin => 'Plugin';
	@override String get link => 'Vincular';
	@override String get discoverIntro => 'El directorio de conectores de claude.ai no tiene API pública, así que GSH no lo lista. Añade cualquier servidor MCP aquí: GSH ejecuta `claude mcp add` en una terminal.';
	@override String get formName => 'Nombre';
	@override String get formType => 'Tipo';
	@override String get formUrl => 'URL';
	@override String get formCommand => 'Comando';
	@override String get formScope => 'Ámbito';
	@override String get formScopeDesc => 'Usuario = todos los proyectos; Local = solo el proyecto de la terminal.';
	@override String get scopeUser => 'Usuario';
	@override String get scopeLocal => 'Local';
	@override String get docs => 'Docs de MCP';
	@override String get addInTerminal => 'Añadir en la terminal';
	@override late final _Translations$settings$page$connectors$status$es status = _Translations$settings$page$connectors$status$es._(_root);
}

// Path: settings.page.plugins
class _Translations$settings$page$plugins$es extends Translations$settings$page$plugins$en {
	_Translations$settings$page$plugins$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get search => 'Buscar skills y plugins';
	@override String get groupProject => 'En este proyecto';
	@override String get groupMarketplaces => 'De los marketplaces que añadiste';
	@override String get noWorkspace => 'Abre un workspace para ver los plugins habilitados en él.';
	@override String get projectEmpty => 'Ningún plugin habilitado en .claude/settings.json de este proyecto.';
	@override String get empty => 'No hay plugins instalados.';
	@override String get disabled => 'Deshabilitado';
}

// Path: settings.page.developer
class _Translations$settings$page$developer$es extends Translations$settings$page$developer$en {
	_Translations$settings$page$developer$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Desarrollador';
	@override String get mcpTitle => 'Servidores MCP locales';
	@override String get mcpDesc => 'Servidores MCP stdio que Claude Code inicia en este equipo. Se configuran en ~/.claude.json.';
	@override String get mcpEmpty => 'Ningún servidor MCP local.';
	@override String get editConfig => 'Editar configuración';
	@override String get command => 'Comando';
	@override String get arguments => 'Argumentos';
	@override String get error => 'Error';
	@override String get telemetryTitle => 'Telemetría';
	@override String get telemetryDesc => 'Los errores y logs de los procesos del workspace están en el panel Telemetría del shell; con el modo desarrollador también muestra los del propio GSH Desktop.';
	@override String get claudeSettingsTitle => 'Archivo de configuración de Claude Code';
	@override String get claudeSettingsDesc => '~/.claude/settings.json — permisos, hooks, entorno y modelo.';
	@override String get apiKeyTitle => '¿Quieres una clave de API?';
	@override String get apiKeyDesc => 'Crea claves y revisa el uso en Claude Console. Requiere otra cuenta y el uso de la API se cobra aparte.';
	@override String get apiKeyButton => 'Ir a la Console';
}

// Path: settings.page.system
class _Translations$settings$page$system$es extends Translations$settings$page$system$en {
	_Translations$settings$page$system$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sistema';
	@override String get version => 'Versión de la aplicación';
	@override String get keepAwakeTitle => 'Mantener el equipo activo';
	@override String get keepAwakeDesc => 'Evita la suspensión por inactividad mientras está activo (el mismo botón de rayo del rail). Se desactiva al cerrar la app; cerrar la tapa igual suspende.';
}

// Path: settings.page.catalog
class _Translations$settings$page$catalog$es extends Translations$settings$page$catalog$en {
	_Translations$settings$page$catalog$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get mine => 'Míos';
	@override String get discover => 'Descubrir';
	@override String get add => 'Añadir';
	@override String get all => 'Todos';
	@override String by({required Object author}) => 'por ${author}';
	@override String get newSkill => 'Nueva skill…';
	@override String get addMarketplace => 'Añadir marketplace…';
}

// Path: settings.page.generalClaude
class _Translations$settings$page$generalClaude$es extends Translations$settings$page$generalClaude$en {
	_Translations$settings$page$generalClaude$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionAppearance => 'Apariencia';
	@override String get theme => 'Tema';
	@override String get themeSystem => 'Sistema';
	@override String get themeLight => 'Claro';
	@override String get themeDark => 'Oscuro';
	@override String get uiFont => 'Fuente de la interfaz';
	@override String get uiFontDesc => 'Fuente para toda la interfaz: menús, barras laterales y paneles.';
	@override String get chatFont => 'Fuente del chat';
	@override String get chatFontDesc => 'Texto de la conversación en el chat con Claude.';
	@override String get chatFontDefault => 'Igual que la interfaz';
	@override String get textSize => 'Tamaño del texto de la conversación';
	@override String get textSizeDesc => 'Tamaño base del texto de la app (el mismo ajuste de Apariencia).';
	@override String get sizeSmall => 'Pequeño';
	@override String get sizeMedium => 'Mediano';
	@override String get sizeLarge => 'Grande';
	@override String get transcriptWidth => 'Ancho de la transcripción';
	@override String get transcriptWidthDesc => 'Ancho máximo de la transcripción y del campo de mensaje.';
	@override String get widthNarrow => 'Estrecho';
	@override String get widthMedium => 'Mediano';
	@override String get widthWide => 'Ancho';
	@override String get reducedMotion => 'Movimiento reducido';
	@override String get reducedMotionDesc => 'Menos animaciones en Claude Code (brillo del spinner, destellos). Se guarda como prefersReducedMotion en ~/.claude/settings.json.';
	@override String get sectionNotifications => 'Notificaciones';
	@override String get notifyTurnDone => 'Finalización de respuestas';
	@override String get notifyTurnDoneDesc => 'Recibe una notificación cuando un agente termine una respuesta y la ventana no esté enfocada.';
	@override String get notifyPermission => 'Solicitudes de permiso de Code';
	@override String get notifyPermissionDesc => 'Reproduce un sonido cuando un agente espera tu aprobación o respuesta.';
	@override String get pushInputNeeded => 'Push al móvil cuando se te necesite';
	@override String get pushInputNeededDesc => 'Claude Code envía un push cuando un permiso o una pregunta están esperando (inputNeededNotifEnabled).';
	@override String get pushAgent => 'Notificaciones proactivas en el móvil';
	@override String get pushAgentDesc => 'Permite que Claude avise en el móvil sobre novedades importantes de una sesión (agentPushNotifEnabled).';
}

// Path: settings.page.privacy
class _Translations$settings$page$privacy$es extends Translations$settings$page$privacy$en {
	_Translations$settings$page$privacy$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Datos';
	@override String get gshTelemetry => 'Telemetría de GSH';
	@override String get gshTelemetryDesc => 'Solo local: errores y logs quedan en SQLite en este equipo y nunca se envían.';
	@override String get ccTelemetry => 'Desactivar la telemetría de Claude Code';
	@override String get ccTelemetryDesc => 'Define DISABLE_TELEMETRY en el env de ~/.claude/settings.json (no se envían métricas de uso).';
	@override String get ccErrors => 'Desactivar informes de errores de Claude Code';
	@override String get ccErrorsDesc => 'Define DISABLE_ERROR_REPORTING en el env de ~/.claude/settings.json.';
}

// Path: settings.page.resources
class _Translations$settings$page$resources$es extends Translations$settings$page$resources$en {
	_Translations$settings$page$resources$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get sectionGeneral => 'General';
	@override String get sectionShell => 'Funciones de GSH';
	@override String get chat => 'Chat con Claude (beta)';
	@override String get chatDesc => 'Botón de chat en la barra del workspace (Claude Code en stream-json).';
	@override String get farm => 'Granja';
	@override String get farmDesc => 'Loops de agentes leídos de las transcripciones de Claude Code.';
	@override String get harnessFeature => 'Harness';
	@override String get harnessFeatureDesc => 'Botón que abre lo que el agente carga en el workspace: instrucciones, skills, subagentes, hooks, permisos y MCP.';
	@override String get sectionTeamFarm => 'Granja del equipo';
	@override String get teamFarm => 'Ver la granja de los compañeros';
	@override String get teamFarmDesc => 'En la misma red (p. ej., en la oficina), cada GSH anuncia su granja y muestra la de los compañeros al lado de la tuya: aleja el zoom para verlas. Sin servidor: nada sale de la red local. Desactivado, nada sale de tu GSH.';
	@override String get teamName => 'Equipo';
	@override String get teamNameDesc => 'Solo se ven quienes usan el mismo nombre de equipo.';
	@override String get teamNamePlaceholder => 'p. ej.: gorila';
	@override String get teamMe => 'Tu nombre';
	@override String get teamMeDesc => 'Aparece sobre tu granja para los compañeros.';
	@override String get teamShowTitles => 'Mostrar títulos de las sesiones';
	@override String get teamShowTitlesDesc => 'Los títulos pueden tener partes de tus prompts. Desactivado, los compañeros solo ven la carpeta, el estado y los tokens de cada agente.';
	@override String get teamSecret => 'Contraseña del equipo';
	@override String get teamSecretDesc => 'Activa la conversación entre agentes: tu agente puede mandar mensajes y archivos a los agentes de los compañeros, y los de ellos al tuyo. Todo el equipo usa la misma contraseña; sin ella, nadie llama a tu puerta (y las granjas sin ella no aparecen).';
	@override String get teamSecretPlaceholder => 'acuerden una contraseña';
	@override String get teamDoorAllow => 'Quién puede llamar a la puerta';
	@override String get teamDoorAllowDesc => 'Nombres de los compañeros, separados por comas. Vacío = todo el equipo.';
	@override String get teamDoorAllowPlaceholder => 'todo el equipo';
	@override String get teamDoorAsk => 'Preguntar antes de abrir la puerta';
	@override String get teamDoorAskDesc => 'Cuando un compañero manda algo a uno de tus agentes, GSH te pregunta antes de entregarlo. Desactivado, tu agente lo recibe directo, marcado como información de un compañero (no como orden tuya).';
	@override String get teamNetwork => 'Red del trabajo';
	@override String get teamNetworkDesc => 'Rango de IP de la red de la oficina (p. ej., 192.168.10.0/24). Si se completa, GSH solo anuncia y escucha cuando estás en ella.';
	@override String get teamNetworkPlaceholder => 'cualquier red local';
	@override String get farmScenery => 'Escenario de la granja';
	@override String get farmSceneryDesc => 'Dónde viven los agentes: la granja o una oficina en pixel art.';
	@override String get sceneryFarm => 'Granja';
	@override String get sceneryOffice => 'Oficina';
	@override String get graph => 'Grafo de agentes';
	@override String get graphDesc => 'Visualiza los agentes del workspace y quién habla con quién.';
	@override String get browser => 'Navegador integrado';
	@override String get browserDesc => 'Pestaña "Navegador" en el menú del panel (donde la plataforma tiene webview integrada).';
	@override String get skillsMoved => 'Las Skills se movieron a ';
}

// Path: settings.page.designSystems
class _Translations$settings$page$designSystems$es extends Translations$settings$page$designSystems$en {
	_Translations$settings$page$designSystems$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Design systems';
	@override String get desc => 'En GSH son los temas: colores de la interfaz, la terminal y el código en un solo paquete.';
	@override String get add => 'Nuevo design system';
	@override String get search => 'Buscar por nombre';
	@override String showing({required Object n, required Object total}) => 'Mostrando ${n} de ${total}';
	@override String get colName => 'Nombre';
	@override String get colOrigin => 'Origen';
	@override String get colAuthor => 'Autor';
	@override String get active => 'Activo';
	@override String get imported => 'Importado';
	@override String get builtIn => 'Integrado';
	@override String get activate => 'Usar este tema';
	@override String get remove => 'Quitar';
}

// Path: settings.page.nav.groups
class _Translations$settings$page$nav$groups$es extends Translations$settings$page$nav$groups$en {
	_Translations$settings$page$nav$groups$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get settings => 'Configuración';
	@override String get thisComputer => 'Este equipo';
	@override String get personalization => 'Personalización';
	@override String get platform => 'Plataforma';
	@override String get app => 'GSH Desktop';
}

// Path: settings.page.general.updateFrequency
class _Translations$settings$page$general$updateFrequency$es extends Translations$settings$page$general$updateFrequency$en {
	_Translations$settings$page$general$updateFrequency$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get daily => 'Diariamente';
	@override String get weekly => 'Semanalmente';
	@override String get monthly => 'Mensualmente';
	@override String get never => 'Nunca';
}

// Path: settings.page.claude.error
class _Translations$settings$page$claude$error$es extends Translations$settings$page$claude$error$en {
	_Translations$settings$page$claude$error$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get cliMissing => 'No se encontró la CLI de Claude Code (`claude`) en este equipo.';
	@override String get timeout => 'La CLI `claude` tardó demasiado en responder.';
	@override String failed({required Object detail}) => 'La CLI `claude` falló: ${detail}';
}

// Path: settings.page.usage.plans
class _Translations$settings$page$usage$plans$es extends Translations$settings$page$usage$plans$en {
	_Translations$settings$page$usage$plans$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get pro => 'Pro';
	@override String get max => 'Max';
	@override String get team => 'Equipo';
	@override String get enterprise => 'Empresa';
}

// Path: settings.page.connectors.status
class _Translations$settings$page$connectors$status$es extends Translations$settings$page$connectors$status$en {
	_Translations$settings$page$connectors$status$es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get connected => 'Conectado';
	@override String get needsAuth => 'Requiere autenticación';
	@override String get failed => 'Falló';
	@override String get pending => 'Aprobación pendiente';
	@override String get unknown => 'Desconocido';
}

/// The flat map containing all translations for locale <es>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'core.bootstrapError.title' => 'No se pudo inicializar GSH Desktop',
			'core.bootstrapError.retry' => 'Reintentar',
			'core.macosNotifications.title' => 'Activar notificaciones en macOS',
			'core.macosNotifications.intro' => 'Las notificaciones están desactivadas en la configuración del sistema. Sigue los pasos a continuación para activarlas:',
			'core.macosNotifications.step1' => 'Abre los Ajustes del Sistema en tu Mac.',
			'core.macosNotifications.step2' => 'Ve a la sección Notificaciones en la barra lateral izquierda.',
			'core.macosNotifications.step3' => 'Busca y selecciona la aplicación GSH Desktop en la lista.',
			'core.macosNotifications.step4' => 'Activa el interruptor Permitir Notificaciones.',
			'core.macosNotifications.tip' => 'Consejo: si la aplicación no aparece en la lista, ciérrala y vuelve a abrirla para activar su registro en el sistema.',
			'core.macosNotifications.gotIt' => 'Entendido',
			'core.appErrorView.renderFailed' => 'Esta parte de la aplicación no se pudo renderizar',
			'core.appErrorView.details' => 'Detalles',
			'core.appErrorView.renderErrorTitle' => 'Error de renderizado',
			'core.errorReportDialog.defaultDescription' => 'Algo salió mal. Los detalles a continuación se guardaron en el registro — puedes reportarlos para que se solucione.',
			'core.errorReportDialog.copyDetails' => 'Copiar detalles',
			'core.errorReportDialog.reportIssue' => 'Reportar problema',
			'core.windowControls.minimize' => 'Minimizar',
			'core.windowControls.maximize' => 'Maximizar',
			'core.windowControls.close' => 'Cerrar',
			'core.crash.title' => 'Cierre inesperado',
			'core.crash.bannerTitle' => 'GSH Desktop se cerró inesperadamente',
			'core.crash.report' => 'Reportar',
			'core.crash.dismiss' => 'Descartar',
			'core.crash.crashMessage' => ({required Object version}) => 'La sesión anterior (versión ${version}) terminó sin cerrarse correctamente. ¿Quieres reportarlo? El log se incluye y puedes revisar todo antes de enviar.',
			'core.crash.crashError' => ({required Object startedAt, required Object pid}) => 'La sesión iniciada el ${startedAt} (pid ${pid}) terminó sin un cierre limpio.',
			'core.crash.crashDescription' => 'No se capturó ningún error: el sistema terminó la app. El log de abajo es de esa sesión y es la parte más útil.',
			'core.menu.settings' => 'Configuración…',
			'core.menu.checkForUpdates' => 'Buscar Actualizaciones…',
			'core.menu.file' => 'Archivo',
			'core.menu.newTerminal' => 'Nueva Terminal',
			'core.menu.newChat' => 'Nuevo Chat',
			'core.menu.newChatRight' => 'Nuevo Chat a la Derecha',
			'core.menu.openWorkspace' => 'Abrir Workspace',
			'core.menu.save' => 'Guardar',
			'core.menu.discard' => 'Descartar',
			'core.menu.format' => 'Formatear',
			'core.menu.view' => 'Ver',
			'core.menu.toggleWorkspacePanel' => 'Alternar Panel de Workspaces',
			'core.menu.toggleFiles' => 'Alternar Archivos',
			'core.menu.splitRight' => 'Dividir a la Derecha',
			'core.menu.splitDown' => 'Dividir Abajo',
			'core.menu.focusPane' => 'Enfocar Panel',
			'core.menu.focusLeft' => 'Izquierda  (⌘⌥←)',
			'core.menu.focusRight' => 'Derecha  (⌘⌥→)',
			'core.menu.focusUp' => 'Arriba  (⌘⌥↑)',
			'core.menu.focusDown' => 'Abajo  (⌘⌥↓)',
			'core.menu.selectTab' => 'Seleccionar Pestaña',
			'core.menu.tabN' => ({required Object n}) => 'Pestaña ${n}',
			'core.menu.lastTab' => 'Última Pestaña',
			'core.menu.previousWorkspace' => 'Workspace Anterior',
			'core.menu.nextWorkspace' => 'Siguiente Workspace',
			'core.menu.zoomIn' => 'Acercar',
			'core.menu.zoomOut' => 'Alejar',
			'core.menu.actualSize' => 'Tamaño Real',
			'core.menu.window' => 'Ventana',
			'core.menu.quit' => 'Salir',
			'core.menu.minimize' => 'Minimizar',
			'core.menu.zoom' => 'Zoom',
			'common.cancel' => 'Cancelar',
			'common.confirm' => 'Confirmar',
			'common.create' => 'Crear',
			'common.gotIt' => 'Entendido',
			'common.save' => 'Guardar',
			'common.close' => 'Cerrar',
			'common.delete' => 'Eliminar',
			'common.done' => 'Listo',
			'common.add' => 'Añadir',
			'common.test' => 'Probar',
			'common.ok' => 'OK',
			'common.loading' => 'Cargando…',
			'common.checking' => 'Comprobando…',
			'common.remove' => 'Quitar',
			'common.restart' => 'Reiniciar',
			'common.settings' => 'Configuración',
			'common.send' => 'Enviar',
			'common.open' => 'Abrir',
			'common.dismiss' => 'Descartar',
			'common.report' => 'Reportar',
			'common.copyCode' => 'Copiar código',
			'common.search' => 'Buscar',
			'common.noResults' => 'Sin resultados',
			'gsh.confirmDialog.unsavedChangesTitle' => 'Cambios sin guardar',
			'gsh.confirmDialog.unsavedChangesMessage' => ({required Object fileName}) => '“${fileName}” tiene cambios sin guardar. ¿Guardarlos antes de cerrar?',
			'gsh.confirmDialog.dontSave' => 'No guardar',
			'gsh.confirmDialog.saveAndClose' => 'Guardar y cerrar',
			'gsh.neovim.unavailable' => 'Neovim no está disponible. Abriendo en GSH Desktop.',
			'gsh.neovim.openFailed' => 'No se pudo acceder a Neovim. Abriendo en GSH Desktop.',
			'gsh.neovim.unsavedTitle' => 'Búferes de Neovim sin guardar',
			'gsh.neovim.unsavedMessage' => 'Neovim tiene búferes modificados. ¿Cerrar la pestaña y descartar esos cambios?',
			'gsh.neovim.closeAnyway' => 'Cerrar de todos modos',
			'gsh.worktreeCreateDialog.forkTitle' => 'Fork del worktree',
			'gsh.worktreeCreateDialog.createTitle' => 'Crear worktree',
			'gsh.worktreeCreateDialog.forkSubtitle' => ({required Object root}) => 'Nueva worktree ramificada desde ${root}.',
			'gsh.worktreeCreateDialog.createSubtitle' => ({required Object root}) => 'Nueva feature en ${root} — nueva branch desde el HEAD actual.',
			'gsh.worktreeCreateDialog.namePlaceholder' => 'feat/mi-feature',
			'gsh.worktreeCreateDialog.errorWhitespace' => 'Sin espacios en el nombre.',
			'gsh.worktreeCreateDialog.errorInvalidChar' => 'Carácter inválido para un nombre de branch.',
			'gsh.worktreeCreateDialog.errorInvalidSequence' => 'Secuencia inválida (ej.: "..", "//", empezar/terminar con "/").',
			'gsh.worktreeCreateDialog.errorReserved' => 'Posición reservada (no empieces con "-"/"." ni termines con ".lock").',
			'gsh.worktreeCreateDialog.errorDuplicateBranch' => 'Ya existe una branch con ese nombre.',
			'gsh.worktreeCreateDialog.errorDuplicateWorktree' => 'Ya existe un worktree con ese nombre.',
			'gsh.worktreeCreateDialog.errorBranchHierarchyConflict' => ({required Object target, required Object existing}) => 'No se puede crear la branch \'${target}\' porque entra en conflicto con la branch \'${existing}\' ya existente.',
			'gsh.worktreeCreateDialog.errorBranchHierarchicalConflictGeneral' => 'Ya existe una branch con una jerarquía conflictiva.',
			'gsh.worktreeCreateDialog.fork' => 'Fork',
			'gsh.worktreeCreateDialog.postCheckoutHint' => 'Este repositorio tiene un hook post-checkout.',
			'gsh.worktreeCreateDialog.running' => 'Ejecutando…',
			'gsh.worktreeCreateDialog.advancedSettings' => 'Configuración Avanzada',
			'gsh.worktreeCreateDialog.copyIgnored' => 'Copiar archivos ignorados (.gitignore)',
			'gsh.worktreeCreateDialog.copyIgnoredDesc' => 'Copia los archivos ignorados por .gitignore (ej. .env, claves locales) al nuevo worktree.',
			'gsh.worktreeCreateDialog.copyUntracked' => 'Copiar archivos no rastreados',
			'gsh.worktreeCreateDialog.copyUntrackedDesc' => 'Copia los archivos nuevos o modificados que aún no se han agregado al stage.',
			'gsh.worktreeCreateDialog.baseBranch' => 'Branch base',
			'gsh.worktreeCreateDialog.baseBranchDesc' => 'La branch desde la cual se creará el nuevo worktree y branch.',
			'gsh.worktreeCreateDialog.fetchRemote' => 'Sincronizar branch remota (fetch)',
			'gsh.worktreeCreateDialog.fetchRemoteDesc' => 'Ejecuta git fetch para garantizar que la branch base esté confirmada antes de crear el worktree.',
			'gsh.worktreeCreateDialog.searchBranch' => 'Buscar branch...',
			'gsh.worktreeCreateDialog.back' => 'Atrás',
			'gsh.commitMessageDialog.commitTitle' => 'Commit',
			'gsh.commitMessageDialog.stageAndCommitTitle' => 'Stage y Commit',
			'gsh.commitMessageDialog.scopeNote' => ({required Object fileName}) => 'Commit solo de "${fileName}".',
			'gsh.commitMessageDialog.placeholder' => 'fix: resumen breve del cambio',
			'gsh.commitMessageDialog.errorEmptySubject' => 'La primera línea (asunto) no puede estar vacía.',
			'gsh.commitMessageDialog.errorTooShort' => ({required Object min}) => 'Asunto demasiado corto (mín. ${min} caracteres).',
			'gsh.commitMessageDialog.errorTooLong' => ({required Object max}) => 'Asunto demasiado largo (máx. ${max} caracteres).',
			'gsh.commitMessageDialog.errorTrailingPeriod' => 'El asunto no debe terminar con un punto.',
			'gsh.commitMessageDialog.errorControlChars' => 'El asunto contiene caracteres de control.',
			'gsh.commitMessageDialog.errorBlankSecondLine' => 'Deja la segunda línea en blanco (separador entre asunto y cuerpo de git).',
			'gsh.commitMessageDialog.generate' => 'Generar mensaje de commit',
			'gsh.commitMessageDialog.generateWith' => ({required Object harness}) => 'Generar con ${harness}',
			'gsh.commitMessageDialog.generating' => 'Generando…',
			'gsh.commitMessageDialog.cancelGeneration' => 'Cancelar generación',
			'gsh.tasksPanel.reloadTasksTooltip' => 'Recargar tasks',
			'gsh.tasksPanel.restartTooltip' => 'Reiniciar',
			'gsh.tasksPanel.stopTooltip' => 'Detener',
			'gsh.tasksPanel.runTooltip' => 'Ejecutar',
			'gsh.tasksPanel.sendsKeyTooltip' => ({required Object label, required Object key}) => '${label} (envía \'${key}\')',
			'gsh.tasksPanel.startingTooltip' => 'Iniciando…',
			'gsh.tasksPanel.stoppingTooltip' => 'Deteniendo…',
			'gsh.tasksPanel.switchProfileTooltip' => 'Cambiar perfil',
			'gsh.tasksPanel.moreKeysTooltip' => 'Más teclas',
			'gsh.tasksPanel.sectionTasks' => 'TAREAS',
			'gsh.tasksPanel.noTasks' => 'No se detectaron tareas en este proyecto.',
			'gsh.tasksPanel.createTasksJson' => 'Crear tasks.json',
			'gsh.tasksPanel.generateComposeTasks' => 'Generar tareas de Compose',
			'gsh.tasksPanel.selectComposeEngine' => 'Elige un motor de Compose',
			'gsh.tasksPanel.noComposeEngine' => 'No se encontró Docker Compose ni Podman Compose.',
			'gsh.tasksPanel.invalidComposeFile' => 'El archivo activo no es un Compose válido con servicios.',
			'gsh.tasksPanel.invalidTasksJson' => 'tasks.json no es válido. No se guardaron cambios.',
			'gsh.tasksPanel.composeConflicts' => ({required Object labels}) => 'Se conservaron tareas que no son Compose con etiquetas en conflicto: ${labels}',
			'gsh.gshPage.chooseProjectFolderDialogTitle' => 'Elige la carpeta del proyecto',
			'gsh.gshPage.chooseWorkspaceFolderDialogTitle' => 'Elige la carpeta del workspace',
			'gsh.gshPage.workspaceRenamedTitle' => 'Workspace renombrado',
			'gsh.gshPage.workspaceRenamedMessage' => ({required Object name}) => 'El nuevo nombre "${name}" solo se enviará a los agentes tras reiniciar el workspace o la aplicación.',
			'gsh.gshPage.syncTitle' => ({required Object label}) => 'Sync — ${label}',
			'gsh.gshPage.pullTitle' => ({required Object label}) => 'Pull — ${label}',
			'gsh.gshPage.pushTitle' => ({required Object label}) => 'Push — ${label}',
			'gsh.gshPage.updateFromParentTitle' => ({required Object name}) => 'Actualizar desde el Padre — ${name}',
			'gsh.gshPage.mergeToParentTitle' => ({required Object name}) => 'Merge al Padre — ${name}',
			'gsh.gshPage.worktreeMergedAndRemoved' => 'Worktree fusionado y eliminado.',
			'gsh.gshPage.nothingWasChanged' => 'No se realizaron cambios.',
			'gsh.gshPage.newRealmTitle' => 'Nuevo realm',
			'gsh.gshPage.closeWorkspaceTitle' => 'Cerrar workspace',
			'gsh.gshPage.closeWorkspaceMessage' => ({required Object name}) => '¿Cerrar "${name}"? Los agentes de este workspace se cerrarán. La carpeta en el disco se conserva.',
			'gsh.gshPage.closeAction' => 'Cerrar',
			'gsh.gshPage.removeWorktreeTitle' => 'Quitar worktree',
			'gsh.gshPage.removeWorktreeMessage' => ({required Object name, required Object warn}) => '¿Quitar "${name}"? La carpeta del worktree y la branch se eliminarán y los agentes de este fork se cerrarán.${warn}',
			'gsh.gshPage.removeWorktreeWarning' => ({required Object name}) => '\n\nAdvertencia: la branch "${name}" aún no se ha fusionado — eliminarla (git branch -D) descarta el trabajo no fusionado.',
			'gsh.gshPage.failedToRemoveWorktreeTitle' => 'No se pudo quitar el worktree',
			'gsh.gshPage.openLayoutTitle' => 'Abrir layout',
			'gsh.gshPage.replaceLayoutTitle' => '¿Reemplazar el layout actual?',
			'gsh.gshPage.replaceLayoutMessage' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: 'Se cerrará 1 pestaña, y tiene un proceso en ejecución.', other: 'Se cerrarán ${n} pestañas, incluidas las que tienen procesos en ejecución.', ), 
			'gsh.gshPage.replaceLayoutConfirm' => 'Reemplazar',
			'gsh.gshPage.restartServerTooltip' => 'Reiniciar servidor',
			'gsh.gshPage.noLspAvailable' => 'Ningún LSP disponible',
			'gsh.gshPage.lspRunning' => 'en ejecución',
			'gsh.gshPage.lspStopped' => 'detenido',
			'gsh.welcomeView.title' => 'Bienvenido a GSH Desktop',
			'gsh.welcomeView.subtitle' => 'Abre una carpeta o conéctate a un host remoto para empezar.',
			'gsh.welcomeView.createWorkspace' => 'Crear workspace',
			'gsh.welcomeView.openLocalFolder' => 'Abrir carpeta local',
			'gsh.welcomeView.connectHost' => 'Conectar a un host',
			'gsh.welcomeView.configureHost' => 'Configurar host',
			'gsh.welcomeView.addWorkspace' => 'Añadir workspace',
			'gsh.paneView.closePaneTitle' => '¿Cerrar panel?',
			'gsh.paneView.closePaneMessage' => ({required Object count}) => 'Esto cierra todas las ${count} pestaña(s) de este panel y finaliza los agentes/terminales en él.',
			'gsh.paneView.close' => 'Cerrar',
			'gsh.paneView.closeOtherTabs' => 'Cerrar las otras',
			'gsh.paneView.closeTabsToTheRight' => 'Cerrar a la derecha',
			'gsh.paneView.closeAllTabs' => 'Cerrar todas',
			'gsh.paneView.closeTabsTitle' => '¿Cerrar pestañas?',
			'gsh.paneView.closeTabsMessage' => ({required Object count}) => 'Esto cierra ${count} pestaña(s) y finaliza los agentes/terminales en ellas.',
			'gsh.paneView.allTabs' => 'Todas las pestañas',
			'gsh.paneView.pinTab' => 'Fijar pestaña',
			'gsh.paneView.openInNewWindow' => 'Abrir en ventana nueva',
			'gsh.paneView.rename' => 'Renombrar',
			'gsh.paneView.openAsMarkdown' => 'Abrir como markdown',
			'gsh.paneView.openAsBoard' => 'Abrir como tablero',
			'gsh.paneView.resetTitle' => 'Restablecer título',
			'gsh.paneView.copyId' => 'Copiar Id',
			'gsh.paneView.restartTab' => 'Reiniciar',
			'gsh.paneView.newTab' => 'Nueva pestaña',
			'gsh.paneView.newTerminal' => 'Nueva terminal…',
			'gsh.paneView.splitRight' => 'Dividir a la derecha',
			'gsh.paneView.splitDown' => 'Dividir abajo',
			'gsh.paneView.closePane' => 'Cerrar panel',
			'gsh.paneView.dropHereToMove' => 'Suelta aquí para mover la pestaña',
			'gsh.paneView.dockAsTab' => 'Acoplar como pestaña',
			'gsh.paneView.openBrowser' => 'Abrir navegador',
			'gsh.paneView.openTerminal' => 'Abrir terminal',
			'gsh.paneView.openAsLayout' => 'Abrir como diseño',
			'gsh.paneView.openAsYaml' => 'Abrir como YAML',
			'gsh.paneView.openAsPanel' => 'Abrir como panel',
			'gsh.paneView.openAsHtml' => 'Abrir como HTML',
			'gsh.fileTreePanel.viewDiff' => 'Ver Diff',
			'gsh.fileTreePanel.commit' => 'Commit',
			'gsh.fileTreePanel.stageAndCommit' => 'Stage y Commit',
			'gsh.fileTreePanel.unstage' => 'Quitar del stage',
			'gsh.fileTreePanel.stageChanges' => 'Poner en stage',
			'gsh.fileTreePanel.discardChanges' => 'Descartar cambios',
			'gsh.fileTreePanel.enterCommitMessage' => 'Escribe un mensaje de commit.',
			'gsh.fileTreePanel.commitUnavailable' => 'Commit no disponible para este workspace.',
			'gsh.fileTreePanel.gitErrorTitle' => 'Error de Git',
			'gsh.fileTreePanel.deleteNewFileTitle' => '¿Eliminar archivo nuevo?',
			'gsh.fileTreePanel.discardChangesTitle' => '¿Descartar cambios?',
			'gsh.fileTreePanel.deleteNewFileMessage' => ({required Object name}) => '"${name}" es un archivo nuevo y no se puede restaurar. ¿Eliminarlo?',
			'gsh.fileTreePanel.discardOneMessage' => ({required Object name}) => '¿Descartar todos los cambios en "${name}"? Los archivos eliminados se restaurarán.',
			'gsh.fileTreePanel.discard' => 'Descartar',
			'gsh.fileTreePanel.deleteAllNewFilesTitle' => '¿Eliminar todos los archivos nuevos?',
			'gsh.fileTreePanel.allNewFilesMessage' => ({required Object count}) => 'Los ${count} archivos son nuevos y se eliminarán. Esto no se puede deshacer.',
			'gsh.fileTreePanel.discardTrackedMessage' => ({required Object count, required Object extra}) => '¿Descartar cambios en ${count} archivo(s) rastreado(s)?${extra}',
			'gsh.fileTreePanel.discardTrackedExtra' => ({required Object count}) => ' Se mantendrán ${count} archivo(s) nuevo(s).',
			'gsh.fileTreePanel.deleteAll' => 'Eliminar todo',
			'gsh.fileTreePanel.deleteQuestionTitle' => '¿Eliminar?',
			'gsh.fileTreePanel.moveToTrash' => ({required Object name}) => '¿Mover “${name}” a la Papelera?',
			'gsh.fileTreePanel.permanentlyDelete' => ({required Object name}) => '¿Eliminar “${name}” de forma permanente? Esto no se puede deshacer.',
			'gsh.fileTreePanel.couldNotDeleteTitle' => 'No se pudo eliminar',
			'gsh.fileTreePanel.moveQuestionTitle' => '¿Mover?',
			'gsh.fileTreePanel.moveMessage' => ({required Object name, required Object dest}) => '¿Mover “${name}” a “${dest}”?',
			'gsh.fileTreePanel.moveAction' => 'Mover',
			'gsh.fileTreePanel.couldNotMoveTitle' => 'No se pudo mover',
			'gsh.fileTreePanel.couldNotPasteTitle' => 'No se pudo pegar',
			'gsh.fileTreePanel.filesTooltip' => 'Archivos',
			'gsh.fileTreePanel.searchTooltip' => 'Buscar',
			'gsh.fileTreePanel.sourceControlTooltip' => 'Control de versiones',
			'gsh.fileTreePanel.databaseTooltip' => 'Base de datos',
			'gsh.fileTreePanel.sectionFiles' => 'ARCHIVOS',
			'gsh.fileTreePanel.newFile' => 'Nuevo archivo',
			'gsh.fileTreePanel.newFolder' => 'Nueva carpeta',
			'gsh.fileTreePanel.refreshTooltip' => 'Actualizar',
			'gsh.fileTreePanel.agentFilterTooltip' => 'Filtrar por agente',
			'gsh.fileTreePanel.allAgents' => 'Todos los agentes',
			'gsh.fileTreePanel.trackingUnavailable' => 'seguimiento no disponible',
			'gsh.fileTreePanel.editedBy' => ({required Object label, required Object time}) => 'Editado por ${label} · ${time}',
			'gsh.fileTreePanel.inferredSuffix' => '(inferido)',
			'gsh.fileTreePanel.noTouchedFiles' => 'Ningún archivo tocado por este agente todavía',
			'gsh.fileTreePanel.concurrentAgentEdits' => 'Editado por 2+ agentes en los últimos 10 minutos',
			'gsh.fileTreePanel.collapseAll' => 'Contraer todas las carpetas',
			'gsh.fileTreePanel.sectionSourceControl' => 'CONTROL DE VERSIONES',
			'gsh.fileTreePanel.viewAsList' => 'Ver como lista',
			'gsh.fileTreePanel.viewAsTree' => 'Ver como árbol',
			'gsh.fileTreePanel.noFolderMessage' => 'Ninguna carpeta — abre un workspace.',
			'gsh.fileTreePanel.amend' => 'Amend',
			'gsh.fileTreePanel.commitMessagePlaceholder' => 'Mensaje del commit',
			'gsh.fileTreePanel.amendCommit' => 'Amend del commit',
			'gsh.fileTreePanel.lastCommit' => 'último commit',
			'gsh.fileTreePanel.openInFinder' => 'Abrir en Finder',
			'gsh.fileTreePanel.openInExplorer' => 'Abrir en el Explorador',
			'gsh.fileTreePanel.openInFileManager' => 'Abrir en el gestor de archivos',
			'gsh.fileTreePanel.open' => 'Abrir',
			'gsh.fileTreePanel.openWith' => 'Abrir con',
			'gsh.fileTreePanel.openInNewWindow' => 'Abrir en ventana nueva',
			'gsh.fileTreePanel.openLayout' => 'Abrir layout',
			'gsh.fileTreePanel.openAsMarkdown' => 'Abrir como markdown',
			'gsh.fileTreePanel.showGitDiff' => 'Mostrar diff de git',
			'gsh.fileTreePanel.createTerminal' => 'Abrir en terminal',
			'gsh.fileTreePanel.rename' => 'Renombrar',
			'gsh.fileTreePanel.copy' => 'Copiar',
			'gsh.fileTreePanel.cut' => 'Cortar',
			'gsh.fileTreePanel.paste' => 'Pegar',
			'gsh.fileTreePanel.copyRelativePath' => 'Copiar ruta relativa',
			'gsh.fileTreePanel.copyAbsolutePath' => 'Copiar ruta absoluta',
			'gsh.fileTreePanel.renameFailed' => 'No se pudo renombrar.',
			'gsh.fileTreePanel.noChanges' => 'Sin cambios.',
			'gsh.fileTreePanel.stagedChangesHeader' => ({required Object count}) => 'CAMBIOS EN STAGE (${count})',
			'gsh.fileTreePanel.changesHeader' => ({required Object count}) => 'CAMBIOS (${count})',
			'gsh.fileTreePanel.discardAllChanges' => 'Descartar todos los cambios',
			'gsh.fileTreePanel.unstageAllChanges' => 'Quitar todo del stage',
			'gsh.fileTreePanel.stageAllChanges' => 'Poner todo en stage',
			'gsh.fileTreePanel.discardFolderChanges' => 'Descartar cambios de la carpeta',
			'gsh.fileTreePanel.unstageFolderChanges' => 'Quitar carpeta del stage',
			'gsh.fileTreePanel.stageFolderChanges' => 'Poner carpeta en stage',
			'gsh.fileTreePanel.generateCommitMessage' => 'Generar mensaje de commit',
			'gsh.fileTreePanel.generateWith' => ({required Object harness}) => 'Generar con ${harness}',
			'gsh.fileTreePanel.generateUnavailableWhileAmending' => 'No disponible mientras se enmienda un commit',
			'gsh.fileTreePanel.cancelGeneration' => 'Cancelar generación',
			'gsh.fileTreePanel.changes' => 'Cambios',
			'gsh.fileTreePanel.history' => 'Historial',
			'gsh.fileTreePanel.historyRepository' => 'Repositorio',
			'gsh.fileTreePanel.historyNoRepository' => 'No hay ningun repositorio Git disponible.',
			'gsh.fileTreePanel.historyEmpty' => 'No se encontraron commits.',
			'gsh.fileTreePanel.historyLoadFailed' => 'No se pudo cargar el historial de Git.',
			'gsh.fileTreePanel.historyUntitledCommit' => 'Commit sin titulo',
			'gsh.fileTreePanel.historyNow' => 'ahora',
			'gsh.fileTreePanel.historyMinutesAgo' => ({required Object count}) => 'hace ${count} min',
			'gsh.fileTreePanel.historyHoursAgo' => ({required Object count}) => 'hace ${count} h',
			'gsh.fileTreePanel.historyYesterday' => 'ayer',
			'gsh.fileTreePanel.historyDayAgo' => 'hace 1 dia',
			'gsh.fileTreePanel.historyDaysAgo' => ({required Object count}) => 'hace ${count} dias',
			'gsh.fileTreePanel.historyFiles' => 'Archivos modificados',
			'gsh.fileTreePanel.historyFilesEmpty' => 'No hay archivos modificados.',
			'gsh.fileTreePanel.historyFilesLoadFailed' => 'No se pudieron cargar los archivos modificados.',
			'gsh.fileTreePanel.diffEmptyTree' => 'Arbol vacio',
			'gsh.fileTreePanel.diffOriginal' => ({required Object ref}) => 'Original ${ref}',
			'gsh.fileTreePanel.diffModified' => ({required Object ref}) => 'Modificado ${ref}',
			'gsh.fileTreePanel.diffWorkingTree' => 'Directorio de trabajo',
			'gsh.fileTreePanel.diffBinaryFile' => 'Archivo binario - sin diff de texto.',
			'gsh.fileTreePanel.diffNoChanges' => 'Sin cambios.',
			'gsh.fileTreePanel.diffError' => ({required Object detail}) => 'No se pudo leer el diff: ${detail}',
			'gsh.fileTreePanel.galleryTooltip' => 'Galería',
			'gsh.fileTreePanel.sectionGallery' => 'GALERÍA',
			'gsh.fileTreePanel.openAsHtml' => 'Abrir como HTML',
			'gsh.fileTreePanel.importQuestionTitle' => '¿Copiar aquí?',
			'gsh.fileTreePanel.importMessage' => ({required Object count, required Object dest}) => '¿Copiar ${count} elementos en “${dest}”?',
			'gsh.fileTreePanel.importAction' => 'Copiar',
			'gsh.fileTreePanel.couldNotImportTitle' => 'No se pudo copiar',
			'gsh.fileTreePanel.openInAgent' => ({required Object harness}) => 'Abrir en ${harness}',
			'gsh.fileViewer.cantOpen' => 'No se puede abrir este archivo.',
			'gsh.fileViewer.couldNotLoadImage' => 'No se pudo cargar la imagen.',
			'gsh.fileViewer.preview' => 'Vista previa',
			'gsh.fileViewer.source' => 'Código fuente',
			'gsh.fileViewer.reload' => 'Recargar',
			'gsh.workspaceSettingsDialog.choosePhotoTitle' => 'Elegir foto del workspace',
			'gsh.workspaceSettingsDialog.title' => 'Configuración del workspace',
			'gsh.workspaceSettingsDialog.namePlaceholder' => 'Nombre del workspace',
			'gsh.workspaceSettingsDialog.addPhoto' => 'Añadir foto',
			'gsh.workspaceSettingsDialog.changePhoto' => 'Cambiar foto',
			'gsh.workspaceSettingsDialog.remove' => 'Quitar',
			'gsh.workspaceSettingsDialog.color' => 'Color',
			'gsh.workspaceSettingsDialog.host' => 'Host',
			'gsh.workspaceSettingsDialog.folder' => 'Carpeta',
			'gsh.realmDialogs.namePlaceholder' => 'Nombre del realm',
			'gsh.realmDialogs.duplicateName' => 'Ya existe un realm con ese nombre.',
			'gsh.realmDialogs.newRealmTitle' => 'Nuevo realm',
			'gsh.realmDialogs.renameRealmTitle' => 'Renombrar realm',
			'gsh.realmDialogs.rename' => 'Renombrar',
			'gsh.realmDialogs.deleteRealmTitle' => 'Eliminar realm',
			'gsh.realmDialogs.deleteMessage' => ({required Object name, required Object suffix}) => '¿Eliminar "${name}"? Ningún workspace se elimina — solo cambia la lista de carpetas.${suffix}',
			'gsh.realmDialogs.deleteSuffixOne' => ' Su workspace se moverá a Predeterminado.',
			'gsh.realmDialogs.deleteSuffixMany' => ({required Object count}) => ' Sus ${count} workspaces se moverán a Predeterminado.',
			'gsh.realmDialogs.manageRealmsTitle' => 'Gestionar realms',
			'gsh.realmDialogs.workspaceCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 workspace', other: '${n} workspaces', ), 
			'gsh.dbRedisTable.deleteKeyTitle' => 'Eliminar clave',
			'gsh.dbRedisTable.deleteKeyMessage' => ({required Object key}) => '¿Eliminar "${key}" de esta base de datos Redis?',
			'gsh.dbRedisTable.refresh' => 'Actualizar',
			'gsh.dbRedisTable.newKey' => 'Nueva clave',
			'gsh.dbRedisTable.columnKey' => 'CLAVE',
			'gsh.dbRedisTable.columnValue' => 'VALOR',
			'gsh.dbRedisTable.columnType' => 'TIPO',
			'gsh.dbRedisTable.columnTtl' => 'TTL',
			'gsh.dbRedisTable.keyCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 clave', other: '${n} claves', ), 
			'gsh.dbRedisTable.noKeys' => 'No hay claves en esta base de datos.',
			'gsh.dbRedisTable.noKeysMatch' => ({required Object pattern}) => 'Ninguna clave coincide con "${pattern}".',
			'gsh.dbRedisTable.loadMore' => 'Cargar más',
			'gsh.dbRedisTable.loadingFullValue' => 'Cargando valor completo…',
			'gsh.dbRedisTable.ttlMustBeNumber' => 'El TTL debe ser un número de segundos.',
			'gsh.dbRedisTable.addKey' => 'Añadir clave',
			'gsh.dbRedisTable.keyFieldHint' => 'clave',
			'gsh.dbRedisTable.ttlFieldHint' => 'ttl (s, opcional)',
			'gsh.dbRedisTable.valueFieldHint' => 'valor',
			'gsh.dbRedisTable.searchHint' => 'Buscar — patrón, ej.: user:*',
			'gsh.dbQueryView.saveQueryAs' => 'Guardar query como',
			'gsh.dbQueryView.couldNotSave' => 'No se pudo guardar',
			'gsh.dbQueryView.selectDatabase' => 'Seleccionar base de datos',
			'gsh.dbQueryView.noSqlConnections' => 'Sin conexiones SQL',
			'gsh.dbQueryView.running' => 'Ejecutando…',
			'gsh.dbQueryView.runSelection' => 'Ejecutar selección',
			'gsh.dbQueryView.run' => 'Ejecutar',
			'gsh.dbQueryView.pickDatabaseHint' => 'Elige una base de datos arriba y luego Ejecutar (⌘↵).',
			'gsh.dbQueryView.runQueryHint' => 'Ejecuta la query (⌘↵) para ver los resultados aquí.',
			'gsh.dbQueryView.noRows' => 'Sin filas.',
			'gsh.dbQueryView.rowsAffected' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 fila afectada', other: '${n} filas afectadas', ), 
			'gsh.dbQueryView.rowsFooter' => ({required Object n}) => '${n} filas',
			'gsh.dbQueryView.truncatedSuffix' => ' · truncado (aumenta -- limit)',
			'gsh.dbQueryView.table' => 'Tabla',
			'gsh.dbQueryView.json' => 'JSON',
			'gsh.dbQueryView.unsaved' => 'sin guardar',
			'gsh.dbQueryView.saved' => 'guardado',
			'gsh.dbQueryView.copied' => 'Copiado',
			'gsh.dbQueryView.copy' => 'Copiar',
			'gsh.httpView.saveRequestAs' => 'Guardar request como',
			'gsh.httpView.couldNotSave' => 'No se pudo guardar',
			'gsh.httpView.run' => 'Ejecutar',
			'gsh.httpView.running' => 'Ejecutando…',
			'gsh.httpView.noRequests' => 'Ningún request en este archivo — escribe uno, p. ej.: GET https://example.com',
			'gsh.httpView.selectRequest' => 'Seleccionar request',
			'gsh.httpView.requestCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 request', other: '${n} requests', ), 
			'gsh.httpView.runHint' => 'Ejecuta el request (⌘↵) para ver la respuesta aquí.',
			'gsh.httpView.emptyBody' => 'Cuerpo de la respuesta vacío.',
			'gsh.httpView.body' => 'JSON',
			'gsh.httpView.headers' => 'Headers',
			'gsh.httpView.raw' => 'Text',
			'gsh.httpView.truncatedSuffix' => ' · truncado (respuesta demasiado grande)',
			'gsh.httpView.error.title' => 'Falló el request',
			'gsh.httpView.error.noRequest' => 'No se encontró ningún request en la posición del cursor.',
			'gsh.httpView.error.invalidUrl' => ({required Object url}) => 'URL inválida: ${url}',
			'gsh.httpView.error.unresolvedVariable' => ({required Object name}) => 'La variable {{${name}}} no tiene valor. Declárala con @${name} = … en este archivo.',
			'gsh.httpView.error.bodyFileMissing' => ({required Object path}) => 'Archivo de cuerpo no encontrado: ${path}',
			'gsh.httpView.error.bodyFileUnreadable' => ({required Object path, required Object detail}) => 'No se pudo leer el archivo de cuerpo ${path}: ${detail}',
			'gsh.httpView.error.connectionFailed' => ({required Object detail}) => 'No se pudo alcanzar el servidor: ${detail}',
			'gsh.httpView.error.connectionFailedNoDetail' => 'No se pudo alcanzar el servidor.',
			'gsh.httpView.error.timeout' => ({required Object seconds}) => 'El request superó el tiempo límite de ${seconds}s.',
			'gsh.httpView.error.responseTooLarge' => ({required Object bytes}) => 'La respuesta superó el límite de ${bytes} bytes.',
			'gsh.kanbanView.filter' => 'Filtrar',
			'gsh.kanbanView.filterTitlePlaceholder' => 'Buscar por título',
			'gsh.kanbanView.filterLabels' => 'Etiquetas',
			'gsh.kanbanView.filterClear' => 'Limpiar',
			'gsh.kanbanView.filterDependencies' => 'Dependencias',
			'gsh.kanbanView.filterBlocked' => 'Bloqueado',
			'gsh.kanbanView.filterReady' => 'Listo',
			'gsh.kanbanView.blockedBy' => 'Bloqueado por',
			'gsh.kanbanView.addBlocker' => 'Agregar tarjeta bloqueante',
			'gsh.kanbanView.searchCards' => 'Buscar tarjetas',
			'gsh.kanbanView.unknownCard' => 'desconocida',
			'gsh.kanbanView.boardView' => 'Tablero',
			'gsh.kanbanView.listView' => 'Lista',
			'gsh.kanbanView.refresh' => 'Actualizar desde el disco',
			'gsh.kanbanView.manageLabels' => 'Etiquetas',
			'gsh.kanbanView.labelsTitle' => 'Etiquetas de este tablero',
			'gsh.kanbanView.labelNamePlaceholder' => 'nombre de la etiqueta',
			'gsh.kanbanView.labelUsage' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 tarjeta', other: '${n} tarjetas', ), 
			'gsh.kanbanView.deleteLabel' => 'Eliminar etiqueta',
			'gsh.kanbanView.newCard' => 'nueva tarjeta',
			'gsh.kanbanView.newCardTitle' => 'Nueva tarjeta',
			'gsh.kanbanView.newColumn' => 'Nueva columna',
			'gsh.kanbanView.columnNameTitle' => 'Nombre de la columna',
			'gsh.kanbanView.dragColumn' => 'Arrastrar columna',
			'gsh.kanbanView.columnOptions' => 'Opciones de la columna',
			'gsh.kanbanView.renameColumn' => 'Renombrar columna',
			'gsh.kanbanView.moveColumnLeft' => 'Mover a la izquierda',
			'gsh.kanbanView.moveColumnRight' => 'Mover a la derecha',
			'gsh.kanbanView.deleteColumn' => 'Eliminar columna',
			'gsh.kanbanView.newCardHere' => 'Nueva tarjeta aquí',
			'gsh.kanbanView.duplicateCard' => 'Duplicar',
			'gsh.kanbanView.cardLabels' => 'Etiquetas',
			'gsh.kanbanView.deleteCard' => 'Eliminar tarjeta',
			'gsh.kanbanView.advance' => 'Pasar a la siguiente columna',
			'gsh.kanbanView.advanceHold' => 'Mover a la siguiente columna (mantener: mover a la última)',
			'gsh.kanbanView.advanceBack' => 'Volver una columna',
			'gsh.kanbanView.emptyColumn' => 'Sin tarjetas',
			'gsh.kanbanView.cardCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 tarjeta', other: '${n} tarjetas', ), 
			'gsh.kanbanView.notes' => 'Nota',
			'gsh.kanbanView.notesPlaceholder' => 'Escribe una nota',
			'gsh.kanbanView.comments' => 'Comentarios',
			'gsh.kanbanView.addComment' => 'Añadir comentario',
			'gsh.kanbanView.commentPlaceholder' => 'Escribe un comentario',
			'gsh.kanbanView.noComments' => 'Aún no hay comentarios',
			'gsh.kanbanView.closeDetail' => 'Cerrar',
			'gsh.kanbanView.notABoard' => 'Este archivo aún no tiene columnas ## — se abre como markdown.',
			'gsh.kanbanView.startBoard' => 'Empezar un tablero',
			'gsh.kanbanView.couldNotSave' => 'No se pudo guardar el tablero',
			'gsh.kanbanView.unrecognizedBlock' => 'No reconocido por el analizador — se arrastra entero, sin edición en línea.',
			'gsh.kanbanView.deleteColumnDialog.title' => ({required Object name}) => '¿Eliminar «${name}»?',
			'gsh.kanbanView.deleteColumnDialog.message' => ({required Object count}) => 'Esta columna tiene ${count}. Elige qué pasa con ellas.',
			'gsh.kanbanView.deleteColumnDialog.moveCards' => 'Mover a la columna anterior',
			'gsh.kanbanView.deleteColumnDialog.deleteAll' => 'Eliminar junto con la columna',
			'gsh.kanbanView.deleteColumnDialog.emptyMessage' => 'Esta columna está vacía.',
			'gsh.dbPanel.sectionDatabase' => 'BASE DE DATOS',
			'gsh.dbPanel.edit' => 'Editar…',
			'gsh.dbPanel.copyName' => 'Copiar nombre',
			'gsh.dbPanel.newQuery' => 'Nueva query',
			'gsh.dbPanel.browseKeys' => 'Ver claves',
			'gsh.dbPanel.deleteConnectionTitle' => 'Eliminar conexión',
			'gsh.dbPanel.deleteConnectionMessage' => ({required Object name}) => '¿Quitar "${name}" de este workspace? Cualquier contraseña guardada se descartará. Los archivos .dbq que la referencian no se modifican.',
			'gsh.dbPanel.footer' => ({required Object n}) => '.gsh/databases.json · ${n} conexiones',
			'gsh.dbPanel.footerOne' => '.gsh/databases.json · 1 conexión',
			'gsh.dbPanel.noConnections' => 'Aún no hay conexiones.',
			'gsh.dbPanel.passwordRequired' => 'Contraseña no encontrada en el host. Abre esta conexión y vuelve a escribirla — se guarda en la máquina que ejecuta la base de datos, no en esta.',
			'gsh.dbMongoView.deleteDocumentTitle' => 'Eliminar documento',
			'gsh.dbMongoView.deleteDocumentMessage' => ({required Object id, required Object collection}) => '¿Eliminar el documento con _id ${id} de "${collection}"?',
			'gsh.dbMongoView.filterHint' => 'Filtro — JSON, ej.: {"status": "active"}',
			'gsh.dbMongoView.docCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 doc', other: '${n} docs', ), 
			'gsh.dbMongoView.refresh' => 'Actualizar',
			'gsh.dbMongoView.insertDocument' => 'Insertar documento',
			'gsh.dbMongoView.noDocuments' => 'No hay documentos en esta colección.',
			'gsh.dbMongoView.noDocumentsMatch' => 'Ningún documento coincide con este filtro.',
			'gsh.dbMongoView.loadMore' => 'Cargar más',
			'gsh.dbMongoView.edit' => 'Editar',
			'gsh.dbMongoView.insert' => 'Insertar',
			'gsh.dbConnectionDialog.chooseFileTitle' => 'Elegir base de datos SQLite',
			'gsh.dbConnectionDialog.file' => 'Archivo',
			'gsh.dbConnectionDialog.chooseFilePlaceholder' => 'Elige un archivo SQLite…',
			'gsh.dbConnectionDialog.name' => 'Nombre',
			'gsh.dbConnectionDialog.password' => 'Contraseña',
			'gsh.dbConnectionDialog.savePassword' => 'Guardar contraseña',
			'gsh.dbConnectionDialog.allowWrites' => 'Permitir escritura (agentes)',
			'gsh.dbConnectionDialog.allowWritesHint' => 'desactivado = los agentes solo leen vía CLI',
			'gsh.dbConnectionDialog.visibleToAgents' => 'Visible para agentes',
			'gsh.dbConnectionDialog.visibleToAgentsHint' => 'desactivado = oculto en la CLI, solo en la GUI',
			'gsh.dbConnectionDialog.testing' => 'Probando conexión…',
			'gsh.dbConnectionDialog.connectionOk' => 'Conexión OK',
			'gsh.dbConnectionDialog.connectionFailed' => 'Fallo en la conexión',
			'gsh.dbConnectionDialog.editTitle' => 'Editar conexión',
			'gsh.dbConnectionDialog.newTitle' => 'Nueva conexión',
			'gsh.dbConnectionDialog.connectionString' => 'Connection string',
			'gsh.dbConnectionDialog.invalidUrl' => 'URL de conexión no válida.',
			'gsh.dbConnectionDialog.sshTunnel' => 'Túnel SSH',
			'gsh.dbConnectionDialog.sshHost' => 'Host SSH',
			'gsh.dbConnectionDialog.sshPort' => 'Puerto SSH',
			'gsh.dbConnectionDialog.sshUser' => 'Usuario SSH',
			'gsh.dbConnectionDialog.privateKey' => 'Clave privada',
			'gsh.dbConnectionDialog.choosePrivateKeyPlaceholder' => 'Elige una clave privada…',
			'gsh.dbConnectionDialog.choosePrivateKeyDialogTitle' => 'Elegir clave privada SSH',
			_ => null,
		} ?? switch (path) {
			'gsh.dbConnectionDialog.keyPassphrase' => 'Frase de contraseña de la clave',
			'gsh.dbConnectionDialog.savePassphrase' => 'Guardar frase de contraseña',
			'gsh.dbConnectionDialog.passwordOnHost' => 'La contraseña se guarda en el host, no en esta máquina.',
			'gsh.sshPrompts.unknownSshHostTitle' => 'Host SSH desconocido',
			'gsh.sshPrompts.neverConnected' => ({required Object endpoint}) => 'GSH Desktop nunca se ha conectado a ${endpoint} antes.',
			'gsh.sshPrompts.trustHint' => 'Confía solo si esta fingerprint coincide con el servidor. Puedes verificarla en el servidor con:',
			'gsh.sshPrompts.trust' => 'Confiar',
			'gsh.sshPrompts.sshKeyPassphraseTitle' => 'Frase de contraseña de la clave SSH',
			'gsh.sshPrompts.unlockMessage' => ({required Object keyPath, required Object connectionName}) => 'Desbloquea ${keyPath} para conectar "${connectionName}".',
			'gsh.sshPrompts.keptInMemoryHint' => 'Se mantiene en memoria hasta que GSH Desktop se cierre. Para que los agentes usen esta conexión, activa "Guardar frase de contraseña" en la conexión.',
			'gsh.sshPrompts.unlock' => 'Desbloquear',
			'gsh.projectsRail.workspaces' => 'Workspaces',
			'gsh.projectsRail.keepAwakeOn' => 'Manteniendo este equipo despierto para acceso remoto. Haz clic para dejarlo dormir de nuevo.',
			'gsh.projectsRail.keepAwakeOff' => 'Mantener este equipo despierto para acceso remoto. Se apaga solo cuando GSH Desktop se reinicia.',
			'gsh.projectsRail.keepAwakeBattery' => 'Despierto con batería. Esto consume la batería.',
			'gsh.projectsRail.keepAwakeLid' => 'Cerrar la tapa del portátil sigue poniéndolo a dormir.',
			'gsh.projectsRail.newWorkspace' => 'Nuevo workspace',
			'gsh.projectsRail.settings' => 'Configuración',
			'gsh.projectsRail.mergeToParent' => 'Fusionar en el padre',
			'gsh.projectsRail.updateFromParent' => 'Actualizar desde el padre',
			'gsh.projectsRail.forkWorktree' => 'Crear worktree derivada',
			'gsh.projectsRail.copyBranch' => 'Copiar branch',
			'gsh.projectsRail.remove' => 'Quitar',
			'gsh.projectsRail.moveToRealm' => 'Mover a realm',
			'gsh.projectsRail.copyWorkspaceId' => 'Copiar id del workspace',
			'gsh.projectsRail.rename' => 'Renombrar',
			'gsh.projectsRail.close' => 'Cerrar',
			'gsh.projectsRail.newRealm' => 'Nuevo realm…',
			'gsh.projectsRail.manageRealms' => 'Gestionar realms…',
			'gsh.projectsRail.noWorkspaces' => 'Aún no hay workspaces.',
			'gsh.projectsRail.sync' => 'Sincronizar',
			'gsh.projectsRail.pull' => 'Pull',
			'gsh.projectsRail.push' => 'Push',
			'gsh.projectsRail.createWorktree' => 'Crear worktree',
			'gsh.projectsRail.worktreeCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: '1 worktree', other: '${n} worktrees', ), 
			'gsh.projectsRail.expandWorktrees' => 'Expandir worktrees',
			'gsh.projectsRail.collapseWorktrees' => 'Contraer worktrees',
			'gsh.findBar.find' => 'Buscar',
			'gsh.findBar.matchCase' => 'Coincidir mayúsculas',
			'gsh.findBar.wholeWord' => 'Palabra completa',
			'gsh.findBar.useRegex' => 'Usar expresión regular',
			'gsh.findBar.previous' => 'Anterior (⇧⏎)',
			'gsh.findBar.next' => 'Siguiente (⏎)',
			'gsh.findBar.close' => 'Cerrar (Esc)',
			'gsh.findBar.badPattern' => 'Patrón inválido',
			'gsh.findBar.noResults' => 'Sin resultados',
			'gsh.contentSearch.sectionSearch' => 'BÚSQUEDA',
			'gsh.contentSearch.searchInFiles' => 'Buscar en los archivos',
			'gsh.contentSearch.matchCase' => 'Coincidir mayúsculas',
			'gsh.contentSearch.wholeWord' => 'Palabra completa',
			'gsh.contentSearch.useRegex' => 'Usar expresión regular',
			'gsh.contentSearch.invalidRegex' => 'Expresión regular inválida.',
			'gsh.contentSearch.typeToSearch' => 'Escribe para buscar en todos los archivos.',
			'gsh.contentSearch.searching' => 'Buscando…',
			'gsh.contentSearch.noResults' => 'Sin resultados.',
			'gsh.topbar.collapseSidebar' => 'Contraer barra lateral',
			'gsh.topbar.toggleFiles' => 'Mostrar/ocultar archivos',
			'gsh.topbar.filesUnavailable' => 'Archivos no disponibles en GSH Desktop',
			'gsh.topbar.hideKeyboard' => 'Ocultar teclado',
			'gsh.topbar.visualizeAgents' => 'Visualizar agentes',
			'gsh.topbar.openHarness' => 'Harness del workspace',
			'gsh.topbar.openFarm' => 'Granja de agentes',
			'gsh.topbar.openChat' => 'Chat con Claude (beta)',
			'gsh.tasks.hotReload' => 'Hot reload',
			'gsh.tasks.hotRestart' => 'Hot restart',
			'gsh.tasks.toggleDebugPaint' => 'Alternar debug paint',
			'gsh.tasks.togglePlatform' => 'Alternar plataforma',
			'gsh.tasks.quit' => 'Salir',
			'gsh.notifications.agentFinished' => 'El agente terminó',
			'gsh.notifications.open' => 'Abrir',
			'gsh.notifications.agentNeedsAction' => 'El agente necesita tu acción',
			'gsh.terminalLink.open' => 'Abrir',
			'gsh.terminalLink.revealFinder' => 'Mostrar en Finder',
			'gsh.terminalLink.revealExplorer' => 'Mostrar en el Explorador',
			'gsh.terminalLink.revealFolder' => 'Abrir carpeta contenedora',
			'gsh.terminalLink.copyPath' => 'Copiar ruta',
			'gsh.terminalLink.openLink' => 'Abrir enlace',
			'gsh.terminalLink.copyLink' => 'Copiar enlace',
			'gsh.terminal.cwdFallbackWarning' => ({required Object requested, required Object path}) => 'Aviso: la carpeta "${requested}" no existe. Esta terminal se abrió en "${path}".',
			'gsh.terminal.workspaceEnvTracked' => ({required Object keys}) => 'Aviso: el .env.gsh está rastreado por git (vino con el repositorio). Inyectado: ${keys}',
			'gsh.remoteHost.addHost' => 'Añadir host remoto',
			'gsh.remoteHost.hostName' => 'Nombre',
			'gsh.remoteHost.sshTarget' => 'Destino SSH (usuario@host)',
			'gsh.remoteHost.connecting' => ({required Object host}) => 'Conectando a ${host}…',
			'gsh.remoteHost.openingTunnel' => 'Túnel SSH',
			'gsh.remoteHost.installingServer' => 'Instalando servidor',
			'gsh.remoteHost.handshake' => ({required Object version}) => 'Servidor ${version}',
			'gsh.remoteHost.loadingWorkspace' => 'Cargando workspace…',
			'gsh.remoteHost.reconnecting' => ({required Object host}) => 'Reconectando a ${host}…',
			'gsh.remoteHost.offline' => ({required Object host}) => '${host} sin conexión',
			'gsh.remoteHost.remove' => 'Quitar',
			'gsh.remoteHost.reconnect' => 'Reconectar',
			'gsh.remoteHost.installServer' => 'Instalar servidor',
			'gsh.remoteHost.errSshUnreachable' => ({required Object host}) => 'No se puede llegar a ${host} por SSH. ¿Está encendido y con Inicio de sesión remoto activado?',
			'gsh.remoteHost.errInstallFailed' => ({required Object host}) => 'No se pudo instalar el servidor en ${host}.',
			'gsh.remoteHost.errVersionMismatch' => 'Versión del servidor incompatible; actualízalo.',
			'gsh.remoteHost.errDetail' => ({required Object detail}) => 'Detalles: ${detail}',
			'gsh.remoteHost.pickFolderTitle' => ({required Object host}) => 'Abrir carpeta en ${host}',
			'gsh.remoteHost.openHere' => 'Abrir aquí',
			'gsh.remoteHost.emptyFolder' => 'Sin subcarpetas',
			'gsh.remoteHost.newLocal' => 'Local',
			'gsh.remoteHost.newRemote' => 'Remoto',
			'gsh.remoteHost.chooseHost' => 'Elegir un host',
			'gsh.remoteHost.newHostEntry' => 'Nuevo host…',
			'gsh.remoteHost.editHost' => 'Editar host',
			'gsh.remoteHost.userLabel' => 'Usuario',
			'gsh.remoteHost.hostLabel' => 'Host / IP',
			'gsh.remoteHost.portLabel' => 'Puerto',
			'gsh.remoteHost.authLabel' => 'Autenticación',
			'gsh.remoteHost.authKey' => 'Clave SSH',
			'gsh.remoteHost.authPassword' => 'Contraseña',
			'gsh.remoteHost.passwordLabel' => 'Contraseña',
			'gsh.remoteHost.passwordKeep' => 'Deja en blanco para mantener la actual',
			'gsh.remoteHost.errUser' => 'Usuario obligatorio',
			'gsh.remoteHost.errHost' => 'Host obligatorio',
			'gsh.remoteHost.errPassword' => 'Contraseña obligatoria',
			'gsh.remoteHost.identityChoose' => 'Elegir…',
			'gsh.remoteHost.identityEmpty' => 'Ninguna clave seleccionada',
			'gsh.remoteHost.identityDialogTitle' => 'Selecciona la clave privada SSH',
			'gsh.remoteHost.errIdentity' => 'Elige la clave privada para autenticarte.',
			'gsh.remoteHost.errHostKeyUnknown' => ({required Object host}) => 'GSH Desktop todavía no confía en ${host}. Conecta de nuevo y confirma la huella.',
			'gsh.remoteHost.errHostKeyChanged' => ({required Object host}) => '${host} presenta una clave SSH distinta de la guardada. Si no reinstalaste esa máquina, detente y compruébalo; si la reinstalaste, elimina la entrada antigua de ~/.ssh/known_hosts.',
			'gsh.remoteHost.errHostBundleMissing' => ({required Object host}) => '${host} es Windows pero no tiene GSH Desktop instalado. El servidor remoto se instala desde el bundle de GSH Desktop que ya está en esa máquina — instálalo allí e inténtalo de nuevo.',
			'gsh.remoteHost.errHostUnknownOs' => ({required Object host}) => 'No se pudo identificar el sistema de ${host}. La cuenta puede tener un shell restringido, o ninguno.',
			'gsh.remoteHost.errIdentityPublic' => 'Solo está la clave pública. Eso funciona solo si la privada está en tu agente SSH; si no, elige la privada (mismo nombre, sin .pub).',
			'gsh.remoteHost.errIdentityNotKey' => 'Ese archivo no parece una clave privada.',
			'gsh.remoteHost.errIdentityMissingFile' => 'Ese archivo ya no existe.',
			'gsh.remoteHost.errIdentityUnreadable' => 'No se pudo leer ese archivo.',
			'gsh.browserPane.back' => 'Atrás',
			'gsh.browserPane.forward' => 'Adelante',
			'gsh.browserPane.reload' => 'Recargar',
			'gsh.browserPane.urlHint' => 'Escribe la URL o dirección',
			'gsh.browserPane.go' => 'Ir',
			'gsh.documentWindow.mediaNotSupported' => 'Audio y video se abren en la ventana principal de GSH Desktop.',
			'gsh.documentWindow.fileNotFound' => ({required Object path}) => 'Archivo no encontrado: ${path}',
			'gsh.gallery.intro' => 'Documentos especiales de GSH Desktop para que veas lo que el agente de IA está haciendo.',
			'gsh.gallery.createErrorTitle' => 'No se pudo crear el archivo',
			'gsh.gallery.dbQuery.title' => 'Consulta de base de datos',
			'gsh.gallery.dbQuery.description' => 'Editor SQL con grilla de resultados, usando una de las conexiones registradas.',
			'gsh.gallery.kanban.title' => 'Tablero kanban',
			'gsh.gallery.kanban.description' => 'Columnas y tarjetas guardadas como markdown puro. Arrastra, edita y comenta.',
			'gsh.gallery.layout.title' => 'Layout de paneles',
			'gsh.gallery.layout.description' => 'Terminales y splits para abrir de una vez, estilo tmuxinator. Puede ejecutarse solo en worktrees nuevos.',
			'gsh.gallery.httpRequest.title' => 'Requests HTTP',
			'gsh.gallery.httpRequest.description' => 'Escribe requests en un archivo y ejecútalos con la respuesta al lado.',
			'gsh.gallery.html.title' => 'Vista HTML',
			'gsh.gallery.html.description' => 'Una página que el agente escribe y GSH Desktop renderiza directo: mapa mental, diagrama, gráfico, lo que necesites.',
			'gsh.gallery.tasks.title' => 'Tareas',
			'gsh.gallery.tasks.description' => 'Comandos para ejecutar desde el panel de Tasks, como dev server, tests y build. Vive en .gsh/tasks.json.',
			'gsh.gallery.notebook.title' => 'Cuaderno',
			'gsh.gallery.notebook.description' => 'Una carpeta de notas cortas con tags. El agente escribe, tú lees y editas. También abre en Obsidian.',
			'gsh.gallery.workspaceEnv.title' => 'Env del workspace',
			'gsh.gallery.workspaceEnv.description' => 'Variables inyectadas en cada terminal de este workspace. Pon tokens o credenciales de API aquí en vez de pegarlos en el prompt del agente. Queda fuera de git.',
			'gsh.gallery.panel.title' => 'Panel',
			'gsh.gallery.panel.description' => 'Una página HTML con puente a la app: sus botones ejecutan comandos de la CLI de GSH Desktop y del shell en esta máquina. Un playground para dashboards rápidos.',
			'gsh.notebook.notes' => 'Notas',
			'gsh.notebook.newNote' => 'Nueva nota',
			'gsh.notebook.searchPlaceholder' => 'Buscar notas',
			'gsh.notebook.empty' => 'Aún no hay notas. Crea una, o pídele al agente que escriba aquí.',
			'gsh.notebook.noMatch' => 'Ninguna nota coincide.',
			'gsh.notebook.selectNote' => 'Selecciona una nota',
			'gsh.notebook.reload' => 'Recargar del disco',
			'gsh.notebook.untagged' => 'sin tag',
			'gsh.notebook.saveFailed' => 'No se pudo guardar la nota',
			'gsh.notebook.createFailed' => 'No se pudo crear la nota',
			'gsh.notebook.addTag' => 'añadir tag',
			'gsh.notebook.untitled' => 'Sin título',
			'gsh.notebook.deleteNote' => 'Eliminar nota',
			'gsh.notebook.deleteConfirm' => ({required Object name}) => '¿Mover “${name}” a la papelera?',
			'gsh.notebook.imageFailed' => 'No se pudo guardar la imagen',
			'gsh.notebook.format.bold' => 'Negrita (⌘B)',
			'gsh.notebook.format.italic' => 'Cursiva (⌘I)',
			'gsh.notebook.format.strike' => 'Tachado',
			'gsh.notebook.format.heading1' => 'Título 1',
			'gsh.notebook.format.heading2' => 'Título 2',
			'gsh.notebook.format.heading3' => 'Título 3',
			'gsh.notebook.format.bullets' => 'Lista',
			'gsh.notebook.format.numbered' => 'Lista numerada',
			'gsh.notebook.format.checklist' => 'Checklist',
			'gsh.notebook.format.quote' => 'Cita',
			'gsh.notebook.format.code' => 'Código inline (⌘E)',
			'gsh.notebook.format.codeBlock' => 'Bloque de código',
			'gsh.notebook.format.link' => 'Enlace (⌘K)',
			'gsh.notebook.format.rule' => 'Divisor',
			'gsh.notebook.format.noteLink' => 'Enlace a una nota ([[…]])',
			'gsh.notebook.format.noteLinkSearch' => 'Buscar notas',
			'gsh.notebook.format.image' => 'Insertar imagen…',
			'gsh.notebook.backlinks' => 'Enlazada desde',
			'gsh.notebook.renameTag' => 'Renombrar tag',
			'gsh.notebook.deleteTag' => 'Eliminar tag',
			'gsh.notebook.deleteTagConfirm' => ({required Object name, required Object count}) => '¿Quitar “${name}” de ${count} notas? Las notas se conservan.',
			'gsh.notebook.showList' => 'Mostrar lista de notas',
			'gsh.notebook.hideList' => 'Ocultar lista de notas',
			'gsh.layoutPreview.applyFailedTitle' => 'No se pudo aplicar el diseño',
			'gsh.layoutPreview.applyInGsh' => 'Aplicar en GSH Desktop',
			'gsh.layoutPreview.applyNewWorkspace' => 'Abrir como nuevo espacio de trabajo',
			'gsh.layoutPreview.applyTo' => ({required Object workspace}) => 'Aplicar en ${workspace}',
			'gsh.layoutPreview.autorunWorktree' => 'autorun: worktree. Este diseño también se aplica solo al crear un worktree del espacio de trabajo que lo contiene.',
			'gsh.layoutPreview.command' => 'Comando',
			'gsh.layoutPreview.folder' => 'Carpeta',
			'gsh.layoutPreview.noCommand' => 'sin comando, abre un shell',
			'gsh.layoutPreview.replaceConfirm' => 'Reemplazar diseño',
			'gsh.layoutPreview.replaceMessage' => ({required Object n}) => 'Se cerrarán ${n} pestañas abiertas de este espacio de trabajo, incluidas las que tienen trabajo en curso.',
			'gsh.layoutPreview.replaceTitle' => ({required Object workspace}) => '¿Reemplazar el diseño de ${workspace}?',
			'gsh.layoutPreview.skippedTitle' => 'No se crean en este sistema',
			'gsh.layoutPreview.splitDown' => 'divide abajo',
			'gsh.layoutPreview.splitRight' => 'divide a la derecha',
			'gsh.layoutPreview.splitTab' => 'pestaña',
			'gsh.layoutPreview.subtitle' => ({required Object n}) => 'Este diseño abre ${n} terminales. Lee los comandos antes de aplicarlo.',
			'gsh.telemetry.tooltip' => 'Telemetría',
			'gsh.telemetry.title' => 'Telemetría',
			'gsh.telemetry.liveRuns' => ({required Object n}) => '${n} activos',
			'gsh.telemetry.noWorkspace' => 'Abre un workspace para ver su telemetría.',
			'gsh.telemetry.empty' => 'Nada por aquí todavía.',
			'gsh.telemetry.emptyFiltered' => 'Nada por aquí todavía.',
			'gsh.telemetry.searchHint' => 'Filtrar casos',
			'gsh.telemetry.chipOpen' => 'Abiertos',
			'gsh.telemetry.chipNew' => 'Nuevos',
			'gsh.telemetry.chipResolved' => 'Resueltos',
			'gsh.telemetry.chipIgnored' => 'Ignorados',
			'gsh.telemetry.chipWarnings' => 'Avisos',
			'gsh.telemetry.tagNew' => 'nuevo',
			'gsh.telemetry.tagRegression' => 'regresión',
			'gsh.telemetry.tagResolved' => 'resuelto',
			'gsh.telemetry.tagIgnored' => 'ignorado',
			'gsh.telemetry.srcTask' => 'task',
			'gsh.telemetry.srcWrapper' => 'gsh telemetry',
			'gsh.telemetry.run' => ({required Object id}) => 'run ${id}',
			'gsh.telemetry.resolve' => 'Marcar resuelto',
			'gsh.telemetry.ignore' => 'Ignorar (también se oculta a los agentes)',
			'gsh.telemetry.reopen' => 'Reabrir',
			'gsh.telemetry.clear' => 'Limpiar ocurrencias',
			'gsh.telemetry.clearRun' => 'Limpiar este run',
			'gsh.telemetry.clearProject' => 'Limpiar proyecto',
			'gsh.telemetry.openFile' => ({required Object location}) => 'Abrir ${location}',
			'gsh.telemetry.showInTerminal' => 'Ver en la terminal',
			'gsh.telemetry.copyCommand' => 'Copiar comando de la CLI',
			'gsh.telemetry.copied' => 'Copiado',
			'gsh.telemetry.statusOpen' => 'Abierto',
			'gsh.telemetry.statusResolved' => 'Resuelto',
			'gsh.telemetry.statusIgnored' => 'Ignorado',
			'gsh.telemetry.occurrences' => 'Ocurrencias',
			'gsh.telemetry.inRuns' => ({required Object n}) => 'en ${n} runs',
			'gsh.telemetry.first' => 'Primera',
			'gsh.telemetry.last' => 'Última',
			'gsh.telemetry.origin' => 'Origen',
			'gsh.telemetry.sectionStack' => 'Stack',
			'gsh.telemetry.stackHint' => 'frames del proyecto destacados · clic abre el archivo',
			'gsh.telemetry.sectionCorrelated' => 'Log correlacionado',
			'gsh.telemetry.correlatedHint' => 'el JSON más cercano antes del error, en el mismo run',
			'gsh.telemetry.none' => 'ninguno',
			'gsh.telemetry.sectionRuns' => 'Ocurrencias por run',
			'gsh.telemetry.runsHint' => 'misma clave (cwd, comando): así se calculan nuevo y regresión',
			'gsh.telemetry.sectionContext' => 'Contexto crudo',
			'gsh.telemetry.contextHint' => 'líneas de la terminal alrededor de la última ocurrencia',
			'gsh.telemetry.current' => 'actual',
			'gsh.telemetry.fingerprintHint' => ({required Object location}) => 'fingerprint = tipo + mensaje normalizado + ${location}',
			'gsh.telemetry.blameUncommitted' => 'cambiado en el working tree',
			'gsh.telemetry.blameCommit' => ({required Object ago, required Object sha}) => 'cambiado ${ago} (${sha})',
			'gsh.telemetry.justNow' => 'ahora',
			'gsh.telemetry.minutesAgo' => ({required Object n}) => 'hace ${n} min',
			'gsh.telemetry.hoursAgo' => ({required Object n}) => 'hace ${n} h',
			'gsh.telemetry.daysAgo' => ({required Object n}) => 'hace ${n} d',
			'gsh.telemetry.resolvedToast' => 'Resuelto. Si vuelve en un run futuro, reaparece como regresión.',
			'gsh.telemetry.ignoredToast' => 'Ignorado. Los agentes ya no lo ven (salvo --include-ignored).',
			'gsh.telemetry.clearedToast' => 'Ocurrencias borradas. Las reglas de triaje se mantienen.',
			'gsh.telemetry.byHuman' => 'por ti',
			'gsh.telemetry.byAgent' => 'por el agente',
			'gsh.telemetry.caseTabTitle' => ({required Object type, required Object file}) => '${type} · ${file}',
			'gsh.telemetry.srcApp' => 'App',
			'gsh.telemetry.chipApp' => 'GSH Desktop',
			'gsh.panelView.unavailable' => 'Los paneles necesitan la web view integrada, que todavía no existe en Linux.',
			'gsh.panelView.openInBrowser' => 'Abrir en el navegador',
			'gsh.panelView.openAsHtml' => 'Abrir como HTML',
			'gsh.chat.tabTitle' => 'Chat',
			'gsh.chat.emptyTitle' => 'Nueva conversación',
			'gsh.chat.emptySubtitle' => ({required Object folder}) => 'Claude Code en ${folder}, con tu propio login.',
			'gsh.chat.emptyHintSend' => 'Enter envía; Shift+Enter agrega una línea.',
			'gsh.chat.emptyHintPaste' => 'Pega una captura con Ctrl+V o suelta archivos en el chat.',
			'gsh.chat.emptyHintMode' => 'Elige el modo de permiso debajo del campo: pedir, aceptar ediciones, planificar o ignorar.',
			'gsh.chat.placeholder' => 'Mensaje para Claude… (Enter envía, Shift+Enter nueva línea)',
			'gsh.chat.send' => 'Enviar',
			'gsh.chat.stop' => 'Detener',
			'gsh.chat.working' => 'trabajando…',
			'gsh.chat.waitingYou' => 'esperándote',
			'gsh.chat.cost' => ({required Object v}) => 'costo US\$ ${v}',
			'gsh.chat.askPermission' => ({required Object tool}) => '¿Permitir ${tool}?',
			'gsh.chat.allow' => 'Permitir',
			'gsh.chat.deny' => 'Denegar',
			'gsh.chat.allowed' => 'Permitido',
			'gsh.chat.denied' => 'Denegado',
			'gsh.chat.startFailed' => ({required Object detail}) => 'No pude iniciar claude: ${detail}',
			'gsh.chat.engineExited' => ({required Object code}) => 'claude terminó (código ${code}).',
			'gsh.chat.turnFailed' => ({required Object detail}) => 'El turno terminó con error: ${detail}',
			'gsh.chat.handedOff' => 'La conversación sigue en una terminal con Remote Control: ábrela en el celular o en claude.ai/code. El chat aquí queda en pausa.',
			'gsh.chat.peerMessageFrom' => ({required Object name}) => 'Mensaje de ${name}',
			'gsh.chat.sessions' => 'Sesiones',
			'gsh.chat.noSessions' => 'Ninguna otra sesión de Claude Code en ejecución ahora.',
			'gsh.chat.listAllSessions' => 'Listar todas las sesiones (pregunta al agente)…',
			'gsh.chat.askListSessions' => 'Lista las sesiones a las que puedo enviar mensaje, con ListAgents, y espera a que elija una. ',
			'gsh.chat.sendToSession' => ({required Object name}) => 'Envía este mensaje a la sesión "${name}" con SendMessage y espera su respuesta: ',
			'gsh.chat.remoteControl' => 'Remote Control',
			'gsh.chat.remoteControlHint' => 'Continuar esta conversación en una terminal con Remote Control (celular, claude.ai/code). El motor del chat no soporta Remote Control.',
			'gsh.chat.usage' => 'Uso',
			'gsh.chat.usageContext' => ({required Object used, required Object window}) => 'Contexto: ${used} de ${window}',
			'gsh.chat.usageContextNone' => 'Contexto: aparece después de la primera respuesta',
			'gsh.chat.usageSession' => 'Sesión (5 h)',
			'gsh.chat.usageWeek' => 'Semana',
			'gsh.chat.usageModelWeek' => ({required Object model}) => '${model} esta semana',
			'gsh.chat.usageResetsToday' => ({required Object time}) => 'se reinicia a las ${time}',
			'gsh.chat.usageResetsOn' => ({required Object date, required Object time}) => 'se reinicia el ${date} a las ${time}',
			'gsh.chat.usageUnavailable' => 'Uso del plan no disponible ahora.',
			'gsh.chat.remoteControlActive' => ({required Object url}) => 'Esta conversación ya está en Remote Control: continúa en el móvil o en ${url}',
			'gsh.chat.remoteControlNoSession' => 'Envía un mensaje primero: Remote Control continúa una conversación existente.',
			'gsh.chat.remoteControlBusy' => 'Espera a que el agente termine este turno e inténtalo de nuevo.',
			'gsh.chat.remoteControlFailed' => 'No pude abrir la terminal en este workspace.',
			'gsh.chat.attachmentTooLarge' => ({required Object name}) => '${name} es demasiado grande para enviar (imágenes hasta 5 MB, PDF hasta 32 MB).',
			'gsh.chat.loadingHistory' => 'Cargando la conversación…',
			'gsh.chat.allowAlways' => ({required Object rule}) => 'Permitir siempre ${rule}',
			'gsh.chat.allowedAlways' => ({required Object rule}) => 'Siempre permitido: ${rule}',
			'gsh.chat.moreLines' => ({required Object n}) => '… ${n} líneas más',
			'gsh.chat.questionTitle' => 'El agente pregunta',
			'gsh.chat.other' => 'Otro…',
			'gsh.chat.answer' => 'Responder',
			'gsh.chat.planTitle' => 'Plan del agente',
			'gsh.chat.planApprove' => 'Aprobar y ejecutar',
			'gsh.chat.planRefine' => 'Seguir planificando',
			'gsh.chat.planRefineHint' => '¿Qué cambiar en el plan?',
			'gsh.chat.planSendRefine' => 'Enviar ajuste',
			'gsh.chat.planApproved' => 'Plan aprobado',
			'gsh.chat.planRefined' => 'Pidió seguir planificando',
			'gsh.chat.planRefinedWith' => ({required Object text}) => 'Ajuste: ${text}',
			'gsh.chat.newChat' => 'Nueva conversación',
			'gsh.chat.attach' => 'Adjuntar archivos',
			'gsh.chat.modeDefault' => 'Pedir permiso',
			'gsh.chat.modeAcceptEdits' => 'Aceptar ediciones',
			'gsh.chat.modePlan' => 'Planificar',
			'gsh.chat.modeBypass' => 'Omitir permisos',
			'gsh.chat.editedFiles' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('es'))(n, one: 'Editó 1 archivo', other: 'Editó ${n} archivos', ), 
			'gsh.chat.thinkingTitle' => 'Razonamiento',
			'gsh.chat.thinkingLive' => 'Pensando…',
			'gsh.chat.stateCompleted' => 'Completada',
			'gsh.chat.stateReviewReady' => 'Lista para revisión',
			'gsh.chat.stateBlocked' => 'Bloqueada',
			'gsh.chat.stateFailed' => 'Falló',
			'gsh.harness.tabTitle' => 'Harness',
			'gsh.harness.subtitle' => ({required Object path}) => 'Lo que el agente carga al ejecutarse en ${path}',
			'gsh.harness.refresh' => 'Leer de nuevo',
			'gsh.harness.memory' => 'Instrucciones',
			'gsh.harness.memoryDesc' => 'Los CLAUDE.md que lee una sesión aquí (de esta carpeta hacia arriba), el tuyo de usuario y AGENTS.md (Codex).',
			'gsh.harness.memoryNew' => 'Crear CLAUDE.md',
			'gsh.harness.skills' => 'Skills',
			'gsh.harness.skillsDesc' => 'Capacidades que el agente activa solo cuando la descripción coincide con la tarea.',
			'gsh.harness.agents' => 'Subagentes',
			'gsh.harness.agentsDesc' => 'Especialistas a los que el agente delega (con herramientas y modelo propios).',
			'gsh.harness.commands' => 'Comandos',
			'gsh.harness.commandsDesc' => 'Atajos /nombre que escribes en la sesión.',
			'gsh.harness.hooks' => 'Hooks',
			'gsh.harness.hooksDesc' => 'Comandos que se ejecutan en eventos de la sesión (antes de una herramienta, al parar...).',
			'gsh.harness.permissions' => 'Permisos',
			'gsh.harness.permissionsDesc' => 'Reglas de herramientas: permitir, preguntar o bloquear.',
			'gsh.harness.mcp' => 'MCP',
			'gsh.harness.mcpDesc' => 'Servidores de herramientas extra. Los de usuario y los locales vienen de ~/.claude.json (cámbialos con claude mcp).',
			'gsh.harness.newItem' => 'Nuevo',
			'gsh.harness.editFile' => 'Editar archivo',
			'gsh.harness.newTitle' => ({required Object section}) => 'Nuevo elemento en ${section}',
			'gsh.harness.create' => 'Crear',
			'gsh.harness.namePlaceholder' => 'nombre (se vuelve el nombre del archivo)',
			'gsh.harness.empty' => 'Nada aquí todavía.',
			'gsh.harness.scopeUser' => 'Usuario',
			'gsh.harness.scopeProject' => 'Proyecto',
			'gsh.harness.scopeLocal' => 'Local',
			'gsh.harness.allow' => 'permitir',
			'gsh.harness.ask' => 'preguntar',
			'gsh.harness.deny' => 'bloquear',
			'gsh.harness.readOnly' => 'Solo lectura aquí: usa claude mcp add/remove',
			'gsh.harness.costTitle' => 'Costo fijo por turno',
			'gsh.harness.costValue' => ({required Object tokens}) => '≈ ${tokens} tokens',
			'gsh.harness.costHint' => 'Lo que entra en el contexto en cada mensaje, antes de cualquier trabajo: las instrucciones completas y el nombre + descripción de cada skill, subagente y comando. Las herramientas MCP no se cuentan.',
			'gsh.harness.costTip' => 'Para reducirlo: lo que solo vale a veces sale del CLAUDE.md y se vuelve skill; borra skills y comandos que nadie usa.',
			'gsh.harness.perTurn' => ({required Object tokens}) => '≈ ${tokens}/turno',
			'gsh.harness.issues' => ({required Object n}) => 'Avisos: ${n}',
			'gsh.harness.issueNoDescription' => 'Sin descripción: el agente no sabe cuándo usarlo.',
			'gsh.harness.issueMissingScript' => 'El script que ejecuta este hook no existe.',
			'gsh.harness.issueTooLarge' => 'Demasiado grande: pesa en cada mensaje (Claude Code avisa por encima de 40 mil caracteres).',
			'gsh.harness.invalidJson' => ({required Object file}) => '${file}: JSON inválido — Claude Code ignora este archivo entero.',
			'gsh.harness.showAll' => ({required Object n}) => 'Mostrar todos (${n})',
			'gsh.harness.showLess' => 'Mostrar menos',
			'gsh.farm.tabTitle' => 'Granja',
			'gsh.farm.title' => 'Granja de agentes',
			'gsh.farm.emptyTitle' => 'Ningún agente en ejecución',
			'gsh.farm.emptyHint' => 'Cada loop de Claude Code en esta máquina aparece aquí mientras trabaja, incluidos subagentes y sesiones fuera de GSH Desktop.',
			'gsh.farm.working' => ({required Object n}) => '${n} trabajando',
			'gsh.farm.waiting' => ({required Object n}) => '${n} te necesitan',
			'gsh.farm.waitingOne' => '1 te necesita',
			'gsh.farm.idle' => ({required Object n}) => '${n} inactivos',
			'gsh.farm.doorTitle' => 'Llamando a tu puerta',
			'gsh.farm.doorMessage' => ({required Object name, required Object agent, required Object target}) => '${name} (agente ${agent}) quiere hablar con tu agente ${target}',
			'gsh.farm.doorFile' => ({required Object name, required Object agent, required Object file, required Object target}) => '${name} (agente ${agent}) quiere entregar ${file} a tu agente ${target}',
			'gsh.farm.doorOpen' => 'Abrir la puerta',
			'gsh.farm.doorRefuse' => 'Rechazar',
			'gsh.farm.peerOf' => ({required Object name}) => 'de ${name}',
			'gsh.farm.peerBanner' => ({required Object name}) => 'Granja de ${name}',
			'gsh.farm.spent' => ({required Object total}) => 'Gastó ${total} tokens',
			'gsh.farm.spentDetail' => ({required Object input, required Object cache, required Object out}) => '${input} entrada · ${cache} caché · ${out} generados',
			'gsh.farm.context' => ({required Object ctx}) => 'contexto ${ctx}',
			'gsh.farm.spentHud' => ({required Object n}) => '${n} tokens gastados',
			'gsh.farm.clickToOpen' => 'Haz clic para abrir su terminal',
			'gsh.farm.outsideGsh' => 'Este agente se ejecuta fuera de GSH Desktop. Su terminal está en otra ventana.',
			'gsh.farm.agents' => ({required Object n}) => '${n} agentes',
			'gsh.farm.subagents' => ({required Object n}) => '${n} subagentes',
			'gsh.farm.activity.thinking' => 'pensando',
			'gsh.farm.activity.reading' => 'leyendo',
			'gsh.farm.activity.editing' => 'editando',
			'gsh.farm.activity.running' => 'ejecutando comando',
			'gsh.farm.activity.searching' => 'buscando en la web',
			'gsh.farm.activity.delegating' => 'delegando',
			'gsh.farm.activity.tooling' => 'usando herramienta',
			'gsh.farm.activity.waiting' => 'esperándote',
			'gsh.farm.activity.idle' => 'inactivo',
			'gsh.farm.activity.sleeping' => 'dormido',
			'gsh.farm.activity.done' => 'terminado',
			'gsh.agentGraph.tabTitle' => 'Agentes',
			'gsh.agentGraph.newAgent' => 'Nuevo agente',
			'gsh.agentGraph.emptyTitle' => 'No hay agentes en este workspace',
			'gsh.agentGraph.emptyHint' => 'Inicia un agente en una terminal o crea uno aquí. Arrastra desde el puerto de un agente hasta otro para conectarlos.',
			'gsh.agentGraph.statusWorking' => 'Trabajando',
			'gsh.agentGraph.statusWaiting' => 'Esperando',
			'gsh.agentGraph.statusIdle' => 'Inactivo',
			'gsh.agentGraph.messageCount' => ({required Object n}) => 'Mensajes: ${n}',
			'gsh.agentGraph.lastMessage' => ({required Object preview}) => 'Último: ${preview}',
			'gsh.agentGraph.linked' => 'Conectado',
			'gsh.agentGraph.removeLinkHint' => 'Clic derecho para quitar la conexión',
			'gsh.agentGraph.removeLink' => 'Quitar conexión',
			'gsh.agentGraph.connectHint' => 'Arrastra hasta otro agente para conectar',
			'gsh.agentGraph.quickStart' => 'Inicio rápido',
			'gsh.agentGraph.shell' => 'Shell',
			'gsh.agentGraph.tabDetails' => 'Detalles',
			'gsh.agentGraph.tabAppearance' => 'Apariencia',
			'gsh.agentGraph.tabAgent' => 'Agente',
			'gsh.agentGraph.name' => 'Nombre del terminal',
			'gsh.agentGraph.namePlaceholder' => 'p. ej. Revisor',
			'gsh.agentGraph.nameTaken' => 'Otra pestaña ya usa este nombre. Los nombres deben ser únicos para que `gsh msg --to` la encuentre.',
			'gsh.agentGraph.command' => 'Comando',
			'gsh.agentGraph.commandPlaceholder' => 'p. ej. claude --model opus (vacío = shell)',
			'gsh.agentGraph.cwd' => 'Directorio de trabajo',
			'gsh.agentGraph.browse' => 'Examinar…',
			'gsh.agentGraph.cwdMissing' => 'Esta carpeta no existe.',
			'gsh.agentGraph.monitor' => 'Monitorear actividad',
			'gsh.agentGraph.monitorHint' => 'Insignia, sonido y notificación cuando termina un turno.',
			'gsh.agentGraph.maestro' => 'Maestro',
			'gsh.agentGraph.maestroTooltip' => 'Promueve este agente a maestro: queda conectado a todos los agentes del lienzo y los coordina.',
			'gsh.agentGraph.maestroReplaces' => ({required Object name}) => '${name} es el maestro actual y dejará de serlo.',
			'gsh.agentGraph.color' => 'Color',
			'gsh.agentGraph.colorAuto' => 'Automático',
			'gsh.agentGraph.role' => 'Rol / instrucciones',
			'gsh.agentGraph.rolePlaceholder' => 'Se envía como primer mensaje cuando el agente esté listo.',
			'gsh.agentGraph.task' => 'Tarea inicial',
			'gsh.agentGraph.taskPlaceholder' => 'Se envía justo después del rol.',
			'gsh.agentGraph.focus' => 'Enfocar',
			'gsh.agentGraph.rename' => 'Renombrar',
			'gsh.agentGraph.renameTitle' => 'Renombrar agente',
			'gsh.agentGraph.makeMaestro' => 'Hacer maestro',
			'gsh.agentGraph.removeMaestro' => 'Quitar maestro',
			'gsh.agentGraph.closeTab' => 'Cerrar pestaña',
			'gsh.agentGraph.removeFromCanvas' => 'Quitar del lienzo',
			'gsh.agentGraph.desktopApps' => 'Apps de escritorio',
			'gsh.agentGraph.desktopBadge' => 'escritorio',
			'gsh.agentGraph.statusOnline' => 'En línea',
			'gsh.agentGraph.statusOffline' => 'Desconectado',
			'gsh.agentGraph.queued' => ({required Object n}) => '${n} en cola',
			'gsh.agentGraph.agentName' => 'Nombre',
			'gsh.agentGraph.integration' => 'Integración',
			'gsh.agentGraph.integrationHint' => 'GSH Desktop agrega un servidor MCP llamado "gsh" a este archivo y guarda una copia de seguridad al lado. Los demás servidores no se tocan.',
			'gsh.agentGraph.integrationConsent' => ({required Object app}) => 'Agregar el servidor MCP de GSH Desktop a la configuración de ${app}',
			'gsh.agentGraph.restartHint' => ({required Object app}) => 'Reinicia ${app} si ya estaba abierto para que cargue el servidor MCP de GSH Desktop; luego pídele que llame a wait_messages.',
			'gsh.agentGraph.integrationError.invalidConfig' => ({required Object path}) => '${path} no es un JSON/TOML simple que GSH Desktop pueda editar con seguridad (comentarios u otro formato). No se cambió nada.',
			'gsh.agentGraph.integrationError.cliMissing' => ({required Object path}) => 'La CLI de GSH Desktop aún no está instalada (${path}). Reinicia GSH Desktop e inténtalo de nuevo.',
			'gsh.agentGraph.integrationError.writeFailed' => ({required Object detail}) => 'No se pudo actualizar la configuración: ${detail}',
			'settings.language.title' => 'Idioma',
			'settings.language.system' => 'Sistema',
			'settings.language.english' => 'Inglés',
			'settings.language.portugueseBr' => 'Portugués (BR)',
			'settings.language.spanish' => 'Español',
			'settings.page.header.back' => 'Atrás',
			'settings.page.header.title' => 'Configuración',
			'settings.page.nav.sideGsh' => 'GSH Desktop',
			'settings.page.nav.sideClaude' => 'Claude',
			'settings.page.nav.general' => 'General',
			'settings.page.nav.appearance' => 'Apariencia',
			'settings.page.nav.terminal' => 'Terminal',
			'settings.page.nav.language' => 'Lenguaje',
			'settings.page.nav.shortcuts' => 'Atajos',
			'settings.page.nav.notifications' => 'Notificaciones',
			'settings.page.nav.automations' => 'Automatizaciones',
			'settings.page.nav.remoteHosts' => 'Hosts remotos',
			'settings.page.nav.claudeCode' => 'Claude Code',
			'settings.page.nav.search' => 'Buscar',
			'settings.page.nav.account' => 'Cuenta',
			'settings.page.nav.privacy' => 'Privacidad',
			'settings.page.nav.usage' => 'Uso',
			'settings.page.nav.resources' => 'Recursos',
			'settings.page.nav.memory' => 'Memoria',
			'settings.page.nav.designSystems' => 'Design systems',
			'settings.page.nav.cowork' => 'Cowork',
			'settings.page.nav.system' => 'Sistema',
			'settings.page.nav.extensions' => 'Extensiones',
			'settings.page.nav.developer' => 'Desarrollador',
			'settings.page.nav.skills' => 'Skills',
			'settings.page.nav.connectors' => 'Conectores',
			'settings.page.nav.plugins' => 'Plugins',
			'settings.page.nav.apiKeys' => 'Claves de API',
			_ => null,
		} ?? switch (path) {
			'settings.page.nav.groups.settings' => 'Configuración',
			'settings.page.nav.groups.thisComputer' => 'Este equipo',
			'settings.page.nav.groups.personalization' => 'Personalización',
			'settings.page.nav.groups.platform' => 'Plataforma',
			'settings.page.nav.groups.app' => 'GSH Desktop',
			'settings.page.general.sectionEditor' => 'Editor',
			'settings.page.general.editorEngineTitle' => 'Motor',
			'settings.page.general.editorEngineGsh' => 'GSH Desktop (predeterminado)',
			'settings.page.general.editorEngineNeovim' => 'Neovim',
			'settings.page.general.neovimChecking' => 'Buscando Neovim…',
			'settings.page.general.neovimNotFound' => 'Neovim no se encontró en la PATH de tu shell.',
			'settings.page.general.neovimRefresh' => 'Comprobar de nuevo',
			'settings.page.general.showGshTitle' => 'Mostrar terminal de GSH Desktop',
			'settings.page.general.showGshDesc' => 'Mantiene un workspace sin carpeta, solo de terminal, fijado en la parte superior de la barra lateral. Desactivarlo cierra sus terminales.',
			'settings.page.general.launchAtStartupTitle' => 'Iniciar al arrancar',
			'settings.page.general.launchAtStartupDesc' => 'Inicia GSH Desktop automáticamente cuando inicias sesión en tu computadora.',
			'settings.page.general.sectionUpdates' => 'Actualizaciones',
			'settings.page.general.checkUpdatesTitle' => 'Buscar actualizaciones',
			'settings.page.general.checkUpdatesDesc' => 'Con qué frecuencia GSH Desktop debe buscar nuevas versiones.',
			'settings.page.general.updateFrequency.daily' => 'Diariamente',
			'settings.page.general.updateFrequency.weekly' => 'Semanalmente',
			'settings.page.general.updateFrequency.monthly' => 'Mensualmente',
			'settings.page.general.updateFrequency.never' => 'Nunca',
			'settings.page.general.developerModeTitle' => 'Modo desarrollador',
			'settings.page.general.developerModeDesc' => 'Registra los errores y avisos del propio GSH Desktop en una base aparte de la Telemetría (chip “GSH Desktop”) y activa las métricas de rendimiento. Solo sirve a quien mantiene la app.',
			'settings.page.diagnostics.sectionTitle' => 'Diagnóstico',
			'settings.page.diagnostics.logFileTitle' => 'Archivo de registro',
			'settings.page.diagnostics.logFileDesc' => ({required Object days, required Object path}) => 'Los errores y eventos de inicio se registran aquí, y se conservan durante ${days} días.\n${path}',
			'settings.page.diagnostics.unavailable' => 'no disponible',
			'settings.page.diagnostics.reveal' => 'Mostrar',
			'settings.page.diagnostics.reportTitle' => 'Reportar un problema',
			'settings.page.diagnostics.reportDesc' => 'Abre un issue prellenado con tu versión, SO y registro reciente. Nada se envía automáticamente — lo revisas antes.',
			'settings.page.diagnostics.reportButton' => 'Reportar…',
			'settings.page.diagnostics.reportDialogTitle' => 'Informe de problema',
			'settings.page.diagnostics.reportDialogError' => 'Reportado manualmente desde Configuración.',
			'settings.page.diagnostics.reportDialogDescription' => 'Describe qué salió mal en el issue. El registro reciente está incluido abajo y en "Copiar detalles".',
			'settings.page.storage.sectionTitle' => 'Almacenamiento',
			'settings.page.storage.locationTitle' => 'Ubicación de almacenamiento',
			'settings.page.storage.locationDesc' => ({required Object root}) => 'GSH Desktop guarda aquí sus proyectos, diseños y configuración. Apúntalo a una carpeta sincronizada para respaldarlo.\n${root}',
			'settings.page.storage.useDefault' => 'Usar predeterminado',
			'settings.page.storage.working' => 'Procesando…',
			'settings.page.storage.change' => 'Cambiar…',
			'settings.page.storage.resetTitle' => 'Restablecer GSH Desktop',
			'settings.page.storage.resetDesc' => 'Elimina todos los datos locales — proyectos, diseños, configuración e historial de terminal — y vuelve a la ubicación predeterminada.',
			'settings.page.storage.resetButton' => 'Restablecer…',
			'settings.page.storage.resetConfirm' => 'Restablecer',
			'settings.page.storage.resetDialogTitle' => '¿Restablecer GSH Desktop?',
			'settings.page.storage.resetDialogContent' => 'Esto elimina permanentemente todos los datos locales de GSH Desktop — proyectos, diseños, configuración e historial de terminal. Esto no se puede deshacer. GSH Desktop se cerrará para que puedas empezar de nuevo.',
			'settings.page.storage.restartRequiredTitle' => 'Reinicio necesario',
			'settings.page.storage.restartChangeFolderMessage' => ({required Object path}) => 'GSH Desktop usará esta carpeta a partir del próximo inicio:\n${path}',
			'settings.page.storage.restartUseDefaultMessage' => 'GSH Desktop usará la ubicación predeterminada del sistema a partir del próximo inicio. Tus datos en la carpeta personalizada permanecen intactos.',
			'settings.page.storage.restartResetMessage' => 'Se borraron todos los datos de GSH Desktop. Reinicia para empezar de nuevo.',
			'settings.page.storage.later' => 'Más tarde',
			'settings.page.storage.quitGsh' => 'Salir de GSH Desktop',
			'settings.page.storage.chooseFolderDialogTitle' => 'Elige una carpeta para los datos de GSH Desktop',
			'settings.page.terminal.sectionDefaultTerminal' => 'Terminal predeterminado',
			'settings.page.terminal.engineTitle' => 'Motor',
			'settings.page.terminal.engineDesc' => 'Usado por nuevas pestañas de terminal y buffers de salida de tasks. Las pestañas abiertas mantienen su motor actual.',
			'settings.page.terminal.shellTitle' => 'Shell',
			'settings.page.terminal.shellDesc' => 'Qué shell abren las nuevas pestañas de terminal. La flecha junto al + sigue abriendo cualquier otro, solo para esa pestaña.',
			'settings.page.terminal.noWslMessage' => 'No se encontraron distros de WSL. Instala una (wsl.exe --install) y reinicia GSH Desktop para verla listada aquí.',
			'settings.page.terminal.sectionBehavior' => 'Comportamiento',
			'settings.page.terminal.closeOnExitTitle' => 'Cerrar la pestaña cuando el shell termine',
			'settings.page.terminal.closeOnExitDesc' => 'Cuando un shell termina por sí solo (exit, Ctrl-D), cierra su pestaña en lugar de dejar un terminal muerto.',
			'settings.page.appearance.sectionTheme' => 'Tema',
			'settings.page.appearance.themeTitle' => 'Tema',
			'settings.page.appearance.themeDesc' => 'Colores de la app, resaltado de código y paleta del terminal.',
			'settings.page.appearance.modeTitle' => 'Modo',
			'settings.page.appearance.modeDesc' => 'Qué variante del tema usar.',
			'settings.page.appearance.modeOnlyDark' => ({required Object theme}) => '"${theme}" solo trae la variante oscura, así que esto no tiene efecto.',
			'settings.page.appearance.modeOnlyLight' => ({required Object theme}) => '"${theme}" solo trae la variante clara, así que esto no tiene efecto.',
			'settings.page.appearance.themeFileTitle' => 'Archivo de tema',
			'settings.page.appearance.themeFileDesc' => 'Importa un tema desde un archivo JSON, o exporta el activo.',
			'settings.page.appearance.previewCode' => 'Código',
			'settings.page.appearance.previewTerminal' => 'Terminal',
			'settings.page.appearance.themeSystem' => 'Sistema',
			'settings.page.appearance.themeLight' => 'Claro',
			'settings.page.appearance.themeDark' => 'Oscuro',
			'settings.page.appearance.sectionFonts' => 'Fuentes',
			'settings.page.appearance.interfaceFontTitle' => 'Fuente de la interfaz',
			'settings.page.appearance.interfaceFontDesc' => 'Se usa en toda la aplicación. Vacío = predeterminado del sistema.',
			'settings.page.appearance.interfaceSizeTitle' => 'Tamaño de la interfaz',
			'settings.page.appearance.codeFontTitle' => 'Fuente del código',
			'settings.page.appearance.codeFontDesc' => 'Código y diffs. Vacío = predeterminado del sistema.',
			'settings.page.appearance.codeSizeTitle' => 'Tamaño del código',
			'settings.page.appearance.terminalFontTitle' => 'Fuente del terminal',
			'settings.page.appearance.terminalFontDesc' => 'Solo la terminal. Vacío = predeterminado del sistema.',
			'settings.page.appearance.terminalSizeTitle' => 'Tamaño de la terminal',
			'settings.page.appearance.terminalSizeDesc' => 'Apagado = sigue el tamaño del código.',
			'settings.page.appearance.terminalSizeInherit' => 'Seguir el código',
			'settings.page.appearance.terminalWeightTitle' => 'Grosor de la terminal',
			'settings.page.appearance.terminalWeightDesc' => 'Las pantallas de baja densidad engrosan los trazos. El automático los afina solo ahí y no toca la Retina.',
			'settings.page.appearance.terminalWeightAuto' => 'Automático (según la pantalla)',
			'settings.page.appearance.terminalWeightLight' => 'Fino',
			'settings.page.appearance.terminalWeightNormal' => 'Normal',
			'settings.page.appearance.terminalWeightMedium' => 'Medio',
			'settings.page.appearance.terminalWeightSemiBold' => 'Seminegrita',
			'settings.page.appearance.sectionConversation' => 'Conversación',
			'settings.page.appearance.pinUserMessageTitle' => 'Fijar mensaje del usuario',
			'settings.page.appearance.pinUserMessageDesc' => 'La pregunta permanece fija arriba mientras la respuesta se desplaza.',
			'settings.page.appearance.importTheme' => 'Importar…',
			'settings.page.appearance.exportTheme' => 'Exportar…',
			'settings.page.appearance.deleteTheme' => 'Eliminar',
			'settings.page.appearance.importThemeDialog' => 'Elige un archivo de tema',
			'settings.page.appearance.exportThemeDialog' => 'Guardar tema como',
			'settings.page.appearance.themeImported' => ({required Object name}) => 'Tema "${name}" importado.',
			'settings.page.appearance.themeExported' => 'Tema guardado.',
			'settings.page.appearance.themeDeleted' => 'Tema eliminado.',
			'settings.page.appearance.fontPickerTitle' => 'Elegir una fuente',
			'settings.page.appearance.fontPickerSearch' => 'Buscar fuentes',
			'settings.page.appearance.fontPickerEmpty' => 'No hay ninguna fuente coincidente en esta máquina.',
			'settings.page.appearance.fontPickerBundled' => 'incluida',
			'settings.page.appearance.fontPickerCustom' => '¿No está en la lista? Escribe el nombre exacto de la familia.',
			'settings.page.appearance.fontPickerCustomHint' => 'Nombre de la familia',
			'settings.page.appearance.fontPickerUse' => 'Usar',
			'settings.page.appearance.fontPickerDefault' => 'Predeterminada',
			'settings.page.appearance.fontMissing' => 'No se encontró en esta máquina — usando el respaldo.',
			'settings.page.appearance.sectionLayout' => 'Diseño',
			'settings.page.appearance.swapPanelsTitle' => 'Invertir paneles',
			'settings.page.appearance.swapPanelsDesc' => 'Coloca los workspaces a la derecha y archivos, búsqueda, git y base de datos a la izquierda.',
			'settings.page.notifications.sectionTitle' => 'Notificaciones',
			'settings.page.notifications.enableTitle' => 'Activar notificaciones',
			'settings.page.notifications.enableDesc' => 'Avisarme cuando un agente termine un turno y la ventana no esté enfocada.',
			'settings.page.notifications.systemPermissionTitle' => 'Permiso del sistema',
			'settings.page.notifications.grantedDesc' => 'GSH Desktop tiene permiso para enviar notificaciones.',
			'settings.page.notifications.notGrantedDesc' => 'macOS aún no ha concedido acceso a las notificaciones.',
			'settings.page.notifications.granted' => 'Concedido',
			'settings.page.notifications.requestPermission' => 'Solicitar permiso',
			'settings.page.notifications.soundsTitle' => 'Sonidos',
			'settings.page.notifications.soundVolumeTitle' => 'Volumen',
			'settings.page.notifications.soundTurnDone' => 'Turno completado',
			'settings.page.notifications.soundTurnDoneDesc' => 'Un agente terminó su turno.',
			'settings.page.notifications.soundActionRequired' => 'Acción requerida',
			'settings.page.notifications.soundActionRequiredDesc' => 'Un agente está esperando tu aprobación o respuesta.',
			'settings.page.notifications.soundDefault' => 'Predeterminado',
			'settings.page.notifications.soundCustom' => ({required Object name}) => 'Personalizado: ${name}',
			'settings.page.notifications.soundChooseFile' => 'Elegir archivo',
			'settings.page.notifications.soundReset' => 'Volver al predeterminado',
			'settings.page.notifications.soundOnActiveTab' => 'Reproducir también con la pestaña activa',
			'settings.page.notifications.soundPreview' => 'Escuchar',
			'settings.page.shortcuts.notCustomizable' => 'Los atajos de teclado aún no se pueden personalizar.',
			'settings.page.languages.sectionFormatting' => 'FORMATO',
			'settings.page.languages.formatOnSaveTitle' => 'Formatear al guardar',
			'settings.page.languages.formatOnSaveDesc' => 'Formatea el archivo automáticamente al guardar (⌘S).',
			'settings.page.languages.sectionLanguageServers' => 'SERVIDORES DE LENGUAJE',
			'settings.page.languages.footerNote' => 'Los errores y el formato usan el language server de cada lenguaje. GSH Desktop no instala servidores — usa lo que ya está en tu máquina. ● responde · ○ no encontrado o comando inválido (instala el servidor o ajusta el comando).',
			'settings.page.languages.serverCommandLabel' => 'Comando del language server',
			'settings.page.languages.formatterCommandLabel' => 'Comando del formateador (opcional)',
			'settings.page.languages.formatterHint' => 'Formateador externo con el marcador %FILE%. Tiene prioridad sobre el formateador del LSP cuando está definido.',
			'settings.page.languages.resetToDefault' => 'Restablecer al predeterminado',
			'settings.page.languages.saveAndRestart' => 'Guardar y reiniciar',
			'settings.page.languages.statusResponds' => 'El servidor responde',
			'settings.page.languages.statusNotFound' => 'Servidor no encontrado o comando inválido',
			'settings.page.automations.sectionCommitMessages' => 'Mensajes de commit',
			'settings.page.automations.harness' => 'Harness',
			'settings.page.automations.harnessDiscovering' => 'Buscando harnesses de línea de comandos instalados…',
			'settings.page.automations.harnessNoneFound' => 'No se encontró ningún harness compatible en el PATH.',
			'settings.page.automations.harnessConfiguredUnavailable' => ({required Object harness}) => '${harness} está configurado, pero no disponible.',
			'settings.page.automations.harnessChoose' => 'Elige la CLI usada para generar mensajes de commit.',
			'settings.page.automations.harnessRefresh' => 'Actualizar harnesses instalados',
			'settings.page.automations.notConfigured' => 'Sin configurar',
			'settings.page.automations.model' => 'Modelo',
			'settings.page.automations.modelUnavailable' => 'La lista de modelos no está disponible hasta encontrar el harness.',
			'settings.page.automations.modelCliOnly' => 'Este harness usa el modelo predeterminado de su CLI.',
			'settings.page.automations.modelCliDefault' => 'Predeterminado de la CLI',
			'settings.page.automations.modelAuto' => 'Auto',
			'settings.page.automations.modelSearch' => ({required Object count}) => 'Buscar entre ${count} modelos…',
			'settings.page.automations.modelAutoRouted' => 'Este harness elige el modelo automáticamente.',
			'settings.page.automations.modelAccountOnly' => 'Solo se muestran los modelos disponibles en tu cuenta.',
			'settings.page.automations.generateFromSourceControl' => 'Generar desde Control de versiones',
			'settings.page.automations.generateFromSourceControlDescription' => 'GSH Desktop envía solo el diff seleccionado y los asuntos de los commits recientes. Los patrones habituales de credenciales y los archivos sensibles se redactan antes de ejecutar el harness.',
			'settings.page.automations.discoveryFailed' => 'No se pudieron descubrir los harnesses de automatización instalados.',
			'settings.page.automations.staleModel' => ({required Object model, required Object harness}) => 'El modelo "${model}" ya no está disponible para ${harness}. Se usará el predeterminado de la CLI; elige otro modelo en Configuración si lo necesitas.',
			'settings.page.automations.recommendedSuffix' => 'Recomendado',
			'settings.page.claudeCode.sectionGeneral' => 'General',
			'settings.page.claudeCode.classifyTitle' => 'Clasificar estados de las sesiones',
			'settings.page.claudeCode.classifyDesc' => 'Muestra en el encabezado del chat el estado que Claude Code asigna al final de cada turno: completada, lista para revisión o bloqueada. Claude Code clasifica igual; desactivarlo solo oculta la insignia.',
			'settings.page.claudeCode.switchModelsTitle' => 'Cambiar de modelo cuando se marque un mensaje',
			'settings.page.claudeCode.switchModelsDesc' => 'Cuando las salvaguardas marquen un mensaje, cambiar automáticamente a otro modelo para continuar la conversación. Si está desactivado, tu sesión se pausará. Se guarda en ~/.claude/settings.json (switchModelsOnFlag).',
			'settings.page.claudeCode.sectionCodeAppearance' => 'Apariencia del código',
			'settings.page.claudeCode.followTheme' => 'Del tema activo',
			'settings.page.claudeCode.codeThemeLightHint' => 'Colores del código en modo claro',
			'settings.page.claudeCode.codeThemeDarkHint' => 'Colores del código en modo oscuro',
			'settings.page.claudeCode.codeFontTitle' => 'Fuente de código',
			'settings.page.claudeCode.codeFontDesc' => 'Define una fuente monoespaciada personalizada para el código: visor, editor, diffs y bloques de código del chat. La terminal tiene su propia fuente en Apariencia.',
			'settings.page.claudeCode.codeFontPlaceholder' => 'p. ej.: JetBrains Mono',
			'settings.page.claudeCode.sectionAppearance' => 'Apariencia',
			'settings.page.claudeCode.transcriptTitle' => 'Vista predeterminada de la transcripción',
			'settings.page.claudeCode.transcriptDesc' => 'La vista con la que abren las nuevas conversaciones del chat. Las conversaciones ya abiertas mantienen la suya.',
			'settings.page.claudeCode.viewNormal' => 'Normal',
			'settings.page.claudeCode.viewThinking' => 'Razonamiento',
			'settings.page.claudeCode.viewVerbose' => 'Detallada',
			'settings.page.claudeCode.sectionRemoteControl' => 'Remote Control',
			'settings.page.claudeCode.chatRemoteControlTitle' => 'Chat con Remote Control (experimental)',
			'settings.page.claudeCode.chatRemoteControlDesc' => 'El chat de GSH ejecuta el claude interactivo en una terminal oculta, conectada a Remote Control: la conversación aparece en el móvil y en claude.ai/code, y las sesiones de otras máquinas la ven. La respuesta llega por mensaje (sin aparecer letra a letra). Vale para los chats abiertos después del cambio; desactívalo para volver al motor rápido.',
			'settings.page.claudeCode.remoteControlTitle' => 'Conectar nuevas sesiones a Remote Control',
			'settings.page.claudeCode.remoteControlDesc' => 'Cada sesión de claude que inicies en una terminal se conecta a Remote Control, para seguir en el celular o en claude.ai/code. Se guarda en ~/.claude/settings.json (remoteControlAtStartup). Requiere login de claude.ai (Pro, Max, Team o Enterprise).',
			'settings.page.claudeCode.saveFailed' => ({required Object detail}) => 'No pude guardar: ${detail}',
			'settings.page.claudeCode.sectionSessions' => 'Sesiones',
			'settings.page.claudeCode.promptSuggestionsTitle' => 'Sugerencias de prompts',
			'settings.page.claudeCode.promptSuggestionsDesc' => 'Mostrar una sugerencia del siguiente prompt después de que Claude responda. Las sugerencias consumen un poco de tu uso.',
			'settings.page.claudeCode.outputStyleTitle' => 'Estilo de salida',
			'settings.page.claudeCode.outputStyleDesc' => 'Cómo Claude estructura sus respuestas en las sesiones de Code. Se aplica a sesiones nuevas.',
			'settings.page.claudeCode.outputStyleDefault' => 'Predeterminado',
			'settings.page.claudeCode.crossSessionTitle' => 'Mensajes de otras sesiones',
			'settings.page.claudeCode.crossSessionDesc' => 'Qué hacer cuando otra sesión de Claude Code le envía un mensaje a esta (SendMessage). GSH deja Aceptar para toda sesión de la máquina; Retener la guarda para tu aprobación, Rechazar la descarta. Se guarda en crossSessionInbound.',
			'settings.page.claudeCode.crossSessionDefault' => 'Por defecto',
			'settings.page.claudeCode.crossSessionAccept' => 'Aceptar',
			'settings.page.claudeCode.crossSessionHold' => 'Retener para aprobar',
			'settings.page.claudeCode.crossSessionRefuse' => 'Rechazar',
			'settings.page.claudeCode.sandboxTitle' => 'Sandbox local',
			'settings.page.claudeCode.sandboxDesc' => 'Ejecuta los comandos bash de Claude Code en un sandbox aislado. Se aplica a sesiones nuevas.',
			'settings.page.claudeCode.sandboxStrictTitle' => 'Modo sandbox estricto',
			'settings.page.claudeCode.sandboxStrictDesc' => 'Bloquea los comandos que no pueden ejecutarse dentro del sandbox en lugar de ejecutarlos fuera.',
			'settings.page.claudeCode.sectionSecurity' => 'Seguridad',
			'settings.page.claudeCode.protectedHostsTitle' => 'Hosts protegidos',
			'settings.page.claudeCode.protectedHostsDesc' => 'Hosts que ningún agente puede tocar desde un comando: ssh, scp, workspace remoto, cualquier cosa que los nombre. GSH bloquea el comando antes de ejecutarlo, en toda sesión de Claude Code y Codex en esta máquina, y le dice al agente que te pregunte. Separados por coma; palabra completa (prod bloquea "ssh prod" y "prod.x.com", no "production"). Se guarda en ~/.gsh/protected-hosts.json.',
			'settings.page.claudeCode.sectionBrowser' => 'Navegador',
			'settings.page.claudeCode.linksInAppTitle' => 'Abrir enlaces en el navegador integrado',
			'settings.page.claudeCode.linksInAppDesc' => 'Los enlaces de las terminales se abren en una pestaña de navegador de GSH en lugar de tu navegador predeterminado.',
			'settings.page.placeholder.cowork1' => 'Cowork es una función de Claude Desktop (tareas que se ejecutan en este equipo con archivos locales, navegador y MCPs).',
			'settings.page.placeholder.cowork2' => 'En GSH, el equivalente es el chat con Claude en un workspace y la Granja, donde los loops de agentes corren en terminales.',
			'settings.page.placeholder.extensionsDesc' => 'Permitir que Claude interactúe directamente con aplicaciones, datos y herramientas de tu equipo.',
			'settings.page.placeholder.extensionsEmpty' => 'Ninguna extensión instalada',
			'settings.page.placeholder.extensions' => 'Las extensiones .MCPB/.DXT son de Claude Desktop. En GSH, los servidores MCP están en Conectores y Desarrollador.',
			'settings.page.claude.refresh' => 'Actualizar',
			'settings.page.claude.loading' => 'Cargando…',
			'settings.page.claude.terminalTitle' => 'Abrir una terminal',
			'settings.page.claude.noWorkspace' => 'Abre primero un workspace local: esto ejecuta la CLI `claude` en una de sus terminales para que la sigas.',
			'settings.page.claude.months' => 'ene.|feb.|mar.|abr.|may.|jun.|jul.|ago.|sept.|oct.|nov.|dic.',
			'settings.page.claude.weekdays' => 'lun.|mar.|mié.|jue.|vie.|sáb.|dom.',
			'settings.page.claude.dateShort' => ({required Object day, required Object month}) => '${day} de ${month}',
			'settings.page.claude.error.cliMissing' => 'No se encontró la CLI de Claude Code (`claude`) en este equipo.',
			'settings.page.claude.error.timeout' => 'La CLI `claude` tardó demasiado en responder.',
			'settings.page.claude.error.failed' => ({required Object detail}) => 'La CLI `claude` falló: ${detail}',
			'settings.page.account.title' => 'Cuenta',
			'settings.page.account.profile' => 'Perfil',
			'settings.page.account.instructions' => 'Instrucciones para Claude',
			'settings.page.account.instructionsDesc' => 'Se guarda en ~/.claude/CLAUDE.md: Claude Code lo carga en cada sesión de este equipo.',
			'settings.page.account.instructionsHint' => 'p. ej.: mantener las explicaciones breves y directas',
			'settings.page.account.loggedIn' => 'Conectado',
			'settings.page.account.loggedOut' => 'Desconectado',
			'settings.page.account.loggedInDesc' => 'Claude Code en este equipo usa esta cuenta.',
			'settings.page.account.loggedOutDesc' => 'Inicia sesión para usar tu suscripción de Claude en Claude Code.',
			'settings.page.account.login' => 'Iniciar sesión',
			'settings.page.account.logout' => 'Cerrar sesión',
			'settings.page.account.logoutConfirmTitle' => '¿Cerrar sesión en Claude Code?',
			'settings.page.account.logoutConfirmMessage' => 'Ejecuta `claude auth logout`. Las sesiones de este equipo dejan de usar tu suscripción hasta que vuelvas a iniciar sesión.',
			'settings.page.account.email' => 'Correo',
			'settings.page.account.organization' => 'Organización',
			'settings.page.account.orgId' => 'ID de la organización',
			'settings.page.account.plan' => 'Plan',
			'settings.page.account.method' => 'Método de inicio de sesión',
			'settings.page.usage.title' => 'Tus límites de uso',
			'settings.page.usage.weeklyTitle' => 'Límites semanales',
			'settings.page.usage.unavailable' => 'Los límites del plan no se aplican a este inicio de sesión (clave de API o proveedor externo).',
			'settings.page.usage.windowSession' => 'Sesión actual',
			'settings.page.usage.windowWeekly' => 'Todos los modelos',
			'settings.page.usage.resetsIn' => ({required Object when}) => 'Se restablece en ${when}',
			'settings.page.usage.resetsAt' => ({required Object when}) => 'Se restablece ${when}',
			'settings.page.usage.percentUsed' => ({required Object pct}) => '${pct}% usado',
			'settings.page.usage.updated' => ({required Object when}) => 'Última actualización: ${when}',
			'settings.page.usage.justNow' => 'hace menos de un minuto',
			'settings.page.usage.minutesAgo' => ({required Object n}) => 'hace ${n} min',
			'settings.page.usage.minutes' => ({required Object m}) => '${m} min',
			'settings.page.usage.hoursMinutes' => ({required Object h, required Object m}) => '${h} h ${m} min',
			'settings.page.usage.plans.pro' => 'Pro',
			'settings.page.usage.plans.max' => 'Max',
			'settings.page.usage.plans.team' => 'Equipo',
			'settings.page.usage.plans.enterprise' => 'Empresa',
			'settings.page.memory.title' => 'Memoria',
			'settings.page.memory.intro' => 'Lo que carga una sesión de Claude Code en el workspace activo: tus instrucciones y la memoria que Claude escribe por su cuenta. Haz clic para abrir el archivo.',
			'settings.page.memory.instructionsTitle' => 'Instrucciones',
			'settings.page.memory.autoTitle' => 'Memoria automática',
			'settings.page.memory.empty' => 'No se encontró ningún CLAUDE.md.',
			'settings.page.memory.autoEmpty' => 'Claude aún no guardó memorias para este workspace.',
			'settings.page.memory.scopeUser' => 'Usuario (todos los proyectos)',
			'settings.page.memory.scopeProject' => 'Proyecto',
			'settings.page.memory.updated' => ({required Object when}) => 'Actualizado ${when}',
			'settings.page.skills.groupUser' => 'Creado por ti',
			'settings.page.skills.groupProject' => 'Del proyecto',
			'settings.page.skills.groupPlugins' => 'De los plugins',
			'settings.page.skills.byYou' => 'por ti',
			'settings.page.skills.byProject' => 'del proyecto',
			'settings.page.skills.empty' => 'No hay skills instaladas.',
			'settings.page.connectors.checking' => 'Verificando cada servidor… puede tardar unos segundos.',
			'settings.page.connectors.empty' => 'No hay servidores MCP configurados.',
			'settings.page.connectors.addServer' => 'Añadir servidor MCP',
			'settings.page.connectors.colConnector' => 'Conector',
			'settings.page.connectors.colType' => 'Tipo',
			'settings.page.connectors.colStatus' => 'Estado',
			'settings.page.connectors.fromPlugin' => ({required Object plugin}) => 'Proporcionado por el plugin ${plugin}',
			'settings.page.connectors.typeWeb' => 'Web',
			'settings.page.connectors.typeLocal' => 'Local',
			'settings.page.connectors.originPlugin' => 'Plugin',
			'settings.page.connectors.link' => 'Vincular',
			'settings.page.connectors.discoverIntro' => 'El directorio de conectores de claude.ai no tiene API pública, así que GSH no lo lista. Añade cualquier servidor MCP aquí: GSH ejecuta `claude mcp add` en una terminal.',
			'settings.page.connectors.formName' => 'Nombre',
			'settings.page.connectors.formType' => 'Tipo',
			'settings.page.connectors.formUrl' => 'URL',
			'settings.page.connectors.formCommand' => 'Comando',
			'settings.page.connectors.formScope' => 'Ámbito',
			'settings.page.connectors.formScopeDesc' => 'Usuario = todos los proyectos; Local = solo el proyecto de la terminal.',
			'settings.page.connectors.scopeUser' => 'Usuario',
			'settings.page.connectors.scopeLocal' => 'Local',
			'settings.page.connectors.docs' => 'Docs de MCP',
			'settings.page.connectors.addInTerminal' => 'Añadir en la terminal',
			'settings.page.connectors.status.connected' => 'Conectado',
			'settings.page.connectors.status.needsAuth' => 'Requiere autenticación',
			'settings.page.connectors.status.failed' => 'Falló',
			'settings.page.connectors.status.pending' => 'Aprobación pendiente',
			'settings.page.connectors.status.unknown' => 'Desconocido',
			'settings.page.plugins.search' => 'Buscar skills y plugins',
			'settings.page.plugins.groupProject' => 'En este proyecto',
			'settings.page.plugins.groupMarketplaces' => 'De los marketplaces que añadiste',
			'settings.page.plugins.noWorkspace' => 'Abre un workspace para ver los plugins habilitados en él.',
			'settings.page.plugins.projectEmpty' => 'Ningún plugin habilitado en .claude/settings.json de este proyecto.',
			'settings.page.plugins.empty' => 'No hay plugins instalados.',
			'settings.page.plugins.disabled' => 'Deshabilitado',
			'settings.page.developer.title' => 'Desarrollador',
			'settings.page.developer.mcpTitle' => 'Servidores MCP locales',
			'settings.page.developer.mcpDesc' => 'Servidores MCP stdio que Claude Code inicia en este equipo. Se configuran en ~/.claude.json.',
			'settings.page.developer.mcpEmpty' => 'Ningún servidor MCP local.',
			'settings.page.developer.editConfig' => 'Editar configuración',
			'settings.page.developer.command' => 'Comando',
			'settings.page.developer.arguments' => 'Argumentos',
			'settings.page.developer.error' => 'Error',
			'settings.page.developer.telemetryTitle' => 'Telemetría',
			'settings.page.developer.telemetryDesc' => 'Los errores y logs de los procesos del workspace están en el panel Telemetría del shell; con el modo desarrollador también muestra los del propio GSH Desktop.',
			'settings.page.developer.claudeSettingsTitle' => 'Archivo de configuración de Claude Code',
			'settings.page.developer.claudeSettingsDesc' => '~/.claude/settings.json — permisos, hooks, entorno y modelo.',
			'settings.page.developer.apiKeyTitle' => '¿Quieres una clave de API?',
			'settings.page.developer.apiKeyDesc' => 'Crea claves y revisa el uso en Claude Console. Requiere otra cuenta y el uso de la API se cobra aparte.',
			'settings.page.developer.apiKeyButton' => 'Ir a la Console',
			'settings.page.system.title' => 'Sistema',
			'settings.page.system.version' => 'Versión de la aplicación',
			'settings.page.system.keepAwakeTitle' => 'Mantener el equipo activo',
			'settings.page.system.keepAwakeDesc' => 'Evita la suspensión por inactividad mientras está activo (el mismo botón de rayo del rail). Se desactiva al cerrar la app; cerrar la tapa igual suspende.',
			'settings.page.catalog.mine' => 'Míos',
			'settings.page.catalog.discover' => 'Descubrir',
			'settings.page.catalog.add' => 'Añadir',
			'settings.page.catalog.all' => 'Todos',
			'settings.page.catalog.by' => ({required Object author}) => 'por ${author}',
			'settings.page.catalog.newSkill' => 'Nueva skill…',
			'settings.page.catalog.addMarketplace' => 'Añadir marketplace…',
			'settings.page.generalClaude.sectionAppearance' => 'Apariencia',
			'settings.page.generalClaude.theme' => 'Tema',
			'settings.page.generalClaude.themeSystem' => 'Sistema',
			'settings.page.generalClaude.themeLight' => 'Claro',
			'settings.page.generalClaude.themeDark' => 'Oscuro',
			'settings.page.generalClaude.uiFont' => 'Fuente de la interfaz',
			'settings.page.generalClaude.uiFontDesc' => 'Fuente para toda la interfaz: menús, barras laterales y paneles.',
			'settings.page.generalClaude.chatFont' => 'Fuente del chat',
			'settings.page.generalClaude.chatFontDesc' => 'Texto de la conversación en el chat con Claude.',
			'settings.page.generalClaude.chatFontDefault' => 'Igual que la interfaz',
			'settings.page.generalClaude.textSize' => 'Tamaño del texto de la conversación',
			'settings.page.generalClaude.textSizeDesc' => 'Tamaño base del texto de la app (el mismo ajuste de Apariencia).',
			'settings.page.generalClaude.sizeSmall' => 'Pequeño',
			'settings.page.generalClaude.sizeMedium' => 'Mediano',
			'settings.page.generalClaude.sizeLarge' => 'Grande',
			'settings.page.generalClaude.transcriptWidth' => 'Ancho de la transcripción',
			'settings.page.generalClaude.transcriptWidthDesc' => 'Ancho máximo de la transcripción y del campo de mensaje.',
			'settings.page.generalClaude.widthNarrow' => 'Estrecho',
			'settings.page.generalClaude.widthMedium' => 'Mediano',
			'settings.page.generalClaude.widthWide' => 'Ancho',
			'settings.page.generalClaude.reducedMotion' => 'Movimiento reducido',
			'settings.page.generalClaude.reducedMotionDesc' => 'Menos animaciones en Claude Code (brillo del spinner, destellos). Se guarda como prefersReducedMotion en ~/.claude/settings.json.',
			'settings.page.generalClaude.sectionNotifications' => 'Notificaciones',
			'settings.page.generalClaude.notifyTurnDone' => 'Finalización de respuestas',
			'settings.page.generalClaude.notifyTurnDoneDesc' => 'Recibe una notificación cuando un agente termine una respuesta y la ventana no esté enfocada.',
			'settings.page.generalClaude.notifyPermission' => 'Solicitudes de permiso de Code',
			'settings.page.generalClaude.notifyPermissionDesc' => 'Reproduce un sonido cuando un agente espera tu aprobación o respuesta.',
			'settings.page.generalClaude.pushInputNeeded' => 'Push al móvil cuando se te necesite',
			'settings.page.generalClaude.pushInputNeededDesc' => 'Claude Code envía un push cuando un permiso o una pregunta están esperando (inputNeededNotifEnabled).',
			'settings.page.generalClaude.pushAgent' => 'Notificaciones proactivas en el móvil',
			'settings.page.generalClaude.pushAgentDesc' => 'Permite que Claude avise en el móvil sobre novedades importantes de una sesión (agentPushNotifEnabled).',
			'settings.page.privacy.title' => 'Datos',
			'settings.page.privacy.gshTelemetry' => 'Telemetría de GSH',
			'settings.page.privacy.gshTelemetryDesc' => 'Solo local: errores y logs quedan en SQLite en este equipo y nunca se envían.',
			'settings.page.privacy.ccTelemetry' => 'Desactivar la telemetría de Claude Code',
			'settings.page.privacy.ccTelemetryDesc' => 'Define DISABLE_TELEMETRY en el env de ~/.claude/settings.json (no se envían métricas de uso).',
			'settings.page.privacy.ccErrors' => 'Desactivar informes de errores de Claude Code',
			'settings.page.privacy.ccErrorsDesc' => 'Define DISABLE_ERROR_REPORTING en el env de ~/.claude/settings.json.',
			'settings.page.resources.sectionGeneral' => 'General',
			'settings.page.resources.sectionShell' => 'Funciones de GSH',
			'settings.page.resources.chat' => 'Chat con Claude (beta)',
			'settings.page.resources.chatDesc' => 'Botón de chat en la barra del workspace (Claude Code en stream-json).',
			'settings.page.resources.farm' => 'Granja',
			'settings.page.resources.farmDesc' => 'Loops de agentes leídos de las transcripciones de Claude Code.',
			'settings.page.resources.harnessFeature' => 'Harness',
			'settings.page.resources.harnessFeatureDesc' => 'Botón que abre lo que el agente carga en el workspace: instrucciones, skills, subagentes, hooks, permisos y MCP.',
			'settings.page.resources.sectionTeamFarm' => 'Granja del equipo',
			'settings.page.resources.teamFarm' => 'Ver la granja de los compañeros',
			'settings.page.resources.teamFarmDesc' => 'En la misma red (p. ej., en la oficina), cada GSH anuncia su granja y muestra la de los compañeros al lado de la tuya: aleja el zoom para verlas. Sin servidor: nada sale de la red local. Desactivado, nada sale de tu GSH.',
			'settings.page.resources.teamName' => 'Equipo',
			'settings.page.resources.teamNameDesc' => 'Solo se ven quienes usan el mismo nombre de equipo.',
			'settings.page.resources.teamNamePlaceholder' => 'p. ej.: gorila',
			'settings.page.resources.teamMe' => 'Tu nombre',
			'settings.page.resources.teamMeDesc' => 'Aparece sobre tu granja para los compañeros.',
			'settings.page.resources.teamShowTitles' => 'Mostrar títulos de las sesiones',
			'settings.page.resources.teamShowTitlesDesc' => 'Los títulos pueden tener partes de tus prompts. Desactivado, los compañeros solo ven la carpeta, el estado y los tokens de cada agente.',
			'settings.page.resources.teamSecret' => 'Contraseña del equipo',
			'settings.page.resources.teamSecretDesc' => 'Activa la conversación entre agentes: tu agente puede mandar mensajes y archivos a los agentes de los compañeros, y los de ellos al tuyo. Todo el equipo usa la misma contraseña; sin ella, nadie llama a tu puerta (y las granjas sin ella no aparecen).',
			'settings.page.resources.teamSecretPlaceholder' => 'acuerden una contraseña',
			'settings.page.resources.teamDoorAllow' => 'Quién puede llamar a la puerta',
			'settings.page.resources.teamDoorAllowDesc' => 'Nombres de los compañeros, separados por comas. Vacío = todo el equipo.',
			'settings.page.resources.teamDoorAllowPlaceholder' => 'todo el equipo',
			'settings.page.resources.teamDoorAsk' => 'Preguntar antes de abrir la puerta',
			'settings.page.resources.teamDoorAskDesc' => 'Cuando un compañero manda algo a uno de tus agentes, GSH te pregunta antes de entregarlo. Desactivado, tu agente lo recibe directo, marcado como información de un compañero (no como orden tuya).',
			'settings.page.resources.teamNetwork' => 'Red del trabajo',
			'settings.page.resources.teamNetworkDesc' => 'Rango de IP de la red de la oficina (p. ej., 192.168.10.0/24). Si se completa, GSH solo anuncia y escucha cuando estás en ella.',
			'settings.page.resources.teamNetworkPlaceholder' => 'cualquier red local',
			'settings.page.resources.farmScenery' => 'Escenario de la granja',
			'settings.page.resources.farmSceneryDesc' => 'Dónde viven los agentes: la granja o una oficina en pixel art.',
			'settings.page.resources.sceneryFarm' => 'Granja',
			'settings.page.resources.sceneryOffice' => 'Oficina',
			'settings.page.resources.graph' => 'Grafo de agentes',
			'settings.page.resources.graphDesc' => 'Visualiza los agentes del workspace y quién habla con quién.',
			'settings.page.resources.browser' => 'Navegador integrado',
			'settings.page.resources.browserDesc' => 'Pestaña "Navegador" en el menú del panel (donde la plataforma tiene webview integrada).',
			'settings.page.resources.skillsMoved' => 'Las Skills se movieron a ',
			'settings.page.designSystems.title' => 'Design systems',
			'settings.page.designSystems.desc' => 'En GSH son los temas: colores de la interfaz, la terminal y el código en un solo paquete.',
			'settings.page.designSystems.add' => 'Nuevo design system',
			'settings.page.designSystems.search' => 'Buscar por nombre',
			'settings.page.designSystems.showing' => ({required Object n, required Object total}) => 'Mostrando ${n} de ${total}',
			'settings.page.designSystems.colName' => 'Nombre',
			'settings.page.designSystems.colOrigin' => 'Origen',
			'settings.page.designSystems.colAuthor' => 'Autor',
			'settings.page.designSystems.active' => 'Activo',
			'settings.page.designSystems.imported' => 'Importado',
			'settings.page.designSystems.builtIn' => 'Integrado',
			'settings.page.designSystems.activate' => 'Usar este tema',
			'settings.page.designSystems.remove' => 'Quitar',
			'settings.remoteHosts.title' => 'Hosts remotos',
			'settings.remoteHosts.description' => 'Máquinas a las que accedes por SSH. Añadir un host aquí es lo mismo que hacerlo desde el menú "+" del workspace.',
			'settings.remoteHosts.empty' => 'Aún no hay hosts remotos.',
			'settings.remoteHosts.add' => 'Añadir host',
			'settings.remoteHosts.edit' => 'Editar',
			'settings.remoteHosts.reconnect' => 'Reconectar',
			'settings.remoteHosts.remove' => 'Eliminar',
			'settings.remoteHosts.removeTitle' => 'Eliminar host',
			'settings.remoteHosts.removeMessage' => ({required Object name}) => '¿Eliminar "${name}" y todos sus workspaces? No se borra nada en el host.',
			'settings.remoteHosts.workspacesCount' => ({required Object count}) => '${count} workspace(s)',
			'settings.remoteHosts.deviceKeyTitle' => 'Clave de este dispositivo',
			'settings.remoteHosts.deviceKeyDesc' => 'Añade esta clave pública a ~/.ssh/authorized_keys del host para que este dispositivo pueda conectarse.',
			'settings.remoteHosts.deviceKeyCopy' => 'Copiar clave pública',
			'settings.remoteHosts.deviceKeyCopied' => 'Clave pública copiada',
			'settings.remoteHosts.statusConnected' => 'Conectado',
			'settings.remoteHosts.statusConnecting' => 'Conectando…',
			'settings.remoteHosts.statusReconnecting' => 'Reconectando…',
			'settings.remoteHosts.statusOffline' => 'Sin conexión',
			'settings.remoteHosts.statusIdle' => 'No conectado',
			'settings.remoteHosts.helpTitle' => 'Cómo funciona',
			'settings.remoteHosts.helpBody' => 'GSH Desktop se conecta a tu máquina por SSH y habla con un pequeño servidor que ejecuta las terminales, archivos y git allí. El host debe tener GSH Desktop (escritorio) o el gsh-server instalado y en ejecución, y la clave pública de este dispositivo añadida en su ~/.ssh/authorized_keys.',
			'automation.error.unavailable' => ({required Object harness}) => '${harness} no está instalado o no está en el PATH.',
			'automation.error.modelUnavailable' => ({required Object model, required Object harness}) => 'El modelo "${model}" no está disponible para ${harness}. Elige otro modelo en Configuración.',
			'automation.error.authentication' => ({required Object harness, required Object detail}) => '${harness}: ${detail}',
			'automation.error.timeout' => ({required Object harness, required Object seconds}) => '${harness} no respondió en ${seconds} segundos.',
			'automation.error.cancelled' => 'Se canceló la generación del mensaje de commit.',
			'automation.error.process' => ({required Object harness, required Object detail}) => '${harness}: ${detail}',
			'automation.error.processNoDetail' => ({required Object harness}) => '${harness} no pudo generar un mensaje de commit.',
			'automation.error.invalidResponse' => 'La automatización devolvió un mensaje de commit vacío.',
			'automation.error.busy' => 'Ya se está generando otro mensaje de commit.',
			'automation.error.unknown' => 'La automatización no pudo generar un mensaje de commit.',
			'automation.error.noWorkspace' => 'Ningún workspace seleccionado.',
			'automation.error.fileOutsideWorkspace' => 'El archivo está fuera de las raíces del workspace.',
			'automation.error.fileUnreadable' => ({required Object detail}) => 'No se pudo leer el archivo: ${detail}',
			'automation.error.binaryFile' => 'No se puede generar un mensaje de commit para un archivo binario.',
			'automation.error.noFileChanges' => 'No hay cambios que describir en este archivo.',
			'automation.error.noStagedChanges' => 'No hay cambios en stage que describir.',
			'automation.error.multipleRepositories' => 'Los cambios en stage pertenecen a varios repositorios. Genéralos por separado.',
			'automation.error.diffUnavailable' => 'No se pudo leer el diff.',
			'automation.error.notConfigured' => 'Configura un harness de mensajes de commit en Configuración.',
			'fileOperation.error.alreadyExists' => ({required Object name}) => 'Ya existe: “${name}”.',
			'fileOperation.error.notFound' => ({required Object name}) => 'No se encontró: “${name}”.',
			'fileOperation.error.invalidPath' => 'Ruta inválida.',
			'fileOperation.error.emptyName' => 'El nombre no puede estar vacío.',
			'fileOperation.error.noWorkspace' => 'Ningún workspace seleccionado.',
			'fileOperation.error.cannotMoveIntoItself' => 'No se puede mover una carpeta dentro de sí misma.',
			'fileOperation.error.clipboardEmpty' => 'El portapapeles está vacío.',
			'fileOperation.error.notScratchTab' => 'Esta pestaña no es un archivo temporal.',
			'fileOperation.error.writeFailed' => 'No se pudo escribir el archivo.',
			'fileOperation.error.formatterEmptyCommand' => 'Comando de formato vacío.',
			'fileOperation.error.formatterMissingPlaceholder' => 'El comando de formato debe incluir el marcador %FILE%.',
			'fileOperation.error.formatterTimeout' => 'El formateador agotó el tiempo de espera.',
			'fileOperation.error.formatterExitCode' => ({required Object code}) => 'El formateador terminó con el código ${code}.',
			'fileOperation.error.formatterFailed' => 'No se pudo ejecutar el formateador.',
			'fileOperation.error.osFailure' => ({required Object detail}) => '${detail}',
			'fileOperation.error.nameHasSlash' => 'El nombre no puede contener “/”.',
			'fileOperation.error.invalidName' => 'Nombre inválido.',
			'fileOperation.error.remoteDropUnsupported' => 'Soltar archivos en un workspace remoto todavía no está soportado.',
			'theme.error.io' => 'No se pudo leer o escribir el archivo del tema.',
			'theme.error.ioDetail' => ({required Object detail}) => 'No se pudo leer o escribir el archivo del tema: ${detail}',
			'theme.error.malformedJson' => ({required Object detail}) => 'Este archivo no es JSON válido: ${detail}',
			'theme.error.invalidTheme' => 'Este archivo no es un tema válido.',
			'theme.error.reservedId' => 'Este tema usa el id de un tema nativo. Cambia el "id" en el archivo e impórtalo de nuevo.',
			'theme.error.notAnObject' => ({required Object field}) => 'Se esperaba un objeto en "${field}".',
			'theme.error.missingField' => ({required Object field}) => 'Falta el campo obligatorio "${field}".',
			'theme.error.badColor' => ({required Object value, required Object field}) => '"${value}" en "${field}" no es un color. Usa #RGB, #RRGGBB o #RRGGBBAA.',
			'theme.error.unknownBase' => ({required Object value}) => 'Tema base "${value}" desconocido en "extends".',
			'theme.error.noVariants' => 'El tema no declara ningún variant. Añade "dark", "light" o ambos en "variants".',
			_ => null,
		};
	}
}
