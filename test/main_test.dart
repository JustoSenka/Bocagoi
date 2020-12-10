
import 'package:flutter_test/flutter_test.dart';

import 'database_test.dart';
import 'object_test.dart';
Future<void> main() async {

  test("test that passes", () {
    expect(1, 1);
  });

  await ObjectTests().run();
  await DatabaseTests().run();
}
