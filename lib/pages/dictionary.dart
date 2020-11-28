import 'dart:collection';

import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/pages/edit_word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DictionaryPage extends StatefulWidget {
  DictionaryPage({Key key}) : super(key: key) {
    print("Dictionary: Constructor of Widget");
  }

  @override
  _DictionaryPageState createState() {
    print("Dictionary: Creating new state");
    return _DictionaryPageState();
  }
}

class _DictionaryPageState extends State<DictionaryPage> {
  final IDatabase database;

  Future<HashMap<int, Word>> words;
  Future<HashMap<int, Word>> masterWords;

  _DictionaryPageState() : database = Dependencies.get<IDatabase>() {
    words = database.words.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionary".tr()),
      ),
      body: LoadingListPageWithProgressIndicator(
        future: words,
        body: buildWordList,
        isDataEmpty: (snapshot) => snapshot.data.isEmpty,
        textIfNoData: "There are no words created.".tr(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewWord,
        tooltip: "Add Word".tr(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildWordList(Map<int, Word> words) {
    return ListView(
      children: words.entries
          .map(
            (e) => Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                title: Column(
                  children: [
                    PrimaryText(e.value.text),
                  ],
                ),
                onTap: () {},
                onLongPress: () {},
              ),
            ),
          )
          .toList(),
    );
  }

  void addNewWord() async {
    print("Navigating to edit word page: ");

    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (ctx) => EditWordPage(
              word: Word(),
            )));

    setStateAndUpdateWords();
  }

  void setStateAndUpdateWords() {
    setState(() {
      print("Dictionary: Setting state");
    });
  }
}
