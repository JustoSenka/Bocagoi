import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/pages/edit_word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/services/persistent_database.dart';
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

  _ShowBookPageState(this.book)
      : database = Dependencies.get<IDatabase>(),
        persistentDatabase = Dependencies.get<IPersistentDatabase>() {
    _bookHasNoWords = book.masterWordsID == null || book.masterWordsID.isEmpty;
    loadWordsFuture = loadWords();
  }

  bool _bookHasNoWords;
  Book book;

  Map<int, Map<int, Word>> words;

  Future<bool> loadWordsFuture;

  Future<bool> loadWords() async {
    words = await persistentDatabase.loadAndGroupWords(book, [1, 2].toSet());

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
        Center(child: PrimaryText(book.name)),
        ...words.values.map(
          (trans) => ListTile(
            title:
                MultiListTile(list: trans.values.map((e) => e?.text).toList()),
          ),
        ),
      ],
    );
  }

  void addNewWord() async {
    print("Navigating to edit word page: ");

    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (ctx) => EditWordPage(
              word: Word(),
              book: book,
            )));

    final newBook = await database.books.get(book.id);

    setState(() {
      book = newBook;
    });
  }
}
