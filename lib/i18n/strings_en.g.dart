///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$core$en core = Translations$core$en.internal(_root);
	late final Translations$common$en common = Translations$common$en.internal(_root);
	late final Translations$gsh$en gsh = Translations$gsh$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$automation$en automation = Translations$automation$en.internal(_root);
	late final Translations$fileOperation$en fileOperation = Translations$fileOperation$en.internal(_root);
	late final Translations$theme$en theme = Translations$theme$en.internal(_root);
}

// Path: core
class Translations$core$en {
	Translations$core$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$core$bootstrapError$en bootstrapError = Translations$core$bootstrapError$en.internal(_root);
	late final Translations$core$macosNotifications$en macosNotifications = Translations$core$macosNotifications$en.internal(_root);
	late final Translations$core$appErrorView$en appErrorView = Translations$core$appErrorView$en.internal(_root);
	late final Translations$core$errorReportDialog$en errorReportDialog = Translations$core$errorReportDialog$en.internal(_root);
	late final Translations$core$windowControls$en windowControls = Translations$core$windowControls$en.internal(_root);
	late final Translations$core$crash$en crash = Translations$core$crash$en.internal(_root);
	late final Translations$core$menu$en menu = Translations$core$menu$en.internal(_root);
}

// Path: common
class Translations$common$en {
	Translations$common$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Create'
	String get create => 'Create';

	/// en: 'Got it'
	String get gotIt => 'Got it';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Done'
	String get done => 'Done';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'Test'
	String get test => 'Test';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Loading…'
	String get loading => 'Loading…';

	/// en: 'Checking…'
	String get checking => 'Checking…';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Restart'
	String get restart => 'Restart';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Send'
	String get send => 'Send';

	/// en: 'Open'
	String get open => 'Open';

	/// en: 'Dismiss'
	String get dismiss => 'Dismiss';

	/// en: 'Report'
	String get report => 'Report';

	/// en: 'Copy code'
	String get copyCode => 'Copy code';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'No results'
	String get noResults => 'No results';
}

// Path: gsh
class Translations$gsh$en {
	Translations$gsh$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$gsh$confirmDialog$en confirmDialog = Translations$gsh$confirmDialog$en.internal(_root);
	late final Translations$gsh$neovim$en neovim = Translations$gsh$neovim$en.internal(_root);
	late final Translations$gsh$worktreeCreateDialog$en worktreeCreateDialog = Translations$gsh$worktreeCreateDialog$en.internal(_root);
	late final Translations$gsh$commitMessageDialog$en commitMessageDialog = Translations$gsh$commitMessageDialog$en.internal(_root);
	late final Translations$gsh$tasksPanel$en tasksPanel = Translations$gsh$tasksPanel$en.internal(_root);
	late final Translations$gsh$gshPage$en gshPage = Translations$gsh$gshPage$en.internal(_root);
	late final Translations$gsh$welcomeView$en welcomeView = Translations$gsh$welcomeView$en.internal(_root);
	late final Translations$gsh$paneView$en paneView = Translations$gsh$paneView$en.internal(_root);
	late final Translations$gsh$fileTreePanel$en fileTreePanel = Translations$gsh$fileTreePanel$en.internal(_root);
	late final Translations$gsh$fileViewer$en fileViewer = Translations$gsh$fileViewer$en.internal(_root);
	late final Translations$gsh$workspaceSettingsDialog$en workspaceSettingsDialog = Translations$gsh$workspaceSettingsDialog$en.internal(_root);
	late final Translations$gsh$realmDialogs$en realmDialogs = Translations$gsh$realmDialogs$en.internal(_root);
	late final Translations$gsh$dbRedisTable$en dbRedisTable = Translations$gsh$dbRedisTable$en.internal(_root);
	late final Translations$gsh$dbQueryView$en dbQueryView = Translations$gsh$dbQueryView$en.internal(_root);
	late final Translations$gsh$httpView$en httpView = Translations$gsh$httpView$en.internal(_root);
	late final Translations$gsh$kanbanView$en kanbanView = Translations$gsh$kanbanView$en.internal(_root);
	late final Translations$gsh$dbPanel$en dbPanel = Translations$gsh$dbPanel$en.internal(_root);
	late final Translations$gsh$dbMongoView$en dbMongoView = Translations$gsh$dbMongoView$en.internal(_root);
	late final Translations$gsh$dbConnectionDialog$en dbConnectionDialog = Translations$gsh$dbConnectionDialog$en.internal(_root);
	late final Translations$gsh$sshPrompts$en sshPrompts = Translations$gsh$sshPrompts$en.internal(_root);
	late final Translations$gsh$projectsRail$en projectsRail = Translations$gsh$projectsRail$en.internal(_root);
	late final Translations$gsh$findBar$en findBar = Translations$gsh$findBar$en.internal(_root);
	late final Translations$gsh$contentSearch$en contentSearch = Translations$gsh$contentSearch$en.internal(_root);
	late final Translations$gsh$topbar$en topbar = Translations$gsh$topbar$en.internal(_root);
	late final Translations$gsh$tasks$en tasks = Translations$gsh$tasks$en.internal(_root);
	late final Translations$gsh$notifications$en notifications = Translations$gsh$notifications$en.internal(_root);
	late final Translations$gsh$terminalLink$en terminalLink = Translations$gsh$terminalLink$en.internal(_root);
	late final Translations$gsh$terminal$en terminal = Translations$gsh$terminal$en.internal(_root);
	late final Translations$gsh$remoteHost$en remoteHost = Translations$gsh$remoteHost$en.internal(_root);
	late final Translations$gsh$browserPane$en browserPane = Translations$gsh$browserPane$en.internal(_root);
	late final Translations$gsh$documentWindow$en documentWindow = Translations$gsh$documentWindow$en.internal(_root);
	late final Translations$gsh$gallery$en gallery = Translations$gsh$gallery$en.internal(_root);
	late final Translations$gsh$notebook$en notebook = Translations$gsh$notebook$en.internal(_root);
	late final Translations$gsh$layoutPreview$en layoutPreview = Translations$gsh$layoutPreview$en.internal(_root);
	late final Translations$gsh$telemetry$en telemetry = Translations$gsh$telemetry$en.internal(_root);
	late final Translations$gsh$panelView$en panelView = Translations$gsh$panelView$en.internal(_root);
	late final Translations$gsh$chat$en chat = Translations$gsh$chat$en.internal(_root);
	late final Translations$gsh$harness$en harness = Translations$gsh$harness$en.internal(_root);
	late final Translations$gsh$farm$en farm = Translations$gsh$farm$en.internal(_root);
	late final Translations$gsh$agentGraph$en agentGraph = Translations$gsh$agentGraph$en.internal(_root);
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$settings$language$en language = Translations$settings$language$en.internal(_root);
	late final Translations$settings$page$en page = Translations$settings$page$en.internal(_root);
	late final Translations$settings$remoteHosts$en remoteHosts = Translations$settings$remoteHosts$en.internal(_root);
}

// Path: automation
class Translations$automation$en {
	Translations$automation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$automation$error$en error = Translations$automation$error$en.internal(_root);
}

// Path: fileOperation
class Translations$fileOperation$en {
	Translations$fileOperation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$fileOperation$error$en error = Translations$fileOperation$error$en.internal(_root);
}

// Path: theme
class Translations$theme$en {
	Translations$theme$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$theme$error$en error = Translations$theme$error$en.internal(_root);
}

// Path: core.bootstrapError
class Translations$core$bootstrapError$en {
	Translations$core$bootstrapError$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Failed to initialize GSH Desktop'
	String get title => 'Failed to initialize GSH Desktop';

	/// en: 'Retry'
	String get retry => 'Retry';
}

// Path: core.macosNotifications
class Translations$core$macosNotifications$en {
	Translations$core$macosNotifications$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enable Notifications on macOS'
	String get title => 'Enable Notifications on macOS';

	/// en: 'Notifications are currently disabled in your system settings. Follow the steps below to enable them:'
	String get intro => 'Notifications are currently disabled in your system settings. Follow the steps below to enable them:';

	/// en: 'Open System Settings on your Mac.'
	String get step1 => 'Open System Settings on your Mac.';

	/// en: 'Navigate to the Notifications section in the left sidebar.'
	String get step2 => 'Navigate to the Notifications section in the left sidebar.';

	/// en: 'Find and select the GSH Desktop application from the list.'
	String get step3 => 'Find and select the GSH Desktop application from the list.';

	/// en: 'Toggle the Allow Notifications switch on.'
	String get step4 => 'Toggle the Allow Notifications switch on.';

	/// en: 'Tip: If the app does not appear in the list, close and reopen it to trigger its registration in the system.'
	String get tip => 'Tip: If the app does not appear in the list, close and reopen it to trigger its registration in the system.';

	/// en: 'Got it'
	String get gotIt => 'Got it';
}

// Path: core.appErrorView
class Translations$core$appErrorView$en {
	Translations$core$appErrorView$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'This part of the app failed to render'
	String get renderFailed => 'This part of the app failed to render';

	/// en: 'Details'
	String get details => 'Details';

	/// en: 'Render error'
	String get renderErrorTitle => 'Render error';
}

// Path: core.errorReportDialog
class Translations$core$errorReportDialog$en {
	Translations$core$errorReportDialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Something went wrong. The details below were saved to the log — you can report them so it gets fixed.'
	String get defaultDescription => 'Something went wrong. The details below were saved to the log — you can report them so it gets fixed.';

	/// en: 'Copy details'
	String get copyDetails => 'Copy details';

	/// en: 'Report issue'
	String get reportIssue => 'Report issue';
}

// Path: core.windowControls
class Translations$core$windowControls$en {
	Translations$core$windowControls$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Minimize'
	String get minimize => 'Minimize';

	/// en: 'Maximize'
	String get maximize => 'Maximize';

	/// en: 'Close'
	String get close => 'Close';
}

// Path: core.crash
class Translations$core$crash$en {
	Translations$core$crash$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unexpected shutdown'
	String get title => 'Unexpected shutdown';

	/// en: 'GSH Desktop closed unexpectedly'
	String get bannerTitle => 'GSH Desktop closed unexpectedly';

	/// en: 'Report'
	String get report => 'Report';

	/// en: 'Dismiss'
	String get dismiss => 'Dismiss';

	/// en: 'The previous session (version ${version}) ended without shutting down cleanly. Want to report it? The log is included and you can review everything before sending.'
	String crashMessage({required Object version}) => 'The previous session (version ${version}) ended without shutting down cleanly. Want to report it? The log is included and you can review everything before sending.';

	/// en: 'Session started at ${startedAt} (pid ${pid}) ended without a clean shutdown.'
	String crashError({required Object startedAt, required Object pid}) => 'Session started at ${startedAt} (pid ${pid}) ended without a clean shutdown.';

	/// en: 'No error was captured — the app was terminated by the system. The log below is from that session and is the most useful part.'
	String get crashDescription => 'No error was captured — the app was terminated by the system. The log below is from that session and is the most useful part.';
}

// Path: core.menu
class Translations$core$menu$en {
	Translations$core$menu$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings…'
	String get settings => 'Settings…';

	/// en: 'Check for Updates…'
	String get checkForUpdates => 'Check for Updates…';

	/// en: 'File'
	String get file => 'File';

	/// en: 'New Terminal'
	String get newTerminal => 'New Terminal';

	/// en: 'New Chat'
	String get newChat => 'New Chat';

	/// en: 'New Chat to the Right'
	String get newChatRight => 'New Chat to the Right';

	/// en: 'Open Workspace'
	String get openWorkspace => 'Open Workspace';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Discard'
	String get discard => 'Discard';

	/// en: 'Format'
	String get format => 'Format';

	/// en: 'View'
	String get view => 'View';

	/// en: 'Toggle Workspace Panel'
	String get toggleWorkspacePanel => 'Toggle Workspace Panel';

	/// en: 'Toggle Files'
	String get toggleFiles => 'Toggle Files';

	/// en: 'Split Right'
	String get splitRight => 'Split Right';

	/// en: 'Split Down'
	String get splitDown => 'Split Down';

	/// en: 'Focus Pane'
	String get focusPane => 'Focus Pane';

	/// en: 'Left (⌘⌥←)'
	String get focusLeft => 'Left  (⌘⌥←)';

	/// en: 'Right (⌘⌥→)'
	String get focusRight => 'Right  (⌘⌥→)';

	/// en: 'Up (⌘⌥↑)'
	String get focusUp => 'Up  (⌘⌥↑)';

	/// en: 'Down (⌘⌥↓)'
	String get focusDown => 'Down  (⌘⌥↓)';

	/// en: 'Select Tab'
	String get selectTab => 'Select Tab';

	/// en: 'Tab ${n}'
	String tabN({required Object n}) => 'Tab ${n}';

	/// en: 'Last Tab'
	String get lastTab => 'Last Tab';

	/// en: 'Previous Workspace'
	String get previousWorkspace => 'Previous Workspace';

	/// en: 'Next Workspace'
	String get nextWorkspace => 'Next Workspace';

	/// en: 'Zoom In'
	String get zoomIn => 'Zoom In';

	/// en: 'Zoom Out'
	String get zoomOut => 'Zoom Out';

	/// en: 'Actual Size'
	String get actualSize => 'Actual Size';

	/// en: 'Window'
	String get window => 'Window';

	/// en: 'Quit'
	String get quit => 'Quit';

	/// en: 'Minimize'
	String get minimize => 'Minimize';

	/// en: 'Zoom'
	String get zoom => 'Zoom';
}

// Path: gsh.confirmDialog
class Translations$gsh$confirmDialog$en {
	Translations$gsh$confirmDialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unsaved changes'
	String get unsavedChangesTitle => 'Unsaved changes';

	/// en: '“${fileName}” has unsaved changes. Save them before closing?'
	String unsavedChangesMessage({required Object fileName}) => '“${fileName}” has unsaved changes. Save them before closing?';

	/// en: 'Don't save'
	String get dontSave => 'Don\'t save';

	/// en: 'Save & close'
	String get saveAndClose => 'Save & close';
}

// Path: gsh.neovim
class Translations$gsh$neovim$en {
	Translations$gsh$neovim$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Neovim is not available. Opening in GSH Desktop instead.'
	String get unavailable => 'Neovim is not available. Opening in GSH Desktop instead.';

	/// en: 'Could not reach Neovim. Opening in GSH Desktop instead.'
	String get openFailed => 'Could not reach Neovim. Opening in GSH Desktop instead.';

	/// en: 'Unsaved Neovim buffers'
	String get unsavedTitle => 'Unsaved Neovim buffers';

	/// en: 'Neovim has modified buffers. Close the tab and discard those changes?'
	String get unsavedMessage => 'Neovim has modified buffers. Close the tab and discard those changes?';

	/// en: 'Close anyway'
	String get closeAnyway => 'Close anyway';
}

// Path: gsh.worktreeCreateDialog
class Translations$gsh$worktreeCreateDialog$en {
	Translations$gsh$worktreeCreateDialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Fork worktree'
	String get forkTitle => 'Fork worktree';

	/// en: 'Create worktree'
	String get createTitle => 'Create worktree';

	/// en: 'New worktree branched from ${root}.'
	String forkSubtitle({required Object root}) => 'New worktree branched from ${root}.';

	/// en: 'New feature in ${root} — new branch from the current HEAD.'
	String createSubtitle({required Object root}) => 'New feature in ${root} — new branch from the current HEAD.';

	/// en: 'feat/minha-feature'
	String get namePlaceholder => 'feat/minha-feature';

	/// en: 'No spaces in the name.'
	String get errorWhitespace => 'No spaces in the name.';

	/// en: 'Invalid character for a branch name.'
	String get errorInvalidChar => 'Invalid character for a branch name.';

	/// en: 'Invalid sequence (e.g. "..", "//", starting/ending with "/").'
	String get errorInvalidSequence => 'Invalid sequence (e.g. "..", "//", starting/ending with "/").';

	/// en: 'Reserved position (do not start with "-"/"." or end with ".lock").'
	String get errorReserved => 'Reserved position (do not start with "-"/"." or end with ".lock").';

	/// en: 'A branch with that name already exists.'
	String get errorDuplicateBranch => 'A branch with that name already exists.';

	/// en: 'A worktree with that name already exists.'
	String get errorDuplicateWorktree => 'A worktree with that name already exists.';

	/// en: 'Cannot create branch '${target}' because it conflicts with the existing branch '${existing}'.'
	String errorBranchHierarchyConflict({required Object target, required Object existing}) => 'Cannot create branch \'${target}\' because it conflicts with the existing branch \'${existing}\'.';

	/// en: 'A branch with a conflicting hierarchy already exists.'
	String get errorBranchHierarchicalConflictGeneral => 'A branch with a conflicting hierarchy already exists.';

	/// en: 'Fork'
	String get fork => 'Fork';

	/// en: 'This repository has a post-checkout hook.'
	String get postCheckoutHint => 'This repository has a post-checkout hook.';

	/// en: 'Running…'
	String get running => 'Running…';

	/// en: 'Advanced Settings'
	String get advancedSettings => 'Advanced Settings';

	/// en: 'Copy ignored files (.gitignore)'
	String get copyIgnored => 'Copy ignored files (.gitignore)';

	/// en: 'Copies files ignored by .gitignore (e.g. .env, local keys) to the new worktree.'
	String get copyIgnoredDesc => 'Copies files ignored by .gitignore (e.g. .env, local keys) to the new worktree.';

	/// en: 'Copy untracked files'
	String get copyUntracked => 'Copy untracked files';

	/// en: 'Copies new or modified files that haven't been staged yet.'
	String get copyUntrackedDesc => 'Copies new or modified files that haven\'t been staged yet.';

	/// en: 'Base branch'
	String get baseBranch => 'Base branch';

	/// en: 'The branch from which the new worktree and branch will be created.'
	String get baseBranchDesc => 'The branch from which the new worktree and branch will be created.';

	/// en: 'Fetch remote branch'
	String get fetchRemote => 'Fetch remote branch';

	/// en: 'Run git fetch to guarantee the base branch is confirmed before creating the worktree.'
	String get fetchRemoteDesc => 'Run git fetch to guarantee the base branch is confirmed before creating the worktree.';

	/// en: 'Search branch...'
	String get searchBranch => 'Search branch...';

	/// en: 'Back'
	String get back => 'Back';
}

// Path: gsh.commitMessageDialog
class Translations$gsh$commitMessageDialog$en {
	Translations$gsh$commitMessageDialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Commit'
	String get commitTitle => 'Commit';

	/// en: 'Stage and Commit'
	String get stageAndCommitTitle => 'Stage and Commit';

	/// en: 'Commit "${fileName}" only.'
	String scopeNote({required Object fileName}) => 'Commit "${fileName}" only.';

	/// en: 'fix: short summary of the change'
	String get placeholder => 'fix: short summary of the change';

	/// en: 'The first line (subject) cannot be empty.'
	String get errorEmptySubject => 'The first line (subject) cannot be empty.';

	/// en: 'Subject too short (min ${min} characters).'
	String errorTooShort({required Object min}) => 'Subject too short (min ${min} characters).';

	/// en: 'Subject too long (max ${max} characters).'
	String errorTooLong({required Object max}) => 'Subject too long (max ${max} characters).';

	/// en: 'Subject should not end with a period.'
	String get errorTrailingPeriod => 'Subject should not end with a period.';

	/// en: 'Subject contains control characters.'
	String get errorControlChars => 'Subject contains control characters.';

	/// en: 'Leave the second line blank (git subject/body separator).'
	String get errorBlankSecondLine => 'Leave the second line blank (git subject/body separator).';

	/// en: 'Generate commit message'
	String get generate => 'Generate commit message';

	/// en: 'Generate with ${harness}'
	String generateWith({required Object harness}) => 'Generate with ${harness}';

	/// en: 'Generating…'
	String get generating => 'Generating…';

	/// en: 'Cancel generation'
	String get cancelGeneration => 'Cancel generation';
}

// Path: gsh.tasksPanel
class Translations$gsh$tasksPanel$en {
	Translations$gsh$tasksPanel$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reload tasks'
	String get reloadTasksTooltip => 'Reload tasks';

	/// en: 'Restart'
	String get restartTooltip => 'Restart';

	/// en: 'Stop'
	String get stopTooltip => 'Stop';

	/// en: 'Run'
	String get runTooltip => 'Run';

	/// en: '${label} (sends '${key}')'
	String sendsKeyTooltip({required Object label, required Object key}) => '${label} (sends \'${key}\')';

	/// en: 'Starting…'
	String get startingTooltip => 'Starting…';

	/// en: 'Stopping…'
	String get stoppingTooltip => 'Stopping…';

	/// en: 'Switch profile'
	String get switchProfileTooltip => 'Switch profile';

	/// en: 'More keys'
	String get moreKeysTooltip => 'More keys';

	/// en: 'TASKS'
	String get sectionTasks => 'TASKS';

	/// en: 'No tasks detected in this project.'
	String get noTasks => 'No tasks detected in this project.';

	/// en: 'Create tasks.json'
	String get createTasksJson => 'Create tasks.json';

	/// en: 'Generate Compose tasks'
	String get generateComposeTasks => 'Generate Compose tasks';

	/// en: 'Choose a Compose engine'
	String get selectComposeEngine => 'Choose a Compose engine';

	/// en: 'Docker Compose or Podman Compose was not found.'
	String get noComposeEngine => 'Docker Compose or Podman Compose was not found.';

	/// en: 'The active file is not a valid Compose file with services.'
	String get invalidComposeFile => 'The active file is not a valid Compose file with services.';

	/// en: 'tasks.json is invalid. No changes were written.'
	String get invalidTasksJson => 'tasks.json is invalid. No changes were written.';

	/// en: 'Kept non-Compose tasks with conflicting labels: ${labels}'
	String composeConflicts({required Object labels}) => 'Kept non-Compose tasks with conflicting labels: ${labels}';
}

// Path: gsh.gshPage
class Translations$gsh$gshPage$en {
	Translations$gsh$gshPage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Choose the project folder'
	String get chooseProjectFolderDialogTitle => 'Choose the project folder';

	/// en: 'Choose the workspace folder'
	String get chooseWorkspaceFolderDialogTitle => 'Choose the workspace folder';

	/// en: 'Workspace renamed'
	String get workspaceRenamedTitle => 'Workspace renamed';

	/// en: 'The new name "${name}" will only be sent to agents after restarting the workspace or the application.'
	String workspaceRenamedMessage({required Object name}) => 'The new name "${name}" will only be sent to agents after restarting the workspace or the application.';

	/// en: 'Sync — ${label}'
	String syncTitle({required Object label}) => 'Sync — ${label}';

	/// en: 'Pull — ${label}'
	String pullTitle({required Object label}) => 'Pull — ${label}';

	/// en: 'Push — ${label}'
	String pushTitle({required Object label}) => 'Push — ${label}';

	/// en: 'Update from Parent — ${name}'
	String updateFromParentTitle({required Object name}) => 'Update from Parent — ${name}';

	/// en: 'Merge to Parent — ${name}'
	String mergeToParentTitle({required Object name}) => 'Merge to Parent — ${name}';

	/// en: 'Worktree merged and removed.'
	String get worktreeMergedAndRemoved => 'Worktree merged and removed.';

	/// en: 'Nothing was changed.'
	String get nothingWasChanged => 'Nothing was changed.';

	/// en: 'New realm'
	String get newRealmTitle => 'New realm';

	/// en: 'Close workspace'
	String get closeWorkspaceTitle => 'Close workspace';

	/// en: 'Close "${name}"? The agents in this workspace will be terminated. The folder on disk is kept.'
	String closeWorkspaceMessage({required Object name}) => 'Close "${name}"? The agents in this workspace will be terminated. The folder on disk is kept.';

	/// en: 'Close'
	String get closeAction => 'Close';

	/// en: 'Remove worktree'
	String get removeWorktreeTitle => 'Remove worktree';

	/// en: 'Remove "${name}"? The worktree folder and the branch will be deleted and the agents in this fork will be terminated.${warn}'
	String removeWorktreeMessage({required Object name, required Object warn}) => 'Remove "${name}"? The worktree folder and the branch will be deleted and the agents in this fork will be terminated.${warn}';

	/// en: ' Warning: the branch "${name}" has not been merged yet — removing it (git branch -D) discards the unmerged work.'
	String removeWorktreeWarning({required Object name}) => '\n\nWarning: the branch "${name}" has not been merged yet — removing it (git branch -D) discards the unmerged work.';

	/// en: 'Failed to remove worktree'
	String get failedToRemoveWorktreeTitle => 'Failed to remove worktree';

	/// en: 'Open layout'
	String get openLayoutTitle => 'Open layout';

	/// en: 'Replace the current layout?'
	String get replaceLayoutTitle => 'Replace the current layout?';

	/// en: '(one) {1 tab will be closed, including one with a running process.} (other) {${n} tabs will be closed, including ones with running processes.}'
	String replaceLayoutMessage({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 tab will be closed, including one with a running process.',
		other: '${n} tabs will be closed, including ones with running processes.',
	);

	/// en: 'Replace'
	String get replaceLayoutConfirm => 'Replace';

	/// en: 'Restart server'
	String get restartServerTooltip => 'Restart server';

	/// en: 'No LSP available'
	String get noLspAvailable => 'No LSP available';

	/// en: 'running'
	String get lspRunning => 'running';

	/// en: 'stopped'
	String get lspStopped => 'stopped';
}

// Path: gsh.welcomeView
class Translations$gsh$welcomeView$en {
	Translations$gsh$welcomeView$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome to GSH Desktop'
	String get title => 'Welcome to GSH Desktop';

	/// en: 'Open a folder or connect to a remote host to start.'
	String get subtitle => 'Open a folder or connect to a remote host to start.';

	/// en: 'Create workspace'
	String get createWorkspace => 'Create workspace';

	/// en: 'Open local folder'
	String get openLocalFolder => 'Open local folder';

	/// en: 'Connect to host'
	String get connectHost => 'Connect to host';

	/// en: 'Configure host'
	String get configureHost => 'Configure host';

	/// en: 'Add workspace'
	String get addWorkspace => 'Add workspace';
}

// Path: gsh.paneView
class Translations$gsh$paneView$en {
	Translations$gsh$paneView$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Close pane?'
	String get closePaneTitle => 'Close pane?';

	/// en: 'This closes all ${count} tab(s) in this pane and ends the agents/terminals in it.'
	String closePaneMessage({required Object count}) => 'This closes all ${count} tab(s) in this pane and ends the agents/terminals in it.';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'Close others'
	String get closeOtherTabs => 'Close others';

	/// en: 'Close to the right'
	String get closeTabsToTheRight => 'Close to the right';

	/// en: 'Close all'
	String get closeAllTabs => 'Close all';

	/// en: 'Close tabs?'
	String get closeTabsTitle => 'Close tabs?';

	/// en: 'This closes ${count} tab(s) and ends the agents/terminals in them.'
	String closeTabsMessage({required Object count}) => 'This closes ${count} tab(s) and ends the agents/terminals in them.';

	/// en: 'All tabs'
	String get allTabs => 'All tabs';

	/// en: 'Pin tab'
	String get pinTab => 'Pin tab';

	/// en: 'Open in new window'
	String get openInNewWindow => 'Open in new window';

	/// en: 'Rename'
	String get rename => 'Rename';

	/// en: 'Open as markdown'
	String get openAsMarkdown => 'Open as markdown';

	/// en: 'Open as board'
	String get openAsBoard => 'Open as board';

	/// en: 'Reset Title'
	String get resetTitle => 'Reset Title';

	/// en: 'Copy Id'
	String get copyId => 'Copy Id';

	/// en: 'Restart'
	String get restartTab => 'Restart';

	/// en: 'New tab'
	String get newTab => 'New tab';

	/// en: 'New terminal…'
	String get newTerminal => 'New terminal…';

	/// en: 'Split right'
	String get splitRight => 'Split right';

	/// en: 'Split down'
	String get splitDown => 'Split down';

	/// en: 'Close pane'
	String get closePane => 'Close pane';

	/// en: 'Drop here to move the tab'
	String get dropHereToMove => 'Drop here to move the tab';

	/// en: 'Dock as tab'
	String get dockAsTab => 'Dock as tab';

	/// en: 'Open browser'
	String get openBrowser => 'Open browser';

	/// en: 'Open terminal'
	String get openTerminal => 'Open terminal';

	/// en: 'Open as layout'
	String get openAsLayout => 'Open as layout';

	/// en: 'Open as YAML'
	String get openAsYaml => 'Open as YAML';

	/// en: 'Open as panel'
	String get openAsPanel => 'Open as panel';

	/// en: 'Open as HTML'
	String get openAsHtml => 'Open as HTML';
}

// Path: gsh.fileTreePanel
class Translations$gsh$fileTreePanel$en {
	Translations$gsh$fileTreePanel$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'View Diff'
	String get viewDiff => 'View Diff';

	/// en: 'Commit'
	String get commit => 'Commit';

	/// en: 'Stage and Commit'
	String get stageAndCommit => 'Stage and Commit';

	/// en: 'Unstage'
	String get unstage => 'Unstage';

	/// en: 'Stage Changes'
	String get stageChanges => 'Stage Changes';

	/// en: 'Discard Changes'
	String get discardChanges => 'Discard Changes';

	/// en: 'Enter a commit message.'
	String get enterCommitMessage => 'Enter a commit message.';

	/// en: 'Commit is unavailable for this workspace.'
	String get commitUnavailable => 'Commit is unavailable for this workspace.';

	/// en: 'Git error'
	String get gitErrorTitle => 'Git error';

	/// en: 'Delete new file?'
	String get deleteNewFileTitle => 'Delete new file?';

	/// en: 'Discard changes?'
	String get discardChangesTitle => 'Discard changes?';

	/// en: '"${name}" is a new file and cannot be restored. Delete it?'
	String deleteNewFileMessage({required Object name}) => '"${name}" is a new file and cannot be restored. Delete it?';

	/// en: 'Discard all changes in "${name}"? Deleted files will be restored.'
	String discardOneMessage({required Object name}) => 'Discard all changes in "${name}"? Deleted files will be restored.';

	/// en: 'Discard'
	String get discard => 'Discard';

	/// en: 'Delete all new files?'
	String get deleteAllNewFilesTitle => 'Delete all new files?';

	/// en: 'All ${count} files are new and will be deleted. This cannot be undone.'
	String allNewFilesMessage({required Object count}) => 'All ${count} files are new and will be deleted. This cannot be undone.';

	/// en: 'Discard changes in ${count} tracked file(s)?${extra}'
	String discardTrackedMessage({required Object count, required Object extra}) => 'Discard changes in ${count} tracked file(s)?${extra}';

	/// en: ' ${count} new file(s) will be kept.'
	String discardTrackedExtra({required Object count}) => ' ${count} new file(s) will be kept.';

	/// en: 'Delete All'
	String get deleteAll => 'Delete All';

	/// en: 'Delete?'
	String get deleteQuestionTitle => 'Delete?';

	/// en: 'Move “${name}” to the Trash?'
	String moveToTrash({required Object name}) => 'Move “${name}” to the Trash?';

	/// en: 'Permanently delete “${name}”? This can’t be undone.'
	String permanentlyDelete({required Object name}) => 'Permanently delete “${name}”? This can’t be undone.';

	/// en: 'Could not delete'
	String get couldNotDeleteTitle => 'Could not delete';

	/// en: 'Move?'
	String get moveQuestionTitle => 'Move?';

	/// en: 'Move “${name}” to “${dest}”?'
	String moveMessage({required Object name, required Object dest}) => 'Move “${name}” to “${dest}”?';

	/// en: 'Move'
	String get moveAction => 'Move';

	/// en: 'Could not move'
	String get couldNotMoveTitle => 'Could not move';

	/// en: 'Could not paste'
	String get couldNotPasteTitle => 'Could not paste';

	/// en: 'Files'
	String get filesTooltip => 'Files';

	/// en: 'Search'
	String get searchTooltip => 'Search';

	/// en: 'Source Control'
	String get sourceControlTooltip => 'Source Control';

	/// en: 'Database'
	String get databaseTooltip => 'Database';

	/// en: 'FILES'
	String get sectionFiles => 'FILES';

	/// en: 'New file'
	String get newFile => 'New file';

	/// en: 'New folder'
	String get newFolder => 'New folder';

	/// en: 'Refresh'
	String get refreshTooltip => 'Refresh';

	/// en: 'Filter by agent'
	String get agentFilterTooltip => 'Filter by agent';

	/// en: 'All agents'
	String get allAgents => 'All agents';

	/// en: 'tracking unavailable'
	String get trackingUnavailable => 'tracking unavailable';

	/// en: 'Edited by ${label} · ${time}'
	String editedBy({required Object label, required Object time}) => 'Edited by ${label} · ${time}';

	/// en: '(inferred)'
	String get inferredSuffix => '(inferred)';

	/// en: 'No files touched by this agent yet'
	String get noTouchedFiles => 'No files touched by this agent yet';

	/// en: 'Edited by 2+ agents in the last 10 minutes'
	String get concurrentAgentEdits => 'Edited by 2+ agents in the last 10 minutes';

	/// en: 'Collapse all folders'
	String get collapseAll => 'Collapse all folders';

	/// en: 'SOURCE CONTROL'
	String get sectionSourceControl => 'SOURCE CONTROL';

	/// en: 'View as List'
	String get viewAsList => 'View as List';

	/// en: 'View as Tree'
	String get viewAsTree => 'View as Tree';

	/// en: 'No folder — open a workspace.'
	String get noFolderMessage => 'No folder — open a workspace.';

	/// en: 'Amend'
	String get amend => 'Amend';

	/// en: 'Commit Message'
	String get commitMessagePlaceholder => 'Commit Message';

	/// en: 'Amend Commit'
	String get amendCommit => 'Amend Commit';

	/// en: 'last commit'
	String get lastCommit => 'last commit';

	/// en: 'Open in Finder'
	String get openInFinder => 'Open in Finder';

	/// en: 'Open in Explorer'
	String get openInExplorer => 'Open in Explorer';

	/// en: 'Open in file manager'
	String get openInFileManager => 'Open in file manager';

	/// en: 'Open'
	String get open => 'Open';

	/// en: 'Open with'
	String get openWith => 'Open with';

	/// en: 'Open in new window'
	String get openInNewWindow => 'Open in new window';

	/// en: 'Open layout'
	String get openLayout => 'Open layout';

	/// en: 'Open as markdown'
	String get openAsMarkdown => 'Open as markdown';

	/// en: 'Show git diff'
	String get showGitDiff => 'Show git diff';

	/// en: 'Open terminal'
	String get createTerminal => 'Open terminal';

	/// en: 'Rename'
	String get rename => 'Rename';

	/// en: 'Copy'
	String get copy => 'Copy';

	/// en: 'Cut'
	String get cut => 'Cut';

	/// en: 'Paste'
	String get paste => 'Paste';

	/// en: 'Copy relative path'
	String get copyRelativePath => 'Copy relative path';

	/// en: 'Copy absolute path'
	String get copyAbsolutePath => 'Copy absolute path';

	/// en: 'Rename failed.'
	String get renameFailed => 'Rename failed.';

	/// en: 'No changes.'
	String get noChanges => 'No changes.';

	/// en: 'STAGED CHANGES (${count})'
	String stagedChangesHeader({required Object count}) => 'STAGED CHANGES (${count})';

	/// en: 'CHANGES (${count})'
	String changesHeader({required Object count}) => 'CHANGES (${count})';

	/// en: 'Discard All Changes'
	String get discardAllChanges => 'Discard All Changes';

	/// en: 'Unstage All Changes'
	String get unstageAllChanges => 'Unstage All Changes';

	/// en: 'Stage All Changes'
	String get stageAllChanges => 'Stage All Changes';

	/// en: 'Discard Folder Changes'
	String get discardFolderChanges => 'Discard Folder Changes';

	/// en: 'Unstage Folder Changes'
	String get unstageFolderChanges => 'Unstage Folder Changes';

	/// en: 'Stage Folder Changes'
	String get stageFolderChanges => 'Stage Folder Changes';

	/// en: 'Generate commit message'
	String get generateCommitMessage => 'Generate commit message';

	/// en: 'Generate with ${harness}'
	String generateWith({required Object harness}) => 'Generate with ${harness}';

	/// en: 'Unavailable while amending a commit'
	String get generateUnavailableWhileAmending => 'Unavailable while amending a commit';

	/// en: 'Cancel generation'
	String get cancelGeneration => 'Cancel generation';

	/// en: 'Changes'
	String get changes => 'Changes';

	/// en: 'History'
	String get history => 'History';

	/// en: 'Repository'
	String get historyRepository => 'Repository';

	/// en: 'No Git repository available.'
	String get historyNoRepository => 'No Git repository available.';

	/// en: 'No commits found.'
	String get historyEmpty => 'No commits found.';

	/// en: 'Could not load Git history.'
	String get historyLoadFailed => 'Could not load Git history.';

	/// en: 'Untitled commit'
	String get historyUntitledCommit => 'Untitled commit';

	/// en: 'now'
	String get historyNow => 'now';

	/// en: '${count}m ago'
	String historyMinutesAgo({required Object count}) => '${count}m ago';

	/// en: '${count}h ago'
	String historyHoursAgo({required Object count}) => '${count}h ago';

	/// en: 'yesterday'
	String get historyYesterday => 'yesterday';

	/// en: '1d ago'
	String get historyDayAgo => '1d ago';

	/// en: '${count}d ago'
	String historyDaysAgo({required Object count}) => '${count}d ago';

	/// en: 'Files changed'
	String get historyFiles => 'Files changed';

	/// en: 'No files changed.'
	String get historyFilesEmpty => 'No files changed.';

	/// en: 'Could not load changed files.'
	String get historyFilesLoadFailed => 'Could not load changed files.';

	/// en: 'Empty tree'
	String get diffEmptyTree => 'Empty tree';

	/// en: 'Original ${ref}'
	String diffOriginal({required Object ref}) => 'Original ${ref}';

