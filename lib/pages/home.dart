import 'package:bocagoi/pages/dictionary.dart';
import 'package:bocagoi/pages/practice_selection.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/utils/strings.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({@required this.database, Key key}) : super(key: key);

  final IDatabase database;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (ctx) => PracticeSelectionPage()));
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
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (ctx) => PracticeSelectionPage()));
            },
          ),
          ListTile(
            title: Text('Dictionary'),
            onTap: () {
              print('Redirecting to Dictionary');
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (ctx) => DictionaryPage(database: widget.database,)));
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
            },
          ),
        ],
      ),
    );
  }
}
