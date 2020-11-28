import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IUserPrefs {
  Future<ILoadedUserPrefs> load();
}

abstract class ILoadedUserPrefs {
  int getPrimaryLanguageID();

  Future setPrimaryLanguageID(int value);

  int getSecondaryLanguageID();

  Future setSecondaryLanguageID(int value);

  int getForeignLanguageID();

  Future setForeignLanguageID(int value);
}

class UserPrefs extends IUserPrefs {
  Future<ILoadedUserPrefs> load() async {
    var prefs = await SharedPreferences.getInstance();
    return LoadedUserPrefs(prefs: prefs);
  }
}

class LoadedUserPrefs extends ILoadedUserPrefs {
  LoadedUserPrefs({@required this.prefs});

  static const String PrimaryLanguageIDKey = "PrimaryLanguageID";
  static const String SecondaryLanguageIDKey = "SecondaryLanguageID";
  static const String ForeignLanguageIDKey = "ForeignLanguageID";

  final SharedPreferences prefs;

  int getPrimaryLanguageID() {
    return prefs.getInt(PrimaryLanguageIDKey);
  }

  Future setPrimaryLanguageID(int value) async {
    await prefs.setInt(PrimaryLanguageIDKey, value);
  }

  int getSecondaryLanguageID() {
    return prefs.getInt(SecondaryLanguageIDKey);
  }

  Future setSecondaryLanguageID(int value) async {
    await prefs.setInt(SecondaryLanguageIDKey, value);
  }

  int getForeignLanguageID() {
    return prefs.getInt(ForeignLanguageIDKey);
  }

  Future setForeignLanguageID(int value) async {
    await prefs.setInt(ForeignLanguageIDKey, value);
  }
}
