import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/pages/edit_word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShowBookPage extends StatefulWidget {
  ShowBookPage({@required this.book, Key key})
      : super(key: key);

  final Book book;

  @override
  _ShowBookPageState createState() => _ShowBookPageState(book);
}

class _ShowBookPageState extends State<ShowBookPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final IDatabase database;

  _ShowBookPageState(this.book) : database = Dependencies.get<IDatabase>() {
    _bookHasNoWords =
        book.masterWordsID == null || book.masterWordsID.isEmpty;
  }

  bool _bookHasNoWords;
  Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book:".tr() + " " + book.name),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: buildBookWordListView(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewWord,
        tooltip: "Add Word".tr(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBookWordListView() {
    if (_bookHasNoWords) {
      return buildTextMessage();
    } else {
      return buildListOfWords();
    }
  }

  Widget buildTextMessage() {
    return Center(
      child: Text("Book is empty. Click floating button to add new words".tr()),
    );
  }

  Widget buildListOfWords() {
    var header = Center(
      child: PrimaryText(book.name),
    );

    var wordElements = book.masterWordsID.map(
      (e) => ListTile(
        title: Row(
          children: [
            //Text(e.translations.values.first),
          ],
        ),
      ),
    );

    return ListView(
      children: [
        header,
        ...wordElements,
      ],
    );
  }

  void addNewWord() async {
    print("Navigating to edit word page: ");

    await Navigator.of(context)
        .push(MaterialPageRoute<void>(
            builder: (ctx) => EditWordPage(
                  word: Word(), book: book,
                )));

    final newBook = await database.books.get(book.id);

    setState(() {
      book = newBook;
    });
  }
}
