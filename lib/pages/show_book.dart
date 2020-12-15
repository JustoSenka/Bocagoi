import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/pages/edit_word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/services/persistent_database.dart';
import 'package:bocagoi/services/user_prefs.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShowBookPage extends StatefulWidget {
  ShowBookPage({@required this.book, Key key}) : super(key: key);

  final Book book;

  @override
  _ShowBookPageState createState() => _ShowBookPageState(book);
}

class _ShowBookPageState extends State<ShowBookPage> {
  final IDatabase database;
  final IPersistentDatabase persistentDatabase;
  final IUserPrefs userPrefs;

  _ShowBookPageState(this.book)
      : database = Dependencies.get<IDatabase>(),
        persistentDatabase = Dependencies.get<IPersistentDatabase>(),
        userPrefs = Dependencies.get<IUserPrefs>() {
    _bookHasNoWords = book.masterWordsID == null || book.masterWordsID.isEmpty;
    loadWordsFuture = loadWords();
  }

  bool _bookHasNoWords;
  Book book;

  Map<int, Map<int, Word>> words;
  List<Language> languages;
  int primaryLangID;
  int foreignLangID;
  int secondaryLangID;

  bool get isThreeColumn => secondaryLangID != null;

  Future<bool> loadWordsFuture;

  Future<bool> loadWords() async {
    final prefs = await userPrefs.load();
    primaryLangID = await prefs.getPrimaryLanguageID();
    foreignLangID = await prefs.getForeignLanguageID();
    secondaryLangID = await prefs.getSecondaryLanguageID();
    final langsToGet = isThreeColumn
        ? [primaryLangID, foreignLangID, secondaryLangID]
        : [primaryLangID, foreignLangID];

    final languageMap = await database.languages.getAll();
    languages = languageMap.values.where((e) =>
        langsToGet.contains(e.id)).toList(growable: false);

    words =
    await persistentDatabase.loadAndGroupWords(book, langsToGet.toSet());

    return words.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book:".tr() + " " + book.name),
      ),
      body: LoadingPageWithProgressIndicator<bool>(
        future: loadWordsFuture,
        body: buildBookWordListView,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewWord,
        tooltip: "Add Word".tr(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBookWordListView(bool hasData) {
    if (_bookHasNoWords || !hasData) {
      return buildTextMessage();
    } else {
      return buildListOfWords(words);
    }
  }

  Widget buildTextMessage() {
    return Center(
      child: Text("Book is empty. Click floating button to add new words".tr()),
    );
  }

  Widget buildListOfWords(Map<int, Map<int, Word>> words) {
    return ListView(
        children: [
    MultiListTile(
    list: languages.values.ma),
    ),
    ...words.values.map(
    (trans) => MultiListTile(
    list: trans.values.map((e) => e?.text).toList(),
    ),
    ),
    ]
    ,
    );
  }

  void addNewWord() async {
    print("Navigating to edit word page: ");

    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (ctx) =>
            EditWordPage(
              word: Word(),
              book: book,
            )));

    final newBook = await database.books.get(book.id);

    setState(() {
      book = newBook;
    });
  }
}
