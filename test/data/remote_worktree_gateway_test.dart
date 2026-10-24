import 'package:gsh_desktop/app/gsh/data/remote/remote_worktree_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteWorktreeGateway.parsePorcelain', () {
    const repo = '/home/jacob/proj';

    test('descarta a raiz e extrai forks com branch', () {
      const out = '''
worktree /home/jacob/proj
HEAD aaaa
branch refs/heads/main

worktree /home/jacob/proj/.gsh/worktrees/feature
HEAD bbbb
branch refs/heads/feature
''';
      final entries = RemoteWorktreeGateway.parsePorcelain(out, repo);
      expect(entries.length, 1);
      expect(entries.single.path, '$repo/.gsh/worktrees/feature');
      expect(entries.single.branch, 'feature');
    });

    test('detached HEAD usa o basename como rótulo', () {
      const out = '''
worktree /home/jacob/proj
HEAD aaaa
branch refs/heads/main

worktree /home/jacob/proj/.gsh/worktrees/wip
HEAD cccc
detached
''';
      final entries = RemoteWorktreeGateway.parsePorcelain(out, repo);
      expect(entries.single.branch, 'wip');
    });

    test('saída vazia = sem forks', () {
      expect(RemoteWorktreeGateway.parsePorcelain('', repo), isEmpty);
    });
  });
}
