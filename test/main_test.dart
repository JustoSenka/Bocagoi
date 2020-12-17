
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/services/logger.dart';
import 'package:bocagoi/services/persistent_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'database_test.dart';
import 'object_test.dart';
import 'utils/utils.dart';
Future<void> main() async {

  database = TestDatabase();
  persistentDatabase = PersistentDatabase(database);
  Dependencies.add<IDatabase>(database);
  Dependencies.add<ILogger>(ConsoleLogger());

  test("test that passes", () {
    expect(1, 1);
  });

  await ObjectTests().run();
  await DatabaseTests().run();
}
