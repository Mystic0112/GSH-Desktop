import 'package:cockpit/app/cockpit/domain/validators/worktree_name_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const validator = WorktreeNameValidator();

  WorktreeNameCheck check(
    String name, {
    Set<String> branches = const <String>{},
    Set<String> worktrees = const <String>{},
  }) => validator.validate(
    name,
    existingBranches: branches,
    existingWorktreeNames: worktrees,
  );

  group('formato', () {
    test('vazio', () {
      expect(check('').error, WorktreeNameError.empty);
    });

    test('espaço é rejeitado (regra do usuário)', () {
      expect(check('feat sso').error, WorktreeNameError.whitespace);
      expect(check('trailing ').error, WorktreeNameError.whitespace);
    });

    test('barra é permitida', () {
      expect(check('feat/sso').isValid, isTrue);
      expect(check('fix/prorate').isValid, isTrue);
    });

    test('caracteres proibidos do git', () {
      for (final n in <String>[
        'a~b',
        'a^b',
        'a:b',
        'a?b',
        'a*b',
        'a[b',
        r'a\b',
      ]) {
        expect(check(n).error, WorktreeNameError.invalidChar, reason: n);
      }
    });

    test('sequências inválidas', () {
      expect(check('foo..bar').error, WorktreeNameError.invalidSequence);
      expect(check('foo//bar').error, WorktreeNameError.invalidSequence);
      expect(check('foo@{bar').error, WorktreeNameError.invalidSequence);
      expect(check('@').error, WorktreeNameError.invalidSequence);
      expect(check('/foo').error, WorktreeNameError.invalidSequence);
      expect(check('foo/').error, WorktreeNameError.invalidSequence);
    });

    test('posições reservadas', () {
      expect(check('-foo').error, WorktreeNameError.reserved);
      expect(check('.foo').error, WorktreeNameError.reserved);
      expect(check('foo.').error, WorktreeNameError.reserved);
      expect(check('foo.lock').error, WorktreeNameError.reserved);
      expect(check('feat/.hidden').error, WorktreeNameError.reserved);
      expect(check('feat/x.lock').error, WorktreeNameError.reserved);
    });

    test('nome simples válido', () {
      expect(check('login').isValid, isTrue);
      expect(check('experiment/cache').isValid, isTrue);
    });
  });

  group('unicidade (decisão 11)', () {
    test('colide com branch local', () {
      expect(
        check('main', branches: {'main', 'dev'}).error,
        WorktreeNameError.duplicateBranch,
      );
    });

    test('colide com worktree existente', () {
      expect(
        check('feat/sso', worktrees: {'sso', 'feat/sso'}).error,
        WorktreeNameError.duplicateWorktree,
      );
    });

    test('nome único passa', () {
      expect(
        check('feat/new', branches: {'main'}, worktrees: {'old'}).isValid,
        isTrue,
      );
    });

    test('formato é checado antes de unicidade', () {
      // 'main ' tem espaço — falha por whitespace, não por duplicate.
      expect(
        check('main ', branches: {'main'}).error,
        WorktreeNameError.whitespace,
      );
    });
  });
}
