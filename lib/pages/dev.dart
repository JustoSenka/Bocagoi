import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/services/persistent_database.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/base_state.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DevPage extends StatefulWidget {
  DevPage({Key key}) : super(key: key);

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends BaseState<DevPage> {
  final IDatabase database;
  final IPersistentDatabase persistentDatabase;

  _DevPageState()
      : database = Dependencies.get<IDatabase>(),
        persistentDatabase = Dependencies.get<IPersistentDatabase>();

  String langsText = "<empty>";
  String bookWordCount = "<empty>";

  @override
  Widget buildScaffold(BuildContext context, GlobalKey<ScaffoldState> key) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text("Dev Tools".tr()),
      ),
      body: ListView(
        padding: EdgeInsets.all(5),
        children: [
          RoundedButton(
            text: "Add Book",
            onPressed: () async => await database.books.add(Book()),
          ),
          RoundedButton(
            text: "Add Word",
            onPressed: () async => await database.words.add(Word()),
          ),
          RoundedButton(
            text: "Add Master Words",
            onPressed: () async => await database.masterWords.add(MasterWord()),
          ),
          RoundedButton(
            text: "Add Language",
            onPressed: () async => await database.languages.add(Language()),
          ),
          RoundedButton(
            text: "Select [1, 3] lanugages",
            onPressed: () async {
              var langs = await database.languages.getMany([1, 3]);
              var newText = langs.values.length.toString() +
                  ": " +
                  langs.values.map((e) => e.name).join(" - ");
              setState(() {
                langsText = newText;
              });
            },
          ),
          PrimaryText(langsText, center: true),
          RoundedButton(
            text: "First book word count",
            onPressed: () async {
              var books = await database.books.getAll();
              var book = books.values.first;
              setState(() {
                bookWordCount = "${book.name}: ${book.masterWordsID.length}";
              });
            },
          ),
          PrimaryText(bookWordCount, center: true),
        ],
      ),
    );
  }
}
