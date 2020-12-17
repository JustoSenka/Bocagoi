import 'package:bocagoi/services/dependencies.dart';
import 'package:flutter/material.dart';

abstract class ILogger {
  void log(String msg);

  BuildContext context;
  GlobalKey<ScaffoldState> key;
}

class Logger {
  // static ILogger instance = ConsoleLogger();
  static ILogger get _instance => Dependencies.get<ILogger>();

  static set context(BuildContext ctx) => _instance.context = ctx;

  static set key(GlobalKey<ScaffoldState> newKey) => _instance.key = newKey;

  static void log(String msg) => _instance.log(msg);
}

class SnackBarLogger implements ILogger {
  BuildContext context;
  GlobalKey<ScaffoldState> key;

  @override
  void log(String msg) {
    print(msg);
    final snackbar = SnackBar(content: Text(msg));

    if (key != null) {
      key.currentState.showSnackBar(snackbar);
    } else if (context != null) {
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }
}

class ConsoleLogger implements ILogger {
  BuildContext context;
  GlobalKey<ScaffoldState> key;

  @override
  void log(String msg) {
    print(msg);
  }
}
