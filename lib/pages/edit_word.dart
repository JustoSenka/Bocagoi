import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:flutter/material.dart';

class EditWordPage extends StatefulWidget {
  EditWordPage(
      {@required this.word, this.book, Key key})
      : super(key: key);

  final Word word;
  final Book book;

  @override
  _EditWordPageState createState() => _EditWordPageState(word);
}

class _EditWordPageState extends State<EditWordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final IDatabase database;

  _EditWordPageState(Word word) : database = Dependencies.get<IDatabase>() {
    _isWordPersisted = word.id != null;
    _dummyWord = Word.from(word);
  }

  Word _dummyWord;
  bool _isWordPersisted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isWordPersisted ? "Edit Word".tr() : "Add Word".tr()),
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
                  RoundedTextFormField(
                    labelText: "Text".tr(),
                    initialValue: _dummyWord.text,
                    onChanged: (val) => _dummyWord.text = val,
                    validator: (value) =>
                        notEmptyFormValidator(
                            "Word cannot be empty".tr(), value),
                  ),
                  RoundedTextFormField(
                    labelText: "Article".tr(),
                    initialValue: _dummyWord.article,
                    onChanged: (val) => _dummyWord.article = val,
                  ),
                  RoundedTextFormField(
                    labelText: "Pronunciation".tr(),
                    initialValue: _dummyWord.pronunciation,
                    onChanged: (val) => _dummyWord.pronunciation = val,
                  ),
                  RoundedTextFormField(
                    labelText: "Alternate Spelling".tr(),
                    initialValue: _dummyWord.alternateSpelling,
                    onChanged: (val) => _dummyWord.alternateSpelling = val,
                  ),
                  RoundedTextFormField(
                    labelText: "Description".tr(),
                    initialValue: _dummyWord.description,
                    onChanged: (val) => _dummyWord.description = val,
                    maxLines: 5,
                  ),
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
    var str = _isWordPersisted
        ? "Editing word with id: ".tr() + widget.word.id.toString()
        : "Creating new word".tr();

    return Text(str);
  }

  Row buildButtonRow() {
    if (_isWordPersisted) {
      return Row(
        children: [
          DeleteButton(
            onPressed: () {
              /*
              widget.database.getBooks().then((books) {
                books..remove(widget.word.id);
                widget.database.save();
                Navigator.of(context).pop();
              });*/
            },
          ),
          Spacer(),
          CancelButton(),
          SaveButton(
            formKey: _formKey,
            onPressed: () {
              /*
              widget.book.name = _name;
              widget.book.description = _description;

              widget.database.getBooks().then((books) {
                // books[widget.book.id] = widget.book;
                widget.database.save();
                Navigator.of(context).pop();
              });*/
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
            onPressed: () async {

              await widget.book.wordsID.add(widget.book.wordsID.length);
              await database.books.update(widget.book);
              Navigator.of(context).pop();

              /*
              widget.database.getBooks().then((books) {
                widget.book.id = books.getNextFreeKey();
                widget.book.name = _name;
                widget.book.description = _description;

                books[widget.book.id] = widget.book;
                widget.database.save();
                Navigator.of(context).pop();
              });*/
            },
          ),
        ],
      );
    }
  }

  String notEmptyFormValidator(String msg, String value) {
    return value == "" ? msg : null;
  }
}
