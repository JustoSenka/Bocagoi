import 'dart:collection';

import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/services/persistent_database.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:flutter/material.dart';

class EditWordPage extends StatefulWidget {
  EditWordPage({@required this.word, this.book, Key key}) : super(key: key);

  final Word word;
  final Book book;

  @override
  _EditWordPageState createState() =>
      _EditWordPageState(wordCopy: Word.from(word));
}

class _EditWordPageState extends State<EditWordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final IDatabase database;
  final IPersistentDatabase persistentDatabase;

  _EditWordPageState({@required this.wordCopy})
      : database = Dependencies.get<IDatabase>(),
        persistentDatabase = Dependencies.get<IPersistentDatabase>() {
    _isWordPersisted = wordCopy.id != null;
    loadDataFuture = loadData();
  }

  Word wordCopy;
  bool _isWordPersisted;

  HashMap<int, Language> languages;
  Future<bool> loadDataFuture;

  Future<bool> loadData() async {
    languages = await database.languages.getAll();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isWordPersisted ? "Edit Word".tr() : "Add Word".tr()),
      ),
      body: LoadingPageWithProgressIndicator<bool>(
        body: buildForm,
        future: loadDataFuture,
      ),
    );
  }

  Form buildForm(bool _) {
    return Form(
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
                  initialValue: wordCopy.text,
                  onChanged: (val) => wordCopy.text = val,
                  validator: (value) =>
                      notEmptyFormValidator("Word cannot be empty".tr(), value),
                ),
                RoundedTextFormField(
                  labelText: "Article".tr(),
                  initialValue: wordCopy.article,
                  onChanged: (val) => wordCopy.article = val,
                ),
                RoundedTextFormField(
                  labelText: "Pronunciation".tr(),
                  initialValue: wordCopy.pronunciation,
                  onChanged: (val) => wordCopy.pronunciation = val,
                ),
                RoundedTextFormField(
                  labelText: "Alternate Spelling".tr(),
                  initialValue: wordCopy.alternateSpelling,
                  onChanged: (val) => wordCopy.alternateSpelling = val,
                ),
                RoundedTextFormField(
                  labelText: "Description".tr(),
                  initialValue: wordCopy.description,
                  onChanged: (val) => wordCopy.description = val,
                  maxLines: 5,
                ),
                Container(
                  child: DropdownButton<int>(
                    value: wordCopy.languageID,
                    items: buildDropdownItems(
                        languages, (id) => languages[id].name),
                    onChanged: (value) => setState(() {
                      wordCopy.languageID = value;
                    }),
                  ),
                ),
                buildButtonRow(),
              ],
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
            onPressed: () async {
              await persistentDatabase.deleteWord(widget.word);
              Navigator.of(context).pop();
            },
          ),
          Spacer(),
          CancelButton(),
          SaveButton(
            formKey: _formKey,
            onPressed: () async {
              await persistentDatabase.updateChangesToWord(wordCopy);
              Navigator.of(context).pop();
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
              await persistentDatabase.addNewWord(wordCopy);
              Navigator.of(context).pop();
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
