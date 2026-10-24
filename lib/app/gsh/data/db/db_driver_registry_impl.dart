import 'package:gsh_desktop/app/gsh/domain/contracts/db_driver.dart';
import 'package:gsh_desktop/app/gsh/domain/entities/db_connection.dart';

import 'anaki_db_driver.dart';

/// Drivers por engine — todos via **anakiORM** ([AnakiDbDriver]): SQLite,
/// Postgres e MySQL com o mesmo conector Rust/FFI. Engines futuros (MSSQL…)
/// entram aqui quando o dylib correspondente for empacotado.
class DbDriverRegistryImpl implements DbDriverRegistry {
  const DbDriverRegistryImpl();

  @override
  DbDriver? forEngine(DbEngine engine) => switch (engine) {
    DbEngine.sqlite ||
    DbEngine.postgres ||
    DbEngine.mysql ||
    DbEngine.mssql => const AnakiDbDriver(),
    // Redis/Mongo não são SQL → acesso CLI via NoSqlCommandService, não pelo
    // contrato DbDriver.
    DbEngine.redis || DbEngine.mongo => null,
  };
}
