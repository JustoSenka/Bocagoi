import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:flutter/material.dart';

class ShowBookPage extends StatefulWidget {
  ShowBookPage({@required this.database, @required this.book, Key key}) : super(key: key);

  final IDatabase database;
  final Book book;

  @override
  _ShowBookPageState createState() => _ShowBookPageState();
}

class _ShowBookPageState extends State<ShowBookPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book:".tr() + " " + widget.book.name),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: [
                  Text("Editing book with id: ".tr() +
                      widget.book.id.toString()),
                  //buildBookNameInput(),
                  //buildBookDescriptionInput(),
                  //buildButtonRow(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewWord,
        tooltip: "Add Word".tr(),
        child: Icon(Icons.add),
      ),
    );
  }

  void addNewWord() {

  }
}