	/// en: 'Modified ${ref}'
	String diffModified({required Object ref}) => 'Modified ${ref}';

	/// en: 'Working tree'
	String get diffWorkingTree => 'Working tree';

	/// en: 'Binary file - no text diff.'
	String get diffBinaryFile => 'Binary file - no text diff.';

	/// en: 'No changes.'
	String get diffNoChanges => 'No changes.';

	/// en: 'Could not read the diff: ${detail}'
	String diffError({required Object detail}) => 'Could not read the diff: ${detail}';

	/// en: 'Gallery'
	String get galleryTooltip => 'Gallery';

	/// en: 'GALLERY'
	String get sectionGallery => 'GALLERY';

	/// en: 'Open as HTML'
	String get openAsHtml => 'Open as HTML';

	/// en: 'Copy here?'
	String get importQuestionTitle => 'Copy here?';

	/// en: 'Copy ${count} items into “${dest}”?'
	String importMessage({required Object count, required Object dest}) => 'Copy ${count} items into “${dest}”?';

	/// en: 'Copy'
	String get importAction => 'Copy';

	/// en: 'Could not copy'
	String get couldNotImportTitle => 'Could not copy';

	/// en: 'Open in ${harness}'
	String openInAgent({required Object harness}) => 'Open in ${harness}';
}

// Path: gsh.fileViewer
class Translations$gsh$fileViewer$en {
	Translations$gsh$fileViewer$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Can't open this file.'
	String get cantOpen => 'Can\'t open this file.';

	/// en: 'Could not load the image.'
	String get couldNotLoadImage => 'Could not load the image.';

	/// en: 'Preview'
	String get preview => 'Preview';

	/// en: 'Source'
	String get source => 'Source';

	/// en: 'Reload'
	String get reload => 'Reload';
}

// Path: gsh.workspaceSettingsDialog
class Translations$gsh$workspaceSettingsDialog$en {
	Translations$gsh$workspaceSettingsDialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Choose workspace photo'
	String get choosePhotoTitle => 'Choose workspace photo';

	/// en: 'Workspace settings'
	String get title => 'Workspace settings';

	/// en: 'Workspace name'
	String get namePlaceholder => 'Workspace name';

	/// en: 'Add photo'
	String get addPhoto => 'Add photo';

	/// en: 'Change photo'
	String get changePhoto => 'Change photo';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Color'
	String get color => 'Color';

	/// en: 'Host'
	String get host => 'Host';

	/// en: 'Folder'
	String get folder => 'Folder';
}

// Path: gsh.realmDialogs
class Translations$gsh$realmDialogs$en {
	Translations$gsh$realmDialogs$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Realm name'
	String get namePlaceholder => 'Realm name';

	/// en: 'A realm with this name already exists.'
	String get duplicateName => 'A realm with this name already exists.';

	/// en: 'New realm'
	String get newRealmTitle => 'New realm';

	/// en: 'Rename realm'
	String get renameRealmTitle => 'Rename realm';

	/// en: 'Rename'
	String get rename => 'Rename';

	/// en: 'Delete realm'
	String get deleteRealmTitle => 'Delete realm';

	/// en: 'Delete "${name}"? No workspace is deleted — the folder list just changes.${suffix}'
	String deleteMessage({required Object name, required Object suffix}) => 'Delete "${name}"? No workspace is deleted — the folder list just changes.${suffix}';

	/// en: ' Its workspace will move to Default.'
	String get deleteSuffixOne => ' Its workspace will move to Default.';

	/// en: ' Its ${count} workspaces will move to Default.'
	String deleteSuffixMany({required Object count}) => ' Its ${count} workspaces will move to Default.';

	/// en: 'Manage realms'
	String get manageRealmsTitle => 'Manage realms';

	/// en: '(one) {1 workspace} (other) {${n} workspaces}'
	String workspaceCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 workspace',
		other: '${n} workspaces',
	);
}

// Path: gsh.dbRedisTable
class Translations$gsh$dbRedisTable$en {
	Translations$gsh$dbRedisTable$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete key'
	String get deleteKeyTitle => 'Delete key';

	/// en: 'Delete "${key}" from this Redis database?'
	String deleteKeyMessage({required Object key}) => 'Delete "${key}" from this Redis database?';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'New key'
	String get newKey => 'New key';

	/// en: 'KEY'
	String get columnKey => 'KEY';

	/// en: 'VALUE'
	String get columnValue => 'VALUE';

	/// en: 'TYPE'
	String get columnType => 'TYPE';

	/// en: 'TTL'
	String get columnTtl => 'TTL';

	/// en: '(one) {1 key} (other) {${n} keys}'
	String keyCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 key',
		other: '${n} keys',
	);

	/// en: 'No keys in this database.'
	String get noKeys => 'No keys in this database.';

	/// en: 'No keys match "${pattern}".'
	String noKeysMatch({required Object pattern}) => 'No keys match "${pattern}".';

	/// en: 'Load more'
	String get loadMore => 'Load more';

	/// en: 'Loading full value…'
	String get loadingFullValue => 'Loading full value…';

	/// en: 'TTL must be a number of seconds.'
	String get ttlMustBeNumber => 'TTL must be a number of seconds.';

	/// en: 'Add key'
	String get addKey => 'Add key';

	/// en: 'key'
	String get keyFieldHint => 'key';

	/// en: 'ttl (s, optional)'
	String get ttlFieldHint => 'ttl (s, optional)';

	/// en: 'value'
	String get valueFieldHint => 'value';

	/// en: 'Search — pattern, e.g. user:*'
	String get searchHint => 'Search — pattern, e.g. user:*';
}

// Path: gsh.dbQueryView
class Translations$gsh$dbQueryView$en {
	Translations$gsh$dbQueryView$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Save query as'
	String get saveQueryAs => 'Save query as';

	/// en: 'Could not save'
	String get couldNotSave => 'Could not save';

	/// en: 'Select database'
	String get selectDatabase => 'Select database';

	/// en: 'No SQL connections'
	String get noSqlConnections => 'No SQL connections';

	/// en: 'Running…'
	String get running => 'Running…';

	/// en: 'Run selection'
	String get runSelection => 'Run selection';

	/// en: 'Run'
	String get run => 'Run';

	/// en: 'Pick a database above, then Run (⌘↵).'
	String get pickDatabaseHint => 'Pick a database above, then Run (⌘↵).';

	/// en: 'Run the query (⌘↵) to see results here.'
	String get runQueryHint => 'Run the query (⌘↵) to see results here.';

	/// en: 'No rows.'
	String get noRows => 'No rows.';

	/// en: '(one) {1 row affected} (other) {${n} rows affected}'
	String rowsAffected({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 row affected',
		other: '${n} rows affected',
	);

	/// en: '${n} rows'
	String rowsFooter({required Object n}) => '${n} rows';

	/// en: ' · truncated (raise -- limit)'
	String get truncatedSuffix => ' · truncated (raise -- limit)';

	/// en: 'Table'
	String get table => 'Table';

	/// en: 'JSON'
	String get json => 'JSON';

	/// en: 'unsaved'
	String get unsaved => 'unsaved';

	/// en: 'saved'
	String get saved => 'saved';

	/// en: 'Copied'
	String get copied => 'Copied';

	/// en: 'Copy'
	String get copy => 'Copy';
}

// Path: gsh.httpView
class Translations$gsh$httpView$en {
	Translations$gsh$httpView$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Save request as'
	String get saveRequestAs => 'Save request as';

	/// en: 'Could not save'
	String get couldNotSave => 'Could not save';

	/// en: 'Run'
	String get run => 'Run';

	/// en: 'Running…'
	String get running => 'Running…';

	/// en: 'No request in this file — write one, e.g. GET https://example.com'
	String get noRequests => 'No request in this file — write one, e.g. GET https://example.com';

	/// en: 'Select request'
	String get selectRequest => 'Select request';

	/// en: '(one) {1 request} (other) {${n} requests}'
	String requestCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 request',
		other: '${n} requests',
	);

	/// en: 'Run the request (⌘↵) to see the response here.'
	String get runHint => 'Run the request (⌘↵) to see the response here.';

	/// en: 'Empty response body.'
	String get emptyBody => 'Empty response body.';

	/// en: 'JSON'
	String get body => 'JSON';

	/// en: 'Headers'
	String get headers => 'Headers';

	/// en: 'Text'
	String get raw => 'Text';

	/// en: ' · truncated (response too large)'
	String get truncatedSuffix => ' · truncated (response too large)';

	late final Translations$gsh$httpView$error$en error = Translations$gsh$httpView$error$en.internal(_root);
}

// Path: gsh.kanbanView
class Translations$gsh$kanbanView$en {
	Translations$gsh$kanbanView$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Filter'
	String get filter => 'Filter';

	/// en: 'Search titles'
	String get filterTitlePlaceholder => 'Search titles';

	/// en: 'Labels'
	String get filterLabels => 'Labels';

	/// en: 'Clear'
	String get filterClear => 'Clear';

	/// en: 'Dependencies'
	String get filterDependencies => 'Dependencies';

	/// en: 'Blocked'
	String get filterBlocked => 'Blocked';

	/// en: 'Ready'
	String get filterReady => 'Ready';

	/// en: 'Blocked by'
	String get blockedBy => 'Blocked by';

	/// en: 'Add a blocking card'
	String get addBlocker => 'Add a blocking card';

	/// en: 'Search cards'
	String get searchCards => 'Search cards';

	/// en: 'unknown'
	String get unknownCard => 'unknown';

	/// en: 'Board'
	String get boardView => 'Board';

	/// en: 'List'
	String get listView => 'List';

	/// en: 'Refresh from disk'
	String get refresh => 'Refresh from disk';

	/// en: 'Labels'
	String get manageLabels => 'Labels';

	/// en: 'Labels in this board'
	String get labelsTitle => 'Labels in this board';

	/// en: 'label name'
	String get labelNamePlaceholder => 'label name';

	/// en: '(one) {1 card} (other) {${n} cards}'
	String labelUsage({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 card',
		other: '${n} cards',
	);

	/// en: 'Delete label'
	String get deleteLabel => 'Delete label';

	/// en: 'new card'
	String get newCard => 'new card';

	/// en: 'New card'
	String get newCardTitle => 'New card';

	/// en: 'New column'
	String get newColumn => 'New column';

	/// en: 'Column name'
	String get columnNameTitle => 'Column name';

	/// en: 'Drag column'
	String get dragColumn => 'Drag column';

	/// en: 'Column options'
	String get columnOptions => 'Column options';

	/// en: 'Rename column'
	String get renameColumn => 'Rename column';

	/// en: 'Move left'
	String get moveColumnLeft => 'Move left';

	/// en: 'Move right'
	String get moveColumnRight => 'Move right';

	/// en: 'Delete column'
	String get deleteColumn => 'Delete column';

	/// en: 'New card here'
	String get newCardHere => 'New card here';

	/// en: 'Duplicate'
	String get duplicateCard => 'Duplicate';

	/// en: 'Labels'
	String get cardLabels => 'Labels';

	/// en: 'Delete card'
	String get deleteCard => 'Delete card';

	/// en: 'Move to next column'
	String get advance => 'Move to next column';

	/// en: 'Move to next column (hold: move to last column)'
	String get advanceHold => 'Move to next column (hold: move to last column)';

	/// en: 'Move back a column'
	String get advanceBack => 'Move back a column';

	/// en: 'No cards'
	String get emptyColumn => 'No cards';

	/// en: '(one) {1 card} (other) {${n} cards}'
	String cardCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 card',
		other: '${n} cards',
	);

	/// en: 'Note'
	String get notes => 'Note';

	/// en: 'Write a note'
	String get notesPlaceholder => 'Write a note';

	/// en: 'Comments'
	String get comments => 'Comments';

	/// en: 'Add comment'
	String get addComment => 'Add comment';

	/// en: 'Write a comment'
	String get commentPlaceholder => 'Write a comment';

	/// en: 'No comments yet'
	String get noComments => 'No comments yet';

	/// en: 'Close'
	String get closeDetail => 'Close';

	/// en: 'This file has no ## columns yet — it opens as markdown.'
	String get notABoard => 'This file has no ## columns yet — it opens as markdown.';

	/// en: 'Start a board'
	String get startBoard => 'Start a board';

	/// en: 'Could not save the board'
	String get couldNotSave => 'Could not save the board';

	/// en: 'Not recognized by the parser — drags whole, no inline editing.'
	String get unrecognizedBlock => 'Not recognized by the parser — drags whole, no inline editing.';

	late final Translations$gsh$kanbanView$deleteColumnDialog$en deleteColumnDialog = Translations$gsh$kanbanView$deleteColumnDialog$en.internal(_root);
}

// Path: gsh.dbPanel
class Translations$gsh$dbPanel$en {
	Translations$gsh$dbPanel$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'DATABASE'
	String get sectionDatabase => 'DATABASE';

	/// en: 'Edit…'
	String get edit => 'Edit…';

	/// en: 'Copy name'
	String get copyName => 'Copy name';

	/// en: 'New query'
	String get newQuery => 'New query';

	/// en: 'Browse keys'
	String get browseKeys => 'Browse keys';

	/// en: 'Delete connection'
	String get deleteConnectionTitle => 'Delete connection';

	/// en: 'Remove "${name}" from this workspace? Any saved password is discarded. .dbq files that reference it are not touched.'
	String deleteConnectionMessage({required Object name}) => 'Remove "${name}" from this workspace? Any saved password is discarded. .dbq files that reference it are not touched.';

	/// en: '.gsh/databases.json · ${n} connections'
	String footer({required Object n}) => '.gsh/databases.json · ${n} connections';

	/// en: '.gsh/databases.json · 1 connection'
	String get footerOne => '.gsh/databases.json · 1 connection';

	/// en: 'No connections yet.'
	String get noConnections => 'No connections yet.';

	/// en: 'Password not found on the host. Open this connection and enter it again — it is saved on the machine that runs the database, not on this one.'
	String get passwordRequired => 'Password not found on the host. Open this connection and enter it again — it is saved on the machine that runs the database, not on this one.';
}

// Path: gsh.dbMongoView
class Translations$gsh$dbMongoView$en {
	Translations$gsh$dbMongoView$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete document'
	String get deleteDocumentTitle => 'Delete document';

	/// en: 'Delete the document with _id ${id} from "${collection}"?'
	String deleteDocumentMessage({required Object id, required Object collection}) => 'Delete the document with _id ${id} from "${collection}"?';

	/// en: 'Filter — JSON, e.g. {"status": "active"}'
	String get filterHint => 'Filter — JSON, e.g. {"status": "active"}';

	/// en: '(one) {1 doc} (other) {${n} docs}'
	String docCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 doc',
		other: '${n} docs',
	);

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'Insert document'
	String get insertDocument => 'Insert document';

	/// en: 'No documents in this collection.'
	String get noDocuments => 'No documents in this collection.';

	/// en: 'No documents match this filter.'
	String get noDocumentsMatch => 'No documents match this filter.';

	/// en: 'Load more'
	String get loadMore => 'Load more';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Insert'
	String get insert => 'Insert';
}

// Path: gsh.dbConnectionDialog
class Translations$gsh$dbConnectionDialog$en {
	Translations$gsh$dbConnectionDialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Choose SQLite database'
	String get chooseFileTitle => 'Choose SQLite database';

	/// en: 'File'
	String get file => 'File';

	/// en: 'Choose a SQLite file…'
	String get chooseFilePlaceholder => 'Choose a SQLite file…';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Save Password'
	String get savePassword => 'Save Password';

	/// en: 'Allow writes (agents)'
	String get allowWrites => 'Allow writes (agents)';

	/// en: 'off = agents can only read via CLI'
	String get allowWritesHint => 'off = agents can only read via CLI';

	/// en: 'Visible to agents'
	String get visibleToAgents => 'Visible to agents';

	/// en: 'off = hidden from the CLI, GUI only'
	String get visibleToAgentsHint => 'off = hidden from the CLI, GUI only';

	/// en: 'Testing connection…'
	String get testing => 'Testing connection…';

	/// en: 'Connection OK'
	String get connectionOk => 'Connection OK';

	/// en: 'Connection failed'
	String get connectionFailed => 'Connection failed';

	/// en: 'Edit connection'
	String get editTitle => 'Edit connection';

	/// en: 'New connection'
	String get newTitle => 'New connection';

	/// en: 'Connection string'
	String get connectionString => 'Connection string';

	/// en: 'Not a valid connection URL.'
	String get invalidUrl => 'Not a valid connection URL.';

	/// en: 'SSH Tunnel'
	String get sshTunnel => 'SSH Tunnel';

	/// en: 'SSH Host'
	String get sshHost => 'SSH Host';

	/// en: 'SSH Port'
	String get sshPort => 'SSH Port';

	/// en: 'SSH User'
	String get sshUser => 'SSH User';

	/// en: 'Private key'
	String get privateKey => 'Private key';

	/// en: 'Choose a private key…'
	String get choosePrivateKeyPlaceholder => 'Choose a private key…';

	/// en: 'Choose SSH private key'
	String get choosePrivateKeyDialogTitle => 'Choose SSH private key';

	/// en: 'Key passphrase'
	String get keyPassphrase => 'Key passphrase';

	/// en: 'Save passphrase'
	String get savePassphrase => 'Save passphrase';

	/// en: 'The password is stored on the host, not on this machine.'
	String get passwordOnHost => 'The password is stored on the host, not on this machine.';
}

// Path: gsh.sshPrompts
class Translations$gsh$sshPrompts$en {
	Translations$gsh$sshPrompts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unknown SSH host'
	String get unknownSshHostTitle => 'Unknown SSH host';

	/// en: 'GSH Desktop has never connected to ${endpoint} before.'
	String neverConnected({required Object endpoint}) => 'GSH Desktop has never connected to ${endpoint} before.';

	/// en: 'Trust it only if this fingerprint matches the server. You can check it on the server with:'
	String get trustHint => 'Trust it only if this fingerprint matches the server. You can check it on the server with:';

	/// en: 'Trust'
	String get trust => 'Trust';

	/// en: 'SSH key passphrase'
	String get sshKeyPassphraseTitle => 'SSH key passphrase';

	/// en: 'Unlock ${keyPath} to connect "${connectionName}".'
	String unlockMessage({required Object keyPath, required Object connectionName}) => 'Unlock ${keyPath} to connect "${connectionName}".';

	/// en: 'Kept in memory until GSH Desktop quits. To let agents use this connection, enable "Save passphrase" in the connection.'
	String get keptInMemoryHint => 'Kept in memory until GSH Desktop quits. To let agents use this connection, enable "Save passphrase" in the connection.';

	/// en: 'Unlock'
	String get unlock => 'Unlock';
}

// Path: gsh.projectsRail
class Translations$gsh$projectsRail$en {
	Translations$gsh$projectsRail$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Workspaces'
	String get workspaces => 'Workspaces';

	/// en: 'Keeping this computer awake for remote access. Click to let it sleep again.'
	String get keepAwakeOn => 'Keeping this computer awake for remote access. Click to let it sleep again.';

	/// en: 'Keep this computer awake for remote access. Off again when GSH Desktop restarts.'
	String get keepAwakeOff => 'Keep this computer awake for remote access. Off again when GSH Desktop restarts.';

	/// en: 'Keeping awake on battery power. This drains the battery.'
	String get keepAwakeBattery => 'Keeping awake on battery power. This drains the battery.';

	/// en: 'Closing a laptop lid still puts it to sleep.'
	String get keepAwakeLid => 'Closing a laptop lid still puts it to sleep.';

	/// en: 'New workspace'
	String get newWorkspace => 'New workspace';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Merge to Parent'
	String get mergeToParent => 'Merge to Parent';

	/// en: 'Update from Parent'
	String get updateFromParent => 'Update from Parent';

	/// en: 'Fork Worktree'
	String get forkWorktree => 'Fork Worktree';

	/// en: 'Copy branch'
	String get copyBranch => 'Copy branch';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Move to realm'
	String get moveToRealm => 'Move to realm';

	/// en: 'Copy workspace id'
	String get copyWorkspaceId => 'Copy workspace id';

	/// en: 'Rename'
	String get rename => 'Rename';

	/// en: 'Close'
	String get close => 'Close';

	/// en: 'New realm…'
	String get newRealm => 'New realm…';

	/// en: 'Manage realms…'
	String get manageRealms => 'Manage realms…';

	/// en: 'No workspaces yet.'
	String get noWorkspaces => 'No workspaces yet.';

	/// en: 'Sync'
	String get sync => 'Sync';

	/// en: 'Pull'
	String get pull => 'Pull';

	/// en: 'Push'
	String get push => 'Push';

	/// en: 'Create worktree'
	String get createWorktree => 'Create worktree';

	/// en: '(one) {1 worktree} (other) {${n} worktrees}'
	String worktreeCount({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 worktree',
		other: '${n} worktrees',
	);

	/// en: 'Expand worktrees'
	String get expandWorktrees => 'Expand worktrees';

	/// en: 'Collapse worktrees'
	String get collapseWorktrees => 'Collapse worktrees';
}

// Path: gsh.findBar
class Translations$gsh$findBar$en {
	Translations$gsh$findBar$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Find'
	String get find => 'Find';

	/// en: 'Match case'
	String get matchCase => 'Match case';

	/// en: 'Whole word'
	String get wholeWord => 'Whole word';

	/// en: 'Use regular expression'
	String get useRegex => 'Use regular expression';

	/// en: 'Previous (⇧⏎)'
	String get previous => 'Previous (⇧⏎)';

	/// en: 'Next (⏎)'
	String get next => 'Next (⏎)';

	/// en: 'Close (Esc)'
	String get close => 'Close (Esc)';

	/// en: 'Bad pattern'
	String get badPattern => 'Bad pattern';

	/// en: 'No results'
	String get noResults => 'No results';
}

// Path: gsh.contentSearch
class Translations$gsh$contentSearch$en {
	Translations$gsh$contentSearch$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'SEARCH'
	String get sectionSearch => 'SEARCH';

	/// en: 'Search in files'
	String get searchInFiles => 'Search in files';

	/// en: 'Match case'
	String get matchCase => 'Match case';

	/// en: 'Whole word'
	String get wholeWord => 'Whole word';

	/// en: 'Use regular expression'
	String get useRegex => 'Use regular expression';

	/// en: 'Invalid regular expression.'
	String get invalidRegex => 'Invalid regular expression.';

	/// en: 'Type to search across files.'
	String get typeToSearch => 'Type to search across files.';

	/// en: 'Searching…'
	String get searching => 'Searching…';

	/// en: 'No results.'
	String get noResults => 'No results.';
}

// Path: gsh.topbar
class Translations$gsh$topbar$en {
	Translations$gsh$topbar$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Collapse sidebar'
	String get collapseSidebar => 'Collapse sidebar';

	/// en: 'Show/hide files'
	String get toggleFiles => 'Show/hide files';

	/// en: 'Files unavailable in GSH Desktop'
	String get filesUnavailable => 'Files unavailable in GSH Desktop';

	/// en: 'Hide keyboard'
	String get hideKeyboard => 'Hide keyboard';

	/// en: 'Visualize agents'
	String get visualizeAgents => 'Visualize agents';

	/// en: 'Workspace harness'
	String get openHarness => 'Workspace harness';

	/// en: 'Agent farm'
	String get openFarm => 'Agent farm';

	/// en: 'Chat with Claude (beta)'
	String get openChat => 'Chat with Claude (beta)';
}

// Path: gsh.tasks
class Translations$gsh$tasks$en {
	Translations$gsh$tasks$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Hot reload'
	String get hotReload => 'Hot reload';

	/// en: 'Hot restart'
	String get hotRestart => 'Hot restart';

	/// en: 'Toggle debug paint'
	String get toggleDebugPaint => 'Toggle debug paint';

	/// en: 'Toggle platform'
	String get togglePlatform => 'Toggle platform';

	/// en: 'Quit'
	String get quit => 'Quit';
}

// Path: gsh.notifications
class Translations$gsh$notifications$en {
	Translations$gsh$notifications$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Agent finished'
	String get agentFinished => 'Agent finished';

	/// en: 'Open'
	String get open => 'Open';

	/// en: 'Agent needs your input'
	String get agentNeedsAction => 'Agent needs your input';
}

// Path: gsh.terminalLink
class Translations$gsh$terminalLink$en {
	Translations$gsh$terminalLink$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Open'
	String get open => 'Open';

	/// en: 'Reveal in Finder'
	String get revealFinder => 'Reveal in Finder';

	/// en: 'Show in Explorer'
	String get revealExplorer => 'Show in Explorer';

	/// en: 'Open containing folder'
	String get revealFolder => 'Open containing folder';

	/// en: 'Copy path'
	String get copyPath => 'Copy path';

	/// en: 'Open link'
	String get openLink => 'Open link';

	/// en: 'Copy link'
	String get copyLink => 'Copy link';
}

// Path: gsh.terminal
class Translations$gsh$terminal$en {
	Translations$gsh$terminal$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Warning: the folder "${requested}" does not exist. This terminal opened in "${path}".'
	String cwdFallbackWarning({required Object requested, required Object path}) => 'Warning: the folder "${requested}" does not exist. This terminal opened in "${path}".';

	/// en: 'Notice: .env.gsh is tracked by git (it came with the repository). Injected: ${keys}'
	String workspaceEnvTracked({required Object keys}) => 'Notice: .env.gsh is tracked by git (it came with the repository). Injected: ${keys}';
}

// Path: gsh.remoteHost
class Translations$gsh$remoteHost$en {
	Translations$gsh$remoteHost$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add remote host'
	String get addHost => 'Add remote host';

	/// en: 'Name'
	String get hostName => 'Name';

	/// en: 'SSH target (user@host)'
	String get sshTarget => 'SSH target (user@host)';

	/// en: 'Connecting to ${host}…'
	String connecting({required Object host}) => 'Connecting to ${host}…';

	/// en: 'SSH tunnel'
	String get openingTunnel => 'SSH tunnel';

	/// en: 'Installing server'
	String get installingServer => 'Installing server';

	/// en: 'Server ${version}'
	String handshake({required Object version}) => 'Server ${version}';

	/// en: 'Loading workspace…'
	String get loadingWorkspace => 'Loading workspace…';

	/// en: 'Reconnecting to ${host}…'
	String reconnecting({required Object host}) => 'Reconnecting to ${host}…';

	/// en: '${host} offline'
	String offline({required Object host}) => '${host} offline';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Reconnect'
	String get reconnect => 'Reconnect';

	/// en: 'Install server'
	String get installServer => 'Install server';

	/// en: 'Cannot reach ${host} over SSH. Is it on, and is Remote Login enabled?'
	String errSshUnreachable({required Object host}) => 'Cannot reach ${host} over SSH. Is it on, and is Remote Login enabled?';

	/// en: 'Could not install the server on ${host}.'
	String errInstallFailed({required Object host}) => 'Could not install the server on ${host}.';

	/// en: 'Server version incompatible; update it.'
	String get errVersionMismatch => 'Server version incompatible; update it.';

	/// en: 'Details: ${detail}'
	String errDetail({required Object detail}) => 'Details: ${detail}';

	/// en: 'Open folder on ${host}'
	String pickFolderTitle({required Object host}) => 'Open folder on ${host}';

	/// en: 'Open here'
	String get openHere => 'Open here';

	/// en: 'No subfolders'
	String get emptyFolder => 'No subfolders';

	/// en: 'Local'
	String get newLocal => 'Local';

	/// en: 'Remote'
	String get newRemote => 'Remote';

	/// en: 'Choose a host'
	String get chooseHost => 'Choose a host';

	/// en: 'New host…'
	String get newHostEntry => 'New host…';

	/// en: 'Edit host'
	String get editHost => 'Edit host';

	/// en: 'Username'
	String get userLabel => 'Username';

	/// en: 'Host / IP'
	String get hostLabel => 'Host / IP';

	/// en: 'Port'
	String get portLabel => 'Port';

	/// en: 'Authentication'
	String get authLabel => 'Authentication';

	/// en: 'SSH key'
	String get authKey => 'SSH key';

	/// en: 'Password'
	String get authPassword => 'Password';

	/// en: 'Password'
	String get passwordLabel => 'Password';

	/// en: 'Leave blank to keep current'
	String get passwordKeep => 'Leave blank to keep current';

	/// en: 'Username required'
	String get errUser => 'Username required';

	/// en: 'Host required'
	String get errHost => 'Host required';

	/// en: 'Password required'
	String get errPassword => 'Password required';

	/// en: 'Choose…'
	String get identityChoose => 'Choose…';

	/// en: 'No key selected'
	String get identityEmpty => 'No key selected';

	/// en: 'Select the SSH private key'
	String get identityDialogTitle => 'Select the SSH private key';

	/// en: 'Pick the private key to authenticate with.'
	String get errIdentity => 'Pick the private key to authenticate with.';

	/// en: 'GSH Desktop does not trust ${host} yet. Connect again and confirm the fingerprint.'
	String errHostKeyUnknown({required Object host}) => 'GSH Desktop does not trust ${host} yet. Connect again and confirm the fingerprint.';

	/// en: '${host} is presenting a different SSH key than the one stored. If you did not reinstall that machine, stop and check it — otherwise remove the old entry from ~/.ssh/known_hosts.'
	String errHostKeyChanged({required Object host}) => '${host} is presenting a different SSH key than the one stored. If you did not reinstall that machine, stop and check it — otherwise remove the old entry from ~/.ssh/known_hosts.';

	/// en: '${host} runs Windows but does not have GSH Desktop installed. The remote server is installed from the GSH Desktop bundle already on that machine, so install GSH Desktop there and try again.'
	String errHostBundleMissing({required Object host}) => '${host} runs Windows but does not have GSH Desktop installed. The remote server is installed from the GSH Desktop bundle already on that machine, so install GSH Desktop there and try again.';

	/// en: 'Could not identify the operating system of ${host}. The account may have a restricted shell, or no shell at all.'
	String errHostUnknownOs({required Object host}) => 'Could not identify the operating system of ${host}. The account may have a restricted shell, or no shell at all.';

	/// en: 'Only the public key is here. That works only if the private key is in your SSH agent; otherwise pick the private file (same name, without .pub).'
	String get errIdentityPublic => 'Only the public key is here. That works only if the private key is in your SSH agent; otherwise pick the private file (same name, without .pub).';

	/// en: 'That file does not look like a private key.'
	String get errIdentityNotKey => 'That file does not look like a private key.';

	/// en: 'That file no longer exists.'
	String get errIdentityMissingFile => 'That file no longer exists.';

	/// en: 'That file could not be read.'
	String get errIdentityUnreadable => 'That file could not be read.';
}

// Path: gsh.browserPane
class Translations$gsh$browserPane$en {
	Translations$gsh$browserPane$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Forward'
	String get forward => 'Forward';

	/// en: 'Reload'
	String get reload => 'Reload';

	/// en: 'Enter URL or address'
	String get urlHint => 'Enter URL or address';

	/// en: 'Go'
	String get go => 'Go';
}

// Path: gsh.documentWindow
class Translations$gsh$documentWindow$en {
	Translations$gsh$documentWindow$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Audio and video open in the main GSH Desktop window.'
	String get mediaNotSupported => 'Audio and video open in the main GSH Desktop window.';

	/// en: 'File not found: ${path}'
	String fileNotFound({required Object path}) => 'File not found: ${path}';
}

// Path: gsh.gallery
class Translations$gsh$gallery$en {
	Translations$gsh$gallery$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Special GSH Desktop documents that give you a visual of what the AI agent is doing.'
	String get intro => 'Special GSH Desktop documents that give you a visual of what the AI agent is doing.';

	/// en: 'Could not create the file'
	String get createErrorTitle => 'Could not create the file';

	late final Translations$gsh$gallery$dbQuery$en dbQuery = Translations$gsh$gallery$dbQuery$en.internal(_root);
	late final Translations$gsh$gallery$kanban$en kanban = Translations$gsh$gallery$kanban$en.internal(_root);
	late final Translations$gsh$gallery$layout$en layout = Translations$gsh$gallery$layout$en.internal(_root);
	late final Translations$gsh$gallery$httpRequest$en httpRequest = Translations$gsh$gallery$httpRequest$en.internal(_root);
	late final Translations$gsh$gallery$html$en html = Translations$gsh$gallery$html$en.internal(_root);
	late final Translations$gsh$gallery$tasks$en tasks = Translations$gsh$gallery$tasks$en.internal(_root);
	late final Translations$gsh$gallery$notebook$en notebook = Translations$gsh$gallery$notebook$en.internal(_root);
	late final Translations$gsh$gallery$workspaceEnv$en workspaceEnv = Translations$gsh$gallery$workspaceEnv$en.internal(_root);
	late final Translations$gsh$gallery$panel$en panel = Translations$gsh$gallery$panel$en.internal(_root);
}

// Path: gsh.notebook
class Translations$gsh$notebook$en {
	Translations$gsh$notebook$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notes'
	String get notes => 'Notes';

	/// en: 'New note'
	String get newNote => 'New note';

	/// en: 'Search notes'
	String get searchPlaceholder => 'Search notes';

	/// en: 'No notes yet. Create one, or ask the agent to write here.'
	String get empty => 'No notes yet. Create one, or ask the agent to write here.';

	/// en: 'No note matches.'
	String get noMatch => 'No note matches.';

	/// en: 'Select a note'
	String get selectNote => 'Select a note';

	/// en: 'Reload from disk'
	String get reload => 'Reload from disk';

	/// en: 'untagged'
	String get untagged => 'untagged';

	/// en: 'Could not save the note'
	String get saveFailed => 'Could not save the note';

	/// en: 'Could not create the note'
	String get createFailed => 'Could not create the note';

	/// en: 'add tag'
	String get addTag => 'add tag';

	/// en: 'Untitled'
	String get untitled => 'Untitled';

	/// en: 'Delete note'
	String get deleteNote => 'Delete note';

	/// en: 'Move “${name}” to the trash?'
	String deleteConfirm({required Object name}) => 'Move “${name}” to the trash?';

	/// en: 'Could not save the image'
	String get imageFailed => 'Could not save the image';

	late final Translations$gsh$notebook$format$en format = Translations$gsh$notebook$format$en.internal(_root);

	/// en: 'Linked from'
	String get backlinks => 'Linked from';

	/// en: 'Rename tag'
	String get renameTag => 'Rename tag';

	/// en: 'Delete tag'
	String get deleteTag => 'Delete tag';

	/// en: 'Remove “${name}” from ${count} notes? The notes stay.'
	String deleteTagConfirm({required Object name, required Object count}) => 'Remove “${name}” from ${count} notes? The notes stay.';

	/// en: 'Show notes list'
	String get showList => 'Show notes list';

	/// en: 'Hide notes list'
	String get hideList => 'Hide notes list';
}

// Path: gsh.layoutPreview
class Translations$gsh$layoutPreview$en {
	Translations$gsh$layoutPreview$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Could not apply the layout'
	String get applyFailedTitle => 'Could not apply the layout';

	/// en: 'Apply in GSH Desktop'
	String get applyInGsh => 'Apply in GSH Desktop';

	/// en: 'Open as new workspace'
	String get applyNewWorkspace => 'Open as new workspace';

	/// en: 'Apply to ${workspace}'
	String applyTo({required Object workspace}) => 'Apply to ${workspace}';

	/// en: 'autorun: worktree. This layout is also applied on its own when you create a worktree of the workspace that holds it.'
	String get autorunWorktree => 'autorun: worktree. This layout is also applied on its own when you create a worktree of the workspace that holds it.';

	/// en: 'Command'
	String get command => 'Command';

	/// en: 'Folder'
	String get folder => 'Folder';

	/// en: 'no command, opens a shell'
	String get noCommand => 'no command, opens a shell';

	/// en: 'Replace layout'
	String get replaceConfirm => 'Replace layout';

	/// en: '${n} open tabs of this workspace will be closed, including any running work.'
	String replaceMessage({required Object n}) => '${n} open tabs of this workspace will be closed, including any running work.';

	/// en: 'Replace the layout of ${workspace}?'
	String replaceTitle({required Object workspace}) => 'Replace the layout of ${workspace}?';

	/// en: 'Not created on this system'
	String get skippedTitle => 'Not created on this system';

	/// en: 'split down'
	String get splitDown => 'split down';

	/// en: 'split right'
	String get splitRight => 'split right';

	/// en: 'tab'
	String get splitTab => 'tab';

	/// en: 'This layout opens ${n} terminals. Read the commands before applying.'
	String subtitle({required Object n}) => 'This layout opens ${n} terminals. Read the commands before applying.';
}

// Path: gsh.telemetry
class Translations$gsh$telemetry$en {
	Translations$gsh$telemetry$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Telemetry'
	String get tooltip => 'Telemetry';

	/// en: 'Telemetry'
	String get title => 'Telemetry';

	/// en: '${n} live'
	String liveRuns({required Object n}) => '${n} live';

	/// en: 'Open a workspace to see its telemetry.'
	String get noWorkspace => 'Open a workspace to see its telemetry.';

	/// en: 'Nothing here yet.'
	String get empty => 'Nothing here yet.';

	/// en: 'Nothing here yet.'
	String get emptyFiltered => 'Nothing here yet.';

	/// en: 'Filter cases'
	String get searchHint => 'Filter cases';

	/// en: 'Open'
	String get chipOpen => 'Open';

	/// en: 'New'
	String get chipNew => 'New';

	/// en: 'Resolved'
	String get chipResolved => 'Resolved';

	/// en: 'Ignored'
	String get chipIgnored => 'Ignored';

	/// en: 'Warnings'
	String get chipWarnings => 'Warnings';

	/// en: 'new'
	String get tagNew => 'new';

	/// en: 'regression'
	String get tagRegression => 'regression';

	/// en: 'resolved'
	String get tagResolved => 'resolved';

	/// en: 'ignored'
	String get tagIgnored => 'ignored';

	/// en: 'task'
	String get srcTask => 'task';

	/// en: 'gsh telemetry'
	String get srcWrapper => 'gsh telemetry';

