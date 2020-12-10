import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:flutter_test/flutter_test.dart';

class ObjectTests {
  Future<void> run() async {
    test("Book can be deserialized", () {
      final book = Book(
          name: "name", description: "desc", id: 1, masterWordsID: [2, 5].toSet());
      final deBook = Book.fromMap(Book.toMap(book));

      expect(deBook.id, book.id);
      expect(deBook.name, book.name);
      expect(deBook.description, book.description);
      expect(deBook.masterWordsID, book.masterWordsID);
    });

    test("Word can be deserialized", () {
      final word = Word(
          id: 1,
          description: "desc",
          alternateSpelling: "alt",
          article: "art",
          languageID: 2,
          pronunciation: "pron",
          text: "text");

      final deWord = Word.fromMap(Word.toMap(word));

      expect(deWord.id, word.id);
      expect(deWord.description, word.description);
      expect(deWord.masterWordID, word.masterWordID);
      expect(deWord.text, word.text);
      expect(deWord.languageID, word.languageID);
      expect(deWord.alternateSpelling, word.alternateSpelling);
      expect(deWord.pronunciation, word.pronunciation);
      expect(deWord.article, word.article);
    });

    test("Language can be deserialized", () {
      final lang = Language(id: 1, name: "name");

      final deLang = Language.fromMap(Language.toMap(lang));

      expect(deLang.id, lang.id);
      expect(deLang.name, lang.name);
    });

    test("Master word can be deserialized", () {
      final master = MasterWord(id: 1, translationsID: [1, 2].toSet());

      final deMaster = MasterWord.fromMap(MasterWord.toMap(master));

      expect(deMaster.id, master.id);
      expect(deMaster.translationsID, master.translationsID);
    });

    test("Newly created objects never have null collections", () {
      final book = Book();
      final deBook = Book.fromMap(Book.toMap(book));
      final masterWord = MasterWord();
      final deMasterWord = MasterWord.fromMap(MasterWord.toMap(masterWord));

      expect(book.masterWordsID == null, false,
          reason: "masterWordsID should not be null");
      expect(deBook.masterWordsID == null, false,
          reason: "masterWordsID should not be null after serialization");

      expect(masterWord.translationsID == null, false,
          reason: "translationsID should not be null");
      expect(deMasterWord.translationsID == null, false,
          reason: "translationsID should not be null after serialization");
    });
  }
}
