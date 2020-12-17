import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/services/persistent_database.dart';
import 'package:bocagoi/services/user_prefs.dart';
import 'package:bocagoi/utils/common_word_operations.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/base_state.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:bocagoi/widgets/text_html.dart';
import 'package:flutter/material.dart';

class ShowWordPage extends StatefulWidget {
  ShowWordPage({@required this.word, this.book, Key key}) : super(key: key);

  final Word word;
  final Book book;

  @override
  _ShowWordPageState createState() => _ShowWordPageState(word: Word.from(word));
}

class _ShowWordPageState extends BaseState<ShowWordPage> {
  _ShowWordPageState({@required this.word})
      : database = Dependencies.get<IDatabase>();

  final IDatabase database;

  @override
  void initState() {
    super.initState();
    loadDataFuture = loadData();
  }

  Word word;
  MasterWord master;
  Map<int, Word> translations;

  Future<bool> loadDataFuture;

  Future<bool> loadData() async {
    await word.languageFuture;
    master = await word.masterWordFuture;
    translations = await master.translationsFuture;
    return true;
  }

  @override
  Widget buildScaffold(BuildContext context, GlobalKey<ScaffoldState> key) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(word.text),
      ),
      body: LoadingPageWithProgressIndicator<bool>(
        body: buildBody,
        future: loadDataFuture,
      ),
    );
  }

  Widget buildBody(bool _) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    child: Text("Edit".tr()),
                    onPressed: () => CommonWordOperations.editWord(
                        context, word,
                        callback: reloadWord),
                  ),
                ],
              ),
              TextHtml("Word Language: ${word.language.name}", classes: [
                Class.bold,
                Class.italic,
                Class.small,
                Class.paddingBottomBig
              ]),
              Row(
                children: [
                  if (word.article != null)
                    TextHtml("${word.article} ",
                        classes: [Class.bold, Class.xbig]),
                  TextHtml(word.text, classes: [Class.bold, Class.xbig]),
                  if (word.alternateSpelling != null)
                    TextHtml(" (${word.alternateSpelling})",
                        classes: [Class.bold, Class.small]),
                  if (word.pronunciation != null)
                    TextHtml(" (${word.pronunciation})",
                        classes: [Class.italic, Class.xsmall]),
                ],
              ),
              if (word.description != null)
                TextHtml(word.description, classes: [
                  Class.xsmall,
                  Class.multiline,
                  Class.paddingTopSmall
                ]),
              Divider(),
              ExpansionTile(
                title: TextHtml("Translations: ${translations.length - 1}",
                    classes: [Class.small]),
                children: <Widget>[],
              ),

            ],
          ),
        ),
      ),
    );
  }

  void reloadWord() async {
    word = await database.words.get(word.id);
    await loadData();
    setState(() {});
  }
}
