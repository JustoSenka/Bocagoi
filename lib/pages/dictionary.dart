import 'dart:collection';

import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/pages/edit_book.dart';
import 'package:bocagoi/pages/show_book.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bocagoi/utils/extensions.dart';

class DictionaryPage extends StatefulWidget {
  DictionaryPage({@required this.database, Key key}) : super(key: key) {
    books = database.getBooks();
  }

  final IDatabase database;
  Future<HashMap<int, Book>> books;

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionary".tr()),
      ),
      body: FutureBuilder(
        future: widget.books,
        builder:
            (BuildContext context, AsyncSnapshot<HashMap<int, Book>> books) {
          if (!books.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (books.data.isEmpty) {
            return Center(
              child: Text("There are no books created.".tr()),
            );
          } else {
            return buildBooksList(books.data);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBook,
        tooltip: "Add Book".tr(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBooksList(HashMap<int, Book> books) {
    return ListView(
      children: books.entries
          .map(
            (e) => ListTile(
              title: Text(e.value.name),
              onTap: () => showBookPage(e.value),
              onLongPress: () => editBookPage(e.value),
            ),
          )
          .toList(),
    );
  }

  void showBookPage(Book book) {
    print("Navigating to show book page: ${book.id}");

    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (ctx) => ShowBookPage(
              database: widget.database,
              book: book,
            )));
  }

  void editBookPage(Book book) {
    print("Navigating to edit book page: ${book.id}");

    Navigator.of(context)
        .push(MaterialPageRoute<void>(
            builder: (ctx) => EditBookPage(
                  database: widget.database,
                  book: book,
                )))
        .then((value) => setState(() {}));
  }

  void addNewBook() {
    widget.books.then((books) {
      setState(() {
        var newId = books.getNextFreeKey();
        var book = Book(
          id: newId,
          name: "New Book".tr(),
          description: "Description".tr(),
        );

        books[newId] = book;
        widget.database.save();
      });
    });
  }
}
