; Template Inno Setup custom do GSH (plano 47). Referenciado por
; `script_template: inno_template.iss` no make_config.yaml. Baseado no template
; default do fastforge (flutter_app_packager) + as diretivas de self-update.
; As variáveis {{...}}/{% %} são preenchidas pelo fastforge (Liquid).
[Setup]
AppId={{APP_ID}}
AppVersion={{APP_VERSION}}
AppName={{DISPLAY_NAME}}
AppPublisher={{PUBLISHER_NAME}}
AppPublisherURL={{PUBLISHER_URL}}
AppSupportURL={{PUBLISHER_URL}}
AppUpdatesURL={{PUBLISHER_URL}}
DefaultDirName={{INSTALL_DIR_NAME}}
DisableProgramGroupPage=yes
OutputDir=.
OutputBaseFilename={{OUTPUT_BASE_FILENAME}}
Compression=lzma
SolidCompression=yes
SetupIconFile={{SETUP_ICON_FILE}}
WizardStyle=modern
PrivilegesRequired={{PRIVILEGES_REQUIRED}}
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
; Plano 47 — self-update via WinSparkle. Num update silencioso o gsh pode
; estar rodando: o Restart Manager fecha a instância (CloseApplications) e a
; relança após instalar (RestartApplications). O WinSparkle encerra o app antes
; de rodar o instalador, então o RM vê uma instância só — sem duplo-launch.
; VALIDAR no Windows real (não testável neste Mac).
CloseApplications=yes
RestartApplications=yes
; Associação de arquivos (k17): o Explorer reconstrói o cache de tipos.
ChangesAssociations=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: {% if CREATE_DESKTOP_ICON != true %}unchecked{% else %}checkedonce{% endif %}

[Files]
Source: "{{SOURCE_DIR}}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{{DISPLAY_NAME}}"; Filename: "{app}\{{EXECUTABLE_NAME}}"
Name: "{autodesktop}\{{DISPLAY_NAME}}"; Filename: "{app}\{{EXECUTABLE_NAME}}"; Tasks: desktopicon

; "Abrir com GSH" (k17). ProgIds próprios por tipo; .kanban/.ckp/.dbq/.http
; são do GSH e viram default. .md só entra na lista "Abrir com"
; (OpenWithProgids) — não rouba o editor padrão de Markdown do usuário.
; Instalação por usuário → HKCU\Software\Classes (sem admin). O app recebe o
; caminho como argumento e, se já há um GSH aberto, repassa a ele
; (instância única, ver RunningInstance no Dart).
[Registry]
Root: HKCU; Subkey: "Software\Classes\GSH.Kanban"; ValueType: string; ValueData: "GSH Kanban Board"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\GSH.Kanban\DefaultIcon"; ValueType: string; ValueData: "{app}\{{EXECUTABLE_NAME}},0"
Root: HKCU; Subkey: "Software\Classes\GSH.Kanban\shell\open\command"; ValueType: string; ValueData: """{app}\{{EXECUTABLE_NAME}}"" ""%1"""
Root: HKCU; Subkey: "Software\Classes\.kanban"; ValueType: string; ValueData: "GSH.Kanban"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Classes\.kanban\OpenWithProgids"; ValueType: string; ValueName: "GSH.Kanban"; ValueData: ""; Flags: uninsdeletevalue

Root: HKCU; Subkey: "Software\Classes\GSH.Layout"; ValueType: string; ValueData: "GSH Pane Layout"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\GSH.Layout\DefaultIcon"; ValueType: string; ValueData: "{app}\{{EXECUTABLE_NAME}},0"
Root: HKCU; Subkey: "Software\Classes\GSH.Layout\shell\open\command"; ValueType: string; ValueData: """{app}\{{EXECUTABLE_NAME}}"" ""%1"""
Root: HKCU; Subkey: "Software\Classes\.ckp"; ValueType: string; ValueData: "GSH.Layout"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Classes\.ckp\OpenWithProgids"; ValueType: string; ValueName: "GSH.Layout"; ValueData: ""; Flags: uninsdeletevalue

Root: HKCU; Subkey: "Software\Classes\GSH.Query"; ValueType: string; ValueData: "GSH Database Query"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\GSH.Query\DefaultIcon"; ValueType: string; ValueData: "{app}\{{EXECUTABLE_NAME}},0"
Root: HKCU; Subkey: "Software\Classes\GSH.Query\shell\open\command"; ValueType: string; ValueData: """{app}\{{EXECUTABLE_NAME}}"" ""%1"""
Root: HKCU; Subkey: "Software\Classes\.dbq"; ValueType: string; ValueData: "GSH.Query"; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Classes\.dbq\OpenWithProgids"; ValueType: string; ValueName: "GSH.Query"; ValueData: ""; Flags: uninsdeletevalue

Root: HKCU; Subkey: "Software\Classes\GSH.Http"; ValueType: string; ValueData: "GSH HTTP Request"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\GSH.Http\DefaultIcon"; ValueType: string; ValueData: "{app}\{{EXECUTABLE_NAME}},0"
Root: HKCU; Subkey: "Software\Classes\GSH.Http\shell\open\command"; ValueType: string; ValueData: """{app}\{{EXECUTABLE_NAME}}"" ""%1"""
Root: HKCU; Subkey: "Software\Classes\.http\OpenWithProgids"; ValueType: string; ValueName: "GSH.Http"; ValueData: ""; Flags: uninsdeletevalue

Root: HKCU; Subkey: "Software\Classes\GSH.Markdown"; ValueType: string; ValueData: "Markdown (GSH)"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\GSH.Markdown\DefaultIcon"; ValueType: string; ValueData: "{app}\{{EXECUTABLE_NAME}},0"
Root: HKCU; Subkey: "Software\Classes\GSH.Markdown\shell\open\command"; ValueType: string; ValueData: """{app}\{{EXECUTABLE_NAME}}"" ""%1"""
Root: HKCU; Subkey: "Software\Classes\.md\OpenWithProgids"; ValueType: string; ValueName: "GSH.Markdown"; ValueData: ""; Flags: uninsdeletevalue
Root: HKCU; Subkey: "Software\Classes\.markdown\OpenWithProgids"; ValueType: string; ValueName: "GSH.Markdown"; ValueData: ""; Flags: uninsdeletevalue

[Run]
Filename: "{app}\{{EXECUTABLE_NAME}}"; Description: "{cm:LaunchProgram,{{DISPLAY_NAME}}}"; Flags: nowait postinstall skipifsilent
