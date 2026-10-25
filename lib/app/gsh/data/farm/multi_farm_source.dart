import 'package:gsh_desktop/app/gsh/domain/contracts/farm_source.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/farm_loop.dart';

/// Junta várias fontes (Claude Code, Codex…) numa só.
class MultiFarmSource implements FarmSource {
  const MultiFarmSource(this.sources);
  final List<FarmSource> sources;

  @override
  Future<List<FarmLoop>> scan(DateTime now) async {
    final all = <FarmLoop>[];
    for (final s in sources) {
      all.addAll(await s.scan(now));
    }
    return all;
  }
}
