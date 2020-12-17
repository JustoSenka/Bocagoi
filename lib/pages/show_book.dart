import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/services/logger.dart';
import 'package:bocagoi/services/persistent_database.dart';
import 'package:bocagoi/services/user_prefs.dart';
import 'package:bocagoi/utils/common_word_operations.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/base_state.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShowBookPage extends StatefulWidget {
  ShowBookPage({@required this.book, Key key}) : super(key: key);

  final Book book;

  @override
  _ShowBookPageState createState() => _ShowBookPageState(book);
}

class _ShowBookPageState extends BaseState<ShowBookPage> {
  final IDatabase database;
  final IPersistentDatabase persistentDatabase;
  final IUserPrefs userPrefs;

  _ShowBookPageState(this.book)
      : database = Dependencies.get<IDatabase>(),
        persistentDatabase = Dependencies.get<IPersistentDatabase>(),
        userPrefs = Dependencies.get<IUserPrefs>() {
    _bookHasNoWords = book.masterWordsID == null || book.masterWordsID.isEmpty;
    loadWordsFuture = loadWords();
  }

  bool _bookHasNoWords;
  Book book;

  Map<int, Map<int, Word>> words;
  List<Language> languages;
  int primaryLangID;
  int foreignLangID;
  int secondaryLangID;
  Set<int> languageIds;

  bool get isThreeColumn => secondaryLangID != null;

  Future<bool> loadWordsFuture;

  Future<bool> loadWords() async {
    final prefs = await userPrefs.load();
    primaryLangID = await prefs.getPrimaryLanguageID();
    foreignLangID = await prefs.getForeignLanguageID();
    secondaryLangID = await prefs.getSecondaryLanguageID();
    languageIds = isThreeColumn
        ? [primaryLangID, foreignLangID, secondaryLangID].toSet()
        : [primaryLangID, foreignLangID].toSet();

    final languageMap = await database.languages.getAll();
    languages = languageMap.values
        .where((e) => languageIds.contains(e.id))
        .toList(growable: false);

    words = await persistentDatabase.loadAndGroupWords(book, languageIds);

    return words.isNotEmpty;
  }

  @override
  Widget buildScaffold(BuildContext context, GlobalKey<ScaffoldState> key) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text("Book:".tr() + " " + book.name),
      ),
      body: LoadingPageWithProgressIndicator<bool>(
        future: loadWordsFuture,
        body: buildBody,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => CommonWordOperations.addNewWord(context,
            book: book, callback: setStateAndUpdateWords),
        tooltip: "Add Word".tr(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBody(bool hasData) {
    if (_bookHasNoWords || !hasData) {
      return buildTextMessage();
    } else {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: languages
                  .map(
                    (e) => Expanded(
                        child: Center(
                      child: Text(e.name,
                          style: TextStyle(fontStyle: FontStyle.italic)),
                    )),
                  )
                  .toList(),
            ),
          ),
          Divider(),
          Expanded(
            child: buildListOfWords(words),
          ),
        ],
      );
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
        ...words.values.map(
          (trans) => Row(
            children: trans.values.map((e) {
              final text = e?.text ?? "<empty>";
              return Expanded(
                child: ListTile(
                  title: Center(
                    child: Text(text),
                  ),
                  onTap: getOnTapForWord(e),
                  onLongPress: getOnLongPressForWord(e),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  VoidCallback getOnTapForWord(Word e) {
    if (e == null) {
      return () => Logger.log("Translation to this word not found");
    } else {
      return () => CommonWordOperations.showWord(context, e);
    }
  }

  VoidCallback getOnLongPressForWord(Word e) {
    if (e == null) {
      return () => Logger.log("Translation to this word not found");
    } else {
      return () => CommonWordOperations.editWord(context, e,
          book: book, callback: setStateAndUpdateWords);
    }
  }

  void setStateAndUpdateWords() async {
    // Reload book and words and set state
    book = await database.books.get(book.id);
    words = await persistentDatabase.loadAndGroupWords(book, languageIds);

    setState(() {});
  }
}