	/// en: 'run ${id}'
	String run({required Object id}) => 'run ${id}';

	/// en: 'Mark resolved'
	String get resolve => 'Mark resolved';

	/// en: 'Ignore (hide from agents too)'
	String get ignore => 'Ignore (hide from agents too)';

	/// en: 'Reopen'
	String get reopen => 'Reopen';

	/// en: 'Clear occurrences'
	String get clear => 'Clear occurrences';

	/// en: 'Clear this run'
	String get clearRun => 'Clear this run';

	/// en: 'Clear project'
	String get clearProject => 'Clear project';

	/// en: 'Open ${location}'
	String openFile({required Object location}) => 'Open ${location}';

	/// en: 'Show in terminal'
	String get showInTerminal => 'Show in terminal';

	/// en: 'Copy CLI command'
	String get copyCommand => 'Copy CLI command';

	/// en: 'Copied'
	String get copied => 'Copied';

	/// en: 'Open'
	String get statusOpen => 'Open';

	/// en: 'Resolved'
	String get statusResolved => 'Resolved';

	/// en: 'Ignored'
	String get statusIgnored => 'Ignored';

	/// en: 'Occurrences'
	String get occurrences => 'Occurrences';

	/// en: 'in ${n} runs'
	String inRuns({required Object n}) => 'in ${n} runs';

	/// en: 'First'
	String get first => 'First';

	/// en: 'Last'
	String get last => 'Last';

	/// en: 'Origin'
	String get origin => 'Origin';

	/// en: 'Stack'
	String get sectionStack => 'Stack';

	/// en: 'project frames highlighted · click opens the file'
	String get stackHint => 'project frames highlighted · click opens the file';

	/// en: 'Correlated log'
	String get sectionCorrelated => 'Correlated log';

	/// en: 'the closest JSON log before the error, same run'
	String get correlatedHint => 'the closest JSON log before the error, same run';

	/// en: 'none'
	String get none => 'none';

	/// en: 'Occurrences by run'
	String get sectionRuns => 'Occurrences by run';

	/// en: 'same key (cwd, command): this is how new and regression are computed'
	String get runsHint => 'same key (cwd, command): this is how new and regression are computed';

	/// en: 'Raw context'
	String get sectionContext => 'Raw context';

	/// en: 'terminal lines around the last occurrence'
	String get contextHint => 'terminal lines around the last occurrence';

	/// en: 'current'
	String get current => 'current';

	/// en: 'fingerprint = type + normalized message + ${location}'
	String fingerprintHint({required Object location}) => 'fingerprint = type + normalized message + ${location}';

	/// en: 'changed in working tree'
	String get blameUncommitted => 'changed in working tree';

	/// en: 'changed ${ago} (${sha})'
	String blameCommit({required Object ago, required Object sha}) => 'changed ${ago} (${sha})';

	/// en: 'just now'
	String get justNow => 'just now';

	/// en: '${n}m ago'
	String minutesAgo({required Object n}) => '${n}m ago';

	/// en: '${n}h ago'
	String hoursAgo({required Object n}) => '${n}h ago';

	/// en: '${n}d ago'
	String daysAgo({required Object n}) => '${n}d ago';

	/// en: 'Resolved. If it comes back in a later run it reappears as a regression.'
	String get resolvedToast => 'Resolved. If it comes back in a later run it reappears as a regression.';

	/// en: 'Ignored. Agents no longer see it (unless --include-ignored).'
	String get ignoredToast => 'Ignored. Agents no longer see it (unless --include-ignored).';

	/// en: 'Occurrences deleted. Triage rules are kept.'
	String get clearedToast => 'Occurrences deleted. Triage rules are kept.';

	/// en: 'by you'
	String get byHuman => 'by you';

	/// en: 'by agent'
	String get byAgent => 'by agent';

	/// en: '${type} · ${file}'
	String caseTabTitle({required Object type, required Object file}) => '${type} · ${file}';

	/// en: 'App'
	String get srcApp => 'App';

	/// en: 'GSH Desktop'
	String get chipApp => 'GSH Desktop';
}

// Path: gsh.panelView
class Translations$gsh$panelView$en {
	Translations$gsh$panelView$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Panels need the embedded web view, which is not available on Linux yet.'
	String get unavailable => 'Panels need the embedded web view, which is not available on Linux yet.';

	/// en: 'Open in browser'
	String get openInBrowser => 'Open in browser';

	/// en: 'Open as HTML'
	String get openAsHtml => 'Open as HTML';
}

// Path: gsh.chat
class Translations$gsh$chat$en {
	Translations$gsh$chat$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Chat'
	String get tabTitle => 'Chat';

	/// en: 'New conversation'
	String get emptyTitle => 'New conversation';

	/// en: 'Claude Code in ${folder}, with your own login.'
	String emptySubtitle({required Object folder}) => 'Claude Code in ${folder}, with your own login.';

	/// en: 'Enter sends; Shift+Enter adds a line.'
	String get emptyHintSend => 'Enter sends; Shift+Enter adds a line.';

	/// en: 'Paste a screenshot with Ctrl+V, or drop files onto the chat.'
	String get emptyHintPaste => 'Paste a screenshot with Ctrl+V, or drop files onto the chat.';

	/// en: 'Pick the permission mode below the input: ask, accept edits, plan, or bypass.'
	String get emptyHintMode => 'Pick the permission mode below the input: ask, accept edits, plan, or bypass.';

	/// en: 'Message Claude… (Enter sends, Shift+Enter for a new line)'
	String get placeholder => 'Message Claude… (Enter sends, Shift+Enter for a new line)';

	/// en: 'Send'
	String get send => 'Send';

	/// en: 'Stop'
	String get stop => 'Stop';

	/// en: 'working…'
	String get working => 'working…';

	/// en: 'waiting for you'
	String get waitingYou => 'waiting for you';

	/// en: 'cost US$ ${v}'
	String cost({required Object v}) => 'cost US\$ ${v}';

	/// en: 'Allow ${tool}?'
	String askPermission({required Object tool}) => 'Allow ${tool}?';

	/// en: 'Allow'
	String get allow => 'Allow';

	/// en: 'Deny'
	String get deny => 'Deny';

	/// en: 'Allowed'
	String get allowed => 'Allowed';

	/// en: 'Denied'
	String get denied => 'Denied';

	/// en: 'Couldn't start claude: ${detail}'
	String startFailed({required Object detail}) => 'Couldn\'t start claude: ${detail}';

	/// en: 'claude exited (code ${code}).'
	String engineExited({required Object code}) => 'claude exited (code ${code}).';

	/// en: 'The turn ended with an error: ${detail}'
	String turnFailed({required Object detail}) => 'The turn ended with an error: ${detail}';

	/// en: 'This conversation continues in a terminal with Remote Control: open it on your phone or at claude.ai/code. The chat here is paused.'
	String get handedOff => 'This conversation continues in a terminal with Remote Control: open it on your phone or at claude.ai/code. The chat here is paused.';

	/// en: 'Message from ${name}'
	String peerMessageFrom({required Object name}) => 'Message from ${name}';

	/// en: 'Sessions'
	String get sessions => 'Sessions';

	/// en: 'No other Claude Code session is running right now.'
	String get noSessions => 'No other Claude Code session is running right now.';

	/// en: 'List every session (asks the agent)…'
	String get listAllSessions => 'List every session (asks the agent)…';

	/// en: 'List the sessions I can message, with ListAgents, and wait for me to pick one. '
	String get askListSessions => 'List the sessions I can message, with ListAgents, and wait for me to pick one. ';

	/// en: 'Send this message to the session "${name}" with SendMessage and wait for its reply: '
	String sendToSession({required Object name}) => 'Send this message to the session "${name}" with SendMessage and wait for its reply: ';

	/// en: 'Remote Control'
	String get remoteControl => 'Remote Control';

	/// en: 'Continue this conversation in a terminal with Remote Control (phone, claude.ai/code). The chat's engine doesn't support Remote Control.'
	String get remoteControlHint => 'Continue this conversation in a terminal with Remote Control (phone, claude.ai/code). The chat\'s engine doesn\'t support Remote Control.';

	/// en: 'Usage'
	String get usage => 'Usage';

	/// en: 'Context: ${used} of ${window}'
	String usageContext({required Object used, required Object window}) => 'Context: ${used} of ${window}';

	/// en: 'Context: shows up after the first reply'
	String get usageContextNone => 'Context: shows up after the first reply';

	/// en: 'Session (5 h)'
	String get usageSession => 'Session (5 h)';

	/// en: 'Week'
	String get usageWeek => 'Week';

	/// en: '${model} this week'
	String usageModelWeek({required Object model}) => '${model} this week';

	/// en: 'resets at ${time}'
	String usageResetsToday({required Object time}) => 'resets at ${time}';

	/// en: 'resets ${date} at ${time}'
	String usageResetsOn({required Object date, required Object time}) => 'resets ${date} at ${time}';

	/// en: 'Plan usage unavailable right now.'
	String get usageUnavailable => 'Plan usage unavailable right now.';

	/// en: 'Resume conversation'
	String get resume => 'Resume conversation';

	/// en: 'Open a recent Claude Code conversation from this machine in a new tab, with its history.'
	String get resumeHint => 'Open a recent Claude Code conversation from this machine in a new tab, with its history.';

	/// en: 'Resume a conversation'
	String get resumeEmpty => 'Resume a conversation';

	/// en: 'No conversations in the last 7 days.'
	String get resumeNone => 'No conversations in the last 7 days.';

	/// en: 'Is this conversation open somewhere else?'
	String get resumeLiveTitle => 'Is this conversation open somewhere else?';

	/// en: 'It changed ${ago}. If it is still open (Claude Desktop, a terminal), continuing here makes both write to the same conversation. Close it there first.'
	String resumeLiveBody({required Object ago}) => 'It changed ${ago}. If it is still open (Claude Desktop, a terminal), continuing here makes both write to the same conversation. Close it there first.';

	/// en: 'Open anyway'
	String get resumeAnyway => 'Open anyway';

	/// en: 'This conversation is already on Remote Control: continue on your phone or at ${url}'
	String remoteControlActive({required Object url}) => 'This conversation is already on Remote Control: continue on your phone or at ${url}';

	/// en: 'Send a message first: Remote Control continues an existing conversation.'
	String get remoteControlNoSession => 'Send a message first: Remote Control continues an existing conversation.';

	/// en: 'Wait for the agent to finish this turn, then try again.'
	String get remoteControlBusy => 'Wait for the agent to finish this turn, then try again.';

	/// en: 'Couldn't open the terminal in this workspace.'
	String get remoteControlFailed => 'Couldn\'t open the terminal in this workspace.';

	/// en: '${name} is too large to send (images up to 5 MB, PDFs up to 32 MB).'
	String attachmentTooLarge({required Object name}) => '${name} is too large to send (images up to 5 MB, PDFs up to 32 MB).';

	/// en: 'Loading the conversation…'
	String get loadingHistory => 'Loading the conversation…';

	/// en: 'Always allow ${rule}'
	String allowAlways({required Object rule}) => 'Always allow ${rule}';

	/// en: 'Always allowed: ${rule}'
	String allowedAlways({required Object rule}) => 'Always allowed: ${rule}';

	/// en: '… ${n} more lines'
	String moreLines({required Object n}) => '… ${n} more lines';

	/// en: 'The agent is asking'
	String get questionTitle => 'The agent is asking';

	/// en: 'Other…'
	String get other => 'Other…';

	/// en: 'Answer'
	String get answer => 'Answer';

	/// en: 'Agent's plan'
	String get planTitle => 'Agent\'s plan';

	/// en: 'Approve and run'
	String get planApprove => 'Approve and run';

	/// en: 'Keep planning'
	String get planRefine => 'Keep planning';

	/// en: 'What should change in the plan?'
	String get planRefineHint => 'What should change in the plan?';

	/// en: 'Send adjustment'
	String get planSendRefine => 'Send adjustment';

	/// en: 'Plan approved'
	String get planApproved => 'Plan approved';

	/// en: 'Asked to keep planning'
	String get planRefined => 'Asked to keep planning';

	/// en: 'Adjustment: ${text}'
	String planRefinedWith({required Object text}) => 'Adjustment: ${text}';

	/// en: 'New conversation'
	String get newChat => 'New conversation';

	/// en: 'Attach files'
	String get attach => 'Attach files';

	/// en: 'Ask permission'
	String get modeDefault => 'Ask permission';

	/// en: 'Accept edits'
	String get modeAcceptEdits => 'Accept edits';

	/// en: 'Plan'
	String get modePlan => 'Plan';

	/// en: 'Skip permissions'
	String get modeBypass => 'Skip permissions';

	/// en: '(one) {Edited 1 file} (other) {Edited ${n} files}'
	String editedFiles({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: 'Edited 1 file',
		other: 'Edited ${n} files',
	);

	/// en: 'Thinking'
	String get thinkingTitle => 'Thinking';

	/// en: 'Thinking…'
	String get thinkingLive => 'Thinking…';

	/// en: 'Completed'
	String get stateCompleted => 'Completed';

	/// en: 'Ready for review'
	String get stateReviewReady => 'Ready for review';

	/// en: 'Blocked'
	String get stateBlocked => 'Blocked';

	/// en: 'Failed'
	String get stateFailed => 'Failed';

	/// en: 'Copy'
	String get copyMessage => 'Copy';

	/// en: 'Copied'
	String get copiedMessage => 'Copied';

	late final Translations$gsh$chat$effort$en effort = Translations$gsh$chat$effort$en.internal(_root);
}

// Path: gsh.harness
class Translations$gsh$harness$en {
	Translations$gsh$harness$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Harness'
	String get tabTitle => 'Harness';

	/// en: 'What the agent loads when it runs in ${path}'
	String subtitle({required Object path}) => 'What the agent loads when it runs in ${path}';

	/// en: 'Read again'
	String get refresh => 'Read again';

	/// en: 'Instructions'
	String get memory => 'Instructions';

	/// en: 'CLAUDE.md files a session here reads (from this folder up), your user one, and AGENTS.md (Codex).'
	String get memoryDesc => 'CLAUDE.md files a session here reads (from this folder up), your user one, and AGENTS.md (Codex).';

	/// en: 'Create CLAUDE.md'
	String get memoryNew => 'Create CLAUDE.md';

	/// en: 'Skills'
	String get skills => 'Skills';

	/// en: 'Capabilities the agent picks up on its own when the description matches the task.'
	String get skillsDesc => 'Capabilities the agent picks up on its own when the description matches the task.';

	/// en: 'Subagents'
	String get agents => 'Subagents';

	/// en: 'Specialists the agent delegates to (with their own tools and model).'
	String get agentsDesc => 'Specialists the agent delegates to (with their own tools and model).';

	/// en: 'Commands'
	String get commands => 'Commands';

	/// en: '/name shortcuts you type in the session.'
	String get commandsDesc => '/name shortcuts you type in the session.';

	/// en: 'Hooks'
	String get hooks => 'Hooks';

	/// en: 'Commands that run on session events (before a tool, on stop...).'
	String get hooksDesc => 'Commands that run on session events (before a tool, on stop...).';

	/// en: 'Permissions'
	String get permissions => 'Permissions';

	/// en: 'Tool rules: allow, ask or block.'
	String get permissionsDesc => 'Tool rules: allow, ask or block.';

	/// en: 'MCP'
	String get mcp => 'MCP';

	/// en: 'Extra tool servers. User and local ones come from ~/.claude.json (change them with claude mcp).'
	String get mcpDesc => 'Extra tool servers. User and local ones come from ~/.claude.json (change them with claude mcp).';

	/// en: 'New'
	String get newItem => 'New';

	/// en: 'Edit file'
	String get editFile => 'Edit file';

	/// en: 'New item in ${section}'
	String newTitle({required Object section}) => 'New item in ${section}';

	/// en: 'Create'
	String get create => 'Create';

	/// en: 'name (becomes the file name)'
	String get namePlaceholder => 'name (becomes the file name)';

	/// en: 'Nothing here yet.'
	String get empty => 'Nothing here yet.';

	/// en: 'User'
	String get scopeUser => 'User';

	/// en: 'Project'
	String get scopeProject => 'Project';

	/// en: 'Local'
	String get scopeLocal => 'Local';

	/// en: 'allow'
	String get allow => 'allow';

	/// en: 'ask'
	String get ask => 'ask';

	/// en: 'block'
	String get deny => 'block';

	/// en: 'Read-only here: use claude mcp add/remove'
	String get readOnly => 'Read-only here: use claude mcp add/remove';

	/// en: 'Fixed cost per turn'
	String get costTitle => 'Fixed cost per turn';

	/// en: '≈ ${tokens} tokens'
	String costValue({required Object tokens}) => '≈ ${tokens} tokens';

	/// en: 'What goes into the context on every message, before any work: the full instructions and each skill, subagent and command's name + description. MCP tools aren't counted.'
	String get costHint => 'What goes into the context on every message, before any work: the full instructions and each skill, subagent and command\'s name + description. MCP tools aren\'t counted.';

	/// en: 'To trim it: what only matters sometimes leaves CLAUDE.md and becomes a skill; delete skills and commands nobody uses.'
	String get costTip => 'To trim it: what only matters sometimes leaves CLAUDE.md and becomes a skill; delete skills and commands nobody uses.';

	/// en: '≈ ${tokens}/turn'
	String perTurn({required Object tokens}) => '≈ ${tokens}/turn';

	/// en: 'Warnings: ${n}'
	String issues({required Object n}) => 'Warnings: ${n}';

	/// en: 'No description: the agent doesn't know when to use it.'
	String get issueNoDescription => 'No description: the agent doesn\'t know when to use it.';

	/// en: 'The script this hook runs doesn't exist.'
	String get issueMissingScript => 'The script this hook runs doesn\'t exist.';

	/// en: 'Too large: it weighs on every message (Claude Code warns above 40k characters).'
	String get issueTooLarge => 'Too large: it weighs on every message (Claude Code warns above 40k characters).';

	/// en: '${file}: invalid JSON — Claude Code ignores this whole file.'
	String invalidJson({required Object file}) => '${file}: invalid JSON — Claude Code ignores this whole file.';

	/// en: 'Show all (${n})'
	String showAll({required Object n}) => 'Show all (${n})';

	/// en: 'Show less'
	String get showLess => 'Show less';
}

// Path: gsh.farm
class Translations$gsh$farm$en {
	Translations$gsh$farm$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Farm'
	String get tabTitle => 'Farm';

	/// en: 'Agent farm'
	String get title => 'Agent farm';

	/// en: 'No agents running'
	String get emptyTitle => 'No agents running';

	/// en: 'Every Claude Code loop on this machine shows up here while it works, including subagents and sessions outside GSH Desktop.'
	String get emptyHint => 'Every Claude Code loop on this machine shows up here while it works, including subagents and sessions outside GSH Desktop.';

	/// en: '${n} working'
	String working({required Object n}) => '${n} working';

	/// en: '${n} need you'
	String waiting({required Object n}) => '${n} need you';

	/// en: '1 needs you'
	String get waitingOne => '1 needs you';

	/// en: '${n} idle'
	String idle({required Object n}) => '${n} idle';

	/// en: 'Knocking on your door'
	String get doorTitle => 'Knocking on your door';

	/// en: '${name} (agent ${agent}) wants to talk to your agent ${target}'
	String doorMessage({required Object name, required Object agent, required Object target}) => '${name} (agent ${agent}) wants to talk to your agent ${target}';

	/// en: '${name} (agent ${agent}) wants to hand ${file} to your agent ${target}'
	String doorFile({required Object name, required Object agent, required Object file, required Object target}) => '${name} (agent ${agent}) wants to hand ${file} to your agent ${target}';

	/// en: 'Open the door'
	String get doorOpen => 'Open the door';

	/// en: 'Refuse'
	String get doorRefuse => 'Refuse';

	/// en: '${name}'s'
	String peerOf({required Object name}) => '${name}\'s';

	/// en: '${name}'s farm'
	String peerBanner({required Object name}) => '${name}\'s farm';

	/// en: 'Spent ${total} tokens'
	String spent({required Object total}) => 'Spent ${total} tokens';

	/// en: '${input} input · ${cache} cache · ${out} out'
	String spentDetail({required Object input, required Object cache, required Object out}) => '${input} input · ${cache} cache · ${out} out';

	/// en: 'context ${ctx} of ${window} (${pct}%)'
	String context({required Object ctx, required Object window, required Object pct}) => 'context ${ctx} of ${window} (${pct}%)';

	/// en: '${n} tokens spent'
	String spentHud({required Object n}) => '${n} tokens spent';

	/// en: 'Click to open its terminal'
	String get clickToOpen => 'Click to open its terminal';

	/// en: 'This agent is running outside GSH Desktop. Its terminal is in another window.'
	String get outsideGsh => 'This agent is running outside GSH Desktop. Its terminal is in another window.';

	/// en: '${n} agents'
	String agents({required Object n}) => '${n} agents';

	/// en: '${n} sub-agents'
	String subagents({required Object n}) => '${n} sub-agents';

	late final Translations$gsh$farm$activity$en activity = Translations$gsh$farm$activity$en.internal(_root);

	/// en: 'teammate of ${lead}'
	String teammateOf({required Object lead}) => 'teammate of ${lead}';

	/// en: 'leads a team of ${n}'
	String teamLead({required Object n}) => 'leads a team of ${n}';

	/// en: 'Reset plot positions'
	String get resetPlots => 'Reset plot positions';

	/// en: 'You'
	String get you => 'You';
}

// Path: gsh.agentGraph
class Translations$gsh$agentGraph$en {
	Translations$gsh$agentGraph$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Agents'
	String get tabTitle => 'Agents';

	/// en: 'New agent'
	String get newAgent => 'New agent';

	/// en: 'No agents in this workspace'
	String get emptyTitle => 'No agents in this workspace';

	/// en: 'Start an agent in a terminal or create one here. Drag from an agent's port to another agent to connect them.'
	String get emptyHint => 'Start an agent in a terminal or create one here. Drag from an agent\'s port to another agent to connect them.';

	/// en: 'Working'
	String get statusWorking => 'Working';

	/// en: 'Waiting'
	String get statusWaiting => 'Waiting';

	/// en: 'Idle'
	String get statusIdle => 'Idle';

	/// en: 'Messages: ${n}'
	String messageCount({required Object n}) => 'Messages: ${n}';

	/// en: 'Last: ${preview}'
	String lastMessage({required Object preview}) => 'Last: ${preview}';

	/// en: 'Connected'
	String get linked => 'Connected';

	/// en: 'Right-click to remove the connection'
	String get removeLinkHint => 'Right-click to remove the connection';

	/// en: 'Remove connection'
	String get removeLink => 'Remove connection';

	/// en: 'Drag to another agent to connect'
	String get connectHint => 'Drag to another agent to connect';

	/// en: 'Quick start'
	String get quickStart => 'Quick start';

	/// en: 'Shell'
	String get shell => 'Shell';

	/// en: 'Details'
	String get tabDetails => 'Details';

	/// en: 'Appearance'
	String get tabAppearance => 'Appearance';

	/// en: 'Agent'
	String get tabAgent => 'Agent';

	/// en: 'Terminal name'
	String get name => 'Terminal name';

	/// en: 'e.g. Reviewer'
	String get namePlaceholder => 'e.g. Reviewer';

	/// en: 'Another tab already uses this name. Names must be unique so `gsh msg --to` can reach it.'
	String get nameTaken => 'Another tab already uses this name. Names must be unique so `gsh msg --to` can reach it.';

	/// en: 'Command'
	String get command => 'Command';

	/// en: 'e.g. claude --model opus (empty = shell)'
	String get commandPlaceholder => 'e.g. claude --model opus (empty = shell)';

	/// en: 'Working directory'
	String get cwd => 'Working directory';

	/// en: 'Browse…'
	String get browse => 'Browse…';

	/// en: 'This folder does not exist.'
	String get cwdMissing => 'This folder does not exist.';

	/// en: 'Monitor activity'
	String get monitor => 'Monitor activity';

	/// en: 'Badge, sound and notification when a turn ends.'
	String get monitorHint => 'Badge, sound and notification when a turn ends.';

	/// en: 'Maestro'
	String get maestro => 'Maestro';

	/// en: 'Promotes this agent to maestro: it is connected to every agent on the canvas and coordinates them.'
	String get maestroTooltip => 'Promotes this agent to maestro: it is connected to every agent on the canvas and coordinates them.';

	/// en: '${name} is the current maestro and will be demoted.'
	String maestroReplaces({required Object name}) => '${name} is the current maestro and will be demoted.';

	/// en: 'Color'
	String get color => 'Color';

	/// en: 'Automatic'
	String get colorAuto => 'Automatic';

	/// en: 'Role / instructions'
	String get role => 'Role / instructions';

	/// en: 'Sent as its first message once the agent is ready.'
	String get rolePlaceholder => 'Sent as its first message once the agent is ready.';

	/// en: 'Initial task'
	String get task => 'Initial task';

	/// en: 'Sent right after the role.'
	String get taskPlaceholder => 'Sent right after the role.';

	/// en: 'Focus'
	String get focus => 'Focus';

	/// en: 'Rename'
	String get rename => 'Rename';

	/// en: 'Rename agent'
	String get renameTitle => 'Rename agent';

	/// en: 'Make maestro'
	String get makeMaestro => 'Make maestro';

	/// en: 'Remove maestro'
	String get removeMaestro => 'Remove maestro';

	/// en: 'Close tab'
	String get closeTab => 'Close tab';

	/// en: 'Remove from canvas'
	String get removeFromCanvas => 'Remove from canvas';

	/// en: 'Desktop apps'
	String get desktopApps => 'Desktop apps';

	/// en: 'desktop'
	String get desktopBadge => 'desktop';

	/// en: 'Online'
	String get statusOnline => 'Online';

	/// en: 'Offline'
	String get statusOffline => 'Offline';

	/// en: '${n} queued'
	String queued({required Object n}) => '${n} queued';

	/// en: 'Name'
	String get agentName => 'Name';

	/// en: 'Integration'
	String get integration => 'Integration';

	/// en: 'GSH Desktop adds an MCP server named "gsh" to this file and saves a backup next to it. Other servers are not touched.'
	String get integrationHint => 'GSH Desktop adds an MCP server named "gsh" to this file and saves a backup next to it. Other servers are not touched.';

	/// en: 'Add the GSH Desktop MCP server to ${app}'s config'
	String integrationConsent({required Object app}) => 'Add the GSH Desktop MCP server to ${app}\'s config';

	/// en: 'Restart ${app} if it was already open so it loads the GSH Desktop MCP server; then ask it to call wait_messages.'
	String restartHint({required Object app}) => 'Restart ${app} if it was already open so it loads the GSH Desktop MCP server; then ask it to call wait_messages.';

	late final Translations$gsh$agentGraph$integrationError$en integrationError = Translations$gsh$agentGraph$integrationError$en.internal(_root);
}

// Path: settings.language
class Translations$settings$language$en {
	Translations$settings$language$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get title => 'Language';

	/// en: 'System'
	String get system => 'System';

	/// en: 'English'
	String get english => 'English';

	/// en: 'Português (BR)'
	String get portugueseBr => 'Português (BR)';

	/// en: 'Español'
	String get spanish => 'Español';
}

// Path: settings.page
class Translations$settings$page$en {
	Translations$settings$page$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$settings$page$header$en header = Translations$settings$page$header$en.internal(_root);
	late final Translations$settings$page$nav$en nav = Translations$settings$page$nav$en.internal(_root);
	late final Translations$settings$page$general$en general = Translations$settings$page$general$en.internal(_root);
	late final Translations$settings$page$diagnostics$en diagnostics = Translations$settings$page$diagnostics$en.internal(_root);
	late final Translations$settings$page$storage$en storage = Translations$settings$page$storage$en.internal(_root);
	late final Translations$settings$page$terminal$en terminal = Translations$settings$page$terminal$en.internal(_root);
	late final Translations$settings$page$appearance$en appearance = Translations$settings$page$appearance$en.internal(_root);
	late final Translations$settings$page$notifications$en notifications = Translations$settings$page$notifications$en.internal(_root);
	late final Translations$settings$page$shortcuts$en shortcuts = Translations$settings$page$shortcuts$en.internal(_root);
	late final Translations$settings$page$languages$en languages = Translations$settings$page$languages$en.internal(_root);
	late final Translations$settings$page$automations$en automations = Translations$settings$page$automations$en.internal(_root);
	late final Translations$settings$page$claudeCode$en claudeCode = Translations$settings$page$claudeCode$en.internal(_root);
	late final Translations$settings$page$placeholder$en placeholder = Translations$settings$page$placeholder$en.internal(_root);
	late final Translations$settings$page$claude$en claude = Translations$settings$page$claude$en.internal(_root);
	late final Translations$settings$page$account$en account = Translations$settings$page$account$en.internal(_root);
	late final Translations$settings$page$usage$en usage = Translations$settings$page$usage$en.internal(_root);
	late final Translations$settings$page$memory$en memory = Translations$settings$page$memory$en.internal(_root);
	late final Translations$settings$page$skills$en skills = Translations$settings$page$skills$en.internal(_root);
	late final Translations$settings$page$connectors$en connectors = Translations$settings$page$connectors$en.internal(_root);
	late final Translations$settings$page$plugins$en plugins = Translations$settings$page$plugins$en.internal(_root);
	late final Translations$settings$page$developer$en developer = Translations$settings$page$developer$en.internal(_root);
	late final Translations$settings$page$system$en system = Translations$settings$page$system$en.internal(_root);
	late final Translations$settings$page$catalog$en catalog = Translations$settings$page$catalog$en.internal(_root);
	late final Translations$settings$page$generalClaude$en generalClaude = Translations$settings$page$generalClaude$en.internal(_root);
	late final Translations$settings$page$privacy$en privacy = Translations$settings$page$privacy$en.internal(_root);
	late final Translations$settings$page$resources$en resources = Translations$settings$page$resources$en.internal(_root);
	late final Translations$settings$page$designSystems$en designSystems = Translations$settings$page$designSystems$en.internal(_root);
}

// Path: settings.remoteHosts
class Translations$settings$remoteHosts$en {
	Translations$settings$remoteHosts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Remote hosts'
	String get title => 'Remote hosts';

	/// en: 'Machines you reach over SSH. Adding a host here is the same as adding one from the workspace "+" menu.'
	String get description => 'Machines you reach over SSH. Adding a host here is the same as adding one from the workspace "+" menu.';

	/// en: 'No remote hosts yet.'
	String get empty => 'No remote hosts yet.';

	/// en: 'Add host'
	String get add => 'Add host';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Reconnect'
	String get reconnect => 'Reconnect';

	/// en: 'Remove'
	String get remove => 'Remove';

	/// en: 'Remove host'
	String get removeTitle => 'Remove host';

	/// en: 'Remove "${name}" and all its workspaces? Nothing is deleted on the host itself.'
	String removeMessage({required Object name}) => 'Remove "${name}" and all its workspaces? Nothing is deleted on the host itself.';

	/// en: '${count} workspace(s)'
	String workspacesCount({required Object count}) => '${count} workspace(s)';

	/// en: 'This device's key'
	String get deviceKeyTitle => 'This device\'s key';

	/// en: 'Add this public key to ~/.ssh/authorized_keys on the host so this device can connect.'
	String get deviceKeyDesc => 'Add this public key to ~/.ssh/authorized_keys on the host so this device can connect.';

	/// en: 'Copy public key'
	String get deviceKeyCopy => 'Copy public key';

	/// en: 'Public key copied'
	String get deviceKeyCopied => 'Public key copied';

	/// en: 'Connected'
	String get statusConnected => 'Connected';

	/// en: 'Connecting…'
	String get statusConnecting => 'Connecting…';

	/// en: 'Reconnecting…'
	String get statusReconnecting => 'Reconnecting…';

	/// en: 'Offline'
	String get statusOffline => 'Offline';

	/// en: 'Not connected'
	String get statusIdle => 'Not connected';

	/// en: 'How it works'
	String get helpTitle => 'How it works';

	/// en: 'GSH Desktop connects to your machine over SSH and talks to a small server that runs the terminals, files and git there. The host must have GSH Desktop (desktop) or the gsh-server installed and running, and this device’s public key added to its ~/.ssh/authorized_keys.'
	String get helpBody => 'GSH Desktop connects to your machine over SSH and talks to a small server that runs the terminals, files and git there. The host must have GSH Desktop (desktop) or the gsh-server installed and running, and this device’s public key added to its ~/.ssh/authorized_keys.';
}

// Path: automation.error
class Translations$automation$error$en {
	Translations$automation$error$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '${harness} is not installed or is not on PATH.'
	String unavailable({required Object harness}) => '${harness} is not installed or is not on PATH.';

	/// en: 'Model "${model}" is not available for ${harness}. Choose another model in Settings.'
	String modelUnavailable({required Object model, required Object harness}) => 'Model "${model}" is not available for ${harness}. Choose another model in Settings.';

	/// en: '${harness}: ${detail}'
	String authentication({required Object harness, required Object detail}) => '${harness}: ${detail}';

	/// en: '${harness} did not respond within ${seconds} seconds.'
	String timeout({required Object harness, required Object seconds}) => '${harness} did not respond within ${seconds} seconds.';

	/// en: 'Commit message generation was cancelled.'
	String get cancelled => 'Commit message generation was cancelled.';

	/// en: '${harness}: ${detail}'
	String process({required Object harness, required Object detail}) => '${harness}: ${detail}';

	/// en: '${harness} could not generate a commit message.'
	String processNoDetail({required Object harness}) => '${harness} could not generate a commit message.';

	/// en: 'The automation returned an empty commit message.'
	String get invalidResponse => 'The automation returned an empty commit message.';

	/// en: 'Another commit message is already being generated.'
	String get busy => 'Another commit message is already being generated.';

	/// en: 'The automation could not generate a commit message.'
	String get unknown => 'The automation could not generate a commit message.';

	/// en: 'No workspace selected.'
	String get noWorkspace => 'No workspace selected.';

	/// en: 'File is outside the workspace roots.'
	String get fileOutsideWorkspace => 'File is outside the workspace roots.';

	/// en: 'Could not read the file: ${detail}'
	String fileUnreadable({required Object detail}) => 'Could not read the file: ${detail}';

	/// en: 'A commit message cannot be generated for a binary file.'
	String get binaryFile => 'A commit message cannot be generated for a binary file.';

	/// en: 'There are no changes to describe for this file.'
	String get noFileChanges => 'There are no changes to describe for this file.';

	/// en: 'There are no staged changes to describe.'
	String get noStagedChanges => 'There are no staged changes to describe.';

	/// en: 'Staged changes belong to multiple repositories. Generate them separately.'
	String get multipleRepositories => 'Staged changes belong to multiple repositories. Generate them separately.';

	/// en: 'Could not read the diff.'
	String get diffUnavailable => 'Could not read the diff.';

	/// en: 'Configure a commit message harness in Settings.'
	String get notConfigured => 'Configure a commit message harness in Settings.';
}

// Path: fileOperation.error
class Translations$fileOperation$error$en {
	Translations$fileOperation$error$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Already exists: “${name}”.'
	String alreadyExists({required Object name}) => 'Already exists: “${name}”.';

	/// en: 'Not found: “${name}”.'
	String notFound({required Object name}) => 'Not found: “${name}”.';

	/// en: 'Invalid path.'
	String get invalidPath => 'Invalid path.';

	/// en: 'The name cannot be empty.'
	String get emptyName => 'The name cannot be empty.';

	/// en: 'No workspace selected.'
	String get noWorkspace => 'No workspace selected.';

	/// en: 'Cannot move a folder into itself.'
	String get cannotMoveIntoItself => 'Cannot move a folder into itself.';

	/// en: 'Clipboard is empty.'
	String get clipboardEmpty => 'Clipboard is empty.';

	/// en: 'This tab is not a scratch file.'
	String get notScratchTab => 'This tab is not a scratch file.';

	/// en: 'Could not write the file.'
	String get writeFailed => 'Could not write the file.';

	/// en: 'Empty formatter command.'
	String get formatterEmptyCommand => 'Empty formatter command.';

	/// en: 'Formatter command must include the %FILE% placeholder.'
	String get formatterMissingPlaceholder => 'Formatter command must include the %FILE% placeholder.';

	/// en: 'Formatter timed out.'
	String get formatterTimeout => 'Formatter timed out.';

	/// en: 'Formatter exited with ${code}.'
	String formatterExitCode({required Object code}) => 'Formatter exited with ${code}.';

	/// en: 'The formatter could not run.'
	String get formatterFailed => 'The formatter could not run.';

	/// en: '${detail}'
	String osFailure({required Object detail}) => '${detail}';

	/// en: 'Name cannot contain “/”.'
	String get nameHasSlash => 'Name cannot contain “/”.';

	/// en: 'Invalid name.'
	String get invalidName => 'Invalid name.';

	/// en: 'Dropping files into a remote workspace is not supported yet.'
	String get remoteDropUnsupported => 'Dropping files into a remote workspace is not supported yet.';
}

// Path: theme.error
class Translations$theme$error$en {
	Translations$theme$error$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Could not read or write the theme file.'
	String get io => 'Could not read or write the theme file.';

	/// en: 'Could not read or write the theme file: ${detail}'
	String ioDetail({required Object detail}) => 'Could not read or write the theme file: ${detail}';

	/// en: 'This file is not valid JSON: ${detail}'
	String malformedJson({required Object detail}) => 'This file is not valid JSON: ${detail}';

	/// en: 'This file is not a valid theme.'
	String get invalidTheme => 'This file is not a valid theme.';

	/// en: 'This theme uses the id of a built-in theme. Change "id" in the file and import again.'
	String get reservedId => 'This theme uses the id of a built-in theme. Change "id" in the file and import again.';

	/// en: 'Expected an object at "${field}".'
	String notAnObject({required Object field}) => 'Expected an object at "${field}".';

	/// en: 'Missing required field "${field}".'
	String missingField({required Object field}) => 'Missing required field "${field}".';

