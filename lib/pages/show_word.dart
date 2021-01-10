import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/services/persistent_database.dart';
import 'package:bocagoi/utils/common_word_operations.dart';
import 'package:bocagoi/utils/strings.dart';
import 'package:bocagoi/widgets/base_state.dart';
import 'package:bocagoi/widgets/buttons.dart';
import 'package:bocagoi/widgets/searcheable_dropdown.dart';
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
      : database = Dependencies.get<IDatabase>(),
        persistentDatabase = Dependencies.get<IPersistentDatabase>();

  final IDatabase database;
  final IPersistentDatabase persistentDatabase;

  @override
  void initState() {
    super.initState();
    loadDataFuture = loadData();
  }

  Word word;
  MasterWord master;
  Map<int, Word> translations;
  Map<int, Word> wordsToLinkTo;
  Map<int, Language> languages;

  Future<bool> loadDataFuture;

  Future<bool> loadData() async {
    await word.languageFuture;
    master = await word.masterWordFuture;
    translations = await master.translationsFuture;

    // TODO: Might be slow to redo this after every modification
    final words = await database.words.getAll();
    wordsToLinkTo = Map<int, Word>.fromEntries(words.entries
        .where((e) => !translations.containsKey(e.value.languageID)));

    languages = await database.languages.getAll();
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
              // Shows translations to other languages
              buildTranslationExpansionTile(),
              // Links words to different other languages
              buildSearchableDropdown(),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget which shows translations this word is translated to
  Widget buildTranslationExpansionTile() {
    return ExpansionTile(
      title: TextHtml("Translations: ${translations.length - 1}",
          classes: [Class.small]),
      children: translations.values.where((e) => e.id != word.id).map((e) {
        return ListTile(
          title: PrimaryText(e?.text ?? "<empty>"),
          trailing: SecondaryText(languages[e?.languageID ?? 1].name),
          onTap: () async {
            CommonWordOperations.showWord(context, e);
          },
        );
      }).toList(),
    );
  }

  /// Widget which can link displayed word to words in other languages
  Widget buildSearchableDropdown() {
    return SearchableDropdown(
      text: TextHtml(
        "Link to existing translation",
        color: Colors.grey.shade700,
      ),
      listViewItemBuilder: (index) {
        return ListTile(
          title: PrimaryText(wordsToLinkTo[index]?.text ?? "<empty $index>"),
          trailing: SecondaryText(
              languages[wordsToLinkTo[index]?.languageID ?? 1].name),
          onTap: () async {
            final wordToLinkTo = wordsToLinkTo[index];
            await persistentDatabase.linkWordToExistingTranslation(
                word, wordToLinkTo);
            Navigator.pop(context);
          },
        );
      },
      itemCount: wordsToLinkTo.length,
      itemTextContentGetter: (index) => wordsToLinkTo[index]?.text ?? "",
    );
  }

  void reloadWord(bool didWordChange) async {
    if (didWordChange ?? false) {
      word = await database.words.get(word.id);
      if (word == null){ // Word was deleted, return back to caller
        Navigator.pop(context, true);
      }

      await loadData();
      setState(() {});
    }
  }
}
