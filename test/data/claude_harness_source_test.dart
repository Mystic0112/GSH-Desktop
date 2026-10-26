import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gsh_desktop/app/gsh/data/harness/claude_harness_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/project_harness.dart';
import 'package:path/path.dart' as p;

void main() {
  late String home, ws;
  setUp(() async {
    final root = await Directory.systemTemp.createTemp('harness');
    home = p.join(root.path, 'home');
    ws = p.join(root.path, 'repo');
    void w(String path, String body) => File(path)
      ..createSync(recursive: true)
      ..writeAsStringSync(body);
    w(p.join(home, '.claude', 'CLAUDE.md'), '# eu');
    w(
      p.join(home, '.claude', 'agents', 'levi.md'),
      '---\nname: levi\ndescription: QA\n---\n',
    );
    w(
      p.join(home, '.claude.json'),
      jsonEncode({
        'mcpServers': {
          'iris': {
            'command': 'npx',
            'args': ['iris'],
          },
        },
        'projects': {
          ws: {
            'mcpServers': {
              'db': {'type': 'http', 'url': 'http://x'},
            },
          },
        },
      }),
    );
    w(p.join(ws, 'CLAUDE.md'), '# repo');
    w(p.join(ws, 'AGENTS.md'), '# agents');
    w(
      p.join(ws, '.claude', 'skills', 'deploy', 'SKILL.md'),
      '---\nname: deploy\ndescription: sobe\n---\n',
    );
    w(
      p.join(ws, '.claude', 'commands', 'git', 'pr.md'),
      '---\ndescription: abre PR\n---\n',
    );
    w(
      p.join(ws, '.claude', 'settings.json'),
      jsonEncode({
        'hooks': {
          'PreToolUse': [
            {
              'matcher': 'Bash',
              'hooks': [
                {'type': 'command', 'command': 'gsh hook'},
              ],
            },
          ],
        },
        'permissions': {
          'allow': ['Bash(npm test *)'],
          'deny': ['Read(.env)'],
        },
      }),
    );
    w(p.join(ws, '.claude', 'settings.local.json'), '{inválido');
    w(
      p.join(ws, '.mcp.json'),
      jsonEncode({
        'mcpServers': {
          'pg': {'command': 'pg-mcp'},
        },
      }),
    );
  });

  test('lê cada seção com escopo e arquivo', () async {
    final h = await ClaudeHarnessSource(home: home).read(ws);
    List<(String, HarnessScope)> of(HarnessKind k) => [
      for (final e in h.of(k)) (e.name, e.scope),
    ];
    expect(
      of(HarnessKind.memory),
      containsAll([
        ('~/.claude/CLAUDE.md', HarnessScope.user),
        ('CLAUDE.md', HarnessScope.project),
        ('AGENTS.md', HarnessScope.project),
      ]),
    );
    expect(of(HarnessKind.skills), [('deploy', HarnessScope.project)]);
    expect(of(HarnessKind.agents), [('levi', HarnessScope.user)]);
    expect(of(HarnessKind.commands), [('/git:pr', HarnessScope.project)]);
    expect(h.of(HarnessKind.hooks).single.name, 'PreToolUse · Bash');
    expect(h.of(HarnessKind.hooks).single.detail, 'gsh hook');
    expect(of(HarnessKind.permissions), [
      ('Bash(npm test *)', HarnessScope.project),
      ('Read(.env)', HarnessScope.project),
    ]);
    expect(
      of(HarnessKind.mcp),
      containsAll([
        ('pg', HarnessScope.project),
        ('iris', HarnessScope.user),
        ('db', HarnessScope.local),
      ]),
    );
    // Lint: settings.local.json quebrado aparece; skill com descrição não
    // tem aviso; custo fixo conta CLAUDE.md inteiro + descrições.
    expect(h.invalidFiles.single, endsWith('settings.local.json'));
    expect(h.of(HarnessKind.skills).single.issues, isEmpty);
    expect(h.alwaysOnTokens(HarnessKind.memory), greaterThan(0));
    expect(h.issueCount, 1);
    // ~/.claude.json é só leitura.
    expect(
      h.of(HarnessKind.mcp).firstWhere((e) => e.name == 'iris').path,
      isNull,
    );
  });

  test('cria skill/subagente/comando pelo modelo sem sobrescrever', () async {
    final src = ClaudeHarnessSource(home: home);
    final skill = await src.create(ws, HarnessKind.skills, name: 'Revisar PR!');
    expect(skill, p.join(ws, '.claude', 'skills', 'revisar-pr', 'SKILL.md'));
    expect(File(skill).readAsStringSync(), contains('name: revisar-pr'));
    final cmd = await src.create(ws, HarnessKind.commands, name: 'pr');
    expect(cmd, endsWith('commands/pr.md'));
    final md = await src.create(ws, HarnessKind.memory);
    expect(File(md).readAsStringSync(), '# repo'); // já existia
    expect(harnessSlug('../../etc'), 'etc');
  });

  test('lint: sem descrição, script sumido, arquivo grande', () {
    expect(
      hookScriptPath('"/opt/x y/gsh" hook', workspace: '/w', home: '/h'),
      '/opt/x y/gsh',
    );
    expect(hookScriptPath('gsh hook', workspace: '/w', home: '/h'), isNull);
    expect(
      hookScriptPath('bash ./scripts/n.sh', workspace: '/w', home: '/h'),
      '/w/scripts/n.sh',
    );
    expect(
      hookScriptPath(
        r'$CLAUDE_PROJECT_DIR/.claude/hooks/a.sh',
        workspace: '/w',
        home: '/h',
      ),
      '/w/.claude/hooks/a.sh',
    );
    expect(hookScriptPath('~/bin/x', workspace: '/w', home: '/h'), '/h/bin/x');
    final hooks = settingsEntries(
      {
        'hooks': {
          'Stop': [
            {
              'hooks': [
                {'type': 'command', 'command': './nao-existe.sh'},
              ],
            },
          ],
        },
      },
      '/w/.claude/settings.json',
      HarnessScope.project,
      workspace: '/w',
      home: '/h',
    );
    expect(hooks.single.issues, [HarnessIssue.missingScript]);
  });

  test('instrução grande e subagente sem descrição', () async {
    File(
      p.join(ws, 'CLAUDE.md'),
    ).writeAsStringSync('x' * (maxInstructionChars + 1));
    File(p.join(ws, '.claude', 'agents', 'mudo.md'))
      ..createSync(recursive: true)
      ..writeAsStringSync('sem frontmatter');
    final h = await ClaudeHarnessSource(home: home).read(ws);
    final md = h
        .of(HarnessKind.memory)
        .firstWhere((e) => e.name == 'CLAUDE.md');
    expect(md.issues, [HarnessIssue.tooLarge]);
    final mudo = h.of(HarnessKind.agents).firstWhere((e) => e.name == 'mudo');
    expect(mudo.issues, [HarnessIssue.noDescription]);
    expect(h.alwaysOnTokens(), greaterThan(maxInstructionChars ~/ 4));
  });
}