	/// en: '"${value}" at "${field}" is not a color. Use #RGB, #RRGGBB or #RRGGBBAA.'
	String badColor({required Object value, required Object field}) => '"${value}" at "${field}" is not a color. Use #RGB, #RRGGBB or #RRGGBBAA.';

	/// en: 'Unknown base theme "${value}" in "extends".'
	String unknownBase({required Object value}) => 'Unknown base theme "${value}" in "extends".';

	/// en: 'The theme declares no variant. Add "dark", "light" or both under "variants".'
	String get noVariants => 'The theme declares no variant. Add "dark", "light" or both under "variants".';
}

// Path: gsh.httpView.error
class Translations$gsh$httpView$error$en {
	Translations$gsh$httpView$error$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Request failed'
	String get title => 'Request failed';

	/// en: 'No request found at the cursor.'
	String get noRequest => 'No request found at the cursor.';

	/// en: 'Invalid URL: ${url}'
	String invalidUrl({required Object url}) => 'Invalid URL: ${url}';

	/// en: 'Variable {{${name}}} has no value. Declare it with @${name} = … in this file.'
	String unresolvedVariable({required Object name}) => 'Variable {{${name}}} has no value. Declare it with @${name} = … in this file.';

	/// en: 'Body file not found: ${path}'
	String bodyFileMissing({required Object path}) => 'Body file not found: ${path}';

	/// en: 'Could not read the body file ${path}: ${detail}'
	String bodyFileUnreadable({required Object path, required Object detail}) => 'Could not read the body file ${path}: ${detail}';

	/// en: 'Could not reach the server: ${detail}'
	String connectionFailed({required Object detail}) => 'Could not reach the server: ${detail}';

	/// en: 'Could not reach the server.'
	String get connectionFailedNoDetail => 'Could not reach the server.';

	/// en: 'The request timed out after ${seconds}s.'
	String timeout({required Object seconds}) => 'The request timed out after ${seconds}s.';

	/// en: 'The response is larger than the ${bytes} byte limit.'
	String responseTooLarge({required Object bytes}) => 'The response is larger than the ${bytes} byte limit.';
}

// Path: gsh.kanbanView.deleteColumnDialog
class Translations$gsh$kanbanView$deleteColumnDialog$en {
	Translations$gsh$kanbanView$deleteColumnDialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete “${name}”?'
	String title({required Object name}) => 'Delete “${name}”?';

	/// en: 'This column has ${count}. Choose what happens to them.'
	String message({required Object count}) => 'This column has ${count}. Choose what happens to them.';

	/// en: 'Move to the previous column'
	String get moveCards => 'Move to the previous column';

	/// en: 'Delete with the column'
	String get deleteAll => 'Delete with the column';

	/// en: 'This column is empty.'
	String get emptyMessage => 'This column is empty.';
}

// Path: gsh.gallery.dbQuery
class Translations$gsh$gallery$dbQuery$en {
	Translations$gsh$gallery$dbQuery$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Database query'
	String get title => 'Database query';

	/// en: 'SQL editor with a result grid, using one of the registered connections.'
	String get description => 'SQL editor with a result grid, using one of the registered connections.';
}

// Path: gsh.gallery.kanban
class Translations$gsh$gallery$kanban$en {
	Translations$gsh$gallery$kanban$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Kanban board'
	String get title => 'Kanban board';

	/// en: 'Columns and cards stored as plain markdown. Drag, edit and comment.'
	String get description => 'Columns and cards stored as plain markdown. Drag, edit and comment.';
}

// Path: gsh.gallery.layout
class Translations$gsh$gallery$layout$en {
	Translations$gsh$gallery$layout$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pane layout'
	String get title => 'Pane layout';

	/// en: 'Terminals and splits to open in one go, like tmuxinator. Can run automatically on new worktrees.'
	String get description => 'Terminals and splits to open in one go, like tmuxinator. Can run automatically on new worktrees.';
}

// Path: gsh.gallery.httpRequest
class Translations$gsh$gallery$httpRequest$en {
	Translations$gsh$gallery$httpRequest$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'HTTP requests'
	String get title => 'HTTP requests';

	/// en: 'Write requests in a file and run them with the response next to it.'
	String get description => 'Write requests in a file and run them with the response next to it.';
}

// Path: gsh.gallery.html
class Translations$gsh$gallery$html$en {
	Translations$gsh$gallery$html$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'HTML view'
	String get title => 'HTML view';

	/// en: 'A page the agent writes and GSH Desktop renders directly: mind maps, diagrams, charts, whatever you need.'
	String get description => 'A page the agent writes and GSH Desktop renders directly: mind maps, diagrams, charts, whatever you need.';
}

// Path: gsh.gallery.tasks
class Translations$gsh$gallery$tasks$en {
	Translations$gsh$gallery$tasks$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tasks'
	String get title => 'Tasks';

	/// en: 'Commands to run from the Tasks panel, such as the dev server, tests and build. Stored in .gsh/tasks.json.'
	String get description => 'Commands to run from the Tasks panel, such as the dev server, tests and build. Stored in .gsh/tasks.json.';
}

// Path: gsh.gallery.notebook
class Translations$gsh$gallery$notebook$en {
	Translations$gsh$gallery$notebook$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notebook'
	String get title => 'Notebook';

	/// en: 'A folder of short notes with tags. The agent writes, you read and edit. Also opens in Obsidian.'
	String get description => 'A folder of short notes with tags. The agent writes, you read and edit. Also opens in Obsidian.';
}

// Path: gsh.gallery.workspaceEnv
class Translations$gsh$gallery$workspaceEnv$en {
	Translations$gsh$gallery$workspaceEnv$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Workspace env'
	String get title => 'Workspace env';

	/// en: 'Variables injected into every terminal of this workspace. Put API tokens or logins here instead of pasting them into the agent's prompt. Kept out of git.'
	String get description => 'Variables injected into every terminal of this workspace. Put API tokens or logins here instead of pasting them into the agent\'s prompt. Kept out of git.';
}

// Path: gsh.gallery.panel
class Translations$gsh$gallery$panel$en {
	Translations$gsh$gallery$panel$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Panel'
	String get title => 'Panel';

	/// en: 'An HTML page with a bridge to the app: its buttons run GSH Desktop CLI and shell commands on this machine. A playground for quick dashboards.'
	String get description => 'An HTML page with a bridge to the app: its buttons run GSH Desktop CLI and shell commands on this machine. A playground for quick dashboards.';
}

// Path: gsh.notebook.format
class Translations$gsh$notebook$format$en {
	Translations$gsh$notebook$format$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Bold (⌘B)'
	String get bold => 'Bold (⌘B)';

	/// en: 'Italic (⌘I)'
	String get italic => 'Italic (⌘I)';

	/// en: 'Strikethrough'
	String get strike => 'Strikethrough';

	/// en: 'Heading 1'
	String get heading1 => 'Heading 1';

	/// en: 'Heading 2'
	String get heading2 => 'Heading 2';

	/// en: 'Heading 3'
	String get heading3 => 'Heading 3';

	/// en: 'Bullet list'
	String get bullets => 'Bullet list';

	/// en: 'Numbered list'
	String get numbered => 'Numbered list';

	/// en: 'Checklist'
	String get checklist => 'Checklist';

	/// en: 'Quote'
	String get quote => 'Quote';

	/// en: 'Inline code (⌘E)'
	String get code => 'Inline code (⌘E)';

	/// en: 'Code block'
	String get codeBlock => 'Code block';

	/// en: 'Link (⌘K)'
	String get link => 'Link (⌘K)';

	/// en: 'Divider'
	String get rule => 'Divider';

	/// en: 'Link to a note ([[…]])'
	String get noteLink => 'Link to a note ([[…]])';

	/// en: 'Search notes'
	String get noteLinkSearch => 'Search notes';

	/// en: 'Insert image…'
	String get image => 'Insert image…';
}

// Path: gsh.chat.effort
class Translations$gsh$chat$effort$en {
	Translations$gsh$chat$effort$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Effort'
	String get title => 'Effort';

	/// en: 'Effort: ${level}'
	String tooltip({required Object level}) => 'Effort: ${level}';

	/// en: 'Default'
	String get auto => 'Default';

	/// en: 'Low'
	String get low => 'Low';

	/// en: 'Medium'
	String get medium => 'Medium';

	/// en: 'High'
	String get high => 'High';

	/// en: 'Extra high'
	String get xhigh => 'Extra high';

	/// en: 'Max'
	String get max => 'Max';

	/// en: 'How much the model thinks before answering. More effort = better on hard tasks, slower and more tokens.'
	String get hint => 'How much the model thinks before answering. More effort = better on hard tasks, slower and more tokens.';
}

// Path: gsh.farm.activity
class Translations$gsh$farm$activity$en {
	Translations$gsh$farm$activity$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'thinking'
	String get thinking => 'thinking';

	/// en: 'reading'
	String get reading => 'reading';

	/// en: 'editing'
	String get editing => 'editing';

	/// en: 'running a command'
	String get running => 'running a command';

	/// en: 'searching the web'
	String get searching => 'searching the web';

	/// en: 'delegating'
	String get delegating => 'delegating';

	/// en: 'using a tool'
	String get tooling => 'using a tool';

	/// en: 'waiting for you'
	String get waiting => 'waiting for you';

	/// en: 'idle'
	String get idle => 'idle';

	/// en: 'asleep'
	String get sleeping => 'asleep';

	/// en: 'done'
	String get done => 'done';
}

// Path: gsh.agentGraph.integrationError
class Translations$gsh$agentGraph$integrationError$en {
	Translations$gsh$agentGraph$integrationError$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '${path} is not plain JSON/TOML that GSH Desktop can edit safely (comments or a different layout). Nothing was changed.'
	String invalidConfig({required Object path}) => '${path} is not plain JSON/TOML that GSH Desktop can edit safely (comments or a different layout). Nothing was changed.';

	/// en: 'The GSH Desktop CLI is not installed yet (${path}). Restart GSH Desktop and try again.'
	String cliMissing({required Object path}) => 'The GSH Desktop CLI is not installed yet (${path}). Restart GSH Desktop and try again.';

	/// en: 'Could not update the config: ${detail}'
	String writeFailed({required Object detail}) => 'Could not update the config: ${detail}';
}

// Path: settings.page.header
class Translations$settings$page$header$en {
	Translations$settings$page$header$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Settings'
	String get title => 'Settings';
}

// Path: settings.page.nav
class Translations$settings$page$nav$en {
	Translations$settings$page$nav$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'GSH Desktop'
	String get sideGsh => 'GSH Desktop';

	/// en: 'Claude'
	String get sideClaude => 'Claude';

	/// en: 'General'
	String get general => 'General';

	/// en: 'Appearance'
	String get appearance => 'Appearance';

	/// en: 'Terminal'
	String get terminal => 'Terminal';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Shortcuts'
	String get shortcuts => 'Shortcuts';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'AI Commits'
	String get automations => 'AI Commits';

	/// en: 'Remote hosts'
	String get remoteHosts => 'Remote hosts';

	/// en: 'Claude Code'
	String get claudeCode => 'Claude Code';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'Privacy'
	String get privacy => 'Privacy';

	/// en: 'Usage'
	String get usage => 'Usage';

	/// en: 'Resources'
	String get resources => 'Resources';

	/// en: 'GSH features'
	String get gshFeatures => 'GSH features';

	/// en: 'Memory'
	String get memory => 'Memory';

	/// en: 'Design systems'
	String get designSystems => 'Design systems';

	/// en: 'Cowork'
	String get cowork => 'Cowork';

	/// en: 'System'
	String get system => 'System';

	/// en: 'Extensions'
	String get extensions => 'Extensions';

	/// en: 'Developer'
	String get developer => 'Developer';

	/// en: 'Skills'
	String get skills => 'Skills';

	/// en: 'Connectors'
	String get connectors => 'Connectors';

	/// en: 'Plugins'
	String get plugins => 'Plugins';

	/// en: 'API keys'
	String get apiKeys => 'API keys';

	late final Translations$settings$page$nav$groups$en groups = Translations$settings$page$nav$groups$en.internal(_root);
}

// Path: settings.page.general
class Translations$settings$page$general$en {
	Translations$settings$page$general$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Editor'
	String get sectionEditor => 'Editor';

	/// en: 'Engine'
	String get editorEngineTitle => 'Engine';

	/// en: 'GSH Desktop (default)'
	String get editorEngineGsh => 'GSH Desktop (default)';

	/// en: 'Neovim'
	String get editorEngineNeovim => 'Neovim';

	/// en: 'Looking for Neovim…'
	String get neovimChecking => 'Looking for Neovim…';

	/// en: 'Neovim was not found in your shell PATH.'
	String get neovimNotFound => 'Neovim was not found in your shell PATH.';

	/// en: 'Check again'
	String get neovimRefresh => 'Check again';

	/// en: 'Show GSH Desktop terminal'
	String get showGshTitle => 'Show GSH Desktop terminal';

	/// en: 'Keep a pathless, terminal-only workspace pinned at the top of the rail. Turning it off closes its terminals.'
	String get showGshDesc => 'Keep a pathless, terminal-only workspace pinned at the top of the rail. Turning it off closes its terminals.';

	/// en: 'Launch at login'
	String get launchAtStartupTitle => 'Launch at login';

	/// en: 'Start GSH Desktop automatically when you sign in to your computer.'
	String get launchAtStartupDesc => 'Start GSH Desktop automatically when you sign in to your computer.';

	/// en: 'Updates'
	String get sectionUpdates => 'Updates';

	/// en: 'Check for updates'
	String get checkUpdatesTitle => 'Check for updates';

	/// en: 'How often GSH Desktop should look for new versions.'
	String get checkUpdatesDesc => 'How often GSH Desktop should look for new versions.';

	late final Translations$settings$page$general$updateFrequency$en updateFrequency = Translations$settings$page$general$updateFrequency$en.internal(_root);

	/// en: 'Developer mode'
	String get developerModeTitle => 'Developer mode';

	/// en: 'Records GSH Desktop’s own errors and warnings in a separate Telemetry store (the “GSH Desktop” chip) and turns on performance metrics. Only useful to whoever maintains the app.'
	String get developerModeDesc => 'Records GSH Desktop’s own errors and warnings in a separate Telemetry store (the “GSH Desktop” chip) and turns on performance metrics. Only useful to whoever maintains the app.';
}

// Path: settings.page.diagnostics
class Translations$settings$page$diagnostics$en {
	Translations$settings$page$diagnostics$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Diagnostics'
	String get sectionTitle => 'Diagnostics';

	/// en: 'Log file'
	String get logFileTitle => 'Log file';

	/// en: 'Errors and startup events are recorded here, kept for ${days} days. ${path}'
	String logFileDesc({required Object days, required Object path}) => 'Errors and startup events are recorded here, kept for ${days} days.\n${path}';

	/// en: 'unavailable'
	String get unavailable => 'unavailable';

	/// en: 'Reveal'
	String get reveal => 'Reveal';

	/// en: 'Report a problem'
	String get reportTitle => 'Report a problem';

	/// en: 'Opens a pre-filled issue with your version, OS and recent log. Nothing is sent automatically — you review it first.'
	String get reportDesc => 'Opens a pre-filled issue with your version, OS and recent log. Nothing is sent automatically — you review it first.';

	/// en: 'Report…'
	String get reportButton => 'Report…';

	/// en: 'Problem report'
	String get reportDialogTitle => 'Problem report';

	/// en: 'Reported manually from Settings.'
	String get reportDialogError => 'Reported manually from Settings.';

	/// en: 'Describe what went wrong in the issue. The recent log is included below and in "Copy details".'
	String get reportDialogDescription => 'Describe what went wrong in the issue. The recent log is included below and in "Copy details".';
}

// Path: settings.page.storage
class Translations$settings$page$storage$en {
	Translations$settings$page$storage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Storage'
	String get sectionTitle => 'Storage';

	/// en: 'Storage location'
	String get locationTitle => 'Storage location';

	/// en: 'GSH Desktop keeps its projects, layouts and settings here. Point it at a synced folder to back it up. ${root}'
	String locationDesc({required Object root}) => 'GSH Desktop keeps its projects, layouts and settings here. Point it at a synced folder to back it up.\n${root}';

	/// en: 'Use default'
	String get useDefault => 'Use default';

	/// en: 'Working…'
	String get working => 'Working…';

	/// en: 'Change…'
	String get change => 'Change…';

	/// en: 'Reset GSH Desktop'
	String get resetTitle => 'Reset GSH Desktop';

	/// en: 'Delete all local data — projects, layouts, settings and terminal history — and return to the default location.'
	String get resetDesc => 'Delete all local data — projects, layouts, settings and terminal history — and return to the default location.';

	/// en: 'Reset…'
	String get resetButton => 'Reset…';

	/// en: 'Reset'
	String get resetConfirm => 'Reset';

	/// en: 'Reset GSH Desktop?'
	String get resetDialogTitle => 'Reset GSH Desktop?';

	/// en: 'This permanently deletes all local GSH Desktop data — projects, layouts, settings and terminal history. This cannot be undone. GSH Desktop will close so you can start fresh.'
	String get resetDialogContent => 'This permanently deletes all local GSH Desktop data — projects, layouts, settings and terminal history. This cannot be undone. GSH Desktop will close so you can start fresh.';

	/// en: 'Restart required'
	String get restartRequiredTitle => 'Restart required';

	/// en: 'GSH Desktop will use this folder from the next launch: ${path}'
	String restartChangeFolderMessage({required Object path}) => 'GSH Desktop will use this folder from the next launch:\n${path}';

	/// en: 'GSH Desktop will use the default system location from the next launch. Your data in the custom folder is left untouched.'
	String get restartUseDefaultMessage => 'GSH Desktop will use the default system location from the next launch. Your data in the custom folder is left untouched.';

	/// en: 'All GSH Desktop data was cleared. Restart to start fresh.'
	String get restartResetMessage => 'All GSH Desktop data was cleared. Restart to start fresh.';

	/// en: 'Later'
	String get later => 'Later';

	/// en: 'Quit GSH Desktop'
	String get quitGsh => 'Quit GSH Desktop';

	/// en: 'Choose a folder for GSH Desktop data'
	String get chooseFolderDialogTitle => 'Choose a folder for GSH Desktop data';
}

// Path: settings.page.terminal
class Translations$settings$page$terminal$en {
	Translations$settings$page$terminal$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Default terminal'
	String get sectionDefaultTerminal => 'Default terminal';

	/// en: 'Engine'
	String get engineTitle => 'Engine';

	/// en: 'Used by new terminal tabs and task output buffers. Open tabs keep their current engine.'
	String get engineDesc => 'Used by new terminal tabs and task output buffers. Open tabs keep their current engine.';

	/// en: 'Shell'
	String get shellTitle => 'Shell';

	/// en: 'Which shell new terminal tabs open. The arrow next to + still opens any other one, just for that tab.'
	String get shellDesc => 'Which shell new terminal tabs open. The arrow next to + still opens any other one, just for that tab.';

	/// en: 'No WSL distros found. Install one (wsl.exe --install) and restart GSH Desktop to see it listed here.'
	String get noWslMessage => 'No WSL distros found. Install one (wsl.exe --install) and restart GSH Desktop to see it listed here.';

	/// en: 'Behavior'
	String get sectionBehavior => 'Behavior';

	/// en: 'Close tab when the shell exits'
	String get closeOnExitTitle => 'Close tab when the shell exits';

	/// en: 'When a shell ends on its own (exit, Ctrl-D), close its tab instead of leaving a dead terminal.'
	String get closeOnExitDesc => 'When a shell ends on its own (exit, Ctrl-D), close its tab instead of leaving a dead terminal.';
}

// Path: settings.page.appearance
class Translations$settings$page$appearance$en {
	Translations$settings$page$appearance$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Theme'
	String get sectionTheme => 'Theme';

	/// en: 'Theme'
	String get themeTitle => 'Theme';

	/// en: 'App colors, code highlighting and terminal palette.'
	String get themeDesc => 'App colors, code highlighting and terminal palette.';

	/// en: 'Mode'
	String get modeTitle => 'Mode';

	/// en: 'Which variant of the theme to use.'
	String get modeDesc => 'Which variant of the theme to use.';

	/// en: '"${theme}" only ships a dark variant, so this has no effect.'
	String modeOnlyDark({required Object theme}) => '"${theme}" only ships a dark variant, so this has no effect.';

	/// en: '"${theme}" only ships a light variant, so this has no effect.'
	String modeOnlyLight({required Object theme}) => '"${theme}" only ships a light variant, so this has no effect.';

	/// en: 'Theme file'
	String get themeFileTitle => 'Theme file';

	/// en: 'Import a theme from a JSON file, or export the active one.'
	String get themeFileDesc => 'Import a theme from a JSON file, or export the active one.';

	/// en: 'Code'
	String get previewCode => 'Code';

	/// en: 'Terminal'
	String get previewTerminal => 'Terminal';

	/// en: 'System'
	String get themeSystem => 'System';

	/// en: 'Light'
	String get themeLight => 'Light';

	/// en: 'Dark'
	String get themeDark => 'Dark';

	/// en: 'Fonts'
	String get sectionFonts => 'Fonts';

	/// en: 'Interface font'
	String get interfaceFontTitle => 'Interface font';

	/// en: 'Used across the whole app. Empty = system default.'
	String get interfaceFontDesc => 'Used across the whole app. Empty = system default.';

	/// en: 'Interface size'
	String get interfaceSizeTitle => 'Interface size';

	/// en: 'Code font'
	String get codeFontTitle => 'Code font';

	/// en: 'Code and diffs. Empty = system default.'
	String get codeFontDesc => 'Code and diffs. Empty = system default.';

	/// en: 'Code size'
	String get codeSizeTitle => 'Code size';

	/// en: 'Terminal font'
	String get terminalFontTitle => 'Terminal font';

	/// en: 'Terminal only. Empty = system default.'
	String get terminalFontDesc => 'Terminal only. Empty = system default.';

	/// en: 'Terminal size'
	String get terminalSizeTitle => 'Terminal size';

	/// en: 'Off = follows the code size.'
	String get terminalSizeDesc => 'Off = follows the code size.';

	/// en: 'Follow code size'
	String get terminalSizeInherit => 'Follow code size';

	/// en: 'Terminal weight'
	String get terminalWeightTitle => 'Terminal weight';

	/// en: 'Low-density screens render strokes heavier. Auto lightens them there and leaves Retina untouched.'
	String get terminalWeightDesc => 'Low-density screens render strokes heavier. Auto lightens them there and leaves Retina untouched.';

	/// en: 'Auto (by screen)'
	String get terminalWeightAuto => 'Auto (by screen)';

	/// en: 'Light'
	String get terminalWeightLight => 'Light';

	/// en: 'Normal'
	String get terminalWeightNormal => 'Normal';

	/// en: 'Medium'
	String get terminalWeightMedium => 'Medium';

	/// en: 'Semibold'
	String get terminalWeightSemiBold => 'Semibold';

	/// en: 'Conversation'
	String get sectionConversation => 'Conversation';

	/// en: 'Pin user message'
	String get pinUserMessageTitle => 'Pin user message';

	/// en: 'The question stays fixed at the top while the answer scrolls.'
	String get pinUserMessageDesc => 'The question stays fixed at the top while the answer scrolls.';

	/// en: 'Import…'
	String get importTheme => 'Import…';

	/// en: 'Export…'
	String get exportTheme => 'Export…';

	/// en: 'Remove'
	String get deleteTheme => 'Remove';

	/// en: 'Pick a theme file'
	String get importThemeDialog => 'Pick a theme file';

	/// en: 'Save theme as'
	String get exportThemeDialog => 'Save theme as';

	/// en: 'Theme "${name}" imported.'
	String themeImported({required Object name}) => 'Theme "${name}" imported.';

	/// en: 'Theme saved.'
	String get themeExported => 'Theme saved.';

	/// en: 'Theme removed.'
	String get themeDeleted => 'Theme removed.';

	/// en: 'Choose a font'
	String get fontPickerTitle => 'Choose a font';

	/// en: 'Search fonts'
	String get fontPickerSearch => 'Search fonts';

	/// en: 'No matching font found on this machine.'
	String get fontPickerEmpty => 'No matching font found on this machine.';

	/// en: 'included'
	String get fontPickerBundled => 'included';

	/// en: 'Not listed? Type the exact family name.'
	String get fontPickerCustom => 'Not listed? Type the exact family name.';

	/// en: 'Family name'
	String get fontPickerCustomHint => 'Family name';

	/// en: 'Use'
	String get fontPickerUse => 'Use';

	/// en: 'Default'
	String get fontPickerDefault => 'Default';

	/// en: 'Not found on this machine — falling back.'
	String get fontMissing => 'Not found on this machine — falling back.';

	/// en: 'Layout'
	String get sectionLayout => 'Layout';

	/// en: 'Swap side panels'
	String get swapPanelsTitle => 'Swap side panels';

	/// en: 'Puts workspaces on the right and files, search, git and database on the left.'
	String get swapPanelsDesc => 'Puts workspaces on the right and files, search, git and database on the left.';
}

// Path: settings.page.notifications
class Translations$settings$page$notifications$en {
	Translations$settings$page$notifications$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Notifications'
	String get sectionTitle => 'Notifications';

	/// en: 'Enable notifications'
	String get enableTitle => 'Enable notifications';

	/// en: 'Alert me when an agent finishes a turn and the window is not focused.'
	String get enableDesc => 'Alert me when an agent finishes a turn and the window is not focused.';

	/// en: 'System permission'
	String get systemPermissionTitle => 'System permission';

	/// en: 'GSH Desktop is allowed to send notifications.'
	String get grantedDesc => 'GSH Desktop is allowed to send notifications.';

	/// en: 'macOS has not granted notification access yet.'
	String get notGrantedDesc => 'macOS has not granted notification access yet.';

	/// en: 'Granted'
	String get granted => 'Granted';

	/// en: 'Request permission'
	String get requestPermission => 'Request permission';

	/// en: 'Sounds'
	String get soundsTitle => 'Sounds';

	/// en: 'Volume'
	String get soundVolumeTitle => 'Volume';

	/// en: 'Turn completed'
	String get soundTurnDone => 'Turn completed';

	/// en: 'An agent finished its turn.'
	String get soundTurnDoneDesc => 'An agent finished its turn.';

	/// en: 'Action required'
	String get soundActionRequired => 'Action required';

	/// en: 'An agent is waiting for your approval or answer.'
	String get soundActionRequiredDesc => 'An agent is waiting for your approval or answer.';

	/// en: 'Default'
	String get soundDefault => 'Default';

	/// en: 'Custom: ${name}'
	String soundCustom({required Object name}) => 'Custom: ${name}';

	/// en: 'Choose file'
	String get soundChooseFile => 'Choose file';

	/// en: 'Reset to default'
	String get soundReset => 'Reset to default';

	/// en: 'Also play when this tab is active'
	String get soundOnActiveTab => 'Also play when this tab is active';

	/// en: 'Preview'
	String get soundPreview => 'Preview';
}

// Path: settings.page.shortcuts
class Translations$settings$page$shortcuts$en {
	Translations$settings$page$shortcuts$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Keyboard shortcuts are not customizable yet.'
	String get notCustomizable => 'Keyboard shortcuts are not customizable yet.';
}

// Path: settings.page.languages
class Translations$settings$page$languages$en {
	Translations$settings$page$languages$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'FORMATTING'
	String get sectionFormatting => 'FORMATTING';

	/// en: 'Format on save'
	String get formatOnSaveTitle => 'Format on save';

	/// en: 'Format the file automatically when you save (⌘S).'
	String get formatOnSaveDesc => 'Format the file automatically when you save (⌘S).';

	/// en: 'LANGUAGE SERVERS'
	String get sectionLanguageServers => 'LANGUAGE SERVERS';

	/// en: 'Errors and formatting use each language's language server. GSH Desktop does not install servers — it uses what is already on your machine. ● responds · ○ not found or invalid command (install the server or adjust the command).'
	String get footerNote => 'Errors and formatting use each language\'s language server. GSH Desktop does not install servers — it uses what is already on your machine. ● responds · ○ not found or invalid command (install the server or adjust the command).';

	/// en: 'Language server command'
	String get serverCommandLabel => 'Language server command';

	/// en: 'Formatter command (optional)'
	String get formatterCommandLabel => 'Formatter command (optional)';

	/// en: 'External formatter with %FILE% placeholder. Takes precedence over the LSP formatter when set.'
	String get formatterHint => 'External formatter with %FILE% placeholder. Takes precedence over the LSP formatter when set.';

	/// en: 'Reset to default'
	String get resetToDefault => 'Reset to default';

	/// en: 'Save & restart'
	String get saveAndRestart => 'Save & restart';

	/// en: 'Server responds'
	String get statusResponds => 'Server responds';

	/// en: 'Server not found or command invalid'
	String get statusNotFound => 'Server not found or command invalid';
}

// Path: settings.page.automations
class Translations$settings$page$automations$en {
	Translations$settings$page$automations$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Commit messages'
	String get sectionCommitMessages => 'Commit messages';

	/// en: 'Harness'
	String get harness => 'Harness';

	/// en: 'Looking for installed command-line harnesses…'
	String get harnessDiscovering => 'Looking for installed command-line harnesses…';

	/// en: 'No supported harness was found on PATH.'
	String get harnessNoneFound => 'No supported harness was found on PATH.';

	/// en: '${harness} is configured but unavailable.'
	String harnessConfiguredUnavailable({required Object harness}) => '${harness} is configured but unavailable.';

	/// en: 'Choose the CLI used to generate commit messages.'
	String get harnessChoose => 'Choose the CLI used to generate commit messages.';

	/// en: 'Refresh installed harnesses'
	String get harnessRefresh => 'Refresh installed harnesses';

	/// en: 'Not configured'
	String get notConfigured => 'Not configured';

	/// en: 'Model'
	String get model => 'Model';

	/// en: 'The model list is unavailable until the harness is found.'
	String get modelUnavailable => 'The model list is unavailable until the harness is found.';

	/// en: 'This harness uses its CLI default model.'
	String get modelCliOnly => 'This harness uses its CLI default model.';

	/// en: 'CLI default'
	String get modelCliDefault => 'CLI default';

	/// en: 'Auto'
	String get modelAuto => 'Auto';

	/// en: 'Search among ${count} models…'
	String modelSearch({required Object count}) => 'Search among ${count} models…';

	/// en: 'This harness routes the model automatically.'
	String get modelAutoRouted => 'This harness routes the model automatically.';

	/// en: 'Only models your account can use are listed.'
	String get modelAccountOnly => 'Only models your account can use are listed.';

	/// en: 'Generate from Source Control'
	String get generateFromSourceControl => 'Generate from Source Control';

	/// en: 'GSH Desktop sends only the selected diff and recent commit subjects. Common credential patterns and sensitive files are redacted before the harness runs.'
	String get generateFromSourceControlDescription => 'GSH Desktop sends only the selected diff and recent commit subjects. Common credential patterns and sensitive files are redacted before the harness runs.';

	/// en: 'Could not discover installed automation harnesses.'
	String get discoveryFailed => 'Could not discover installed automation harnesses.';

	/// en: 'Model "${model}" is no longer available for ${harness}. Using the CLI default — pick another model in Settings if needed.'
	String staleModel({required Object model, required Object harness}) => 'Model "${model}" is no longer available for ${harness}. Using the CLI default — pick another model in Settings if needed.';

	/// en: 'Recommended'
	String get recommendedSuffix => 'Recommended';
}

// Path: settings.page.claudeCode
class Translations$settings$page$claudeCode$en {
	Translations$settings$page$claudeCode$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'General'
	String get sectionGeneral => 'General';

	/// en: 'Classify session states'
	String get classifyTitle => 'Classify session states';

	/// en: 'Show in the chat header the state Claude Code assigns at the end of each turn: completed, ready for review or blocked. Claude Code classifies either way; turning this off only hides the badge.'
	String get classifyDesc => 'Show in the chat header the state Claude Code assigns at the end of each turn: completed, ready for review or blocked. Claude Code classifies either way; turning this off only hides the badge.';

	/// en: 'Switch models when a message is flagged'
	String get switchModelsTitle => 'Switch models when a message is flagged';

	/// en: 'When safeguards flag a message, automatically switch to a different model to keep the conversation going. When off, your session pauses instead. Saved in ~/.claude/settings.json (switchModelsOnFlag).'
	String get switchModelsDesc => 'When safeguards flag a message, automatically switch to a different model to keep the conversation going. When off, your session pauses instead. Saved in ~/.claude/settings.json (switchModelsOnFlag).';

	/// en: 'Code appearance'
	String get sectionCodeAppearance => 'Code appearance';

	/// en: 'From the active theme'
	String get followTheme => 'From the active theme';

	/// en: 'Code colors in light mode'
	String get codeThemeLightHint => 'Code colors in light mode';

	/// en: 'Code colors in dark mode'
	String get codeThemeDarkHint => 'Code colors in dark mode';

	/// en: 'Code font'
	String get codeFontTitle => 'Code font';

	/// en: 'A custom monospaced font for code: viewer, editor, diffs and the chat's code blocks. The terminal has its own font under Appearance.'
	String get codeFontDesc => 'A custom monospaced font for code: viewer, editor, diffs and the chat\'s code blocks. The terminal has its own font under Appearance.';

	/// en: 'e.g. JetBrains Mono'
	String get codeFontPlaceholder => 'e.g. JetBrains Mono';

	/// en: 'Appearance'
	String get sectionAppearance => 'Appearance';

	/// en: 'Default transcript view'
	String get transcriptTitle => 'Default transcript view';

	/// en: 'The view new chat conversations open with. Conversations already open keep theirs.'
	String get transcriptDesc => 'The view new chat conversations open with. Conversations already open keep theirs.';

	/// en: 'Normal'
	String get viewNormal => 'Normal';

	/// en: 'Thinking'
	String get viewThinking => 'Thinking';

	/// en: 'Verbose'
	String get viewVerbose => 'Verbose';

	/// en: 'Remote Control'
	String get sectionRemoteControl => 'Remote Control';

	/// en: 'Chat with Remote Control (experimental)'
	String get chatRemoteControlTitle => 'Chat with Remote Control (experimental)';

	/// en: 'The GSH chat runs the interactive claude in a hidden terminal, connected to Remote Control: the conversation shows up on your phone and at claude.ai/code, and other machines' sessions can see it. Replies arrive per message (no letter-by-letter streaming). Applies to chats opened after the change; turn it off to go back to the fast engine.'
	String get chatRemoteControlDesc => 'The GSH chat runs the interactive claude in a hidden terminal, connected to Remote Control: the conversation shows up on your phone and at claude.ai/code, and other machines\' sessions can see it. Replies arrive per message (no letter-by-letter streaming). Applies to chats opened after the change; turn it off to go back to the fast engine.';

	/// en: 'Connect new sessions to Remote Control'
	String get remoteControlTitle => 'Connect new sessions to Remote Control';

	/// en: 'Every claude session you start in a terminal connects to Remote Control, so you can continue it on your phone or at claude.ai/code. Saved in ~/.claude/settings.json (remoteControlAtStartup). Needs a claude.ai login (Pro, Max, Team or Enterprise).'
	String get remoteControlDesc => 'Every claude session you start in a terminal connects to Remote Control, so you can continue it on your phone or at claude.ai/code. Saved in ~/.claude/settings.json (remoteControlAtStartup). Needs a claude.ai login (Pro, Max, Team or Enterprise).';

	/// en: 'Couldn't save: ${detail}'
	String saveFailed({required Object detail}) => 'Couldn\'t save: ${detail}';

	/// en: 'Sessions'
	String get sectionSessions => 'Sessions';

	/// en: 'Prompt suggestions'
	String get promptSuggestionsTitle => 'Prompt suggestions';

	/// en: 'Show a suggested next prompt after Claude answers. Suggestions use a bit of your usage.'
	String get promptSuggestionsDesc => 'Show a suggested next prompt after Claude answers. Suggestions use a bit of your usage.';

	/// en: 'Output style'
	String get outputStyleTitle => 'Output style';

	/// en: 'How Claude structures answers in Code sessions. Applies to new sessions.'
	String get outputStyleDesc => 'How Claude structures answers in Code sessions. Applies to new sessions.';

	/// en: 'Default'
	String get outputStyleDefault => 'Default';

	/// en: 'Messages from other sessions'
	String get crossSessionTitle => 'Messages from other sessions';

	/// en: 'What to do when another Claude Code session sends this one a message (SendMessage). GSH sets Accept for every session on this machine; Hold parks it for your approval, Refuse drops it. Saved as crossSessionInbound.'
	String get crossSessionDesc => 'What to do when another Claude Code session sends this one a message (SendMessage). GSH sets Accept for every session on this machine; Hold parks it for your approval, Refuse drops it. Saved as crossSessionInbound.';

	/// en: 'Default'
	String get crossSessionDefault => 'Default';

	/// en: 'Accept'
	String get crossSessionAccept => 'Accept';

	/// en: 'Hold for approval'
	String get crossSessionHold => 'Hold for approval';

	/// en: 'Refuse'
	String get crossSessionRefuse => 'Refuse';

	/// en: 'Local sandbox'
	String get sandboxTitle => 'Local sandbox';

	/// en: 'Runs Claude Code bash commands inside an isolated sandbox. Applies to new sessions.'
	String get sandboxDesc => 'Runs Claude Code bash commands inside an isolated sandbox. Applies to new sessions.';

	/// en: 'Strict sandbox mode'
	String get sandboxStrictTitle => 'Strict sandbox mode';

	/// en: 'Blocks commands that cannot run inside the sandbox instead of running them outside it.'
	String get sandboxStrictDesc => 'Blocks commands that cannot run inside the sandbox instead of running them outside it.';

	/// en: 'Security'
	String get sectionSecurity => 'Security';

	/// en: 'Protected hosts'
	String get protectedHostsTitle => 'Protected hosts';

