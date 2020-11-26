import 'dart:ffi';

import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/utils/extensions.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:flutter/material.dart';

class EditBookPage extends StatefulWidget {
  EditBookPage({@required this.database, @required this.book, Key key})
      : super(key: key);

  final IDatabase database;
  final Book book;

  @override
  _EditBookPageState createState() => _EditBookPageState(book);
}

class _EditBookPageState extends State<EditBookPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _EditBookPageState(Book book) {
    _isBookPersisted = book.id != null;
    _name = book.name;
    _description = book.description;
  }

  bool _isBookPersisted;
  String _name;
  String _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isBookPersisted ? "Edit Book".tr() : "Add Book".tr()),
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
                  buildTopText(),
                  buildBookNameInput(),
                  buildBookDescriptionInput(),
                  buildButtonRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text buildTopText() {
    var str = _isBookPersisted
        ? "Editing book with id: ".tr() + widget.book.id.toString()
        : "Creating new book".tr();

    return Text(str);
  }

  Padding buildBookNameInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: TextFormField(
        validator: (value) =>
            value == "" ? "Book name cannot be empty.".tr() : null,
        initialValue: widget.book.name,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          labelText: "Book name".tr(),
        ),
        onChanged: (value) => _name = value,
      ),
    );
  }

  Padding buildBookDescriptionInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: TextFormField(
        initialValue: widget.book.description,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          labelText: "Book description".tr(),
        ),
        maxLines: 5,
        onChanged: (value) => _description = value,
      ),
    );
  }

  Row buildButtonRow() {
    if (_isBookPersisted) {
      return Row(
        children: [
          DeleteButton(
            onPressed: () {
              widget.database.getBooks().then((books) {
                books.remove(widget.book.id);
                widget.database.save();
                Navigator.of(context).pop();
              });
            },
          ),
          Spacer(),
          CancelButton(),
          SaveButton(
            formKey: _formKey,
            onPressed: () {
              widget.book.name = _name;
              widget.book.description = _description;

              widget.database.getBooks().then((books) {
                // books[widget.book.id] = widget.book;
                widget.database.save();
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Spacer(),
          CancelButton(),
          SaveButton(
            formKey: _formKey,
            onPressed: () {
              widget.database.getBooks().then((books) {
                widget.book.id = books.getNextFreeKey();
                widget.book.name = _name;
                widget.book.description = _description;

                books[widget.book.id] = widget.book;
                widget.database.save();
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      );
    }
  }
}
