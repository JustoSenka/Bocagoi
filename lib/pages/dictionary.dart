import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/pages/edit_word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/base_state.dart';
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

class _DictionaryPageState extends BaseState<DictionaryPage> {
  final IDatabase database;

  Future<bool> loadDataFuture;

  Map<int, Word> words;
  Map<int, MasterWord> masterWords;
  Map<int, Language> languages;

  _DictionaryPageState() : database = Dependencies.get<IDatabase>() {
    loadDataFuture = loadData();
  }

  Future<bool> loadData() async {
    words = await database.words.getAll();
    languages = await database.languages.getAll();
    masterWords = await database.masterWords.getAll();
    return words.isEmpty;
  }

  Future<bool> reloadWords() async {
    words = await database.words.getAll();
    masterWords = await database.masterWords.getAll();
    return words.isEmpty;
  }

  @override
  Widget buildScaffold(BuildContext context, GlobalKey<ScaffoldState> key) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text("Dictionary".tr()),
      ),
      body: LoadingPageWithProgressIndicator<bool>(
        future: loadDataFuture,
        body: buildWordList,
        isDataEmpty: (snapshot) => snapshot.data,
        textIfNoData: "There are no words created.".tr(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewWord,
        tooltip: "Add Word".tr(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildWordList(bool _) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: ListView(
        children: [
          Center(
            child: Text("Number of words: ".tr() + words.length.toString()),
          ),
          ...buildListEntries(),
        ],
      ),
    );
  }

  List<Padding> buildListEntries() {
    return words.entries
        .map(
          (e) => Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: ListTile(
              title: PrimaryText(e.value?.text ?? "<empty>".tr()),
              onTap: () {},
              onLongPress: () => editWord(e.value),
            ),
          ),
        )
        .toList();
  }

  void editWord(Word word) async {
    print("Navigating to edit word page: ");

    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (ctx) => EditWordPage(
              word: word,
            )));

    setStateAndUpdateWords();
  }

  void addNewWord() async => editWord(Word());

  void setStateAndUpdateWords() {
    setState(() {
      print("Dictionary: Setting state");
      loadDataFuture = reloadWords();
    });
  }
}
