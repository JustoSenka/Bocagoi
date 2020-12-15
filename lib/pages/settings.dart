import 'dart:collection';

import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/services/authentication.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/services/user_prefs.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState()
      : database = Dependencies.get<IDatabase>(),
        userPrefs = Dependencies.get<IUserPrefs>(),
        auth = Dependencies.get<IAuth>() {
    user = auth.getCurrentUser();
    loadSettingsFuture = loadSettings();
  }

  Language primaryLanguage;
  Language secondaryLanguage;
  Language foreignLanguage;
  Map<int, Language> languages;

  final IDatabase database;
  final IAuth auth;
  final IUserPrefs userPrefs;

  User user;
  Future<bool> loadSettingsFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings".tr()),
      ),
      body: LoadingPageWithProgressIndicator(
        future: loadSettingsFuture,
        body: buildSettingsBody,
      ),
    );
  }

  Widget buildSettingsBody(bool hasData) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: ListView(
        children: [
          Divider(),
          DoubleListTile(
              left: "User ID:".tr(),
              right: user.uid,
              titleStyle: TextStyle(fontFamily: "Monospace")),
          DoubleListTile(
              left: "User Email:".tr(),
              right: user.email,
              titleStyle: TextStyle(fontFamily: "Monospace")),
          DoubleListTile(
              left: "User Display Name:".tr(),
              right: user.displayName,
              titleStyle: TextStyle(fontFamily: "Monospace")),
          Divider(),
          ListTileDropdown(
            title: "Primary Language".tr(),
            value: primaryLanguage?.id ?? 0,
            dropdownTextGetter: (id) => languages[id].name,
            map: languages,
            dropdownFlex: 2,
            titleStyle: TextStyle(fontFamily: "Monospace"),
            onChanged: (value) async {
              setState(() {
                primaryLanguage = languages[value];
              });

              var prefs = await userPrefs.load();
              await prefs.setPrimaryLanguageID(value);
            },
          ),
          ListTileDropdown(
            title: "Foreign Language".tr(),
            value: foreignLanguage?.id ?? 0,
            dropdownTextGetter: (id) => languages[id].name,
            map: languages,
            dropdownFlex: 2,
            titleStyle: TextStyle(fontFamily: "Monospace"),
            onChanged: (value) async {
              setState(() {
                foreignLanguage = languages[value];
              });

              var prefs = await userPrefs.load();
              await prefs.setForeignLanguageID(value);
            },
          ),
          ListTileDropdown(
            title: "Secondary Language".tr(),
            value: secondaryLanguage?.id ?? 0,
            dropdownTextGetter: (id) => languages[id].name,
            map: languages,
            dropdownFlex: 2,
            addNoneSelection: true,
            titleStyle: TextStyle(fontFamily: "Monospace"),
            onChanged: (value) async {
              setState(() {
                secondaryLanguage = languages[value];
              });

              var prefs = await userPrefs.load();
              await prefs.setSecondaryLanguageID(value);
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  Future<bool> loadSettings() async {
    print("Settings: loading user prefs");
    var prefs = await userPrefs.load();

    languages = await database.languages.getAll();
    print("Settings: languages found: ${languages.length}");

    var pID = prefs.getPrimaryLanguageID();
    if (pID != null) {
      primaryLanguage = languages[pID];
    }

    var sID = prefs.getSecondaryLanguageID();
    if (sID != null) {
      secondaryLanguage = languages[sID];
    }

    var fID = prefs.getForeignLanguageID();
    if (fID != null) {
      foreignLanguage = languages[fID];
    }
    print("Settings: settings loaded");
    return true;
  }
}
