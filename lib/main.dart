import 'dart:async';

import 'package:bocagoi/services/analytics.dart';
import 'package:bocagoi/services/authentication.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/services/logger.dart';
import 'package:bocagoi/services/persistent_database.dart';
import 'package:bocagoi/services/user_prefs.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'package:bocagoi/pages/home.dart';
import 'package:bocagoi/utils/strings.dart';

void main() async {
  unawaited(
    () => runZonedGuarded<Future<void>>(() async {
      WidgetsFlutterBinding.ensureInitialized();
      print('-------------------- Running App --------------------');

      final app = await Firebase.initializeApp();
      print("Firebase app initialize: " + app.name);

      final analytics = Analytics(FirebaseAnalytics());
      analytics.logAppOpen();

      final auth = Auth();
      unawaited(() => auth.signIn("glodjus@gmail.com", "somepass").then((user) {
            print("User connected: " + user.email);
          }));

      unawaited(() =>
          FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true));

      final database = Database();
      final persistentDatabase = PersistentDatabase(database);

      Dependencies.add<ILogger>(SnackBarLogger());
      Dependencies.add<IUserPrefs>(UserPrefs());
      Dependencies.add<IAnalytics>(analytics);
      Dependencies.add<IDatabase>(database);
      Dependencies.add<IAuth>(auth);
      Dependencies.add<IPersistentDatabase>(
          persistentDatabase);
      Dependencies.printDebug();

      FlutterError.onError = (FlutterErrorDetails details) async {
        // Logger.log(details.exception?.toString());
        Zone.current.handleUncaughtError(details.exception, details.stack);
        await FirebaseCrashlytics.instance.recordFlutterError(details);
      };

      runApp(MyApp());
    }, (error, stackTrace) {
      Logger.log(error.toString());
      throw error;
    }),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.AppTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

void unawaited(Function func) {
  func();
}
