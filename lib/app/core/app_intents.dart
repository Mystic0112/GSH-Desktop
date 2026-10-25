import 'package:flutter/foundation.dart';

/// Pontes globais entre o shell (page-scoped) e handlers que vivem acima da
/// rota — atalhos de teclado (`main`/`AppRoot`, sempre na cadeia de foco) e o
/// menu nativo (`PlatformMenuBar`, fora da árvore de rotas). Cada ponte é `null`
/// enquanto o `GshPage` não estiver montado; os menus/atalhos checam antes
/// de disparar. O `GshPage` registra os handlers no `initState` e limpa no
/// `dispose`.

/// Menu **GSH → Configurações…** (⌘,) → empilha a rota `/settings`. Vive
/// numa ponte porque o `flutter_modular` v7 navega só via `context.pushNamed`, e
/// o menu nativo roda fora da árvore de rotas (sem `BuildContext`).
VoidCallback? requestOpenSettings;

/// Menu **Arquivo → Abrir projeto…** → abre o seletor de pasta e adiciona o
/// projeto (mesmo fluxo do botão "+" do rail).
VoidCallback? requestOpenProject;

/// Menu **GSH → Verificar atualizações…** → dispara um check imediato do
/// self-updater (Sparkle/WinSparkle) e, se já houver download pronto, instala.
VoidCallback? requestCheckForUpdates;

// Pontes usadas pelas Configurações (rota empilhada sobre o shell, sem acesso
// ao GshViewModel page-scoped). Registradas pelo próprio GshViewModel
// enquanto ele vive.

/// Abre [path] numa aba fixa do workspace ativo (Memória, Skills,
/// Desenvolvedor).
void Function(String path)? requestOpenFileTab;

/// Nova aba de terminal no workspace ativo rodando [command] (Conta →
/// Entrar). Devolve `false` sem workspace local ativo.
bool Function(String command)? requestRunInTerminal;

/// Raiz local do workspace ativo; `null` sem workspace com pasta local.
String? Function()? activeWorkspaceRoot;
