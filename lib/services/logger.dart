import 'package:flutter/material.dart';

abstract class ILogger {
  void log(String msg);

  BuildContext context;
  GlobalKey<ScaffoldState> key;
}

class Logger {
  static ILogger instance = ConsoleLogger();

  static set context(BuildContext ctx) => instance.context = ctx;

  static set key(GlobalKey<ScaffoldState> newKey) => instance.key = newKey;

  static void log(String msg) => instance.log(msg);
}

class SnackBarLogger implements ILogger {
  BuildContext context;
  GlobalKey<ScaffoldState> key;

  @override
  void log(String msg) {
    print(msg);

    if (key != null) {
      key.currentState.showSnackBar(SnackBar(
        content: Text(msg),
      ));
    }

    if (context != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
        ),
      );
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
