import 'package:bocagoi/services/database.dart';
import 'package:flutter/material.dart';

import 'package:bocagoi/pages/home.dart';
import 'package:bocagoi/utils/strings.dart';

void main() {
  var database = Database();
  database.Clean();

  print('-------------------- Running App --------------------');
  runApp(MyApp(database: database,));
}

class MyApp extends StatelessWidget {
  MyApp({@required this.database}) {}
  final IDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.AppTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(database: database),
    );
  }
}
