/// An app that ships with `dart build cli` and this companion.
///
/// In the app's `pubspec.yaml`:
///
///     dependencies:
///       slingshot_postgres: ^0.1.9
///       slingshot_postgres_assets: ^0.1.0
///
/// Put this file in the app's `bin/`, then build and run (Postgres up at
/// localhost:5432, or `PG_CONNINFO` set):
///
///     dart build cli -o out
///     ./out/bundle/bin/main
///
/// No library copy and no `DART_DB_CONNECTOR_NATIVE_LIB_PATH`: the build hook
/// of this package puts `libnative_db` in `out/bundle/lib/`, where the driver
/// finds it.
library;

import 'dart:io';

import 'package:slingshot_postgres/slingshot_postgres.dart';

Future<void> main() async {
  final connInfo =
      Platform.environment['PG_CONNINFO'] ??
      'host=localhost port=5432 dbname=teste user=postgres password=123';
  final pool = PostgresConnectionPool(
    PoolConfig(connInfo: connInfo, maxSize: 1),
  );
  await pool.start();
  try {
    final rs = await withTransaction<PostgresResultSet>(
      pool,
      (exec) => exec.execute('SELECT 1 AS one'),
    );
    try {
      print('one=${rs.row(0).getInt('one')}');
    } finally {
      rs.release();
    }
  } finally {
    await pool.close();
  }
}
