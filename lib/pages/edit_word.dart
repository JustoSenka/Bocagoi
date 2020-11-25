
import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:flutter/material.dart';

class EditWordPage extends StatefulWidget {
  EditWordPage({@required this.database, @required this.book, Key key})
      : super(key: key);

  final IDatabase database;
  final Book book;

  @override
  _EditWordPageState createState() => _EditWordPageState(book);
}

class _EditWordPageState extends State<EditWordPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _EditWordPageState(Book book){
    _name = book.name;
    _description = book.description;
  }

  String _name;
  String _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Book".tr()),
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
    return Row(
      children: [
        RoundedButton(
          text: "Delete".tr(),
          color: BootstrapColors.danger,
          fontSize: FontSize.small,
          onPressed: () {
            widget.database.getBooks().then((books) {
              books.remove(widget.book.id);
              widget.database.save();
              Navigator.of(context).pop();
            });
          },
        ),
        Spacer(),
        RoundedButton(
          text: "Cancel".tr(),
          color: BootstrapColors.dark,
          onPressed: () => Navigator.of(context).pop(),
        ),
        RoundedButton(
          text: "Save".tr(),
          color: BootstrapColors.primary,
          fontSize: FontSize.big,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              setState(() {
                widget.book.name = _name;
                widget.book.description = _description;
              });

              widget.database.getBooks().then((books) {
                // books[widget.book.id] = widget.book;
                widget.database.save();
                Navigator.of(context).pop();
              });
            }
          },
        ),
      ],
    );
  }
}
