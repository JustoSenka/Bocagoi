import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/services/persistent_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/utils.dart';

IDatabase database;
IPersistentDatabase persistentDatabase;

class DatabaseTests {
  Future<void> run() async {
    database = TestDatabase();
    persistentDatabase = PersistentDatabase(database);
    Dependencies.add<IDatabase, IDatabase>(database);

    Future clean() async {
      await database.words.deleteAll();
      await database.books.deleteAll();
      await database.masterWords.deleteAll();
      await database.languages.deleteAll();
    }

    test("Cleaning data leaves empty slate", () async {
      await database.words.add(Word());
      await database.books.add(Book());
      await database.languages.add(Language());
      await database.masterWords.add(MasterWord());
      await clean();

      final words = await database.words.getAll();
      final books = await database.books.getAll();
      final languages = await database.languages.getAll();
      final masterWords = await database.masterWords.getAll();

      expect(words.isEmpty, true);
      expect(books.isEmpty, true);
      expect(languages.isEmpty, true);
      expect(masterWords.isEmpty, true);
    });

    test("Adding word creates master word automatically", () async {
      await clean();
      await persistentDatabase.addNewWord(Word());

      final words = await database.words.getAll();
      final masterWords = await database.masterWords.getAll();

      final word = words.entries.first.value;
      final masterWord = masterWords.entries.first.value;

      expect(words.length, 1);
      expect(masterWords.length, 1);
      expect(word.id, masterWord.translationsID.first);
      expect(masterWord.id, word.masterWordID);
    });

    test("Adding multiple translations maps all of them to single master",
        () async {
      await clean();
      final wordsToAdd = [Word(languageID: 1), Word(languageID: 2)];

      await persistentDatabase.addNewWord(Word(languageID: 1));
      await persistentDatabase.addMultipleNewTranslations(wordsToAdd);

      final words = await database.words.getAll();
      final masterWords = await database.masterWords.getAll();

      final masterWord =
          masterWords.values.firstWhere((e) => e.translationsID.length > 1);

      await masterWord.translationsFuture;

      expect(words.length, 3);
      expect(masterWords.length, 2);
      expect(masterWord.translationsID.toList(), [2, 3]);

      expect(masterWord.translations[1].id, 2);
      expect(masterWord.translations[2].id, 3);
      expect(masterWord.translations[1].languageID, 1);
      expect(masterWord.translations[2].languageID, 2);
    });

    test("Adding word adds it to the book automatically", () async {
      await clean();

      var book = Book();
      await database.books.add(book);
      await persistentDatabase.addNewWord(Word(), book: book);
      await persistentDatabase.addNewWord(Word(), book: book);

      final masters = await database.masterWords.getAll();
      final master1 = masters.values.elementAt(0);
      final master2 = masters.values.elementAt(1);

      final books = await database.books.getAll();
      book = books.values.first;

      expect(book.masterWordsID.contains(master1.id), true);
      expect(book.masterWordsID.contains(master2.id), true);
    });

    test("Getting grouped words by language loads all correct words", () async {
      await clean();

      var book = await addTwoWordsAndTwoTranslations();
      var words =
          await persistentDatabase.loadAndGroupWords(book, [101, 102].toSet());

      expectTwoWordsAndTwoTranslations(words);
    });

    test(
        "Getting grouped words by language loads all correct words with extra clutter",
        () async {
      await clean();

      var book = await addTwoWordsAndTwoTranslations();
      var words =
          await persistentDatabase.loadAndGroupWords(book, [101, 102].toSet());

      // adding additional words which fit language, but are not in the book
      var master1 = MasterWord(id: 3, translationsID: [15, 16].toSet());
      await database.masterWords.add(master1);
      await database.words.add(Word(id: 15, masterWordID: 3, languageID: 101));
      await database.words.add(Word(id: 16, masterWordID: 3, languageID: 102));

      // adding additional words which don't fit the language
      var existingMaster =
          MasterWord(id: 2, translationsID: [15, 16, 17].toSet());
      await database.masterWords.update(existingMaster);
      await database.words.add(Word(id: 17, masterWordID: 2, languageID: 102));

      expectTwoWordsAndTwoTranslations(words);
    });

    test("Getting grouped words by language loads even if some are missing",
        () async {
      await clean();

      var book = await addTwoWordsAndTwoTranslations();
      var words =
          await persistentDatabase.loadAndGroupWords(book, [101, 103].toSet());

      expect(words.length, 2);
      expect(words[1].length, 2);
      expect(words[2].length, 2);

      expect(words[1][101].languageID, 101);
      expect(words[2][101].languageID, 101);
      expect(words[1][101].masterWordID, 1);
      expect(words[2][101].masterWordID, 2);

      expect(words[1][103], null); // word to these langs was not translated
      expect(words[2][103], null);
    });

    test("Getting grouped words by language if none are found", () async {
      await clean();

      var book = await addTwoWordsAndTwoTranslations();
      var words =
          await persistentDatabase.loadAndGroupWords(book, [106, 107].toSet());

      // Books still has 2 master words added, although they don't have translations
      expect(words.length, 2);
      expect(words[1].length, 2);
      expect(words[2].length, 2);

      expect(words[1][101], null);
      expect(words[1][101], null);
      expect(words[2][102], null);
      expect(words[2][102], null);

      expect(words[2][101], null);
      expect(words[2][101], null);
      expect(words[1][102], null);
      expect(words[1][102], null);
    });
  }

  Future<Book> addTwoWordsAndTwoTranslations() async {
    var master1 = MasterWord(id: 1, translationsID: [11, 12].toSet());
    var master2 = MasterWord(id: 2, translationsID: [13, 14].toSet());
    var book = Book(id: 1, masterWordsID: [1, 2].toSet());

    await database.words.add(Word(id: 11, masterWordID: 1, languageID: 101));
    await database.words.add(Word(id: 12, masterWordID: 1, languageID: 102));
    await database.words.add(Word(id: 13, masterWordID: 2, languageID: 101));
    await database.words.add(Word(id: 14, masterWordID: 2, languageID: 102));

    await database.masterWords.add(master1);
    await database.masterWords.add(master2);
    await database.books.add(book);
    return book;
  }

  void expectTwoWordsAndTwoTranslations(Map<int, Map<int, Word>> words) {
    expect(words.length, 2);
    expect(words[1].length, 2);
    expect(words[2].length, 2);

    expect(words[1][101].languageID, 101);
    expect(words[2][101].languageID, 101);
    expect(words[1][102].languageID, 102);
    expect(words[2][102].languageID, 102);

    expect(words[1][101].masterWordID, 1);
    expect(words[2][101].masterWordID, 2);
    expect(words[1][102].masterWordID, 1);
    expect(words[2][102].masterWordID, 2);
  }
}
