import 'dart:collection';

import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/pages/edit_book.dart';
import 'package:bocagoi/pages/show_book.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  LibraryPage({Key key}) : super(key: key) {
    print("Library: Constructor of Widget");
  }

  @override
  _LibraryPageState createState() {
    print("Library: Creating new state");
    return _LibraryPageState();
  }
}

class _LibraryPageState extends State<LibraryPage> {
  final IDatabase database;

  Future<HashMap<int, Book>> books;

  _LibraryPageState() : database = Dependencies.get<IDatabase>() {
    books = database.books.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Library".tr()),
      ),
      body: LoadingListPageWithProgressIndicator(
        future: books,
        body: buildBooksList,
        isDataEmpty: (snapshot) => snapshot.data.isEmpty,
        textIfNoData: "There are no books created.".tr(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBook,
        tooltip: "Add Book".tr(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBooksList(Map<int, Book> books) {
    return ListView(
      children: books.entries
          .map(
            (e) => Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                title: Column(
                  children: [
                    PrimaryText(e.value.name),
                    SecondaryText("Words count: ".tr() +
                        e.value.masterWordsID?.length.toString()),
                  ],
                ),
                onTap: () => showBookPage(e.value),
                onLongPress: () => editBookPage(e.value),
              ),
            ),
          )
          .toList(),
    );
  }

  void showBookPage(Book book) async {
    print("Navigating to show book page: ${book.id}");

    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (ctx) => ShowBookPage(
              book: book,
            )));

    setStateAndUpdateBooks();
  }

  void addNewBook() => editBookPage(Book());

  void editBookPage(Book book) async {
    print("Navigating to edit book page: ${book.id}");

    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (ctx) => EditBookPage(
              book: book,
            )));

    setStateAndUpdateBooks();
  }

  void setStateAndUpdateBooks() {
    setState(() {
      print("Library: Setting state");
      books = database.books.getAll();
    });
  }
}