	/// en: 'Hosts no agent may touch from a command: ssh, scp, remote workspace, anything that names them. GSH blocks the command before it runs, in every Claude Code and Codex session on this machine, and tells the agent to ask you. Comma-separated; whole words (prod blocks "ssh prod" and "prod.x.com", not "production"). Saved in ~/.gsh/protected-hosts.json.'
	String get protectedHostsDesc => 'Hosts no agent may touch from a command: ssh, scp, remote workspace, anything that names them. GSH blocks the command before it runs, in every Claude Code and Codex session on this machine, and tells the agent to ask you. Comma-separated; whole words (prod blocks "ssh prod" and "prod.x.com", not "production"). Saved in ~/.gsh/protected-hosts.json.';

	/// en: 'Browser'
	String get sectionBrowser => 'Browser';

	/// en: 'Open links in the built-in browser'
	String get linksInAppTitle => 'Open links in the built-in browser';

	/// en: 'Links clicked in terminals open in a GSH browser tab instead of your default browser.'
	String get linksInAppDesc => 'Links clicked in terminals open in a GSH browser tab instead of your default browser.';
}

// Path: settings.page.placeholder
class Translations$settings$page$placeholder$en {
	Translations$settings$page$placeholder$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cowork is a Claude Desktop feature (tasks that run on this computer with local files, browser and MCPs).'
	String get cowork1 => 'Cowork is a Claude Desktop feature (tasks that run on this computer with local files, browser and MCPs).';

	/// en: 'In GSH the equivalent is the Claude chat in a workspace and the Farm, where agent loops run in terminals.'
	String get cowork2 => 'In GSH the equivalent is the Claude chat in a workspace and the Farm, where agent loops run in terminals.';

	/// en: 'Let Claude work directly with apps, data and tools on your computer.'
	String get extensionsDesc => 'Let Claude work directly with apps, data and tools on your computer.';

	/// en: 'No extension installed'
	String get extensionsEmpty => 'No extension installed';

	/// en: '.MCPB/.DXT extensions belong to Claude Desktop. In GSH, MCP servers live under Connectors and Developer.'
	String get extensions => '.MCPB/.DXT extensions belong to Claude Desktop. In GSH, MCP servers live under Connectors and Developer.';
}

// Path: settings.page.claude
class Translations$settings$page$claude$en {
	Translations$settings$page$claude$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'Loading…'
	String get loading => 'Loading…';

	/// en: 'Open a terminal'
	String get terminalTitle => 'Open a terminal';

	/// en: 'Open a local workspace first: this runs the `claude` CLI in one of its terminals so you can follow it.'
	String get noWorkspace => 'Open a local workspace first: this runs the `claude` CLI in one of its terminals so you can follow it.';

	/// en: 'Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec'
	String get months => 'Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec';

	/// en: 'Mon|Tue|Wed|Thu|Fri|Sat|Sun'
	String get weekdays => 'Mon|Tue|Wed|Thu|Fri|Sat|Sun';

	/// en: '${month} ${day}'
	String dateShort({required Object month, required Object day}) => '${month} ${day}';

	late final Translations$settings$page$claude$error$en error = Translations$settings$page$claude$error$en.internal(_root);
}

// Path: settings.page.account
class Translations$settings$page$account$en {
	Translations$settings$page$account$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account'
	String get title => 'Account';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Instructions for Claude'
	String get instructions => 'Instructions for Claude';

	/// en: 'Saved in ~/.claude/CLAUDE.md: Claude Code loads it in every session on this computer.'
	String get instructionsDesc => 'Saved in ~/.claude/CLAUDE.md: Claude Code loads it in every session on this computer.';

	/// en: 'e.g. keep explanations short and direct'
	String get instructionsHint => 'e.g. keep explanations short and direct';

	/// en: 'Signed in'
	String get loggedIn => 'Signed in';

	/// en: 'Signed out'
	String get loggedOut => 'Signed out';

	/// en: 'Claude Code on this computer uses this account.'
	String get loggedInDesc => 'Claude Code on this computer uses this account.';

	/// en: 'Sign in to use your Claude subscription in Claude Code.'
	String get loggedOutDesc => 'Sign in to use your Claude subscription in Claude Code.';

	/// en: 'Sign in'
	String get login => 'Sign in';

	/// en: 'Sign out'
	String get logout => 'Sign out';

	/// en: 'Sign out of Claude Code?'
	String get logoutConfirmTitle => 'Sign out of Claude Code?';

	/// en: 'Runs `claude auth logout`. Sessions on this computer stop using your subscription until you sign in again.'
	String get logoutConfirmMessage => 'Runs `claude auth logout`. Sessions on this computer stop using your subscription until you sign in again.';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Organization'
	String get organization => 'Organization';

	/// en: 'Organization ID'
	String get orgId => 'Organization ID';

	/// en: 'Plan'
	String get plan => 'Plan';

	/// en: 'Sign-in method'
	String get method => 'Sign-in method';
}

// Path: settings.page.usage
class Translations$settings$page$usage$en {
	Translations$settings$page$usage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your usage limits'
	String get title => 'Your usage limits';

	/// en: 'Weekly limits'
	String get weeklyTitle => 'Weekly limits';

	/// en: 'Plan limits do not apply to this sign-in (API key or third-party provider).'
	String get unavailable => 'Plan limits do not apply to this sign-in (API key or third-party provider).';

	/// en: 'Current session'
	String get windowSession => 'Current session';

	/// en: 'All models'
	String get windowWeekly => 'All models';

	/// en: 'Resets in ${when}'
	String resetsIn({required Object when}) => 'Resets in ${when}';

	/// en: 'Resets ${when}'
	String resetsAt({required Object when}) => 'Resets ${when}';

	/// en: '${pct}% used'
	String percentUsed({required Object pct}) => '${pct}% used';

	/// en: 'Last updated: ${when}'
	String updated({required Object when}) => 'Last updated: ${when}';

	/// en: 'less than a minute ago'
	String get justNow => 'less than a minute ago';

	/// en: '${n} min ago'
	String minutesAgo({required Object n}) => '${n} min ago';

	/// en: '${m} min'
	String minutes({required Object m}) => '${m} min';

	/// en: '${h} h ${m} min'
	String hoursMinutes({required Object h, required Object m}) => '${h} h ${m} min';

	late final Translations$settings$page$usage$plans$en plans = Translations$settings$page$usage$plans$en.internal(_root);
}

// Path: settings.page.memory
class Translations$settings$page$memory$en {
	Translations$settings$page$memory$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Memory'
	String get title => 'Memory';

	/// en: 'What a Claude Code session in the active workspace loads: your instructions and the memory Claude writes on its own. Click to open the file.'
	String get intro => 'What a Claude Code session in the active workspace loads: your instructions and the memory Claude writes on its own. Click to open the file.';

	/// en: 'Instructions'
	String get instructionsTitle => 'Instructions';

	/// en: 'Auto memory'
	String get autoTitle => 'Auto memory';

	/// en: 'No CLAUDE.md found.'
	String get empty => 'No CLAUDE.md found.';

	/// en: 'Claude has not saved memories for this workspace yet.'
	String get autoEmpty => 'Claude has not saved memories for this workspace yet.';

	/// en: 'User (all projects)'
	String get scopeUser => 'User (all projects)';

	/// en: 'Project'
	String get scopeProject => 'Project';

	/// en: 'Updated ${when}'
	String updated({required Object when}) => 'Updated ${when}';
}

// Path: settings.page.skills
class Translations$settings$page$skills$en {
	Translations$settings$page$skills$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Created by you'
	String get groupUser => 'Created by you';

	/// en: 'From this project'
	String get groupProject => 'From this project';

	/// en: 'From plugins'
	String get groupPlugins => 'From plugins';

	/// en: 'by you'
	String get byYou => 'by you';

	/// en: 'project'
	String get byProject => 'project';

	/// en: 'No skills installed.'
	String get empty => 'No skills installed.';
}

// Path: settings.page.connectors
class Translations$settings$page$connectors$en {
	Translations$settings$page$connectors$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Checking each server… this can take a few seconds.'
	String get checking => 'Checking each server… this can take a few seconds.';

	/// en: 'No MCP server configured.'
	String get empty => 'No MCP server configured.';

	/// en: 'Add MCP server'
	String get addServer => 'Add MCP server';

	/// en: 'Connector'
	String get colConnector => 'Connector';

	/// en: 'Type'
	String get colType => 'Type';

	/// en: 'Status'
	String get colStatus => 'Status';

	/// en: 'Provided by the plugin ${plugin}'
	String fromPlugin({required Object plugin}) => 'Provided by the plugin ${plugin}';

	/// en: 'Web'
	String get typeWeb => 'Web';

	/// en: 'Local'
	String get typeLocal => 'Local';

	/// en: 'Plugin'
	String get originPlugin => 'Plugin';

	/// en: 'Connect'
	String get link => 'Connect';

	/// en: 'The claude.ai connector directory has no public API, so GSH does not list it. Add any MCP server here: GSH runs `claude mcp add` in a terminal.'
	String get discoverIntro => 'The claude.ai connector directory has no public API, so GSH does not list it. Add any MCP server here: GSH runs `claude mcp add` in a terminal.';

	/// en: 'Name'
	String get formName => 'Name';

	/// en: 'Type'
	String get formType => 'Type';

	/// en: 'URL'
	String get formUrl => 'URL';

	/// en: 'Command'
	String get formCommand => 'Command';

	/// en: 'Scope'
	String get formScope => 'Scope';

	/// en: 'User = every project; Local = only the project of the terminal.'
	String get formScopeDesc => 'User = every project; Local = only the project of the terminal.';

	/// en: 'User'
	String get scopeUser => 'User';

	/// en: 'Local'
	String get scopeLocal => 'Local';

	/// en: 'MCP docs'
	String get docs => 'MCP docs';

	/// en: 'Add in terminal'
	String get addInTerminal => 'Add in terminal';

	late final Translations$settings$page$connectors$status$en status = Translations$settings$page$connectors$status$en.internal(_root);
}

// Path: settings.page.plugins
class Translations$settings$page$plugins$en {
	Translations$settings$page$plugins$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search skills and plugins'
	String get search => 'Search skills and plugins';

	/// en: 'In this project'
	String get groupProject => 'In this project';

	/// en: 'From the marketplaces you added'
	String get groupMarketplaces => 'From the marketplaces you added';

	/// en: 'Open a workspace to see the plugins enabled in it.'
	String get noWorkspace => 'Open a workspace to see the plugins enabled in it.';

	/// en: 'No plugin enabled in .claude/settings.json of this project.'
	String get projectEmpty => 'No plugin enabled in .claude/settings.json of this project.';

	/// en: 'No plugins installed.'
	String get empty => 'No plugins installed.';

	/// en: 'Disabled'
	String get disabled => 'Disabled';
}

// Path: settings.page.developer
class Translations$settings$page$developer$en {
	Translations$settings$page$developer$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Developer'
	String get title => 'Developer';

	/// en: 'Local MCP servers'
	String get mcpTitle => 'Local MCP servers';

	/// en: 'stdio MCP servers that Claude Code starts on this computer. They are configured in ~/.claude.json.'
	String get mcpDesc => 'stdio MCP servers that Claude Code starts on this computer. They are configured in ~/.claude.json.';

	/// en: 'No local MCP server.'
	String get mcpEmpty => 'No local MCP server.';

	/// en: 'Edit configuration'
	String get editConfig => 'Edit configuration';

	/// en: 'Command'
	String get command => 'Command';

	/// en: 'Arguments'
	String get arguments => 'Arguments';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Telemetry'
	String get telemetryTitle => 'Telemetry';

	/// en: 'Errors and logs from workspace processes are in the shell Telemetry panel; with developer mode on it also shows GSH Desktop’s own.'
	String get telemetryDesc => 'Errors and logs from workspace processes are in the shell Telemetry panel; with developer mode on it also shows GSH Desktop’s own.';

	/// en: 'Claude Code settings file'
	String get claudeSettingsTitle => 'Claude Code settings file';

	/// en: '~/.claude/settings.json — permissions, hooks, environment and model.'
	String get claudeSettingsDesc => '~/.claude/settings.json — permissions, hooks, environment and model.';

	/// en: 'Want an API key?'
	String get apiKeyTitle => 'Want an API key?';

	/// en: 'Create keys and check usage in the Claude Console. It needs another account and API usage is billed separately.'
	String get apiKeyDesc => 'Create keys and check usage in the Claude Console. It needs another account and API usage is billed separately.';

	/// en: 'Go to the Console'
	String get apiKeyButton => 'Go to the Console';
}

// Path: settings.page.system
class Translations$settings$page$system$en {
	Translations$settings$page$system$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'System'
	String get title => 'System';

	/// en: 'App version'
	String get version => 'App version';

	/// en: 'Keep computer awake'
	String get keepAwakeTitle => 'Keep computer awake';

	/// en: 'Prevents idle sleep while on (same as the bolt button in the rail). Turns off when the app closes; closing the lid still sleeps.'
	String get keepAwakeDesc => 'Prevents idle sleep while on (same as the bolt button in the rail). Turns off when the app closes; closing the lid still sleeps.';
}

// Path: settings.page.catalog
class Translations$settings$page$catalog$en {
	Translations$settings$page$catalog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Mine'
	String get mine => 'Mine';

	/// en: 'Discover'
	String get discover => 'Discover';

	/// en: 'Add'
	String get add => 'Add';

	/// en: 'All'
	String get all => 'All';

	/// en: 'by ${author}'
	String by({required Object author}) => 'by ${author}';

	/// en: 'New skill…'
	String get newSkill => 'New skill…';

	/// en: 'Add marketplace…'
	String get addMarketplace => 'Add marketplace…';
}

// Path: settings.page.generalClaude
class Translations$settings$page$generalClaude$en {
	Translations$settings$page$generalClaude$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appearance'
	String get sectionAppearance => 'Appearance';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'System'
	String get themeSystem => 'System';

	/// en: 'Light'
	String get themeLight => 'Light';

	/// en: 'Dark'
	String get themeDark => 'Dark';

	/// en: 'Interface font'
	String get uiFont => 'Interface font';

	/// en: 'Font for the whole interface — menus, sidebars and panels.'
	String get uiFontDesc => 'Font for the whole interface — menus, sidebars and panels.';

	/// en: 'Chat font'
	String get chatFont => 'Chat font';

	/// en: 'Text of the Claude chat conversation.'
	String get chatFontDesc => 'Text of the Claude chat conversation.';

	/// en: 'Same as the interface'
	String get chatFontDefault => 'Same as the interface';

	/// en: 'Text size'
	String get textSize => 'Text size';

	/// en: 'Base text size of the app (the same setting as in Appearance).'
	String get textSizeDesc => 'Base text size of the app (the same setting as in Appearance).';

	/// en: 'Small'
	String get sizeSmall => 'Small';

	/// en: 'Medium'
	String get sizeMedium => 'Medium';

	/// en: 'Large'
	String get sizeLarge => 'Large';

	/// en: 'Transcript width'
	String get transcriptWidth => 'Transcript width';

	/// en: 'Maximum width of the chat transcript and message box.'
	String get transcriptWidthDesc => 'Maximum width of the chat transcript and message box.';

	/// en: 'Narrow'
	String get widthNarrow => 'Narrow';

	/// en: 'Medium'
	String get widthMedium => 'Medium';

	/// en: 'Wide'
	String get widthWide => 'Wide';

	/// en: 'Reduced motion'
	String get reducedMotion => 'Reduced motion';

	/// en: 'Fewer animations in Claude Code (spinner shimmer, flashes). Saved as prefersReducedMotion in ~/.claude/settings.json.'
	String get reducedMotionDesc => 'Fewer animations in Claude Code (spinner shimmer, flashes). Saved as prefersReducedMotion in ~/.claude/settings.json.';

	/// en: 'Notifications'
	String get sectionNotifications => 'Notifications';

	/// en: 'Response completion'
	String get notifyTurnDone => 'Response completion';

	/// en: 'Get a notification when an agent finishes a response and the window is not focused.'
	String get notifyTurnDoneDesc => 'Get a notification when an agent finishes a response and the window is not focused.';

	/// en: 'Code permission requests'
	String get notifyPermission => 'Code permission requests';

	/// en: 'Play a sound when an agent is waiting for your approval or answer.'
	String get notifyPermissionDesc => 'Play a sound when an agent is waiting for your approval or answer.';

	/// en: 'Push to phone when input is needed'
	String get pushInputNeeded => 'Push to phone when input is needed';

	/// en: 'Claude Code sends a push when a permission prompt or question is waiting (inputNeededNotifEnabled).'
	String get pushInputNeededDesc => 'Claude Code sends a push when a permission prompt or question is waiting (inputNeededNotifEnabled).';

	/// en: 'Proactive phone notifications'
	String get pushAgent => 'Proactive phone notifications';

	/// en: 'Let Claude push important session updates to your phone (agentPushNotifEnabled).'
	String get pushAgentDesc => 'Let Claude push important session updates to your phone (agentPushNotifEnabled).';
}

// Path: settings.page.privacy
class Translations$settings$page$privacy$en {
	Translations$settings$page$privacy$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Data'
	String get title => 'Data';

	/// en: 'GSH telemetry'
	String get gshTelemetry => 'GSH telemetry';

	/// en: 'Local only: errors and logs stay in SQLite on this computer and are never sent anywhere.'
	String get gshTelemetryDesc => 'Local only: errors and logs stay in SQLite on this computer and are never sent anywhere.';

	/// en: 'Turn off Claude Code telemetry'
	String get ccTelemetry => 'Turn off Claude Code telemetry';

	/// en: 'Sets DISABLE_TELEMETRY in the env of ~/.claude/settings.json (usage metrics are not sent).'
	String get ccTelemetryDesc => 'Sets DISABLE_TELEMETRY in the env of ~/.claude/settings.json (usage metrics are not sent).';

	/// en: 'Turn off Claude Code error reports'
	String get ccErrors => 'Turn off Claude Code error reports';

	/// en: 'Sets DISABLE_ERROR_REPORTING in the env of ~/.claude/settings.json.'
	String get ccErrorsDesc => 'Sets DISABLE_ERROR_REPORTING in the env of ~/.claude/settings.json.';
}

// Path: settings.page.resources
class Translations$settings$page$resources$en {
	Translations$settings$page$resources$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'General'
	String get sectionGeneral => 'General';

	/// en: 'GSH features'
	String get sectionShell => 'GSH features';

	/// en: 'Chat with Claude (beta)'
	String get chat => 'Chat with Claude (beta)';

	/// en: 'Chat button in the workspace bar (Claude Code in stream-json).'
	String get chatDesc => 'Chat button in the workspace bar (Claude Code in stream-json).';

	/// en: 'Farm'
	String get farm => 'Farm';

	/// en: 'Agent loops read from Claude Code transcripts.'
	String get farmDesc => 'Agent loops read from Claude Code transcripts.';

	/// en: 'Harness'
	String get harnessFeature => 'Harness';

	/// en: 'Button that opens what the agent loads in the workspace: instructions, skills, subagents, hooks, permissions and MCP.'
	String get harnessFeatureDesc => 'Button that opens what the agent loads in the workspace: instructions, skills, subagents, hooks, permissions and MCP.';

	/// en: 'Team farm'
	String get sectionTeamFarm => 'Team farm';

	/// en: 'See your teammates' farms'
	String get teamFarm => 'See your teammates\' farms';

	/// en: 'On the same network (e.g. at the office), each GSH announces its own farm and shows your teammates' next to yours — zoom out to see them. No server: nothing leaves the local network. Off, nothing leaves your GSH.'
	String get teamFarmDesc => 'On the same network (e.g. at the office), each GSH announces its own farm and shows your teammates\' next to yours — zoom out to see them. No server: nothing leaves the local network. Off, nothing leaves your GSH.';

	/// en: 'Team'
	String get teamName => 'Team';

	/// en: 'Only people using the same team name see each other.'
	String get teamNameDesc => 'Only people using the same team name see each other.';

	/// en: 'e.g. gorila'
	String get teamNamePlaceholder => 'e.g. gorila';

	/// en: 'Your name'
	String get teamMe => 'Your name';

	/// en: 'Shown above your farm to your teammates.'
	String get teamMeDesc => 'Shown above your farm to your teammates.';

	/// en: 'Show session titles'
	String get teamShowTitles => 'Show session titles';

	/// en: 'Titles may contain bits of your prompts. Off, teammates only see each agent's folder, status and tokens.'
	String get teamShowTitlesDesc => 'Titles may contain bits of your prompts. Off, teammates only see each agent\'s folder, status and tokens.';

	/// en: 'Team password'
	String get teamSecret => 'Team password';

	/// en: 'Turns on agent-to-agent messaging: your agent can send messages and files to your teammates' agents, and theirs to yours. Everyone on the team uses the same password; without it, nobody knocks on your door (and farms without it don't show up).'
	String get teamSecretDesc => 'Turns on agent-to-agent messaging: your agent can send messages and files to your teammates\' agents, and theirs to yours. Everyone on the team uses the same password; without it, nobody knocks on your door (and farms without it don\'t show up).';

	/// en: 'agree on a password'
	String get teamSecretPlaceholder => 'agree on a password';

	/// en: 'Who can knock'
	String get teamDoorAllow => 'Who can knock';

	/// en: 'Teammates' names, comma separated. Empty = the whole team.'
	String get teamDoorAllowDesc => 'Teammates\' names, comma separated. Empty = the whole team.';

	/// en: 'whole team'
	String get teamDoorAllowPlaceholder => 'whole team';

	/// en: 'Ask before opening the door'
	String get teamDoorAsk => 'Ask before opening the door';

	/// en: 'When a teammate sends something to one of your agents, GSH asks you before handing it over. Off, your agent gets it directly, marked as information from a teammate (not as an order from you).'
	String get teamDoorAskDesc => 'When a teammate sends something to one of your agents, GSH asks you before handing it over. Off, your agent gets it directly, marked as information from a teammate (not as an order from you).';

	/// en: 'Work network'
	String get teamNetwork => 'Work network';

	/// en: 'The office network's IP range (e.g. 192.168.10.0/24). When set, GSH only announces and listens while you're on it.'
	String get teamNetworkDesc => 'The office network\'s IP range (e.g. 192.168.10.0/24). When set, GSH only announces and listens while you\'re on it.';

	/// en: 'any local network'
	String get teamNetworkPlaceholder => 'any local network';

	/// en: 'Farm scenery'
	String get farmScenery => 'Farm scenery';

	/// en: 'Where the agents live: the farm or a pixel art office.'
	String get farmSceneryDesc => 'Where the agents live: the farm or a pixel art office.';

	/// en: 'Farm'
	String get sceneryFarm => 'Farm';

	/// en: 'Office'
	String get sceneryOffice => 'Office';

	/// en: 'Agent graph'
	String get graph => 'Agent graph';

	/// en: 'Visualize the agents of the workspace and who talks to whom.'
	String get graphDesc => 'Visualize the agents of the workspace and who talks to whom.';

	/// en: 'Built-in browser'
	String get browser => 'Built-in browser';

	/// en: '"Browser" tab in the pane menu (where the platform has an inline webview).'
	String get browserDesc => '"Browser" tab in the pane menu (where the platform has an inline webview).';

	/// en: 'Skills moved to '
	String get skillsMoved => 'Skills moved to ';
}

// Path: settings.page.designSystems
class Translations$settings$page$designSystems$en {
	Translations$settings$page$designSystems$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Design systems'
	String get title => 'Design systems';

	/// en: 'In GSH these are the themes: interface, terminal and code colors in one package.'
	String get desc => 'In GSH these are the themes: interface, terminal and code colors in one package.';

	/// en: 'New design system'
	String get add => 'New design system';

	/// en: 'Search by name'
	String get search => 'Search by name';

	/// en: 'Showing ${n} of ${total}'
	String showing({required Object n, required Object total}) => 'Showing ${n} of ${total}';

	/// en: 'Name'
	String get colName => 'Name';

	/// en: 'Origin'
	String get colOrigin => 'Origin';

	/// en: 'Author'
	String get colAuthor => 'Author';

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'Imported'
	String get imported => 'Imported';

	/// en: 'Built-in'
	String get builtIn => 'Built-in';

	/// en: 'Use this theme'
	String get activate => 'Use this theme';

	/// en: 'Remove'
	String get remove => 'Remove';
}

// Path: settings.page.nav.groups
class Translations$settings$page$nav$groups$en {
	Translations$settings$page$nav$groups$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'This computer'
	String get thisComputer => 'This computer';

	/// en: 'Personalization'
	String get personalization => 'Personalization';

	/// en: 'Platform'
	String get platform => 'Platform';

	/// en: 'GSH Desktop'
	String get app => 'GSH Desktop';
}

// Path: settings.page.general.updateFrequency
class Translations$settings$page$general$updateFrequency$en {
	Translations$settings$page$general$updateFrequency$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Daily'
	String get daily => 'Daily';

	/// en: 'Weekly'
	String get weekly => 'Weekly';

	/// en: 'Monthly'
	String get monthly => 'Monthly';

	/// en: 'Never'
	String get never => 'Never';
}

// Path: settings.page.claude.error
class Translations$settings$page$claude$error$en {
	Translations$settings$page$claude$error$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Claude Code CLI (`claude`) not found on this computer.'
	String get cliMissing => 'Claude Code CLI (`claude`) not found on this computer.';

	/// en: 'The `claude` CLI took too long to answer.'
	String get timeout => 'The `claude` CLI took too long to answer.';

	/// en: 'The `claude` CLI failed: ${detail}'
	String failed({required Object detail}) => 'The `claude` CLI failed: ${detail}';
}

// Path: settings.page.usage.plans
class Translations$settings$page$usage$plans$en {
	Translations$settings$page$usage$plans$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Pro'
	String get pro => 'Pro';

	/// en: 'Max'
	String get max => 'Max';

	/// en: 'Team'
	String get team => 'Team';

	/// en: 'Enterprise'
	String get enterprise => 'Enterprise';
}

// Path: settings.page.connectors.status
class Translations$settings$page$connectors$status$en {
	Translations$settings$page$connectors$status$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Connected'
	String get connected => 'Connected';

	/// en: 'Needs authentication'
	String get needsAuth => 'Needs authentication';

	/// en: 'Failed'
	String get failed => 'Failed';

	/// en: 'Pending approval'
	String get pending => 'Pending approval';

