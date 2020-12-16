import 'package:bocagoi/pages/dev.dart';
import 'package:bocagoi/pages/dictionary.dart';
import 'package:bocagoi/pages/library.dart';
import 'package:bocagoi/pages/practice_selection.dart';
import 'package:bocagoi/pages/settings.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/base_state.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> {
  @override
  Widget buildScaffold(BuildContext context, GlobalKey<ScaffoldState> key) {
    return Scaffold(
      key: key,
      drawer: buildDrawer(),
      appBar: AppBar(
        title: Text(Strings.AppTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome, press floating button to start practice:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Redirecting to Practice');
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (ctx) => PracticeSelectionPage()));
        },
        tooltip: 'Practice Words',
        child: Icon(Icons.add),
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Text("User data: "),
                Text("test"),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Practice'),
            onTap: () {
              print('Redirecting to Practice');
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (ctx) => PracticeSelectionPage()));
            },
          ),
          ListTile(
            title: Text('Library'),
            onTap: () {
              print('Redirecting to Library');
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (ctx) => LibraryPage()));
            },
          ),
          ListTile(
            title: Text('Dictionary'),
            onTap: () {
              print('Redirecting to Dictionary');
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (ctx) => DictionaryPage()));
            },
          ),
          ListTile(
            title: Text('History'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (ctx) => SettingsPage()));
            },
          ),
          ListTile(
            title: Text('Dev Tools'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (ctx) => DevPage()));
            },
          ),
        ],
      ),
    );
  }
}
