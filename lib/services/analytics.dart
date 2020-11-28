import 'package:firebase_analytics/firebase_analytics.dart';

abstract class IAnalytics {
  void logAppOpen();
  void logEvent(String name);
}

class Analytics implements IAnalytics {
  Analytics(this.firebase);

  final FirebaseAnalytics firebase;

  void logAppOpen() => firebase.logAppOpen();

  void logEvent(String name) => firebase.logEvent(name: name);
}