	/// en: 'Unknown'
	String get unknown => 'Unknown';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'core.bootstrapError.title' => 'Failed to initialize GSH Desktop',
			'core.bootstrapError.retry' => 'Retry',
			'core.macosNotifications.title' => 'Enable Notifications on macOS',
			'core.macosNotifications.intro' => 'Notifications are currently disabled in your system settings. Follow the steps below to enable them:',
			'core.macosNotifications.step1' => 'Open System Settings on your Mac.',
			'core.macosNotifications.step2' => 'Navigate to the Notifications section in the left sidebar.',
			'core.macosNotifications.step3' => 'Find and select the GSH Desktop application from the list.',
			'core.macosNotifications.step4' => 'Toggle the Allow Notifications switch on.',
			'core.macosNotifications.tip' => 'Tip: If the app does not appear in the list, close and reopen it to trigger its registration in the system.',
			'core.macosNotifications.gotIt' => 'Got it',
			'core.appErrorView.renderFailed' => 'This part of the app failed to render',
			'core.appErrorView.details' => 'Details',
			'core.appErrorView.renderErrorTitle' => 'Render error',
			'core.errorReportDialog.defaultDescription' => 'Something went wrong. The details below were saved to the log — you can report them so it gets fixed.',
			'core.errorReportDialog.copyDetails' => 'Copy details',
			'core.errorReportDialog.reportIssue' => 'Report issue',
			'core.windowControls.minimize' => 'Minimize',
			'core.windowControls.maximize' => 'Maximize',
			'core.windowControls.close' => 'Close',
			'core.crash.title' => 'Unexpected shutdown',
			'core.crash.bannerTitle' => 'GSH Desktop closed unexpectedly',
			'core.crash.report' => 'Report',
			'core.crash.dismiss' => 'Dismiss',
			'core.crash.crashMessage' => ({required Object version}) => 'The previous session (version ${version}) ended without shutting down cleanly. Want to report it? The log is included and you can review everything before sending.',
			'core.crash.crashError' => ({required Object startedAt, required Object pid}) => 'Session started at ${startedAt} (pid ${pid}) ended without a clean shutdown.',
			'core.crash.crashDescription' => 'No error was captured — the app was terminated by the system. The log below is from that session and is the most useful part.',
			'core.menu.settings' => 'Settings…',
			'core.menu.checkForUpdates' => 'Check for Updates…',
			'core.menu.file' => 'File',
			'core.menu.newTerminal' => 'New Terminal',
			'core.menu.newChat' => 'New Chat',
			'core.menu.newChatRight' => 'New Chat to the Right',
			'core.menu.openWorkspace' => 'Open Workspace',
			'core.menu.save' => 'Save',
			'core.menu.discard' => 'Discard',
			'core.menu.format' => 'Format',
			'core.menu.view' => 'View',
			'core.menu.toggleWorkspacePanel' => 'Toggle Workspace Panel',
			'core.menu.toggleFiles' => 'Toggle Files',
			'core.menu.splitRight' => 'Split Right',
			'core.menu.splitDown' => 'Split Down',
			'core.menu.focusPane' => 'Focus Pane',
			'core.menu.focusLeft' => 'Left  (⌘⌥←)',
			'core.menu.focusRight' => 'Right  (⌘⌥→)',
			'core.menu.focusUp' => 'Up  (⌘⌥↑)',
			'core.menu.focusDown' => 'Down  (⌘⌥↓)',
			'core.menu.selectTab' => 'Select Tab',
			'core.menu.tabN' => ({required Object n}) => 'Tab ${n}',
			'core.menu.lastTab' => 'Last Tab',
			'core.menu.previousWorkspace' => 'Previous Workspace',
			'core.menu.nextWorkspace' => 'Next Workspace',
			'core.menu.zoomIn' => 'Zoom In',
			'core.menu.zoomOut' => 'Zoom Out',
			'core.menu.actualSize' => 'Actual Size',
			'core.menu.window' => 'Window',
			'core.menu.quit' => 'Quit',
			'core.menu.minimize' => 'Minimize',
			'core.menu.zoom' => 'Zoom',
			'common.cancel' => 'Cancel',
			'common.confirm' => 'Confirm',
			'common.create' => 'Create',
			'common.gotIt' => 'Got it',
			'common.save' => 'Save',
			'common.close' => 'Close',
			'common.delete' => 'Delete',
			'common.done' => 'Done',
			'common.add' => 'Add',
			'common.test' => 'Test',
			'common.ok' => 'OK',
			'common.loading' => 'Loading…',
			'common.checking' => 'Checking…',
			'common.remove' => 'Remove',
			'common.restart' => 'Restart',
			'common.settings' => 'Settings',
			'common.send' => 'Send',
			'common.open' => 'Open',
			'common.dismiss' => 'Dismiss',
			'common.report' => 'Report',
			'common.copyCode' => 'Copy code',
			'common.search' => 'Search',
			'common.noResults' => 'No results',
			'gsh.confirmDialog.unsavedChangesTitle' => 'Unsaved changes',
			'gsh.confirmDialog.unsavedChangesMessage' => ({required Object fileName}) => '“${fileName}” has unsaved changes. Save them before closing?',
			'gsh.confirmDialog.dontSave' => 'Don\'t save',
			'gsh.confirmDialog.saveAndClose' => 'Save & close',
			'gsh.neovim.unavailable' => 'Neovim is not available. Opening in GSH Desktop instead.',
			'gsh.neovim.openFailed' => 'Could not reach Neovim. Opening in GSH Desktop instead.',
			'gsh.neovim.unsavedTitle' => 'Unsaved Neovim buffers',
			'gsh.neovim.unsavedMessage' => 'Neovim has modified buffers. Close the tab and discard those changes?',
			'gsh.neovim.closeAnyway' => 'Close anyway',
			'gsh.worktreeCreateDialog.forkTitle' => 'Fork worktree',
			'gsh.worktreeCreateDialog.createTitle' => 'Create worktree',
			'gsh.worktreeCreateDialog.forkSubtitle' => ({required Object root}) => 'New worktree branched from ${root}.',
			'gsh.worktreeCreateDialog.createSubtitle' => ({required Object root}) => 'New feature in ${root} — new branch from the current HEAD.',
			'gsh.worktreeCreateDialog.namePlaceholder' => 'feat/minha-feature',
			'gsh.worktreeCreateDialog.errorWhitespace' => 'No spaces in the name.',
			'gsh.worktreeCreateDialog.errorInvalidChar' => 'Invalid character for a branch name.',
			'gsh.worktreeCreateDialog.errorInvalidSequence' => 'Invalid sequence (e.g. "..", "//", starting/ending with "/").',
			'gsh.worktreeCreateDialog.errorReserved' => 'Reserved position (do not start with "-"/"." or end with ".lock").',
			'gsh.worktreeCreateDialog.errorDuplicateBranch' => 'A branch with that name already exists.',
			'gsh.worktreeCreateDialog.errorDuplicateWorktree' => 'A worktree with that name already exists.',
			'gsh.worktreeCreateDialog.errorBranchHierarchyConflict' => ({required Object target, required Object existing}) => 'Cannot create branch \'${target}\' because it conflicts with the existing branch \'${existing}\'.',
			'gsh.worktreeCreateDialog.errorBranchHierarchicalConflictGeneral' => 'A branch with a conflicting hierarchy already exists.',
			'gsh.worktreeCreateDialog.fork' => 'Fork',
			'gsh.worktreeCreateDialog.postCheckoutHint' => 'This repository has a post-checkout hook.',
			'gsh.worktreeCreateDialog.running' => 'Running…',
			'gsh.worktreeCreateDialog.advancedSettings' => 'Advanced Settings',
			'gsh.worktreeCreateDialog.copyIgnored' => 'Copy ignored files (.gitignore)',
			'gsh.worktreeCreateDialog.copyIgnoredDesc' => 'Copies files ignored by .gitignore (e.g. .env, local keys) to the new worktree.',
			'gsh.worktreeCreateDialog.copyUntracked' => 'Copy untracked files',
			'gsh.worktreeCreateDialog.copyUntrackedDesc' => 'Copies new or modified files that haven\'t been staged yet.',
			'gsh.worktreeCreateDialog.baseBranch' => 'Base branch',
			'gsh.worktreeCreateDialog.baseBranchDesc' => 'The branch from which the new worktree and branch will be created.',
			'gsh.worktreeCreateDialog.fetchRemote' => 'Fetch remote branch',
			'gsh.worktreeCreateDialog.fetchRemoteDesc' => 'Run git fetch to guarantee the base branch is confirmed before creating the worktree.',
			'gsh.worktreeCreateDialog.searchBranch' => 'Search branch...',
			'gsh.worktreeCreateDialog.back' => 'Back',
			'gsh.commitMessageDialog.commitTitle' => 'Commit',
			'gsh.commitMessageDialog.stageAndCommitTitle' => 'Stage and Commit',
			'gsh.commitMessageDialog.scopeNote' => ({required Object fileName}) => 'Commit "${fileName}" only.',
			'gsh.commitMessageDialog.placeholder' => 'fix: short summary of the change',
			'gsh.commitMessageDialog.errorEmptySubject' => 'The first line (subject) cannot be empty.',
			'gsh.commitMessageDialog.errorTooShort' => ({required Object min}) => 'Subject too short (min ${min} characters).',
			'gsh.commitMessageDialog.errorTooLong' => ({required Object max}) => 'Subject too long (max ${max} characters).',
			'gsh.commitMessageDialog.errorTrailingPeriod' => 'Subject should not end with a period.',
			'gsh.commitMessageDialog.errorControlChars' => 'Subject contains control characters.',
			'gsh.commitMessageDialog.errorBlankSecondLine' => 'Leave the second line blank (git subject/body separator).',
			'gsh.commitMessageDialog.generate' => 'Generate commit message',
			'gsh.commitMessageDialog.generateWith' => ({required Object harness}) => 'Generate with ${harness}',
			'gsh.commitMessageDialog.generating' => 'Generating…',
			'gsh.commitMessageDialog.cancelGeneration' => 'Cancel generation',
			'gsh.tasksPanel.reloadTasksTooltip' => 'Reload tasks',
			'gsh.tasksPanel.restartTooltip' => 'Restart',
			'gsh.tasksPanel.stopTooltip' => 'Stop',
			'gsh.tasksPanel.runTooltip' => 'Run',
			'gsh.tasksPanel.sendsKeyTooltip' => ({required Object label, required Object key}) => '${label} (sends \'${key}\')',
			'gsh.tasksPanel.startingTooltip' => 'Starting…',
			'gsh.tasksPanel.stoppingTooltip' => 'Stopping…',
			'gsh.tasksPanel.switchProfileTooltip' => 'Switch profile',
			'gsh.tasksPanel.moreKeysTooltip' => 'More keys',
			'gsh.tasksPanel.sectionTasks' => 'TASKS',
			'gsh.tasksPanel.noTasks' => 'No tasks detected in this project.',
			'gsh.tasksPanel.createTasksJson' => 'Create tasks.json',
			'gsh.tasksPanel.generateComposeTasks' => 'Generate Compose tasks',
			'gsh.tasksPanel.selectComposeEngine' => 'Choose a Compose engine',
			'gsh.tasksPanel.noComposeEngine' => 'Docker Compose or Podman Compose was not found.',
			'gsh.tasksPanel.invalidComposeFile' => 'The active file is not a valid Compose file with services.',
			'gsh.tasksPanel.invalidTasksJson' => 'tasks.json is invalid. No changes were written.',
			'gsh.tasksPanel.composeConflicts' => ({required Object labels}) => 'Kept non-Compose tasks with conflicting labels: ${labels}',
			'gsh.gshPage.chooseProjectFolderDialogTitle' => 'Choose the project folder',
			'gsh.gshPage.chooseWorkspaceFolderDialogTitle' => 'Choose the workspace folder',
			'gsh.gshPage.workspaceRenamedTitle' => 'Workspace renamed',
			'gsh.gshPage.workspaceRenamedMessage' => ({required Object name}) => 'The new name "${name}" will only be sent to agents after restarting the workspace or the application.',
			'gsh.gshPage.syncTitle' => ({required Object label}) => 'Sync — ${label}',
			'gsh.gshPage.pullTitle' => ({required Object label}) => 'Pull — ${label}',
			'gsh.gshPage.pushTitle' => ({required Object label}) => 'Push — ${label}',
			'gsh.gshPage.updateFromParentTitle' => ({required Object name}) => 'Update from Parent — ${name}',
			'gsh.gshPage.mergeToParentTitle' => ({required Object name}) => 'Merge to Parent — ${name}',
			'gsh.gshPage.worktreeMergedAndRemoved' => 'Worktree merged and removed.',
			'gsh.gshPage.nothingWasChanged' => 'Nothing was changed.',
			'gsh.gshPage.newRealmTitle' => 'New realm',
			'gsh.gshPage.closeWorkspaceTitle' => 'Close workspace',
			'gsh.gshPage.closeWorkspaceMessage' => ({required Object name}) => 'Close "${name}"? The agents in this workspace will be terminated. The folder on disk is kept.',
			'gsh.gshPage.closeAction' => 'Close',
			'gsh.gshPage.removeWorktreeTitle' => 'Remove worktree',
			'gsh.gshPage.removeWorktreeMessage' => ({required Object name, required Object warn}) => 'Remove "${name}"? The worktree folder and the branch will be deleted and the agents in this fork will be terminated.${warn}',
			'gsh.gshPage.removeWorktreeWarning' => ({required Object name}) => '\n\nWarning: the branch "${name}" has not been merged yet — removing it (git branch -D) discards the unmerged work.',
			'gsh.gshPage.failedToRemoveWorktreeTitle' => 'Failed to remove worktree',
			'gsh.gshPage.openLayoutTitle' => 'Open layout',
			'gsh.gshPage.replaceLayoutTitle' => 'Replace the current layout?',
			'gsh.gshPage.replaceLayoutMessage' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 tab will be closed, including one with a running process.', other: '${n} tabs will be closed, including ones with running processes.', ), 
			'gsh.gshPage.replaceLayoutConfirm' => 'Replace',
			'gsh.gshPage.restartServerTooltip' => 'Restart server',
			'gsh.gshPage.noLspAvailable' => 'No LSP available',
			'gsh.gshPage.lspRunning' => 'running',
			'gsh.gshPage.lspStopped' => 'stopped',
			'gsh.welcomeView.title' => 'Welcome to GSH Desktop',
			'gsh.welcomeView.subtitle' => 'Open a folder or connect to a remote host to start.',
			'gsh.welcomeView.createWorkspace' => 'Create workspace',
			'gsh.welcomeView.openLocalFolder' => 'Open local folder',
			'gsh.welcomeView.connectHost' => 'Connect to host',
			'gsh.welcomeView.configureHost' => 'Configure host',
			'gsh.welcomeView.addWorkspace' => 'Add workspace',
			'gsh.paneView.closePaneTitle' => 'Close pane?',
			'gsh.paneView.closePaneMessage' => ({required Object count}) => 'This closes all ${count} tab(s) in this pane and ends the agents/terminals in it.',
			'gsh.paneView.close' => 'Close',
			'gsh.paneView.closeOtherTabs' => 'Close others',
			'gsh.paneView.closeTabsToTheRight' => 'Close to the right',
			'gsh.paneView.closeAllTabs' => 'Close all',
			'gsh.paneView.closeTabsTitle' => 'Close tabs?',
			'gsh.paneView.closeTabsMessage' => ({required Object count}) => 'This closes ${count} tab(s) and ends the agents/terminals in them.',
			'gsh.paneView.allTabs' => 'All tabs',
			'gsh.paneView.pinTab' => 'Pin tab',
			'gsh.paneView.openInNewWindow' => 'Open in new window',
			'gsh.paneView.rename' => 'Rename',
			'gsh.paneView.openAsMarkdown' => 'Open as markdown',
			'gsh.paneView.openAsBoard' => 'Open as board',
			'gsh.paneView.resetTitle' => 'Reset Title',
			'gsh.paneView.copyId' => 'Copy Id',
			'gsh.paneView.restartTab' => 'Restart',
			'gsh.paneView.newTab' => 'New tab',
			'gsh.paneView.newTerminal' => 'New terminal…',
			'gsh.paneView.splitRight' => 'Split right',
			'gsh.paneView.splitDown' => 'Split down',
			'gsh.paneView.closePane' => 'Close pane',
			'gsh.paneView.dropHereToMove' => 'Drop here to move the tab',
			'gsh.paneView.dockAsTab' => 'Dock as tab',
			'gsh.paneView.openBrowser' => 'Open browser',
			'gsh.paneView.openTerminal' => 'Open terminal',
			'gsh.paneView.openAsLayout' => 'Open as layout',
			'gsh.paneView.openAsYaml' => 'Open as YAML',
			'gsh.paneView.openAsPanel' => 'Open as panel',
			'gsh.paneView.openAsHtml' => 'Open as HTML',
			'gsh.fileTreePanel.viewDiff' => 'View Diff',
			'gsh.fileTreePanel.commit' => 'Commit',
			'gsh.fileTreePanel.stageAndCommit' => 'Stage and Commit',
			'gsh.fileTreePanel.unstage' => 'Unstage',
			'gsh.fileTreePanel.stageChanges' => 'Stage Changes',
			'gsh.fileTreePanel.discardChanges' => 'Discard Changes',
			'gsh.fileTreePanel.enterCommitMessage' => 'Enter a commit message.',
			'gsh.fileTreePanel.commitUnavailable' => 'Commit is unavailable for this workspace.',
			'gsh.fileTreePanel.gitErrorTitle' => 'Git error',
			'gsh.fileTreePanel.deleteNewFileTitle' => 'Delete new file?',
			'gsh.fileTreePanel.discardChangesTitle' => 'Discard changes?',
			'gsh.fileTreePanel.deleteNewFileMessage' => ({required Object name}) => '"${name}" is a new file and cannot be restored. Delete it?',
			'gsh.fileTreePanel.discardOneMessage' => ({required Object name}) => 'Discard all changes in "${name}"? Deleted files will be restored.',
			'gsh.fileTreePanel.discard' => 'Discard',
			'gsh.fileTreePanel.deleteAllNewFilesTitle' => 'Delete all new files?',
			'gsh.fileTreePanel.allNewFilesMessage' => ({required Object count}) => 'All ${count} files are new and will be deleted. This cannot be undone.',
			'gsh.fileTreePanel.discardTrackedMessage' => ({required Object count, required Object extra}) => 'Discard changes in ${count} tracked file(s)?${extra}',
			'gsh.fileTreePanel.discardTrackedExtra' => ({required Object count}) => ' ${count} new file(s) will be kept.',
			'gsh.fileTreePanel.deleteAll' => 'Delete All',
			'gsh.fileTreePanel.deleteQuestionTitle' => 'Delete?',
			'gsh.fileTreePanel.moveToTrash' => ({required Object name}) => 'Move “${name}” to the Trash?',
			'gsh.fileTreePanel.permanentlyDelete' => ({required Object name}) => 'Permanently delete “${name}”? This can’t be undone.',
			'gsh.fileTreePanel.couldNotDeleteTitle' => 'Could not delete',
			'gsh.fileTreePanel.moveQuestionTitle' => 'Move?',
			'gsh.fileTreePanel.moveMessage' => ({required Object name, required Object dest}) => 'Move “${name}” to “${dest}”?',
			'gsh.fileTreePanel.moveAction' => 'Move',
			'gsh.fileTreePanel.couldNotMoveTitle' => 'Could not move',
			'gsh.fileTreePanel.couldNotPasteTitle' => 'Could not paste',
			'gsh.fileTreePanel.filesTooltip' => 'Files',
			'gsh.fileTreePanel.searchTooltip' => 'Search',
			'gsh.fileTreePanel.sourceControlTooltip' => 'Source Control',
			'gsh.fileTreePanel.databaseTooltip' => 'Database',
			'gsh.fileTreePanel.sectionFiles' => 'FILES',
			'gsh.fileTreePanel.newFile' => 'New file',
			'gsh.fileTreePanel.newFolder' => 'New folder',
			'gsh.fileTreePanel.refreshTooltip' => 'Refresh',
			'gsh.fileTreePanel.agentFilterTooltip' => 'Filter by agent',
			'gsh.fileTreePanel.allAgents' => 'All agents',
			'gsh.fileTreePanel.trackingUnavailable' => 'tracking unavailable',
			'gsh.fileTreePanel.editedBy' => ({required Object label, required Object time}) => 'Edited by ${label} · ${time}',
			'gsh.fileTreePanel.inferredSuffix' => '(inferred)',
			'gsh.fileTreePanel.noTouchedFiles' => 'No files touched by this agent yet',
			'gsh.fileTreePanel.concurrentAgentEdits' => 'Edited by 2+ agents in the last 10 minutes',
			'gsh.fileTreePanel.collapseAll' => 'Collapse all folders',
			'gsh.fileTreePanel.sectionSourceControl' => 'SOURCE CONTROL',
			'gsh.fileTreePanel.viewAsList' => 'View as List',
			'gsh.fileTreePanel.viewAsTree' => 'View as Tree',
			'gsh.fileTreePanel.noFolderMessage' => 'No folder — open a workspace.',
			'gsh.fileTreePanel.amend' => 'Amend',
			'gsh.fileTreePanel.commitMessagePlaceholder' => 'Commit Message',
			'gsh.fileTreePanel.amendCommit' => 'Amend Commit',
			'gsh.fileTreePanel.lastCommit' => 'last commit',
			'gsh.fileTreePanel.openInFinder' => 'Open in Finder',
			'gsh.fileTreePanel.openInExplorer' => 'Open in Explorer',
			'gsh.fileTreePanel.openInFileManager' => 'Open in file manager',
			'gsh.fileTreePanel.open' => 'Open',
			'gsh.fileTreePanel.openWith' => 'Open with',
			'gsh.fileTreePanel.openInNewWindow' => 'Open in new window',
			'gsh.fileTreePanel.openLayout' => 'Open layout',
			'gsh.fileTreePanel.openAsMarkdown' => 'Open as markdown',
			'gsh.fileTreePanel.showGitDiff' => 'Show git diff',
			'gsh.fileTreePanel.createTerminal' => 'Open terminal',
			'gsh.fileTreePanel.rename' => 'Rename',
			'gsh.fileTreePanel.copy' => 'Copy',
			'gsh.fileTreePanel.cut' => 'Cut',
			'gsh.fileTreePanel.paste' => 'Paste',
			'gsh.fileTreePanel.copyRelativePath' => 'Copy relative path',
			'gsh.fileTreePanel.copyAbsolutePath' => 'Copy absolute path',
			'gsh.fileTreePanel.renameFailed' => 'Rename failed.',
			'gsh.fileTreePanel.noChanges' => 'No changes.',
			'gsh.fileTreePanel.stagedChangesHeader' => ({required Object count}) => 'STAGED CHANGES (${count})',
			'gsh.fileTreePanel.changesHeader' => ({required Object count}) => 'CHANGES (${count})',
			'gsh.fileTreePanel.discardAllChanges' => 'Discard All Changes',
			'gsh.fileTreePanel.unstageAllChanges' => 'Unstage All Changes',
			'gsh.fileTreePanel.stageAllChanges' => 'Stage All Changes',
			'gsh.fileTreePanel.discardFolderChanges' => 'Discard Folder Changes',
			'gsh.fileTreePanel.unstageFolderChanges' => 'Unstage Folder Changes',
			'gsh.fileTreePanel.stageFolderChanges' => 'Stage Folder Changes',
			'gsh.fileTreePanel.generateCommitMessage' => 'Generate commit message',
			'gsh.fileTreePanel.generateWith' => ({required Object harness}) => 'Generate with ${harness}',
			'gsh.fileTreePanel.generateUnavailableWhileAmending' => 'Unavailable while amending a commit',
			'gsh.fileTreePanel.cancelGeneration' => 'Cancel generation',
			'gsh.fileTreePanel.changes' => 'Changes',
			'gsh.fileTreePanel.history' => 'History',
			'gsh.fileTreePanel.historyRepository' => 'Repository',
			'gsh.fileTreePanel.historyNoRepository' => 'No Git repository available.',
			'gsh.fileTreePanel.historyEmpty' => 'No commits found.',
			'gsh.fileTreePanel.historyLoadFailed' => 'Could not load Git history.',
			'gsh.fileTreePanel.historyUntitledCommit' => 'Untitled commit',
			'gsh.fileTreePanel.historyNow' => 'now',
			'gsh.fileTreePanel.historyMinutesAgo' => ({required Object count}) => '${count}m ago',
			'gsh.fileTreePanel.historyHoursAgo' => ({required Object count}) => '${count}h ago',
			'gsh.fileTreePanel.historyYesterday' => 'yesterday',
			'gsh.fileTreePanel.historyDayAgo' => '1d ago',
			'gsh.fileTreePanel.historyDaysAgo' => ({required Object count}) => '${count}d ago',
			'gsh.fileTreePanel.historyFiles' => 'Files changed',
			'gsh.fileTreePanel.historyFilesEmpty' => 'No files changed.',
			'gsh.fileTreePanel.historyFilesLoadFailed' => 'Could not load changed files.',
			'gsh.fileTreePanel.diffEmptyTree' => 'Empty tree',
			'gsh.fileTreePanel.diffOriginal' => ({required Object ref}) => 'Original ${ref}',
			'gsh.fileTreePanel.diffModified' => ({required Object ref}) => 'Modified ${ref}',
			'gsh.fileTreePanel.diffWorkingTree' => 'Working tree',
			'gsh.fileTreePanel.diffBinaryFile' => 'Binary file - no text diff.',
			'gsh.fileTreePanel.diffNoChanges' => 'No changes.',
			'gsh.fileTreePanel.diffError' => ({required Object detail}) => 'Could not read the diff: ${detail}',
			'gsh.fileTreePanel.galleryTooltip' => 'Gallery',
			'gsh.fileTreePanel.sectionGallery' => 'GALLERY',
			'gsh.fileTreePanel.openAsHtml' => 'Open as HTML',
			'gsh.fileTreePanel.importQuestionTitle' => 'Copy here?',
			'gsh.fileTreePanel.importMessage' => ({required Object count, required Object dest}) => 'Copy ${count} items into “${dest}”?',
			'gsh.fileTreePanel.importAction' => 'Copy',
			'gsh.fileTreePanel.couldNotImportTitle' => 'Could not copy',
			'gsh.fileTreePanel.openInAgent' => ({required Object harness}) => 'Open in ${harness}',
			'gsh.fileViewer.cantOpen' => 'Can\'t open this file.',
			'gsh.fileViewer.couldNotLoadImage' => 'Could not load the image.',
			'gsh.fileViewer.preview' => 'Preview',
			'gsh.fileViewer.source' => 'Source',
			'gsh.fileViewer.reload' => 'Reload',
			'gsh.workspaceSettingsDialog.choosePhotoTitle' => 'Choose workspace photo',
			'gsh.workspaceSettingsDialog.title' => 'Workspace settings',
			'gsh.workspaceSettingsDialog.namePlaceholder' => 'Workspace name',
			'gsh.workspaceSettingsDialog.addPhoto' => 'Add photo',
			'gsh.workspaceSettingsDialog.changePhoto' => 'Change photo',
			'gsh.workspaceSettingsDialog.remove' => 'Remove',
			'gsh.workspaceSettingsDialog.color' => 'Color',
			'gsh.workspaceSettingsDialog.host' => 'Host',
			'gsh.workspaceSettingsDialog.folder' => 'Folder',
			'gsh.realmDialogs.namePlaceholder' => 'Realm name',
			'gsh.realmDialogs.duplicateName' => 'A realm with this name already exists.',
			'gsh.realmDialogs.newRealmTitle' => 'New realm',
			'gsh.realmDialogs.renameRealmTitle' => 'Rename realm',
			'gsh.realmDialogs.rename' => 'Rename',
			'gsh.realmDialogs.deleteRealmTitle' => 'Delete realm',
			'gsh.realmDialogs.deleteMessage' => ({required Object name, required Object suffix}) => 'Delete "${name}"? No workspace is deleted — the folder list just changes.${suffix}',
			'gsh.realmDialogs.deleteSuffixOne' => ' Its workspace will move to Default.',
			'gsh.realmDialogs.deleteSuffixMany' => ({required Object count}) => ' Its ${count} workspaces will move to Default.',
			'gsh.realmDialogs.manageRealmsTitle' => 'Manage realms',
			'gsh.realmDialogs.workspaceCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 workspace', other: '${n} workspaces', ), 
			'gsh.dbRedisTable.deleteKeyTitle' => 'Delete key',
			'gsh.dbRedisTable.deleteKeyMessage' => ({required Object key}) => 'Delete "${key}" from this Redis database?',
			'gsh.dbRedisTable.refresh' => 'Refresh',
			'gsh.dbRedisTable.newKey' => 'New key',
			'gsh.dbRedisTable.columnKey' => 'KEY',
			'gsh.dbRedisTable.columnValue' => 'VALUE',
			'gsh.dbRedisTable.columnType' => 'TYPE',
			'gsh.dbRedisTable.columnTtl' => 'TTL',
			'gsh.dbRedisTable.keyCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 key', other: '${n} keys', ), 
			'gsh.dbRedisTable.noKeys' => 'No keys in this database.',
			'gsh.dbRedisTable.noKeysMatch' => ({required Object pattern}) => 'No keys match "${pattern}".',
			'gsh.dbRedisTable.loadMore' => 'Load more',
			'gsh.dbRedisTable.loadingFullValue' => 'Loading full value…',
			'gsh.dbRedisTable.ttlMustBeNumber' => 'TTL must be a number of seconds.',
			'gsh.dbRedisTable.addKey' => 'Add key',
			'gsh.dbRedisTable.keyFieldHint' => 'key',
			'gsh.dbRedisTable.ttlFieldHint' => 'ttl (s, optional)',
			'gsh.dbRedisTable.valueFieldHint' => 'value',
			'gsh.dbRedisTable.searchHint' => 'Search — pattern, e.g. user:*',
			'gsh.dbQueryView.saveQueryAs' => 'Save query as',
			'gsh.dbQueryView.couldNotSave' => 'Could not save',
			'gsh.dbQueryView.selectDatabase' => 'Select database',
			'gsh.dbQueryView.noSqlConnections' => 'No SQL connections',
			'gsh.dbQueryView.running' => 'Running…',
			'gsh.dbQueryView.runSelection' => 'Run selection',
			'gsh.dbQueryView.run' => 'Run',
			'gsh.dbQueryView.pickDatabaseHint' => 'Pick a database above, then Run (⌘↵).',
			'gsh.dbQueryView.runQueryHint' => 'Run the query (⌘↵) to see results here.',
			'gsh.dbQueryView.noRows' => 'No rows.',
			'gsh.dbQueryView.rowsAffected' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 row affected', other: '${n} rows affected', ), 
			'gsh.dbQueryView.rowsFooter' => ({required Object n}) => '${n} rows',
			'gsh.dbQueryView.truncatedSuffix' => ' · truncated (raise -- limit)',
			'gsh.dbQueryView.table' => 'Table',
			'gsh.dbQueryView.json' => 'JSON',
			'gsh.dbQueryView.unsaved' => 'unsaved',
			'gsh.dbQueryView.saved' => 'saved',
			'gsh.dbQueryView.copied' => 'Copied',
			'gsh.dbQueryView.copy' => 'Copy',
			'gsh.httpView.saveRequestAs' => 'Save request as',
			'gsh.httpView.couldNotSave' => 'Could not save',
			'gsh.httpView.run' => 'Run',
			'gsh.httpView.running' => 'Running…',
			'gsh.httpView.noRequests' => 'No request in this file — write one, e.g. GET https://example.com',
			'gsh.httpView.selectRequest' => 'Select request',
			'gsh.httpView.requestCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 request', other: '${n} requests', ), 
			'gsh.httpView.runHint' => 'Run the request (⌘↵) to see the response here.',
			'gsh.httpView.emptyBody' => 'Empty response body.',
			'gsh.httpView.body' => 'JSON',
			'gsh.httpView.headers' => 'Headers',
			'gsh.httpView.raw' => 'Text',
			'gsh.httpView.truncatedSuffix' => ' · truncated (response too large)',
			'gsh.httpView.error.title' => 'Request failed',
			'gsh.httpView.error.noRequest' => 'No request found at the cursor.',
			'gsh.httpView.error.invalidUrl' => ({required Object url}) => 'Invalid URL: ${url}',
			'gsh.httpView.error.unresolvedVariable' => ({required Object name}) => 'Variable {{${name}}} has no value. Declare it with @${name} = … in this file.',
			'gsh.httpView.error.bodyFileMissing' => ({required Object path}) => 'Body file not found: ${path}',
			'gsh.httpView.error.bodyFileUnreadable' => ({required Object path, required Object detail}) => 'Could not read the body file ${path}: ${detail}',
			'gsh.httpView.error.connectionFailed' => ({required Object detail}) => 'Could not reach the server: ${detail}',
			'gsh.httpView.error.connectionFailedNoDetail' => 'Could not reach the server.',
			'gsh.httpView.error.timeout' => ({required Object seconds}) => 'The request timed out after ${seconds}s.',
			'gsh.httpView.error.responseTooLarge' => ({required Object bytes}) => 'The response is larger than the ${bytes} byte limit.',
			'gsh.kanbanView.filter' => 'Filter',
			'gsh.kanbanView.filterTitlePlaceholder' => 'Search titles',
			'gsh.kanbanView.filterLabels' => 'Labels',
			'gsh.kanbanView.filterClear' => 'Clear',
			'gsh.kanbanView.filterDependencies' => 'Dependencies',
			'gsh.kanbanView.filterBlocked' => 'Blocked',
			'gsh.kanbanView.filterReady' => 'Ready',
			'gsh.kanbanView.blockedBy' => 'Blocked by',
			'gsh.kanbanView.addBlocker' => 'Add a blocking card',
			'gsh.kanbanView.searchCards' => 'Search cards',
			'gsh.kanbanView.unknownCard' => 'unknown',
			'gsh.kanbanView.boardView' => 'Board',
			'gsh.kanbanView.listView' => 'List',
			'gsh.kanbanView.refresh' => 'Refresh from disk',
			'gsh.kanbanView.manageLabels' => 'Labels',
			'gsh.kanbanView.labelsTitle' => 'Labels in this board',
			'gsh.kanbanView.labelNamePlaceholder' => 'label name',
			'gsh.kanbanView.labelUsage' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 card', other: '${n} cards', ), 
			'gsh.kanbanView.deleteLabel' => 'Delete label',
			'gsh.kanbanView.newCard' => 'new card',
			'gsh.kanbanView.newCardTitle' => 'New card',
			'gsh.kanbanView.newColumn' => 'New column',
			'gsh.kanbanView.columnNameTitle' => 'Column name',
			'gsh.kanbanView.dragColumn' => 'Drag column',
			'gsh.kanbanView.columnOptions' => 'Column options',
			'gsh.kanbanView.renameColumn' => 'Rename column',
			'gsh.kanbanView.moveColumnLeft' => 'Move left',
			'gsh.kanbanView.moveColumnRight' => 'Move right',
			'gsh.kanbanView.deleteColumn' => 'Delete column',
			'gsh.kanbanView.newCardHere' => 'New card here',
			'gsh.kanbanView.duplicateCard' => 'Duplicate',
			'gsh.kanbanView.cardLabels' => 'Labels',
			'gsh.kanbanView.deleteCard' => 'Delete card',
			'gsh.kanbanView.advance' => 'Move to next column',
			'gsh.kanbanView.advanceHold' => 'Move to next column (hold: move to last column)',
			'gsh.kanbanView.advanceBack' => 'Move back a column',
			'gsh.kanbanView.emptyColumn' => 'No cards',
			'gsh.kanbanView.cardCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 card', other: '${n} cards', ), 
			'gsh.kanbanView.notes' => 'Note',
			'gsh.kanbanView.notesPlaceholder' => 'Write a note',
			'gsh.kanbanView.comments' => 'Comments',
			'gsh.kanbanView.addComment' => 'Add comment',
			'gsh.kanbanView.commentPlaceholder' => 'Write a comment',
			'gsh.kanbanView.noComments' => 'No comments yet',
			'gsh.kanbanView.closeDetail' => 'Close',
			'gsh.kanbanView.notABoard' => 'This file has no ## columns yet — it opens as markdown.',
			'gsh.kanbanView.startBoard' => 'Start a board',
			'gsh.kanbanView.couldNotSave' => 'Could not save the board',
			'gsh.kanbanView.unrecognizedBlock' => 'Not recognized by the parser — drags whole, no inline editing.',
			'gsh.kanbanView.deleteColumnDialog.title' => ({required Object name}) => 'Delete “${name}”?',
			'gsh.kanbanView.deleteColumnDialog.message' => ({required Object count}) => 'This column has ${count}. Choose what happens to them.',
			'gsh.kanbanView.deleteColumnDialog.moveCards' => 'Move to the previous column',
			'gsh.kanbanView.deleteColumnDialog.deleteAll' => 'Delete with the column',
			'gsh.kanbanView.deleteColumnDialog.emptyMessage' => 'This column is empty.',
			'gsh.dbPanel.sectionDatabase' => 'DATABASE',
			'gsh.dbPanel.edit' => 'Edit…',
			'gsh.dbPanel.copyName' => 'Copy name',
			'gsh.dbPanel.newQuery' => 'New query',
			'gsh.dbPanel.browseKeys' => 'Browse keys',
			'gsh.dbPanel.deleteConnectionTitle' => 'Delete connection',
			'gsh.dbPanel.deleteConnectionMessage' => ({required Object name}) => 'Remove "${name}" from this workspace? Any saved password is discarded. .dbq files that reference it are not touched.',
			'gsh.dbPanel.footer' => ({required Object n}) => '.gsh/databases.json · ${n} connections',
			'gsh.dbPanel.footerOne' => '.gsh/databases.json · 1 connection',
			'gsh.dbPanel.noConnections' => 'No connections yet.',
			'gsh.dbPanel.passwordRequired' => 'Password not found on the host. Open this connection and enter it again — it is saved on the machine that runs the database, not on this one.',
			'gsh.dbMongoView.deleteDocumentTitle' => 'Delete document',
			'gsh.dbMongoView.deleteDocumentMessage' => ({required Object id, required Object collection}) => 'Delete the document with _id ${id} from "${collection}"?',
			'gsh.dbMongoView.filterHint' => 'Filter — JSON, e.g. {"status": "active"}',
			'gsh.dbMongoView.docCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 doc', other: '${n} docs', ), 
			'gsh.dbMongoView.refresh' => 'Refresh',
			'gsh.dbMongoView.insertDocument' => 'Insert document',
			'gsh.dbMongoView.noDocuments' => 'No documents in this collection.',
			'gsh.dbMongoView.noDocumentsMatch' => 'No documents match this filter.',
			'gsh.dbMongoView.loadMore' => 'Load more',
			'gsh.dbMongoView.edit' => 'Edit',
			'gsh.dbMongoView.insert' => 'Insert',
			'gsh.dbConnectionDialog.chooseFileTitle' => 'Choose SQLite database',
			'gsh.dbConnectionDialog.file' => 'File',
			'gsh.dbConnectionDialog.chooseFilePlaceholder' => 'Choose a SQLite file…',
			'gsh.dbConnectionDialog.name' => 'Name',
			'gsh.dbConnectionDialog.password' => 'Password',
			'gsh.dbConnectionDialog.savePassword' => 'Save Password',
			'gsh.dbConnectionDialog.allowWrites' => 'Allow writes (agents)',
			'gsh.dbConnectionDialog.allowWritesHint' => 'off = agents can only read via CLI',
			'gsh.dbConnectionDialog.visibleToAgents' => 'Visible to agents',
			'gsh.dbConnectionDialog.visibleToAgentsHint' => 'off = hidden from the CLI, GUI only',
			'gsh.dbConnectionDialog.testing' => 'Testing connection…',
			'gsh.dbConnectionDialog.connectionOk' => 'Connection OK',
			'gsh.dbConnectionDialog.connectionFailed' => 'Connection failed',
			'gsh.dbConnectionDialog.editTitle' => 'Edit connection',
			'gsh.dbConnectionDialog.newTitle' => 'New connection',
			'gsh.dbConnectionDialog.connectionString' => 'Connection string',
			'gsh.dbConnectionDialog.invalidUrl' => 'Not a valid connection URL.',
			'gsh.dbConnectionDialog.sshTunnel' => 'SSH Tunnel',
			'gsh.dbConnectionDialog.sshHost' => 'SSH Host',
			'gsh.dbConnectionDialog.sshPort' => 'SSH Port',
			'gsh.dbConnectionDialog.sshUser' => 'SSH User',
			'gsh.dbConnectionDialog.privateKey' => 'Private key',
			'gsh.dbConnectionDialog.choosePrivateKeyPlaceholder' => 'Choose a private key…',
			'gsh.dbConnectionDialog.choosePrivateKeyDialogTitle' => 'Choose SSH private key',
			_ => null,
		} ?? switch (path) {
			'gsh.dbConnectionDialog.keyPassphrase' => 'Key passphrase',
			'gsh.dbConnectionDialog.savePassphrase' => 'Save passphrase',
			'gsh.dbConnectionDialog.passwordOnHost' => 'The password is stored on the host, not on this machine.',
			'gsh.sshPrompts.unknownSshHostTitle' => 'Unknown SSH host',
			'gsh.sshPrompts.neverConnected' => ({required Object endpoint}) => 'GSH Desktop has never connected to ${endpoint} before.',
			'gsh.sshPrompts.trustHint' => 'Trust it only if this fingerprint matches the server. You can check it on the server with:',
			'gsh.sshPrompts.trust' => 'Trust',
			'gsh.sshPrompts.sshKeyPassphraseTitle' => 'SSH key passphrase',
			'gsh.sshPrompts.unlockMessage' => ({required Object keyPath, required Object connectionName}) => 'Unlock ${keyPath} to connect "${connectionName}".',
			'gsh.sshPrompts.keptInMemoryHint' => 'Kept in memory until GSH Desktop quits. To let agents use this connection, enable "Save passphrase" in the connection.',
			'gsh.sshPrompts.unlock' => 'Unlock',
			'gsh.projectsRail.workspaces' => 'Workspaces',
			'gsh.projectsRail.keepAwakeOn' => 'Keeping this computer awake for remote access. Click to let it sleep again.',
			'gsh.projectsRail.keepAwakeOff' => 'Keep this computer awake for remote access. Off again when GSH Desktop restarts.',
			'gsh.projectsRail.keepAwakeBattery' => 'Keeping awake on battery power. This drains the battery.',
			'gsh.projectsRail.keepAwakeLid' => 'Closing a laptop lid still puts it to sleep.',
			'gsh.projectsRail.newWorkspace' => 'New workspace',
			'gsh.projectsRail.settings' => 'Settings',
			'gsh.projectsRail.mergeToParent' => 'Merge to Parent',
			'gsh.projectsRail.updateFromParent' => 'Update from Parent',
			'gsh.projectsRail.forkWorktree' => 'Fork Worktree',
			'gsh.projectsRail.copyBranch' => 'Copy branch',
			'gsh.projectsRail.remove' => 'Remove',
			'gsh.projectsRail.moveToRealm' => 'Move to realm',
			'gsh.projectsRail.copyWorkspaceId' => 'Copy workspace id',
			'gsh.projectsRail.rename' => 'Rename',
			'gsh.projectsRail.close' => 'Close',
			'gsh.projectsRail.newRealm' => 'New realm…',
			'gsh.projectsRail.manageRealms' => 'Manage realms…',
			'gsh.projectsRail.noWorkspaces' => 'No workspaces yet.',
			'gsh.projectsRail.sync' => 'Sync',
			'gsh.projectsRail.pull' => 'Pull',
			'gsh.projectsRail.push' => 'Push',
			'gsh.projectsRail.createWorktree' => 'Create worktree',
			'gsh.projectsRail.worktreeCount' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 worktree', other: '${n} worktrees', ), 
			'gsh.projectsRail.expandWorktrees' => 'Expand worktrees',
			'gsh.projectsRail.collapseWorktrees' => 'Collapse worktrees',
			'gsh.findBar.find' => 'Find',
			'gsh.findBar.matchCase' => 'Match case',
			'gsh.findBar.wholeWord' => 'Whole word',
			'gsh.findBar.useRegex' => 'Use regular expression',
			'gsh.findBar.previous' => 'Previous (⇧⏎)',
			'gsh.findBar.next' => 'Next (⏎)',
			'gsh.findBar.close' => 'Close (Esc)',
			'gsh.findBar.badPattern' => 'Bad pattern',
			'gsh.findBar.noResults' => 'No results',
			'gsh.contentSearch.sectionSearch' => 'SEARCH',
			'gsh.contentSearch.searchInFiles' => 'Search in files',
			'gsh.contentSearch.matchCase' => 'Match case',
			'gsh.contentSearch.wholeWord' => 'Whole word',
			'gsh.contentSearch.useRegex' => 'Use regular expression',
			'gsh.contentSearch.invalidRegex' => 'Invalid regular expression.',
			'gsh.contentSearch.typeToSearch' => 'Type to search across files.',
			'gsh.contentSearch.searching' => 'Searching…',
			'gsh.contentSearch.noResults' => 'No results.',
			'gsh.topbar.collapseSidebar' => 'Collapse sidebar',
			'gsh.topbar.toggleFiles' => 'Show/hide files',
			'gsh.topbar.filesUnavailable' => 'Files unavailable in GSH Desktop',
			'gsh.topbar.hideKeyboard' => 'Hide keyboard',
			'gsh.topbar.visualizeAgents' => 'Visualize agents',
			'gsh.topbar.openHarness' => 'Workspace harness',
			'gsh.topbar.openFarm' => 'Agent farm',
			'gsh.topbar.openChat' => 'Chat with Claude (beta)',
			'gsh.tasks.hotReload' => 'Hot reload',
			'gsh.tasks.hotRestart' => 'Hot restart',
			'gsh.tasks.toggleDebugPaint' => 'Toggle debug paint',
			'gsh.tasks.togglePlatform' => 'Toggle platform',
			'gsh.tasks.quit' => 'Quit',
			'gsh.notifications.agentFinished' => 'Agent finished',
			'gsh.notifications.open' => 'Open',
			'gsh.notifications.agentNeedsAction' => 'Agent needs your input',
			'gsh.terminalLink.open' => 'Open',
			'gsh.terminalLink.revealFinder' => 'Reveal in Finder',
			'gsh.terminalLink.revealExplorer' => 'Show in Explorer',
			'gsh.terminalLink.revealFolder' => 'Open containing folder',
			'gsh.terminalLink.copyPath' => 'Copy path',
			'gsh.terminalLink.openLink' => 'Open link',
			'gsh.terminalLink.copyLink' => 'Copy link',
			'gsh.terminal.cwdFallbackWarning' => ({required Object requested, required Object path}) => 'Warning: the folder "${requested}" does not exist. This terminal opened in "${path}".',
			'gsh.terminal.workspaceEnvTracked' => ({required Object keys}) => 'Notice: .env.gsh is tracked by git (it came with the repository). Injected: ${keys}',
			'gsh.remoteHost.addHost' => 'Add remote host',
			'gsh.remoteHost.hostName' => 'Name',
			'gsh.remoteHost.sshTarget' => 'SSH target (user@host)',
			'gsh.remoteHost.connecting' => ({required Object host}) => 'Connecting to ${host}…',
			'gsh.remoteHost.openingTunnel' => 'SSH tunnel',
			'gsh.remoteHost.installingServer' => 'Installing server',
			'gsh.remoteHost.handshake' => ({required Object version}) => 'Server ${version}',
			'gsh.remoteHost.loadingWorkspace' => 'Loading workspace…',
			'gsh.remoteHost.reconnecting' => ({required Object host}) => 'Reconnecting to ${host}…',
			'gsh.remoteHost.offline' => ({required Object host}) => '${host} offline',
			'gsh.remoteHost.remove' => 'Remove',
			'gsh.remoteHost.reconnect' => 'Reconnect',
			'gsh.remoteHost.installServer' => 'Install server',
			'gsh.remoteHost.errSshUnreachable' => ({required Object host}) => 'Cannot reach ${host} over SSH. Is it on, and is Remote Login enabled?',
			'gsh.remoteHost.errInstallFailed' => ({required Object host}) => 'Could not install the server on ${host}.',
			'gsh.remoteHost.errVersionMismatch' => 'Server version incompatible; update it.',
			'gsh.remoteHost.errDetail' => ({required Object detail}) => 'Details: ${detail}',
			'gsh.remoteHost.pickFolderTitle' => ({required Object host}) => 'Open folder on ${host}',
			'gsh.remoteHost.openHere' => 'Open here',
			'gsh.remoteHost.emptyFolder' => 'No subfolders',
			'gsh.remoteHost.newLocal' => 'Local',
			'gsh.remoteHost.newRemote' => 'Remote',
			'gsh.remoteHost.chooseHost' => 'Choose a host',
			'gsh.remoteHost.newHostEntry' => 'New host…',
			'gsh.remoteHost.editHost' => 'Edit host',
			'gsh.remoteHost.userLabel' => 'Username',
			'gsh.remoteHost.hostLabel' => 'Host / IP',
			'gsh.remoteHost.portLabel' => 'Port',
			'gsh.remoteHost.authLabel' => 'Authentication',
			'gsh.remoteHost.authKey' => 'SSH key',
			'gsh.remoteHost.authPassword' => 'Password',
			'gsh.remoteHost.passwordLabel' => 'Password',
			'gsh.remoteHost.passwordKeep' => 'Leave blank to keep current',
			'gsh.remoteHost.errUser' => 'Username required',
			'gsh.remoteHost.errHost' => 'Host required',
			'gsh.remoteHost.errPassword' => 'Password required',
			'gsh.remoteHost.identityChoose' => 'Choose…',
			'gsh.remoteHost.identityEmpty' => 'No key selected',
			'gsh.remoteHost.identityDialogTitle' => 'Select the SSH private key',
			'gsh.remoteHost.errIdentity' => 'Pick the private key to authenticate with.',
			'gsh.remoteHost.errHostKeyUnknown' => ({required Object host}) => 'GSH Desktop does not trust ${host} yet. Connect again and confirm the fingerprint.',
			'gsh.remoteHost.errHostKeyChanged' => ({required Object host}) => '${host} is presenting a different SSH key than the one stored. If you did not reinstall that machine, stop and check it — otherwise remove the old entry from ~/.ssh/known_hosts.',
			'gsh.remoteHost.errHostBundleMissing' => ({required Object host}) => '${host} runs Windows but does not have GSH Desktop installed. The remote server is installed from the GSH Desktop bundle already on that machine, so install GSH Desktop there and try again.',
			'gsh.remoteHost.errHostUnknownOs' => ({required Object host}) => 'Could not identify the operating system of ${host}. The account may have a restricted shell, or no shell at all.',
			'gsh.remoteHost.errIdentityPublic' => 'Only the public key is here. That works only if the private key is in your SSH agent; otherwise pick the private file (same name, without .pub).',
			'gsh.remoteHost.errIdentityNotKey' => 'That file does not look like a private key.',
			'gsh.remoteHost.errIdentityMissingFile' => 'That file no longer exists.',
			'gsh.remoteHost.errIdentityUnreadable' => 'That file could not be read.',
			'gsh.browserPane.back' => 'Back',
			'gsh.browserPane.forward' => 'Forward',
			'gsh.browserPane.reload' => 'Reload',
			'gsh.browserPane.urlHint' => 'Enter URL or address',
			'gsh.browserPane.go' => 'Go',
			'gsh.documentWindow.mediaNotSupported' => 'Audio and video open in the main GSH Desktop window.',
			'gsh.documentWindow.fileNotFound' => ({required Object path}) => 'File not found: ${path}',
			'gsh.gallery.intro' => 'Special GSH Desktop documents that give you a visual of what the AI agent is doing.',
			'gsh.gallery.createErrorTitle' => 'Could not create the file',
			'gsh.gallery.dbQuery.title' => 'Database query',
			'gsh.gallery.dbQuery.description' => 'SQL editor with a result grid, using one of the registered connections.',
			'gsh.gallery.kanban.title' => 'Kanban board',
			'gsh.gallery.kanban.description' => 'Columns and cards stored as plain markdown. Drag, edit and comment.',
			'gsh.gallery.layout.title' => 'Pane layout',
			'gsh.gallery.layout.description' => 'Terminals and splits to open in one go, like tmuxinator. Can run automatically on new worktrees.',
			'gsh.gallery.httpRequest.title' => 'HTTP requests',
			'gsh.gallery.httpRequest.description' => 'Write requests in a file and run them with the response next to it.',
			'gsh.gallery.html.title' => 'HTML view',
			'gsh.gallery.html.description' => 'A page the agent writes and GSH Desktop renders directly: mind maps, diagrams, charts, whatever you need.',
			'gsh.gallery.tasks.title' => 'Tasks',
			'gsh.gallery.tasks.description' => 'Commands to run from the Tasks panel, such as the dev server, tests and build. Stored in .gsh/tasks.json.',
			'gsh.gallery.notebook.title' => 'Notebook',
			'gsh.gallery.notebook.description' => 'A folder of short notes with tags. The agent writes, you read and edit. Also opens in Obsidian.',
			'gsh.gallery.workspaceEnv.title' => 'Workspace env',
			'gsh.gallery.workspaceEnv.description' => 'Variables injected into every terminal of this workspace. Put API tokens or logins here instead of pasting them into the agent\'s prompt. Kept out of git.',
			'gsh.gallery.panel.title' => 'Panel',
			'gsh.gallery.panel.description' => 'An HTML page with a bridge to the app: its buttons run GSH Desktop CLI and shell commands on this machine. A playground for quick dashboards.',
			'gsh.notebook.notes' => 'Notes',
			'gsh.notebook.newNote' => 'New note',
			'gsh.notebook.searchPlaceholder' => 'Search notes',
			'gsh.notebook.empty' => 'No notes yet. Create one, or ask the agent to write here.',
			'gsh.notebook.noMatch' => 'No note matches.',
			'gsh.notebook.selectNote' => 'Select a note',
			'gsh.notebook.reload' => 'Reload from disk',
			'gsh.notebook.untagged' => 'untagged',
			'gsh.notebook.saveFailed' => 'Could not save the note',
			'gsh.notebook.createFailed' => 'Could not create the note',
			'gsh.notebook.addTag' => 'add tag',
			'gsh.notebook.untitled' => 'Untitled',
			'gsh.notebook.deleteNote' => 'Delete note',
			'gsh.notebook.deleteConfirm' => ({required Object name}) => 'Move “${name}” to the trash?',
			'gsh.notebook.imageFailed' => 'Could not save the image',
			'gsh.notebook.format.bold' => 'Bold (⌘B)',
			'gsh.notebook.format.italic' => 'Italic (⌘I)',
			'gsh.notebook.format.strike' => 'Strikethrough',
			'gsh.notebook.format.heading1' => 'Heading 1',
			'gsh.notebook.format.heading2' => 'Heading 2',
			'gsh.notebook.format.heading3' => 'Heading 3',
			'gsh.notebook.format.bullets' => 'Bullet list',
			'gsh.notebook.format.numbered' => 'Numbered list',
			'gsh.notebook.format.checklist' => 'Checklist',
			'gsh.notebook.format.quote' => 'Quote',
			'gsh.notebook.format.code' => 'Inline code (⌘E)',
			'gsh.notebook.format.codeBlock' => 'Code block',
			'gsh.notebook.format.link' => 'Link (⌘K)',
			'gsh.notebook.format.rule' => 'Divider',
			'gsh.notebook.format.noteLink' => 'Link to a note ([[…]])',
			'gsh.notebook.format.noteLinkSearch' => 'Search notes',
			'gsh.notebook.format.image' => 'Insert image…',
			'gsh.notebook.backlinks' => 'Linked from',
			'gsh.notebook.renameTag' => 'Rename tag',
			'gsh.notebook.deleteTag' => 'Delete tag',
			'gsh.notebook.deleteTagConfirm' => ({required Object name, required Object count}) => 'Remove “${name}” from ${count} notes? The notes stay.',
			'gsh.notebook.showList' => 'Show notes list',
			'gsh.notebook.hideList' => 'Hide notes list',
			'gsh.layoutPreview.applyFailedTitle' => 'Could not apply the layout',
			'gsh.layoutPreview.applyInGsh' => 'Apply in GSH Desktop',
			'gsh.layoutPreview.applyNewWorkspace' => 'Open as new workspace',
			'gsh.layoutPreview.applyTo' => ({required Object workspace}) => 'Apply to ${workspace}',
			'gsh.layoutPreview.autorunWorktree' => 'autorun: worktree. This layout is also applied on its own when you create a worktree of the workspace that holds it.',
			'gsh.layoutPreview.command' => 'Command',
			'gsh.layoutPreview.folder' => 'Folder',
			'gsh.layoutPreview.noCommand' => 'no command, opens a shell',
			'gsh.layoutPreview.replaceConfirm' => 'Replace layout',
			'gsh.layoutPreview.replaceMessage' => ({required Object n}) => '${n} open tabs of this workspace will be closed, including any running work.',
			'gsh.layoutPreview.replaceTitle' => ({required Object workspace}) => 'Replace the layout of ${workspace}?',
			'gsh.layoutPreview.skippedTitle' => 'Not created on this system',
			'gsh.layoutPreview.splitDown' => 'split down',
			'gsh.layoutPreview.splitRight' => 'split right',
			'gsh.layoutPreview.splitTab' => 'tab',
			'gsh.layoutPreview.subtitle' => ({required Object n}) => 'This layout opens ${n} terminals. Read the commands before applying.',
			'gsh.telemetry.tooltip' => 'Telemetry',
			'gsh.telemetry.title' => 'Telemetry',
			'gsh.telemetry.liveRuns' => ({required Object n}) => '${n} live',
			'gsh.telemetry.noWorkspace' => 'Open a workspace to see its telemetry.',
			'gsh.telemetry.empty' => 'Nothing here yet.',
			'gsh.telemetry.emptyFiltered' => 'Nothing here yet.',
			'gsh.telemetry.searchHint' => 'Filter cases',
			'gsh.telemetry.chipOpen' => 'Open',
			'gsh.telemetry.chipNew' => 'New',
			'gsh.telemetry.chipResolved' => 'Resolved',
			'gsh.telemetry.chipIgnored' => 'Ignored',
			'gsh.telemetry.chipWarnings' => 'Warnings',
			'gsh.telemetry.tagNew' => 'new',
			'gsh.telemetry.tagRegression' => 'regression',
			'gsh.telemetry.tagResolved' => 'resolved',
			'gsh.telemetry.tagIgnored' => 'ignored',
			'gsh.telemetry.srcTask' => 'task',
			'gsh.telemetry.srcWrapper' => 'gsh telemetry',
			'gsh.telemetry.run' => ({required Object id}) => 'run ${id}',
			'gsh.telemetry.resolve' => 'Mark resolved',
			'gsh.telemetry.ignore' => 'Ignore (hide from agents too)',
			'gsh.telemetry.reopen' => 'Reopen',
			'gsh.telemetry.clear' => 'Clear occurrences',
			'gsh.telemetry.clearRun' => 'Clear this run',
			'gsh.telemetry.clearProject' => 'Clear project',
			'gsh.telemetry.openFile' => ({required Object location}) => 'Open ${location}',
			'gsh.telemetry.showInTerminal' => 'Show in terminal',
			'gsh.telemetry.copyCommand' => 'Copy CLI command',
			'gsh.telemetry.copied' => 'Copied',
			'gsh.telemetry.statusOpen' => 'Open',
			'gsh.telemetry.statusResolved' => 'Resolved',
			'gsh.telemetry.statusIgnored' => 'Ignored',
			'gsh.telemetry.occurrences' => 'Occurrences',
			'gsh.telemetry.inRuns' => ({required Object n}) => 'in ${n} runs',
			'gsh.telemetry.first' => 'First',
			'gsh.telemetry.last' => 'Last',
			'gsh.telemetry.origin' => 'Origin',
			'gsh.telemetry.sectionStack' => 'Stack',
			'gsh.telemetry.stackHint' => 'project frames highlighted · click opens the file',
			'gsh.telemetry.sectionCorrelated' => 'Correlated log',
			'gsh.telemetry.correlatedHint' => 'the closest JSON log before the error, same run',
			'gsh.telemetry.none' => 'none',
			'gsh.telemetry.sectionRuns' => 'Occurrences by run',
			'gsh.telemetry.runsHint' => 'same key (cwd, command): this is how new and regression are computed',
			'gsh.telemetry.sectionContext' => 'Raw context',
			'gsh.telemetry.contextHint' => 'terminal lines around the last occurrence',
			'gsh.telemetry.current' => 'current',
			'gsh.telemetry.fingerprintHint' => ({required Object location}) => 'fingerprint = type + normalized message + ${location}',
			'gsh.telemetry.blameUncommitted' => 'changed in working tree',
			'gsh.telemetry.blameCommit' => ({required Object ago, required Object sha}) => 'changed ${ago} (${sha})',
			'gsh.telemetry.justNow' => 'just now',
			'gsh.telemetry.minutesAgo' => ({required Object n}) => '${n}m ago',
			'gsh.telemetry.hoursAgo' => ({required Object n}) => '${n}h ago',
			'gsh.telemetry.daysAgo' => ({required Object n}) => '${n}d ago',
			'gsh.telemetry.resolvedToast' => 'Resolved. If it comes back in a later run it reappears as a regression.',
			'gsh.telemetry.ignoredToast' => 'Ignored. Agents no longer see it (unless --include-ignored).',
			'gsh.telemetry.clearedToast' => 'Occurrences deleted. Triage rules are kept.',
			'gsh.telemetry.byHuman' => 'by you',
			'gsh.telemetry.byAgent' => 'by agent',
			'gsh.telemetry.caseTabTitle' => ({required Object type, required Object file}) => '${type} · ${file}',
			'gsh.telemetry.srcApp' => 'App',
			'gsh.telemetry.chipApp' => 'GSH Desktop',
			'gsh.panelView.unavailable' => 'Panels need the embedded web view, which is not available on Linux yet.',
			'gsh.panelView.openInBrowser' => 'Open in browser',
			'gsh.panelView.openAsHtml' => 'Open as HTML',
			'gsh.chat.tabTitle' => 'Chat',
			'gsh.chat.emptyTitle' => 'New conversation',
			'gsh.chat.emptySubtitle' => ({required Object folder}) => 'Claude Code in ${folder}, with your own login.',
			'gsh.chat.emptyHintSend' => 'Enter sends; Shift+Enter adds a line.',
			'gsh.chat.emptyHintPaste' => 'Paste a screenshot with Ctrl+V, or drop files onto the chat.',
			'gsh.chat.emptyHintMode' => 'Pick the permission mode below the input: ask, accept edits, plan, or bypass.',
			'gsh.chat.placeholder' => 'Message Claude… (Enter sends, Shift+Enter for a new line)',
			'gsh.chat.send' => 'Send',
			'gsh.chat.stop' => 'Stop',
			'gsh.chat.working' => 'working…',
			'gsh.chat.waitingYou' => 'waiting for you',
			'gsh.chat.cost' => ({required Object v}) => 'cost US\$ ${v}',
			'gsh.chat.askPermission' => ({required Object tool}) => 'Allow ${tool}?',
			'gsh.chat.allow' => 'Allow',
			'gsh.chat.deny' => 'Deny',
			'gsh.chat.allowed' => 'Allowed',
			'gsh.chat.denied' => 'Denied',
			'gsh.chat.startFailed' => ({required Object detail}) => 'Couldn\'t start claude: ${detail}',
			'gsh.chat.engineExited' => ({required Object code}) => 'claude exited (code ${code}).',
			'gsh.chat.turnFailed' => ({required Object detail}) => 'The turn ended with an error: ${detail}',
			'gsh.chat.handedOff' => 'This conversation continues in a terminal with Remote Control: open it on your phone or at claude.ai/code. The chat here is paused.',
			'gsh.chat.peerMessageFrom' => ({required Object name}) => 'Message from ${name}',
			'gsh.chat.sessions' => 'Sessions',
			'gsh.chat.noSessions' => 'No other Claude Code session is running right now.',
			'gsh.chat.listAllSessions' => 'List every session (asks the agent)…',
			'gsh.chat.askListSessions' => 'List the sessions I can message, with ListAgents, and wait for me to pick one. ',
			'gsh.chat.sendToSession' => ({required Object name}) => 'Send this message to the session "${name}" with SendMessage and wait for its reply: ',
			'gsh.chat.remoteControl' => 'Remote Control',
			'gsh.chat.remoteControlHint' => 'Continue this conversation in a terminal with Remote Control (phone, claude.ai/code). The chat\'s engine doesn\'t support Remote Control.',
			'gsh.chat.usage' => 'Usage',
			'gsh.chat.usageContext' => ({required Object used, required Object window}) => 'Context: ${used} of ${window}',
			'gsh.chat.usageContextNone' => 'Context: shows up after the first reply',
			'gsh.chat.usageSession' => 'Session (5 h)',
			'gsh.chat.usageWeek' => 'Week',
			'gsh.chat.usageModelWeek' => ({required Object model}) => '${model} this week',
			'gsh.chat.usageResetsToday' => ({required Object time}) => 'resets at ${time}',
			'gsh.chat.usageResetsOn' => ({required Object date, required Object time}) => 'resets ${date} at ${time}',
			'gsh.chat.usageUnavailable' => 'Plan usage unavailable right now.',
			'gsh.chat.resume' => 'Resume conversation',
			'gsh.chat.resumeHint' => 'Open a recent Claude Code conversation from this machine in a new tab, with its history.',
			'gsh.chat.resumeEmpty' => 'Resume a conversation',
			'gsh.chat.resumeNone' => 'No conversations in the last 7 days.',
			'gsh.chat.resumeLiveTitle' => 'Is this conversation open somewhere else?',
			'gsh.chat.resumeLiveBody' => ({required Object ago}) => 'It changed ${ago}. If it is still open (Claude Desktop, a terminal), continuing here makes both write to the same conversation. Close it there first.',
			'gsh.chat.resumeAnyway' => 'Open anyway',
			'gsh.chat.remoteControlActive' => ({required Object url}) => 'This conversation is already on Remote Control: continue on your phone or at ${url}',
			'gsh.chat.remoteControlNoSession' => 'Send a message first: Remote Control continues an existing conversation.',
			'gsh.chat.remoteControlBusy' => 'Wait for the agent to finish this turn, then try again.',
			'gsh.chat.remoteControlFailed' => 'Couldn\'t open the terminal in this workspace.',
			'gsh.chat.attachmentTooLarge' => ({required Object name}) => '${name} is too large to send (images up to 5 MB, PDFs up to 32 MB).',
			'gsh.chat.loadingHistory' => 'Loading the conversation…',
			'gsh.chat.allowAlways' => ({required Object rule}) => 'Always allow ${rule}',
			'gsh.chat.allowedAlways' => ({required Object rule}) => 'Always allowed: ${rule}',
			'gsh.chat.moreLines' => ({required Object n}) => '… ${n} more lines',
			'gsh.chat.questionTitle' => 'The agent is asking',
			'gsh.chat.other' => 'Other…',
			'gsh.chat.answer' => 'Answer',
			'gsh.chat.planTitle' => 'Agent\'s plan',
			'gsh.chat.planApprove' => 'Approve and run',
			'gsh.chat.planRefine' => 'Keep planning',
			'gsh.chat.planRefineHint' => 'What should change in the plan?',
			'gsh.chat.planSendRefine' => 'Send adjustment',
			'gsh.chat.planApproved' => 'Plan approved',
			'gsh.chat.planRefined' => 'Asked to keep planning',
			'gsh.chat.planRefinedWith' => ({required Object text}) => 'Adjustment: ${text}',
			'gsh.chat.newChat' => 'New conversation',
			'gsh.chat.attach' => 'Attach files',
			'gsh.chat.modeDefault' => 'Ask permission',
			'gsh.chat.modeAcceptEdits' => 'Accept edits',
			'gsh.chat.modePlan' => 'Plan',
			'gsh.chat.modeBypass' => 'Skip permissions',
			'gsh.chat.editedFiles' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: 'Edited 1 file', other: 'Edited ${n} files', ), 
			'gsh.chat.thinkingTitle' => 'Thinking',
			'gsh.chat.thinkingLive' => 'Thinking…',
			'gsh.chat.stateCompleted' => 'Completed',
			'gsh.chat.stateReviewReady' => 'Ready for review',
			'gsh.chat.stateBlocked' => 'Blocked',
			'gsh.chat.stateFailed' => 'Failed',
			'gsh.chat.copyMessage' => 'Copy',
			'gsh.chat.copiedMessage' => 'Copied',
			'gsh.chat.effort.title' => 'Effort',
			'gsh.chat.effort.tooltip' => ({required Object level}) => 'Effort: ${level}',
			'gsh.chat.effort.auto' => 'Default',
			'gsh.chat.effort.low' => 'Low',
			'gsh.chat.effort.medium' => 'Medium',
			'gsh.chat.effort.high' => 'High',
			'gsh.chat.effort.xhigh' => 'Extra high',
			'gsh.chat.effort.max' => 'Max',
			'gsh.chat.effort.hint' => 'How much the model thinks before answering. More effort = better on hard tasks, slower and more tokens.',
			'gsh.harness.tabTitle' => 'Harness',
			'gsh.harness.subtitle' => ({required Object path}) => 'What the agent loads when it runs in ${path}',
			'gsh.harness.refresh' => 'Read again',
			'gsh.harness.memory' => 'Instructions',
			'gsh.harness.memoryDesc' => 'CLAUDE.md files a session here reads (from this folder up), your user one, and AGENTS.md (Codex).',
			'gsh.harness.memoryNew' => 'Create CLAUDE.md',
			'gsh.harness.skills' => 'Skills',
			'gsh.harness.skillsDesc' => 'Capabilities the agent picks up on its own when the description matches the task.',
			'gsh.harness.agents' => 'Subagents',
			'gsh.harness.agentsDesc' => 'Specialists the agent delegates to (with their own tools and model).',
			'gsh.harness.commands' => 'Commands',
			'gsh.harness.commandsDesc' => '/name shortcuts you type in the session.',
			'gsh.harness.hooks' => 'Hooks',
			'gsh.harness.hooksDesc' => 'Commands that run on session events (before a tool, on stop...).',
			'gsh.harness.permissions' => 'Permissions',
			'gsh.harness.permissionsDesc' => 'Tool rules: allow, ask or block.',
			'gsh.harness.mcp' => 'MCP',
			'gsh.harness.mcpDesc' => 'Extra tool servers. User and local ones come from ~/.claude.json (change them with claude mcp).',
			'gsh.harness.newItem' => 'New',
			'gsh.harness.editFile' => 'Edit file',
			'gsh.harness.newTitle' => ({required Object section}) => 'New item in ${section}',
			'gsh.harness.create' => 'Create',
			'gsh.harness.namePlaceholder' => 'name (becomes the file name)',
			'gsh.harness.empty' => 'Nothing here yet.',
			'gsh.harness.scopeUser' => 'User',
			'gsh.harness.scopeProject' => 'Project',
			'gsh.harness.scopeLocal' => 'Local',
			'gsh.harness.allow' => 'allow',
			'gsh.harness.ask' => 'ask',
			'gsh.harness.deny' => 'block',
			'gsh.harness.readOnly' => 'Read-only here: use claude mcp add/remove',
			'gsh.harness.costTitle' => 'Fixed cost per turn',
			'gsh.harness.costValue' => ({required Object tokens}) => '≈ ${tokens} tokens',
			'gsh.harness.costHint' => 'What goes into the context on every message, before any work: the full instructions and each skill, subagent and command\'s name + description. MCP tools aren\'t counted.',
			'gsh.harness.costTip' => 'To trim it: what only matters sometimes leaves CLAUDE.md and becomes a skill; delete skills and commands nobody uses.',
			'gsh.harness.perTurn' => ({required Object tokens}) => '≈ ${tokens}/turn',
			'gsh.harness.issues' => ({required Object n}) => 'Warnings: ${n}',
			'gsh.harness.issueNoDescription' => 'No description: the agent doesn\'t know when to use it.',
			'gsh.harness.issueMissingScript' => 'The script this hook runs doesn\'t exist.',
			'gsh.harness.issueTooLarge' => 'Too large: it weighs on every message (Claude Code warns above 40k characters).',
			'gsh.harness.invalidJson' => ({required Object file}) => '${file}: invalid JSON — Claude Code ignores this whole file.',
			'gsh.harness.showAll' => ({required Object n}) => 'Show all (${n})',
			'gsh.harness.showLess' => 'Show less',
			'gsh.farm.tabTitle' => 'Farm',
			'gsh.farm.title' => 'Agent farm',
			'gsh.farm.emptyTitle' => 'No agents running',
			'gsh.farm.emptyHint' => 'Every Claude Code loop on this machine shows up here while it works, including subagents and sessions outside GSH Desktop.',
			'gsh.farm.working' => ({required Object n}) => '${n} working',
			'gsh.farm.waiting' => ({required Object n}) => '${n} need you',
			'gsh.farm.waitingOne' => '1 needs you',
			'gsh.farm.idle' => ({required Object n}) => '${n} idle',
			'gsh.farm.doorTitle' => 'Knocking on your door',
			'gsh.farm.doorMessage' => ({required Object name, required Object agent, required Object target}) => '${name} (agent ${agent}) wants to talk to your agent ${target}',
			'gsh.farm.doorFile' => ({required Object name, required Object agent, required Object file, required Object target}) => '${name} (agent ${agent}) wants to hand ${file} to your agent ${target}',
			'gsh.farm.doorOpen' => 'Open the door',
			'gsh.farm.doorRefuse' => 'Refuse',
			'gsh.farm.peerOf' => ({required Object name}) => '${name}\'s',
			'gsh.farm.peerBanner' => ({required Object name}) => '${name}\'s farm',
			'gsh.farm.spent' => ({required Object total}) => 'Spent ${total} tokens',
			'gsh.farm.spentDetail' => ({required Object input, required Object cache, required Object out}) => '${input} input · ${cache} cache · ${out} out',
			'gsh.farm.context' => ({required Object ctx, required Object window, required Object pct}) => 'context ${ctx} of ${window} (${pct}%)',
			'gsh.farm.spentHud' => ({required Object n}) => '${n} tokens spent',
			'gsh.farm.clickToOpen' => 'Click to open its terminal',
			'gsh.farm.outsideGsh' => 'This agent is running outside GSH Desktop. Its terminal is in another window.',
			'gsh.farm.agents' => ({required Object n}) => '${n} agents',
			'gsh.farm.subagents' => ({required Object n}) => '${n} sub-agents',
			'gsh.farm.activity.thinking' => 'thinking',
			'gsh.farm.activity.reading' => 'reading',
			'gsh.farm.activity.editing' => 'editing',
			'gsh.farm.activity.running' => 'running a command',
			'gsh.farm.activity.searching' => 'searching the web',
			'gsh.farm.activity.delegating' => 'delegating',
			'gsh.farm.activity.tooling' => 'using a tool',
			'gsh.farm.activity.waiting' => 'waiting for you',
			'gsh.farm.activity.idle' => 'idle',
			'gsh.farm.activity.sleeping' => 'asleep',
			'gsh.farm.activity.done' => 'done',
			'gsh.farm.teammateOf' => ({required Object lead}) => 'teammate of ${lead}',
			'gsh.farm.teamLead' => ({required Object n}) => 'leads a team of ${n}',
			'gsh.farm.resetPlots' => 'Reset plot positions',
			'gsh.farm.you' => 'You',
			'gsh.agentGraph.tabTitle' => 'Agents',
			'gsh.agentGraph.newAgent' => 'New agent',
			'gsh.agentGraph.emptyTitle' => 'No agents in this workspace',
			'gsh.agentGraph.emptyHint' => 'Start an agent in a terminal or create one here. Drag from an agent\'s port to another agent to connect them.',
			'gsh.agentGraph.statusWorking' => 'Working',
			'gsh.agentGraph.statusWaiting' => 'Waiting',
			'gsh.agentGraph.statusIdle' => 'Idle',
			'gsh.agentGraph.messageCount' => ({required Object n}) => 'Messages: ${n}',
			'gsh.agentGraph.lastMessage' => ({required Object preview}) => 'Last: ${preview}',
			'gsh.agentGraph.linked' => 'Connected',
			'gsh.agentGraph.removeLinkHint' => 'Right-click to remove the connection',
			'gsh.agentGraph.removeLink' => 'Remove connection',
			'gsh.agentGraph.connectHint' => 'Drag to another agent to connect',
			'gsh.agentGraph.quickStart' => 'Quick start',
			'gsh.agentGraph.shell' => 'Shell',
			'gsh.agentGraph.tabDetails' => 'Details',
			'gsh.agentGraph.tabAppearance' => 'Appearance',
			'gsh.agentGraph.tabAgent' => 'Agent',
			'gsh.agentGraph.name' => 'Terminal name',
			'gsh.agentGraph.namePlaceholder' => 'e.g. Reviewer',
			'gsh.agentGraph.nameTaken' => 'Another tab already uses this name. Names must be unique so `gsh msg --to` can reach it.',
			'gsh.agentGraph.command' => 'Command',
			'gsh.agentGraph.commandPlaceholder' => 'e.g. claude --model opus (empty = shell)',
			'gsh.agentGraph.cwd' => 'Working directory',
			'gsh.agentGraph.browse' => 'Browse…',
			'gsh.agentGraph.cwdMissing' => 'This folder does not exist.',
			'gsh.agentGraph.monitor' => 'Monitor activity',
			'gsh.agentGraph.monitorHint' => 'Badge, sound and notification when a turn ends.',
			'gsh.agentGraph.maestro' => 'Maestro',
			'gsh.agentGraph.maestroTooltip' => 'Promotes this agent to maestro: it is connected to every agent on the canvas and coordinates them.',
			'gsh.agentGraph.maestroReplaces' => ({required Object name}) => '${name} is the current maestro and will be demoted.',
			'gsh.agentGraph.color' => 'Color',
			'gsh.agentGraph.colorAuto' => 'Automatic',
			'gsh.agentGraph.role' => 'Role / instructions',
			'gsh.agentGraph.rolePlaceholder' => 'Sent as its first message once the agent is ready.',
			'gsh.agentGraph.task' => 'Initial task',
			'gsh.agentGraph.taskPlaceholder' => 'Sent right after the role.',
			'gsh.agentGraph.focus' => 'Focus',
			'gsh.agentGraph.rename' => 'Rename',
			'gsh.agentGraph.renameTitle' => 'Rename agent',
			'gsh.agentGraph.makeMaestro' => 'Make maestro',
			'gsh.agentGraph.removeMaestro' => 'Remove maestro',
			'gsh.agentGraph.closeTab' => 'Close tab',
			'gsh.agentGraph.removeFromCanvas' => 'Remove from canvas',
			'gsh.agentGraph.desktopApps' => 'Desktop apps',
			'gsh.agentGraph.desktopBadge' => 'desktop',
			'gsh.agentGraph.statusOnline' => 'Online',
			'gsh.agentGraph.statusOffline' => 'Offline',
			'gsh.agentGraph.queued' => ({required Object n}) => '${n} queued',
			'gsh.agentGraph.agentName' => 'Name',
			'gsh.agentGraph.integration' => 'Integration',
			'gsh.agentGraph.integrationHint' => 'GSH Desktop adds an MCP server named "gsh" to this file and saves a backup next to it. Other servers are not touched.',
			'gsh.agentGraph.integrationConsent' => ({required Object app}) => 'Add the GSH Desktop MCP server to ${app}\'s config',
			'gsh.agentGraph.restartHint' => ({required Object app}) => 'Restart ${app} if it was already open so it loads the GSH Desktop MCP server; then ask it to call wait_messages.',
			'gsh.agentGraph.integrationError.invalidConfig' => ({required Object path}) => '${path} is not plain JSON/TOML that GSH Desktop can edit safely (comments or a different layout). Nothing was changed.',
			'gsh.agentGraph.integrationError.cliMissing' => ({required Object path}) => 'The GSH Desktop CLI is not installed yet (${path}). Restart GSH Desktop and try again.',
			'gsh.agentGraph.integrationError.writeFailed' => ({required Object detail}) => 'Could not update the config: ${detail}',
			'settings.language.title' => 'Language',
			'settings.language.system' => 'System',
			'settings.language.english' => 'English',
			'settings.language.portugueseBr' => 'Português (BR)',
			'settings.language.spanish' => 'Español',
			'settings.page.header.back' => 'Back',
			'settings.page.header.title' => 'Settings',
			'settings.page.nav.sideGsh' => 'GSH Desktop',
			'settings.page.nav.sideClaude' => 'Claude',
			'settings.page.nav.general' => 'General',
			'settings.page.nav.appearance' => 'Appearance',
			_ => null,
		} ?? switch (path) {
			'settings.page.nav.terminal' => 'Terminal',
			'settings.page.nav.language' => 'Language',
			'settings.page.nav.shortcuts' => 'Shortcuts',
			'settings.page.nav.notifications' => 'Notifications',
			'settings.page.nav.automations' => 'AI Commits',
			'settings.page.nav.remoteHosts' => 'Remote hosts',
			'settings.page.nav.claudeCode' => 'Claude Code',
			'settings.page.nav.search' => 'Search',
			'settings.page.nav.account' => 'Account',
			'settings.page.nav.privacy' => 'Privacy',
			'settings.page.nav.usage' => 'Usage',
			'settings.page.nav.resources' => 'Resources',
			'settings.page.nav.gshFeatures' => 'GSH features',
			'settings.page.nav.memory' => 'Memory',
			'settings.page.nav.designSystems' => 'Design systems',
			'settings.page.nav.cowork' => 'Cowork',
			'settings.page.nav.system' => 'System',
			'settings.page.nav.extensions' => 'Extensions',
			'settings.page.nav.developer' => 'Developer',
			'settings.page.nav.skills' => 'Skills',
			'settings.page.nav.connectors' => 'Connectors',
			'settings.page.nav.plugins' => 'Plugins',
			'settings.page.nav.apiKeys' => 'API keys',
			'settings.page.nav.groups.settings' => 'Settings',
			'settings.page.nav.groups.thisComputer' => 'This computer',
			'settings.page.nav.groups.personalization' => 'Personalization',
			'settings.page.nav.groups.platform' => 'Platform',
			'settings.page.nav.groups.app' => 'GSH Desktop',
			'settings.page.general.sectionEditor' => 'Editor',
			'settings.page.general.editorEngineTitle' => 'Engine',
			'settings.page.general.editorEngineGsh' => 'GSH Desktop (default)',
			'settings.page.general.editorEngineNeovim' => 'Neovim',
			'settings.page.general.neovimChecking' => 'Looking for Neovim…',
			'settings.page.general.neovimNotFound' => 'Neovim was not found in your shell PATH.',
			'settings.page.general.neovimRefresh' => 'Check again',
			'settings.page.general.showGshTitle' => 'Show GSH Desktop terminal',
			'settings.page.general.showGshDesc' => 'Keep a pathless, terminal-only workspace pinned at the top of the rail. Turning it off closes its terminals.',
			'settings.page.general.launchAtStartupTitle' => 'Launch at login',
			'settings.page.general.launchAtStartupDesc' => 'Start GSH Desktop automatically when you sign in to your computer.',
			'settings.page.general.sectionUpdates' => 'Updates',
			'settings.page.general.checkUpdatesTitle' => 'Check for updates',
			'settings.page.general.checkUpdatesDesc' => 'How often GSH Desktop should look for new versions.',
			'settings.page.general.updateFrequency.daily' => 'Daily',
			'settings.page.general.updateFrequency.weekly' => 'Weekly',
			'settings.page.general.updateFrequency.monthly' => 'Monthly',
			'settings.page.general.updateFrequency.never' => 'Never',
			'settings.page.general.developerModeTitle' => 'Developer mode',
			'settings.page.general.developerModeDesc' => 'Records GSH Desktop’s own errors and warnings in a separate Telemetry store (the “GSH Desktop” chip) and turns on performance metrics. Only useful to whoever maintains the app.',
			'settings.page.diagnostics.sectionTitle' => 'Diagnostics',
			'settings.page.diagnostics.logFileTitle' => 'Log file',
			'settings.page.diagnostics.logFileDesc' => ({required Object days, required Object path}) => 'Errors and startup events are recorded here, kept for ${days} days.\n${path}',
			'settings.page.diagnostics.unavailable' => 'unavailable',
			'settings.page.diagnostics.reveal' => 'Reveal',
			'settings.page.diagnostics.reportTitle' => 'Report a problem',
			'settings.page.diagnostics.reportDesc' => 'Opens a pre-filled issue with your version, OS and recent log. Nothing is sent automatically — you review it first.',
			'settings.page.diagnostics.reportButton' => 'Report…',
			'settings.page.diagnostics.reportDialogTitle' => 'Problem report',
			'settings.page.diagnostics.reportDialogError' => 'Reported manually from Settings.',
			'settings.page.diagnostics.reportDialogDescription' => 'Describe what went wrong in the issue. The recent log is included below and in "Copy details".',
			'settings.page.storage.sectionTitle' => 'Storage',
			'settings.page.storage.locationTitle' => 'Storage location',
			'settings.page.storage.locationDesc' => ({required Object root}) => 'GSH Desktop keeps its projects, layouts and settings here. Point it at a synced folder to back it up.\n${root}',
			'settings.page.storage.useDefault' => 'Use default',
			'settings.page.storage.working' => 'Working…',
			'settings.page.storage.change' => 'Change…',
			'settings.page.storage.resetTitle' => 'Reset GSH Desktop',
			'settings.page.storage.resetDesc' => 'Delete all local data — projects, layouts, settings and terminal history — and return to the default location.',
			'settings.page.storage.resetButton' => 'Reset…',
			'settings.page.storage.resetConfirm' => 'Reset',
			'settings.page.storage.resetDialogTitle' => 'Reset GSH Desktop?',
			'settings.page.storage.resetDialogContent' => 'This permanently deletes all local GSH Desktop data — projects, layouts, settings and terminal history. This cannot be undone. GSH Desktop will close so you can start fresh.',
			'settings.page.storage.restartRequiredTitle' => 'Restart required',
			'settings.page.storage.restartChangeFolderMessage' => ({required Object path}) => 'GSH Desktop will use this folder from the next launch:\n${path}',
			'settings.page.storage.restartUseDefaultMessage' => 'GSH Desktop will use the default system location from the next launch. Your data in the custom folder is left untouched.',
			'settings.page.storage.restartResetMessage' => 'All GSH Desktop data was cleared. Restart to start fresh.',
			'settings.page.storage.later' => 'Later',
			'settings.page.storage.quitGsh' => 'Quit GSH Desktop',
			'settings.page.storage.chooseFolderDialogTitle' => 'Choose a folder for GSH Desktop data',
			'settings.page.terminal.sectionDefaultTerminal' => 'Default terminal',
			'settings.page.terminal.engineTitle' => 'Engine',
			'settings.page.terminal.engineDesc' => 'Used by new terminal tabs and task output buffers. Open tabs keep their current engine.',
			'settings.page.terminal.shellTitle' => 'Shell',
			'settings.page.terminal.shellDesc' => 'Which shell new terminal tabs open. The arrow next to + still opens any other one, just for that tab.',
			'settings.page.terminal.noWslMessage' => 'No WSL distros found. Install one (wsl.exe --install) and restart GSH Desktop to see it listed here.',
			'settings.page.terminal.sectionBehavior' => 'Behavior',
			'settings.page.terminal.closeOnExitTitle' => 'Close tab when the shell exits',
			'settings.page.terminal.closeOnExitDesc' => 'When a shell ends on its own (exit, Ctrl-D), close its tab instead of leaving a dead terminal.',
			'settings.page.appearance.sectionTheme' => 'Theme',
			'settings.page.appearance.themeTitle' => 'Theme',
			'settings.page.appearance.themeDesc' => 'App colors, code highlighting and terminal palette.',
			'settings.page.appearance.modeTitle' => 'Mode',
			'settings.page.appearance.modeDesc' => 'Which variant of the theme to use.',
			'settings.page.appearance.modeOnlyDark' => ({required Object theme}) => '"${theme}" only ships a dark variant, so this has no effect.',
			'settings.page.appearance.modeOnlyLight' => ({required Object theme}) => '"${theme}" only ships a light variant, so this has no effect.',
			'settings.page.appearance.themeFileTitle' => 'Theme file',
			'settings.page.appearance.themeFileDesc' => 'Import a theme from a JSON file, or export the active one.',
			'settings.page.appearance.previewCode' => 'Code',
			'settings.page.appearance.previewTerminal' => 'Terminal',
			'settings.page.appearance.themeSystem' => 'System',
			'settings.page.appearance.themeLight' => 'Light',
			'settings.page.appearance.themeDark' => 'Dark',
			'settings.page.appearance.sectionFonts' => 'Fonts',
			'settings.page.appearance.interfaceFontTitle' => 'Interface font',
			'settings.page.appearance.interfaceFontDesc' => 'Used across the whole app. Empty = system default.',
			'settings.page.appearance.interfaceSizeTitle' => 'Interface size',
			'settings.page.appearance.codeFontTitle' => 'Code font',
			'settings.page.appearance.codeFontDesc' => 'Code and diffs. Empty = system default.',
			'settings.page.appearance.codeSizeTitle' => 'Code size',
			'settings.page.appearance.terminalFontTitle' => 'Terminal font',
			'settings.page.appearance.terminalFontDesc' => 'Terminal only. Empty = system default.',
			'settings.page.appearance.terminalSizeTitle' => 'Terminal size',
			'settings.page.appearance.terminalSizeDesc' => 'Off = follows the code size.',
			'settings.page.appearance.terminalSizeInherit' => 'Follow code size',
			'settings.page.appearance.terminalWeightTitle' => 'Terminal weight',
			'settings.page.appearance.terminalWeightDesc' => 'Low-density screens render strokes heavier. Auto lightens them there and leaves Retina untouched.',
			'settings.page.appearance.terminalWeightAuto' => 'Auto (by screen)',
			'settings.page.appearance.terminalWeightLight' => 'Light',
			'settings.page.appearance.terminalWeightNormal' => 'Normal',
			'settings.page.appearance.terminalWeightMedium' => 'Medium',
			'settings.page.appearance.terminalWeightSemiBold' => 'Semibold',
			'settings.page.appearance.sectionConversation' => 'Conversation',
			'settings.page.appearance.pinUserMessageTitle' => 'Pin user message',
			'settings.page.appearance.pinUserMessageDesc' => 'The question stays fixed at the top while the answer scrolls.',
			'settings.page.appearance.importTheme' => 'Import…',
			'settings.page.appearance.exportTheme' => 'Export…',
			'settings.page.appearance.deleteTheme' => 'Remove',
			'settings.page.appearance.importThemeDialog' => 'Pick a theme file',
			'settings.page.appearance.exportThemeDialog' => 'Save theme as',
			'settings.page.appearance.themeImported' => ({required Object name}) => 'Theme "${name}" imported.',
			'settings.page.appearance.themeExported' => 'Theme saved.',
			'settings.page.appearance.themeDeleted' => 'Theme removed.',
			'settings.page.appearance.fontPickerTitle' => 'Choose a font',
			'settings.page.appearance.fontPickerSearch' => 'Search fonts',
			'settings.page.appearance.fontPickerEmpty' => 'No matching font found on this machine.',
			'settings.page.appearance.fontPickerBundled' => 'included',
			'settings.page.appearance.fontPickerCustom' => 'Not listed? Type the exact family name.',
			'settings.page.appearance.fontPickerCustomHint' => 'Family name',
			'settings.page.appearance.fontPickerUse' => 'Use',
			'settings.page.appearance.fontPickerDefault' => 'Default',
			'settings.page.appearance.fontMissing' => 'Not found on this machine — falling back.',
			'settings.page.appearance.sectionLayout' => 'Layout',
			'settings.page.appearance.swapPanelsTitle' => 'Swap side panels',
			'settings.page.appearance.swapPanelsDesc' => 'Puts workspaces on the right and files, search, git and database on the left.',
			'settings.page.notifications.sectionTitle' => 'Notifications',
			'settings.page.notifications.enableTitle' => 'Enable notifications',
			'settings.page.notifications.enableDesc' => 'Alert me when an agent finishes a turn and the window is not focused.',
			'settings.page.notifications.systemPermissionTitle' => 'System permission',
			'settings.page.notifications.grantedDesc' => 'GSH Desktop is allowed to send notifications.',
			'settings.page.notifications.notGrantedDesc' => 'macOS has not granted notification access yet.',
			'settings.page.notifications.granted' => 'Granted',
			'settings.page.notifications.requestPermission' => 'Request permission',
			'settings.page.notifications.soundsTitle' => 'Sounds',
			'settings.page.notifications.soundVolumeTitle' => 'Volume',
			'settings.page.notifications.soundTurnDone' => 'Turn completed',
			'settings.page.notifications.soundTurnDoneDesc' => 'An agent finished its turn.',
			'settings.page.notifications.soundActionRequired' => 'Action required',
			'settings.page.notifications.soundActionRequiredDesc' => 'An agent is waiting for your approval or answer.',
			'settings.page.notifications.soundDefault' => 'Default',
			'settings.page.notifications.soundCustom' => ({required Object name}) => 'Custom: ${name}',
			'settings.page.notifications.soundChooseFile' => 'Choose file',
			'settings.page.notifications.soundReset' => 'Reset to default',
			'settings.page.notifications.soundOnActiveTab' => 'Also play when this tab is active',
			'settings.page.notifications.soundPreview' => 'Preview',
			'settings.page.shortcuts.notCustomizable' => 'Keyboard shortcuts are not customizable yet.',
			'settings.page.languages.sectionFormatting' => 'FORMATTING',
			'settings.page.languages.formatOnSaveTitle' => 'Format on save',
			'settings.page.languages.formatOnSaveDesc' => 'Format the file automatically when you save (⌘S).',
			'settings.page.languages.sectionLanguageServers' => 'LANGUAGE SERVERS',
			'settings.page.languages.footerNote' => 'Errors and formatting use each language\'s language server. GSH Desktop does not install servers — it uses what is already on your machine. ● responds · ○ not found or invalid command (install the server or adjust the command).',
			'settings.page.languages.serverCommandLabel' => 'Language server command',
			'settings.page.languages.formatterCommandLabel' => 'Formatter command (optional)',
			'settings.page.languages.formatterHint' => 'External formatter with %FILE% placeholder. Takes precedence over the LSP formatter when set.',
			'settings.page.languages.resetToDefault' => 'Reset to default',
			'settings.page.languages.saveAndRestart' => 'Save & restart',
			'settings.page.languages.statusResponds' => 'Server responds',
			'settings.page.languages.statusNotFound' => 'Server not found or command invalid',
			'settings.page.automations.sectionCommitMessages' => 'Commit messages',
			'settings.page.automations.harness' => 'Harness',
			'settings.page.automations.harnessDiscovering' => 'Looking for installed command-line harnesses…',
			'settings.page.automations.harnessNoneFound' => 'No supported harness was found on PATH.',
			'settings.page.automations.harnessConfiguredUnavailable' => ({required Object harness}) => '${harness} is configured but unavailable.',
			'settings.page.automations.harnessChoose' => 'Choose the CLI used to generate commit messages.',
			'settings.page.automations.harnessRefresh' => 'Refresh installed harnesses',
			'settings.page.automations.notConfigured' => 'Not configured',
			'settings.page.automations.model' => 'Model',
			'settings.page.automations.modelUnavailable' => 'The model list is unavailable until the harness is found.',
			'settings.page.automations.modelCliOnly' => 'This harness uses its CLI default model.',
			'settings.page.automations.modelCliDefault' => 'CLI default',
			'settings.page.automations.modelAuto' => 'Auto',
			'settings.page.automations.modelSearch' => ({required Object count}) => 'Search among ${count} models…',
			'settings.page.automations.modelAutoRouted' => 'This harness routes the model automatically.',
			'settings.page.automations.modelAccountOnly' => 'Only models your account can use are listed.',
			'settings.page.automations.generateFromSourceControl' => 'Generate from Source Control',
			'settings.page.automations.generateFromSourceControlDescription' => 'GSH Desktop sends only the selected diff and recent commit subjects. Common credential patterns and sensitive files are redacted before the harness runs.',
			'settings.page.automations.discoveryFailed' => 'Could not discover installed automation harnesses.',
			'settings.page.automations.staleModel' => ({required Object model, required Object harness}) => 'Model "${model}" is no longer available for ${harness}. Using the CLI default — pick another model in Settings if needed.',
			'settings.page.automations.recommendedSuffix' => 'Recommended',
			'settings.page.claudeCode.sectionGeneral' => 'General',
			'settings.page.claudeCode.classifyTitle' => 'Classify session states',
			'settings.page.claudeCode.classifyDesc' => 'Show in the chat header the state Claude Code assigns at the end of each turn: completed, ready for review or blocked. Claude Code classifies either way; turning this off only hides the badge.',
			'settings.page.claudeCode.switchModelsTitle' => 'Switch models when a message is flagged',
			'settings.page.claudeCode.switchModelsDesc' => 'When safeguards flag a message, automatically switch to a different model to keep the conversation going. When off, your session pauses instead. Saved in ~/.claude/settings.json (switchModelsOnFlag).',
			'settings.page.claudeCode.sectionCodeAppearance' => 'Code appearance',
			'settings.page.claudeCode.followTheme' => 'From the active theme',
			'settings.page.claudeCode.codeThemeLightHint' => 'Code colors in light mode',
			'settings.page.claudeCode.codeThemeDarkHint' => 'Code colors in dark mode',
			'settings.page.claudeCode.codeFontTitle' => 'Code font',
			'settings.page.claudeCode.codeFontDesc' => 'A custom monospaced font for code: viewer, editor, diffs and the chat\'s code blocks. The terminal has its own font under Appearance.',
			'settings.page.claudeCode.codeFontPlaceholder' => 'e.g. JetBrains Mono',
			'settings.page.claudeCode.sectionAppearance' => 'Appearance',
			'settings.page.claudeCode.transcriptTitle' => 'Default transcript view',
			'settings.page.claudeCode.transcriptDesc' => 'The view new chat conversations open with. Conversations already open keep theirs.',
			'settings.page.claudeCode.viewNormal' => 'Normal',
			'settings.page.claudeCode.viewThinking' => 'Thinking',
			'settings.page.claudeCode.viewVerbose' => 'Verbose',
			'settings.page.claudeCode.sectionRemoteControl' => 'Remote Control',
			'settings.page.claudeCode.chatRemoteControlTitle' => 'Chat with Remote Control (experimental)',
			'settings.page.claudeCode.chatRemoteControlDesc' => 'The GSH chat runs the interactive claude in a hidden terminal, connected to Remote Control: the conversation shows up on your phone and at claude.ai/code, and other machines\' sessions can see it. Replies arrive per message (no letter-by-letter streaming). Applies to chats opened after the change; turn it off to go back to the fast engine.',
			'settings.page.claudeCode.remoteControlTitle' => 'Connect new sessions to Remote Control',
			'settings.page.claudeCode.remoteControlDesc' => 'Every claude session you start in a terminal connects to Remote Control, so you can continue it on your phone or at claude.ai/code. Saved in ~/.claude/settings.json (remoteControlAtStartup). Needs a claude.ai login (Pro, Max, Team or Enterprise).',
			'settings.page.claudeCode.saveFailed' => ({required Object detail}) => 'Couldn\'t save: ${detail}',
			'settings.page.claudeCode.sectionSessions' => 'Sessions',
			'settings.page.claudeCode.promptSuggestionsTitle' => 'Prompt suggestions',
			'settings.page.claudeCode.promptSuggestionsDesc' => 'Show a suggested next prompt after Claude answers. Suggestions use a bit of your usage.',
			'settings.page.claudeCode.outputStyleTitle' => 'Output style',
			'settings.page.claudeCode.outputStyleDesc' => 'How Claude structures answers in Code sessions. Applies to new sessions.',
			'settings.page.claudeCode.outputStyleDefault' => 'Default',
			'settings.page.claudeCode.crossSessionTitle' => 'Messages from other sessions',
			'settings.page.claudeCode.crossSessionDesc' => 'What to do when another Claude Code session sends this one a message (SendMessage). GSH sets Accept for every session on this machine; Hold parks it for your approval, Refuse drops it. Saved as crossSessionInbound.',
			'settings.page.claudeCode.crossSessionDefault' => 'Default',
			'settings.page.claudeCode.crossSessionAccept' => 'Accept',
			'settings.page.claudeCode.crossSessionHold' => 'Hold for approval',
			'settings.page.claudeCode.crossSessionRefuse' => 'Refuse',
			'settings.page.claudeCode.sandboxTitle' => 'Local sandbox',
			'settings.page.claudeCode.sandboxDesc' => 'Runs Claude Code bash commands inside an isolated sandbox. Applies to new sessions.',
			'settings.page.claudeCode.sandboxStrictTitle' => 'Strict sandbox mode',
			'settings.page.claudeCode.sandboxStrictDesc' => 'Blocks commands that cannot run inside the sandbox instead of running them outside it.',
			'settings.page.claudeCode.sectionSecurity' => 'Security',
			'settings.page.claudeCode.protectedHostsTitle' => 'Protected hosts',
			'settings.page.claudeCode.protectedHostsDesc' => 'Hosts no agent may touch from a command: ssh, scp, remote workspace, anything that names them. GSH blocks the command before it runs, in every Claude Code and Codex session on this machine, and tells the agent to ask you. Comma-separated; whole words (prod blocks "ssh prod" and "prod.x.com", not "production"). Saved in ~/.gsh/protected-hosts.json.',
			'settings.page.claudeCode.sectionBrowser' => 'Browser',
			'settings.page.claudeCode.linksInAppTitle' => 'Open links in the built-in browser',
			'settings.page.claudeCode.linksInAppDesc' => 'Links clicked in terminals open in a GSH browser tab instead of your default browser.',
			'settings.page.placeholder.cowork1' => 'Cowork is a Claude Desktop feature (tasks that run on this computer with local files, browser and MCPs).',
			'settings.page.placeholder.cowork2' => 'In GSH the equivalent is the Claude chat in a workspace and the Farm, where agent loops run in terminals.',
			'settings.page.placeholder.extensionsDesc' => 'Let Claude work directly with apps, data and tools on your computer.',
			'settings.page.placeholder.extensionsEmpty' => 'No extension installed',
			'settings.page.placeholder.extensions' => '.MCPB/.DXT extensions belong to Claude Desktop. In GSH, MCP servers live under Connectors and Developer.',
			'settings.page.claude.refresh' => 'Refresh',
			'settings.page.claude.loading' => 'Loading…',
			'settings.page.claude.terminalTitle' => 'Open a terminal',
			'settings.page.claude.noWorkspace' => 'Open a local workspace first: this runs the `claude` CLI in one of its terminals so you can follow it.',
			'settings.page.claude.months' => 'Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec',
			'settings.page.claude.weekdays' => 'Mon|Tue|Wed|Thu|Fri|Sat|Sun',
			'settings.page.claude.dateShort' => ({required Object month, required Object day}) => '${month} ${day}',
			'settings.page.claude.error.cliMissing' => 'Claude Code CLI (`claude`) not found on this computer.',
			'settings.page.claude.error.timeout' => 'The `claude` CLI took too long to answer.',
			'settings.page.claude.error.failed' => ({required Object detail}) => 'The `claude` CLI failed: ${detail}',
			'settings.page.account.title' => 'Account',
			'settings.page.account.profile' => 'Profile',
			'settings.page.account.instructions' => 'Instructions for Claude',
			'settings.page.account.instructionsDesc' => 'Saved in ~/.claude/CLAUDE.md: Claude Code loads it in every session on this computer.',
			'settings.page.account.instructionsHint' => 'e.g. keep explanations short and direct',
			'settings.page.account.loggedIn' => 'Signed in',
			'settings.page.account.loggedOut' => 'Signed out',
			'settings.page.account.loggedInDesc' => 'Claude Code on this computer uses this account.',
			'settings.page.account.loggedOutDesc' => 'Sign in to use your Claude subscription in Claude Code.',
			'settings.page.account.login' => 'Sign in',
			'settings.page.account.logout' => 'Sign out',
			'settings.page.account.logoutConfirmTitle' => 'Sign out of Claude Code?',
			'settings.page.account.logoutConfirmMessage' => 'Runs `claude auth logout`. Sessions on this computer stop using your subscription until you sign in again.',
			'settings.page.account.email' => 'Email',
			'settings.page.account.organization' => 'Organization',
			'settings.page.account.orgId' => 'Organization ID',
			'settings.page.account.plan' => 'Plan',
			'settings.page.account.method' => 'Sign-in method',
			'settings.page.usage.title' => 'Your usage limits',
			'settings.page.usage.weeklyTitle' => 'Weekly limits',
			'settings.page.usage.unavailable' => 'Plan limits do not apply to this sign-in (API key or third-party provider).',
			'settings.page.usage.windowSession' => 'Current session',
			'settings.page.usage.windowWeekly' => 'All models',
			'settings.page.usage.resetsIn' => ({required Object when}) => 'Resets in ${when}',
			'settings.page.usage.resetsAt' => ({required Object when}) => 'Resets ${when}',
			'settings.page.usage.percentUsed' => ({required Object pct}) => '${pct}% used',
			'settings.page.usage.updated' => ({required Object when}) => 'Last updated: ${when}',
			'settings.page.usage.justNow' => 'less than a minute ago',
			'settings.page.usage.minutesAgo' => ({required Object n}) => '${n} min ago',
			'settings.page.usage.minutes' => ({required Object m}) => '${m} min',
			'settings.page.usage.hoursMinutes' => ({required Object h, required Object m}) => '${h} h ${m} min',
			'settings.page.usage.plans.pro' => 'Pro',
			'settings.page.usage.plans.max' => 'Max',
			'settings.page.usage.plans.team' => 'Team',
			'settings.page.usage.plans.enterprise' => 'Enterprise',
			'settings.page.memory.title' => 'Memory',
			'settings.page.memory.intro' => 'What a Claude Code session in the active workspace loads: your instructions and the memory Claude writes on its own. Click to open the file.',
			'settings.page.memory.instructionsTitle' => 'Instructions',
			'settings.page.memory.autoTitle' => 'Auto memory',
			'settings.page.memory.empty' => 'No CLAUDE.md found.',
			'settings.page.memory.autoEmpty' => 'Claude has not saved memories for this workspace yet.',
			'settings.page.memory.scopeUser' => 'User (all projects)',
			'settings.page.memory.scopeProject' => 'Project',
			'settings.page.memory.updated' => ({required Object when}) => 'Updated ${when}',
			'settings.page.skills.groupUser' => 'Created by you',
			'settings.page.skills.groupProject' => 'From this project',
			'settings.page.skills.groupPlugins' => 'From plugins',
			'settings.page.skills.byYou' => 'by you',
			'settings.page.skills.byProject' => 'project',
			'settings.page.skills.empty' => 'No skills installed.',
			'settings.page.connectors.checking' => 'Checking each server… this can take a few seconds.',
			'settings.page.connectors.empty' => 'No MCP server configured.',
			'settings.page.connectors.addServer' => 'Add MCP server',
			'settings.page.connectors.colConnector' => 'Connector',
			'settings.page.connectors.colType' => 'Type',
			'settings.page.connectors.colStatus' => 'Status',
			'settings.page.connectors.fromPlugin' => ({required Object plugin}) => 'Provided by the plugin ${plugin}',
			'settings.page.connectors.typeWeb' => 'Web',
			'settings.page.connectors.typeLocal' => 'Local',
			'settings.page.connectors.originPlugin' => 'Plugin',
			'settings.page.connectors.link' => 'Connect',
			'settings.page.connectors.discoverIntro' => 'The claude.ai connector directory has no public API, so GSH does not list it. Add any MCP server here: GSH runs `claude mcp add` in a terminal.',
			'settings.page.connectors.formName' => 'Name',
			'settings.page.connectors.formType' => 'Type',
			'settings.page.connectors.formUrl' => 'URL',
			'settings.page.connectors.formCommand' => 'Command',
			'settings.page.connectors.formScope' => 'Scope',
			'settings.page.connectors.formScopeDesc' => 'User = every project; Local = only the project of the terminal.',
			'settings.page.connectors.scopeUser' => 'User',
			'settings.page.connectors.scopeLocal' => 'Local',
			'settings.page.connectors.docs' => 'MCP docs',
			'settings.page.connectors.addInTerminal' => 'Add in terminal',
			'settings.page.connectors.status.connected' => 'Connected',
			'settings.page.connectors.status.needsAuth' => 'Needs authentication',
			'settings.page.connectors.status.failed' => 'Failed',
			'settings.page.connectors.status.pending' => 'Pending approval',
			'settings.page.connectors.status.unknown' => 'Unknown',
			'settings.page.plugins.search' => 'Search skills and plugins',
			'settings.page.plugins.groupProject' => 'In this project',
			'settings.page.plugins.groupMarketplaces' => 'From the marketplaces you added',
			'settings.page.plugins.noWorkspace' => 'Open a workspace to see the plugins enabled in it.',
			'settings.page.plugins.projectEmpty' => 'No plugin enabled in .claude/settings.json of this project.',
			'settings.page.plugins.empty' => 'No plugins installed.',
			'settings.page.plugins.disabled' => 'Disabled',
			'settings.page.developer.title' => 'Developer',
			'settings.page.developer.mcpTitle' => 'Local MCP servers',
			'settings.page.developer.mcpDesc' => 'stdio MCP servers that Claude Code starts on this computer. They are configured in ~/.claude.json.',
			'settings.page.developer.mcpEmpty' => 'No local MCP server.',
			'settings.page.developer.editConfig' => 'Edit configuration',
			'settings.page.developer.command' => 'Command',
			'settings.page.developer.arguments' => 'Arguments',
			'settings.page.developer.error' => 'Error',
			'settings.page.developer.telemetryTitle' => 'Telemetry',
			'settings.page.developer.telemetryDesc' => 'Errors and logs from workspace processes are in the shell Telemetry panel; with developer mode on it also shows GSH Desktop’s own.',
			'settings.page.developer.claudeSettingsTitle' => 'Claude Code settings file',
			'settings.page.developer.claudeSettingsDesc' => '~/.claude/settings.json — permissions, hooks, environment and model.',
			'settings.page.developer.apiKeyTitle' => 'Want an API key?',
			'settings.page.developer.apiKeyDesc' => 'Create keys and check usage in the Claude Console. It needs another account and API usage is billed separately.',
			'settings.page.developer.apiKeyButton' => 'Go to the Console',
			'settings.page.system.title' => 'System',
			'settings.page.system.version' => 'App version',
			'settings.page.system.keepAwakeTitle' => 'Keep computer awake',
			'settings.page.system.keepAwakeDesc' => 'Prevents idle sleep while on (same as the bolt button in the rail). Turns off when the app closes; closing the lid still sleeps.',
			'settings.page.catalog.mine' => 'Mine',
			'settings.page.catalog.discover' => 'Discover',
			'settings.page.catalog.add' => 'Add',
			'settings.page.catalog.all' => 'All',
			'settings.page.catalog.by' => ({required Object author}) => 'by ${author}',
			'settings.page.catalog.newSkill' => 'New skill…',
			'settings.page.catalog.addMarketplace' => 'Add marketplace…',
			'settings.page.generalClaude.sectionAppearance' => 'Appearance',
			'settings.page.generalClaude.theme' => 'Theme',
			'settings.page.generalClaude.themeSystem' => 'System',
			'settings.page.generalClaude.themeLight' => 'Light',
			'settings.page.generalClaude.themeDark' => 'Dark',
			'settings.page.generalClaude.uiFont' => 'Interface font',
			'settings.page.generalClaude.uiFontDesc' => 'Font for the whole interface — menus, sidebars and panels.',
			'settings.page.generalClaude.chatFont' => 'Chat font',
			'settings.page.generalClaude.chatFontDesc' => 'Text of the Claude chat conversation.',
			'settings.page.generalClaude.chatFontDefault' => 'Same as the interface',
			'settings.page.generalClaude.textSize' => 'Text size',
			'settings.page.generalClaude.textSizeDesc' => 'Base text size of the app (the same setting as in Appearance).',
			'settings.page.generalClaude.sizeSmall' => 'Small',
			'settings.page.generalClaude.sizeMedium' => 'Medium',
			'settings.page.generalClaude.sizeLarge' => 'Large',
			'settings.page.generalClaude.transcriptWidth' => 'Transcript width',
			'settings.page.generalClaude.transcriptWidthDesc' => 'Maximum width of the chat transcript and message box.',
			'settings.page.generalClaude.widthNarrow' => 'Narrow',
			'settings.page.generalClaude.widthMedium' => 'Medium',
			'settings.page.generalClaude.widthWide' => 'Wide',
			'settings.page.generalClaude.reducedMotion' => 'Reduced motion',
			'settings.page.generalClaude.reducedMotionDesc' => 'Fewer animations in Claude Code (spinner shimmer, flashes). Saved as prefersReducedMotion in ~/.claude/settings.json.',
			'settings.page.generalClaude.sectionNotifications' => 'Notifications',
			'settings.page.generalClaude.notifyTurnDone' => 'Response completion',
			'settings.page.generalClaude.notifyTurnDoneDesc' => 'Get a notification when an agent finishes a response and the window is not focused.',
			'settings.page.generalClaude.notifyPermission' => 'Code permission requests',
			'settings.page.generalClaude.notifyPermissionDesc' => 'Play a sound when an agent is waiting for your approval or answer.',
			'settings.page.generalClaude.pushInputNeeded' => 'Push to phone when input is needed',
			'settings.page.generalClaude.pushInputNeededDesc' => 'Claude Code sends a push when a permission prompt or question is waiting (inputNeededNotifEnabled).',
			'settings.page.generalClaude.pushAgent' => 'Proactive phone notifications',
			'settings.page.generalClaude.pushAgentDesc' => 'Let Claude push important session updates to your phone (agentPushNotifEnabled).',
			'settings.page.privacy.title' => 'Data',
			'settings.page.privacy.gshTelemetry' => 'GSH telemetry',
			'settings.page.privacy.gshTelemetryDesc' => 'Local only: errors and logs stay in SQLite on this computer and are never sent anywhere.',
			'settings.page.privacy.ccTelemetry' => 'Turn off Claude Code telemetry',
			'settings.page.privacy.ccTelemetryDesc' => 'Sets DISABLE_TELEMETRY in the env of ~/.claude/settings.json (usage metrics are not sent).',
			'settings.page.privacy.ccErrors' => 'Turn off Claude Code error reports',
			'settings.page.privacy.ccErrorsDesc' => 'Sets DISABLE_ERROR_REPORTING in the env of ~/.claude/settings.json.',
			'settings.page.resources.sectionGeneral' => 'General',
			'settings.page.resources.sectionShell' => 'GSH features',
			'settings.page.resources.chat' => 'Chat with Claude (beta)',
			'settings.page.resources.chatDesc' => 'Chat button in the workspace bar (Claude Code in stream-json).',
			'settings.page.resources.farm' => 'Farm',
			'settings.page.resources.farmDesc' => 'Agent loops read from Claude Code transcripts.',
			'settings.page.resources.harnessFeature' => 'Harness',
			'settings.page.resources.harnessFeatureDesc' => 'Button that opens what the agent loads in the workspace: instructions, skills, subagents, hooks, permissions and MCP.',
			'settings.page.resources.sectionTeamFarm' => 'Team farm',
			'settings.page.resources.teamFarm' => 'See your teammates\' farms',
			'settings.page.resources.teamFarmDesc' => 'On the same network (e.g. at the office), each GSH announces its own farm and shows your teammates\' next to yours — zoom out to see them. No server: nothing leaves the local network. Off, nothing leaves your GSH.',
			'settings.page.resources.teamName' => 'Team',
			'settings.page.resources.teamNameDesc' => 'Only people using the same team name see each other.',
			'settings.page.resources.teamNamePlaceholder' => 'e.g. gorila',
			'settings.page.resources.teamMe' => 'Your name',
			'settings.page.resources.teamMeDesc' => 'Shown above your farm to your teammates.',
			'settings.page.resources.teamShowTitles' => 'Show session titles',
			'settings.page.resources.teamShowTitlesDesc' => 'Titles may contain bits of your prompts. Off, teammates only see each agent\'s folder, status and tokens.',
			'settings.page.resources.teamSecret' => 'Team password',
			'settings.page.resources.teamSecretDesc' => 'Turns on agent-to-agent messaging: your agent can send messages and files to your teammates\' agents, and theirs to yours. Everyone on the team uses the same password; without it, nobody knocks on your door (and farms without it don\'t show up).',
			'settings.page.resources.teamSecretPlaceholder' => 'agree on a password',
			'settings.page.resources.teamDoorAllow' => 'Who can knock',
			'settings.page.resources.teamDoorAllowDesc' => 'Teammates\' names, comma separated. Empty = the whole team.',
			'settings.page.resources.teamDoorAllowPlaceholder' => 'whole team',
			'settings.page.resources.teamDoorAsk' => 'Ask before opening the door',
			'settings.page.resources.teamDoorAskDesc' => 'When a teammate sends something to one of your agents, GSH asks you before handing it over. Off, your agent gets it directly, marked as information from a teammate (not as an order from you).',
			'settings.page.resources.teamNetwork' => 'Work network',
			'settings.page.resources.teamNetworkDesc' => 'The office network\'s IP range (e.g. 192.168.10.0/24). When set, GSH only announces and listens while you\'re on it.',
			'settings.page.resources.teamNetworkPlaceholder' => 'any local network',
			'settings.page.resources.farmScenery' => 'Farm scenery',
			'settings.page.resources.farmSceneryDesc' => 'Where the agents live: the farm or a pixel art office.',
			'settings.page.resources.sceneryFarm' => 'Farm',
			'settings.page.resources.sceneryOffice' => 'Office',
			'settings.page.resources.graph' => 'Agent graph',
			'settings.page.resources.graphDesc' => 'Visualize the agents of the workspace and who talks to whom.',
			'settings.page.resources.browser' => 'Built-in browser',
			'settings.page.resources.browserDesc' => '"Browser" tab in the pane menu (where the platform has an inline webview).',
			'settings.page.resources.skillsMoved' => 'Skills moved to ',
			'settings.page.designSystems.title' => 'Design systems',
			'settings.page.designSystems.desc' => 'In GSH these are the themes: interface, terminal and code colors in one package.',
			'settings.page.designSystems.add' => 'New design system',
			'settings.page.designSystems.search' => 'Search by name',
			'settings.page.designSystems.showing' => ({required Object n, required Object total}) => 'Showing ${n} of ${total}',
			'settings.page.designSystems.colName' => 'Name',
			'settings.page.designSystems.colOrigin' => 'Origin',
			'settings.page.designSystems.colAuthor' => 'Author',
			'settings.page.designSystems.active' => 'Active',
			'settings.page.designSystems.imported' => 'Imported',
			'settings.page.designSystems.builtIn' => 'Built-in',
			'settings.page.designSystems.activate' => 'Use this theme',
			'settings.page.designSystems.remove' => 'Remove',
			'settings.remoteHosts.title' => 'Remote hosts',
			'settings.remoteHosts.description' => 'Machines you reach over SSH. Adding a host here is the same as adding one from the workspace "+" menu.',
			'settings.remoteHosts.empty' => 'No remote hosts yet.',
			'settings.remoteHosts.add' => 'Add host',
			'settings.remoteHosts.edit' => 'Edit',
			'settings.remoteHosts.reconnect' => 'Reconnect',
			'settings.remoteHosts.remove' => 'Remove',
			'settings.remoteHosts.removeTitle' => 'Remove host',
			'settings.remoteHosts.removeMessage' => ({required Object name}) => 'Remove "${name}" and all its workspaces? Nothing is deleted on the host itself.',
			'settings.remoteHosts.workspacesCount' => ({required Object count}) => '${count} workspace(s)',
			'settings.remoteHosts.deviceKeyTitle' => 'This device\'s key',
			'settings.remoteHosts.deviceKeyDesc' => 'Add this public key to ~/.ssh/authorized_keys on the host so this device can connect.',
			'settings.remoteHosts.deviceKeyCopy' => 'Copy public key',
			'settings.remoteHosts.deviceKeyCopied' => 'Public key copied',
			'settings.remoteHosts.statusConnected' => 'Connected',
			'settings.remoteHosts.statusConnecting' => 'Connecting…',
			'settings.remoteHosts.statusReconnecting' => 'Reconnecting…',
			'settings.remoteHosts.statusOffline' => 'Offline',
			'settings.remoteHosts.statusIdle' => 'Not connected',
			'settings.remoteHosts.helpTitle' => 'How it works',
			'settings.remoteHosts.helpBody' => 'GSH Desktop connects to your machine over SSH and talks to a small server that runs the terminals, files and git there. The host must have GSH Desktop (desktop) or the gsh-server installed and running, and this device’s public key added to its ~/.ssh/authorized_keys.',
			'automation.error.unavailable' => ({required Object harness}) => '${harness} is not installed or is not on PATH.',
			'automation.error.modelUnavailable' => ({required Object model, required Object harness}) => 'Model "${model}" is not available for ${harness}. Choose another model in Settings.',
			'automation.error.authentication' => ({required Object harness, required Object detail}) => '${harness}: ${detail}',
			'automation.error.timeout' => ({required Object harness, required Object seconds}) => '${harness} did not respond within ${seconds} seconds.',
			'automation.error.cancelled' => 'Commit message generation was cancelled.',
			'automation.error.process' => ({required Object harness, required Object detail}) => '${harness}: ${detail}',
			'automation.error.processNoDetail' => ({required Object harness}) => '${harness} could not generate a commit message.',
			'automation.error.invalidResponse' => 'The automation returned an empty commit message.',
			'automation.error.busy' => 'Another commit message is already being generated.',
			'automation.error.unknown' => 'The automation could not generate a commit message.',
			'automation.error.noWorkspace' => 'No workspace selected.',
			'automation.error.fileOutsideWorkspace' => 'File is outside the workspace roots.',
			'automation.error.fileUnreadable' => ({required Object detail}) => 'Could not read the file: ${detail}',
			'automation.error.binaryFile' => 'A commit message cannot be generated for a binary file.',
			'automation.error.noFileChanges' => 'There are no changes to describe for this file.',
			'automation.error.noStagedChanges' => 'There are no staged changes to describe.',
			'automation.error.multipleRepositories' => 'Staged changes belong to multiple repositories. Generate them separately.',
			'automation.error.diffUnavailable' => 'Could not read the diff.',
			'automation.error.notConfigured' => 'Configure a commit message harness in Settings.',
			'fileOperation.error.alreadyExists' => ({required Object name}) => 'Already exists: “${name}”.',
			'fileOperation.error.notFound' => ({required Object name}) => 'Not found: “${name}”.',
			'fileOperation.error.invalidPath' => 'Invalid path.',
			'fileOperation.error.emptyName' => 'The name cannot be empty.',
			'fileOperation.error.noWorkspace' => 'No workspace selected.',
			'fileOperation.error.cannotMoveIntoItself' => 'Cannot move a folder into itself.',
			'fileOperation.error.clipboardEmpty' => 'Clipboard is empty.',
			'fileOperation.error.notScratchTab' => 'This tab is not a scratch file.',
			'fileOperation.error.writeFailed' => 'Could not write the file.',
			'fileOperation.error.formatterEmptyCommand' => 'Empty formatter command.',
			'fileOperation.error.formatterMissingPlaceholder' => 'Formatter command must include the %FILE% placeholder.',
			'fileOperation.error.formatterTimeout' => 'Formatter timed out.',
			'fileOperation.error.formatterExitCode' => ({required Object code}) => 'Formatter exited with ${code}.',
			'fileOperation.error.formatterFailed' => 'The formatter could not run.',
			'fileOperation.error.osFailure' => ({required Object detail}) => '${detail}',
			_ => null,
		} ?? switch (path) {
			'fileOperation.error.nameHasSlash' => 'Name cannot contain “/”.',
			'fileOperation.error.invalidName' => 'Invalid name.',
			'fileOperation.error.remoteDropUnsupported' => 'Dropping files into a remote workspace is not supported yet.',
			'theme.error.io' => 'Could not read or write the theme file.',
			'theme.error.ioDetail' => ({required Object detail}) => 'Could not read or write the theme file: ${detail}',
			'theme.error.malformedJson' => ({required Object detail}) => 'This file is not valid JSON: ${detail}',
			'theme.error.invalidTheme' => 'This file is not a valid theme.',
			'theme.error.reservedId' => 'This theme uses the id of a built-in theme. Change "id" in the file and import again.',
			'theme.error.notAnObject' => ({required Object field}) => 'Expected an object at "${field}".',
			'theme.error.missingField' => ({required Object field}) => 'Missing required field "${field}".',
			'theme.error.badColor' => ({required Object value, required Object field}) => '"${value}" at "${field}" is not a color. Use #RGB, #RRGGBB or #RRGGBBAA.',
			'theme.error.unknownBase' => ({required Object value}) => 'Unknown base theme "${value}" in "extends".',
			'theme.error.noVariants' => 'The theme declares no variant. Add "dark", "light" or both under "variants".',
			_ => null,
		};
	}
}
