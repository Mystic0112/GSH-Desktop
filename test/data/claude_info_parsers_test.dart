import 'package:gsh_desktop/app/settings/data/claude_info_parsers.dart';
import 'package:gsh_desktop/app/settings/domain/claude_info.dart';
import 'package:flutter_test/flutter_test.dart';

// Fixtures copiadas da saída real do `claude` 2.1.309 (dados pessoais trocados).
void main() {
  test('auth status --json', () {
    final a = parseAuthStatus('''
{
  "loggedIn": true,
  "authMethod": "claude.ai",
  "apiProvider": "firstParty",
  "analyticsDisabled": false,
  "email": "dev@example.com",
  "orgId": "00000000-0000-0000-0000-000000000000",
  "orgName": "Acme",
  "subscriptionType": "team"
}''');
    expect(
      (a.loggedIn, a.email, a.orgName, a.subscriptionType, a.authMethod),
      (true, 'dev@example.com', 'Acme', 'team', 'claude.ai'),
    );
    expect(parseAuthStatus('{"loggedIn": false}').loggedIn, isFalse);
    expect(() => parseAuthStatus('[]'), throwsFormatException);
  });

  test('resposta do get_usage', () {
    final u = parseUsageReply({
      'subscription_type': 'team',
      'rate_limits_available': true,
      'rate_limits': {
        'five_hour': {
          'utilization': 4,
          'resets_at': '2026-10-24T02:59:59.626978+00:00',
        },
        'seven_day': {
          'utilization': 63,
          'resets_at': '2026-10-25T19:59:59.627002+00:00',
        },
        'seven_day_opus': null,
        'model_scoped': [
          {
            'display_name': 'Fable',
            'utilization': 37,
            'resets_at': '2026-10-25T19:59:59.627181+00:00',
          },
        ],
      },
      'behaviors': null,
    });
    expect(u.available, isTrue);
    expect(u.subscriptionType, 'team');
    expect(
      [for (final w in u.windows) (w.kind, w.label, w.percent)],
      [
        (UsageWindowKind.session, null, 4.0),
        (UsageWindowKind.weekly, null, 63.0),
        (UsageWindowKind.weeklyModel, 'Fable', 37.0),
      ],
    );
    expect(
      u.windows.first.resetsAt!.toUtc(),
      DateTime.utc(2026, 10, 24, 2, 59, 59, 626, 978),
    );

    final api = parseUsageReply({
      'subscription_type': null,
      'rate_limits_available': false,
      'rate_limits': null,
    });
    expect(api.available, isFalse);
    expect(api.windows, isEmpty);
  });

  test('mcp list', () {
    final s = parseMcpList('''
Checking MCP server health…

claude.ai Claude Docs: https://api.anthropic.com/v1/pages/mcp - √ Connected
claude.ai Supabase: https://mcp.supabase.com/mcp - ! Needs authentication
plugin:rankedin:rankedin: https://rankedin.app/api/mcp (HTTP) - ! Needs authentication
notebooklm: /home/dev/.local/bin/notebooklm-mcp --transport stdio - × Failed to connect — CONNECTION_CLOSED: Connection closed
rea: npx -y rea-agents@4.0.1 mcp - ✓ Connected
21st: https://21st.dev/api/mcp (HTTP) - ⏸ Pending approval (run `claude` to approve)
''');
    expect(
      [for (final m in s) (m.name, m.status)],
      [
        ('claude.ai Claude Docs', McpStatus.connected),
        ('claude.ai Supabase', McpStatus.needsAuth),
        ('plugin:rankedin:rankedin', McpStatus.needsAuth),
        ('notebooklm', McpStatus.failed),
        ('rea', McpStatus.connected),
        ('21st', McpStatus.pending),
      ],
    );
    expect(s[2].target, 'https://rankedin.app/api/mcp (HTTP)');
    expect(
      s[3].target,
      '/home/dev/.local/bin/notebooklm-mcp --transport stdio',
    );
    expect(s[3].statusText, startsWith('Failed to connect'));
    expect(s[4].target, 'npx -y rea-agents@4.0.1 mcp');
    expect(parseMcpList('No MCP servers configured.'), isEmpty);
  });

  test('plugin list --json', () {
    final p = parsePluginList('''
[
  {"id": "caveman@caveman", "version": "17f9f2ec2377", "scope": "user",
   "enabled": true, "installPath": "/x/cache/caveman/caveman/17f9f2ec2377"},
  {"id": "watch@claude-video", "version": "0.2.0", "scope": "project",
   "enabled": false}
]''');
    expect(
      [for (final x in p) (x.id, x.version, x.scope, x.enabled)],
      [
        ('caveman@caveman', '17f9f2ec2377', 'user', true),
        ('watch@claude-video', '0.2.0', 'project', false),
      ],
    );
    expect(p.first.installPath, endsWith('17f9f2ec2377'));
  });

  test('frontmatter do SKILL.md', () {
    expect(
      parseSkillFrontmatter(
        '---\nname: "AgentDB Advanced"\ndescription: "Master: features."\n---\n# x',
      ),
      (name: 'AgentDB Advanced', description: 'Master: features.'),
    );
    // Descrição com ": " sem aspas é YAML inválido: cai no leitor por linha.
    expect(
      parseSkillFrontmatter(
        '---\nname: gon\ndescription: Invoca o Gon: mobile dev\n---\n',
      ),
      (name: 'gon', description: 'Invoca o Gon: mobile dev'),
    );
    expect(parseSkillFrontmatter('# sem frontmatter'), (
      name: null,
      description: null,
    ));
  });

  test('marketplace list + marketplace.json + plugin.json', () {
    expect(
      parseMarketplaceList(
        '[{"name":"ponytail","source":"github","repo":"x/ponytail",'
        '"installLocation":"/h/.claude/plugins/marketplaces/ponytail"}]',
      ),
      {'ponytail': '/h/.claude/plugins/marketplaces/ponytail'},
    );
    final m = parseMarketplaceManifest(
      '{"name":"official","owner":{"name":"Anthropic"},"plugins":['
      '{"name":"adobe","description":"Edit images","author":{"name":"Adobe"}},'
      '{"name":"agent-sdk-dev","description":"SDK kit","category":"dev"}]}',
      marketplace: 'official',
      installed: {'agent-sdk-dev@official'},
    );
    expect(
      [for (final p in m) (p.id, p.author, p.installed)],
      [
        ('adobe@official', 'Adobe', false),
        ('agent-sdk-dev@official', 'Anthropic', true),
      ],
    );
    expect(
      parsePluginManifest(
        '{"name":"caveman","description":"Talk less","author":{"name":"Julius"}}',
      ),
      (name: 'caveman', description: 'Talk less', author: 'Julius'),
    );
  });

  test('índice MEMORY.md e tipo da memória', () {
    final idx = parseMemoryIndex(
      '# Memória\n'
      '- [Atividade 1](atividade-1.md) — entrega 26/08, Prof. Ricardo\n'
      '- [Perfil](profile.md)\n'
      'texto solto\n',
    );
    expect(
      [for (final e in idx) (e.title, e.file, e.hook)],
      [
        ('Atividade 1', 'atividade-1.md', 'entrega 26/08, Prof. Ricardo'),
        ('Perfil', 'profile.md', null),
      ],
    );
    expect(
      parseMemoryType(
        '---\nname: x\ndescription: "y"\nmetadata: \n  type: project\n---\n',
      ),
      'project',
    );
    expect(parseMemoryType('---\ntype: feedback\n---\n'), 'feedback');
  });

  test('servidor MCP: origem, nome e linha de comando', () {
    const ai = McpServerInfo(
      name: 'claude.ai Notion',
      target: 'https://mcp.notion.com/mcp',
      status: McpStatus.needsAuth,
      statusText: '',
    );
    const plugin = McpServerInfo(
      name: 'plugin:rankedin:rankedin',
      target: 'https://rankedin.app/api/mcp (HTTP)',
      status: McpStatus.connected,
      statusText: '',
    );
    const local = McpServerInfo(
      name: 'gsh',
      target: '/h/.gsh/bin/gsh mcp --agent claude-desktop',
      status: McpStatus.connected,
      statusText: '',
    );
    expect(
      [
        for (final s in [ai, plugin, local])
          (s.origin, s.displayName, s.isRemote),
      ],
      [
        (McpOrigin.claudeAi, 'Notion', true),
        (McpOrigin.plugin, 'rankedin', true),
        (McpOrigin.local, 'gsh', false),
      ],
    );
    expect(local.commandLine, (
      '/h/.gsh/bin/gsh',
      'mcp --agent claude-desktop',
    ));
  });
}
