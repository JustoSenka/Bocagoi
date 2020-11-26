import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:flutter/material.dart';

class EditWordPage extends StatefulWidget {
  EditWordPage({@required this.database, @required this.word, Key key})
      : super(key: key);

  final IDatabase database;
  final Word word;

  @override
  _EditWordPageState createState() => _EditWordPageState(word);
}

class _EditWordPageState extends State<EditWordPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _EditWordPageState(Word word) {
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
                    validator: (value) => notEmptyFormValidator(
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
                  )
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
    return Row(
      children: [
        RoundedButton(
          text: "Delete".tr(),
          color: BootstrapColors.danger,
          fontSize: FontSize.small,
          onPressed: () {
            widget.database.getBooks().then((books) {
              //books.remove(widget.book.id);
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
                //widget.book.name = _name;
                //widget.book.description = _description;
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

  String notEmptyFormValidator(String msg, String value) {
    return value == "" ? msg : "";
  }
}
