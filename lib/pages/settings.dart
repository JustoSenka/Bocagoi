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
  HashMap<int, Language> languages;

  final IDatabase database;
  final IAuth auth;
  final IUserPrefs userPrefs;

  User user;
  Future<bool> loadSettingsFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionary".tr()),
      ),
      body: LoadingPageWithProgressIndicator(
        future: loadSettingsFuture,
        body: buildSettingsBody,
      ),
    );
  }

  Widget buildSettingsBody(bool _) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: ListView(
        children: [
          Divider(),
          buildListTile("User ID:".tr(), user.uid),
          buildListTile("User Email:".tr(), user.email),
          buildListTile("User Display Name:".tr(), user.displayName),
          Divider(),
          buildListTileDropdown(
            left: "Primary Language".tr(),
            value: primaryLanguage?.id ?? 0,
            onChanged: (value) async {
              setState(() {
                primaryLanguage = languages[value];
              });

              var prefs = await userPrefs.load();
              await prefs.setPrimaryLanguageID(value);
            },
          ),
          buildListTileDropdown(
            left: "Foreign Language".tr(),
            value: foreignLanguage?.id ?? 0,
            onChanged: (value) async {
              setState(() {
                foreignLanguage = languages[value];
              });

              var prefs = await userPrefs.load();
              await prefs.setForeignLanguageID(value);
            },
          ),
          buildListTileDropdown(
            left: "Secondary Language".tr(),
            value: secondaryLanguage?.id ?? 0,
            hasNoneSelection: true,
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

  ListTile buildListTile(String left, String right) {
    return ListTile(
      title: Row(
        children: [
          Text(
            left ?? "<empty>".tr(),
            style: TextStyle(fontFamily: "Monospace"),
          ),
          Spacer(),
          Text(right ?? "<empty>".tr()),
        ],
      ),
    );
  }

  ListTile buildListTileDropdown(
      {String left,
      int value,
      void Function(int) onChanged,
      bool hasNoneSelection = false}) {
    return ListTile(
      title: Row(
        children: [
          Text(
            left ?? "<empty>".tr(),
            style: TextStyle(fontFamily: "Monospace"),
          ),
          Spacer(),
          Expanded(
            flex: 2,
            child: DropdownButton<int>(
              value: value,
              items: [
                if (hasNoneSelection)
                  DropdownMenuItem<int>(value: 0, child: Text("None".tr())),
                ...buildLanguageDropdownItems()
              ],
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> buildLanguageDropdownItems() {
    return languages.entries
        .map(
          (e) => DropdownMenuItem<int>(
            value: e.value.id,
            child: Text(e.value.name),
          ),
        )
        .toList();
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
