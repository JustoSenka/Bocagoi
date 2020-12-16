import 'dart:collection';

import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/utils/extensions.dart';
import 'package:flutter/cupertino.dart';

/// An abstraction layer on IDatabase.
/// It's purpose is to add/modify data in persistent manner.
/// For example, creating a word, will also create a master word for it.
/// Deleting word will remove it from the master and from the books as well.
/// Some operations might be illegal as well if persistence does not allow it.
/// While IDatabase will forcefully delete/create everything what's requested.
abstract class IPersistentDatabase {
  Future<bool> addMultipleNewTranslations(List<Word> words, {Book book});

  Future addNewWord(Word word, {Book book});

  Future deleteWord(Word word);

  Future updateChangesToWord(Word word);

  Future<Map<int, Map<int, Word>>> loadAndGroupWords(
      Book book, Set<int> languageIDs);
}

class PersistentDatabase extends IPersistentDatabase {
  PersistentDatabase(this.database);

  final IDatabase database;

  /// Creates new master.
  /// Creates new words and links to master.
  /// Add master to book if provided.
  Future<bool> addMultipleNewTranslations(List<Word> words, {Book book}) async {
    final langsSet = words.map((e) => e.languageID).toSet();
    if (langsSet.length != words.length) {
      final msg =
          "Cannot add multiple translations to same master word if some have the same language id";
      print(msg);
      return false;
    }

    return await database.batchRequests(() async {
      final master = MasterWord();
      master.id = await database.masterWords.getNextFreeID();

      final ids = await database.words.getNextFreeIDs(words.length);
      words.zip(ids).forEach((e) {
        e.item1.id ??= e.item2;
        e.item1.masterWordID = master.id;
      });

      master.translationsID.addAll(words.map((e) => e.id));

      await database.masterWords.add(master);
      await Future.wait(words.map((e) async => await database.words.add(e)));

      if (book != null) {
        book.masterWordsID.add(master.id);
        await database.books.update(book);
      }
    });
  }

  /// Creates new master.
  /// Creates new word and links to master.
  /// Add master to book if provided.
  Future<bool> addNewWord(Word word, {Book book}) async {
    return await database.batchRequests(() async {
      if (word.languageID == null){
        throw Exception("Cannot add word with no language set");
      }

      final master = MasterWord();
      master.id = await database.masterWords.getNextFreeID();
      word.id ??= await database.words.getNextFreeID();

      master.translationsID.add(word.id);
      word.masterWordID = master.id;

      await database.masterWords.add(master);
      await database.words.add(word);

      if (book != null) {
        book.masterWordsID.add(master.id);
        await database.books.update(book);
      }
    });
  }

  /// Deletes word.
  /// Deletes it from the master.
  /// Deletes master if it becomes empty.
  /// Removes master from all books it is in.
  Future<bool> deleteWord(Word word) async {
    return await database.batchRequests(() async {
      await database.words.delete(word.id);

      final master = await word.masterWordFuture;
      master.translationsID.remove(word.id);
      if (master.translationsID.isEmpty) {
        await database.masterWords.delete(master.id);
      }

      // This would benefit from batching commands
      final books = await database.books.getAll();
      await Future.wait(books.entries.map((e) async {
        if (e.value.masterWordsID.contains(master.id)) {
          e.value.masterWordsID.remove(master.id);
          return await database.books.update(e.value);
        }
      }));
    });
  }

  /// Updates changes to a word
  /// Updating language might lead to conflicts if master has already a word
  /// in the same language. New master will be created if that happens.
  Future<bool> updateChangesToWord(Word word) async {
    if (word.id == null) {
      final msg = "Should not update an object which is not persisted";
      print(msg);
      return false;
    }

    return await database.batchRequests(() async {
      final master = await word.masterWordFuture;
      var trans = await master.translationsFuture;

      // If master already have a translation in same
      // language the word wants to be updated to
      if (trans.containsKey(word.languageID) &&
          trans[word.languageID].id != word.id) {
        master.translationsID.remove(word.id);
        await database.masterWords.update(master);

        final newMaster = MasterWord();
        newMaster.translationsID.add(word.id);
        await database.masterWords.add(newMaster);

        word.masterWordID = newMaster.id;
      }

      await database.words.update(word);
    });
  }

  /// Outer Map Key -> MasterWordID
  /// Inner Map Key -> LanguageID
  /// Words are all the words linked to the master word.
  Future<Map<int, Map<int, Word>>> loadAndGroupWords(
      Book book, Set<int> languageIDs) async {
    try {
      final masterWords = await book.masterWordsFuture;

      final wordIDs =
          masterWords.values.expand((e) => e.translationsID).toSet();

      final words = await database.words.getMany(wordIDs.toList());
      final map = words.values
          .where((e) => languageIDs.contains(e.languageID))
          .groupBy((e) => e.masterWordID)
          .innerGroupBy((w) => w.languageID);

      // If database does not contain some words, still create empty maps or nulls
      // inside the inner one, if word is not translated to the desired language
      var mapWithEmpties = masterWords.map((id, master) {
        var innerMap = HashMap<int, Word>();

        languageIDs.forEach((langId) {
          innerMap[langId] = map.tryGet(id)?.tryGet(langId);
        });

        return MapEntry(id, innerMap);
      });

      return mapWithEmpties;
    } catch (e) {
      print(e.toString());
    }

    return HashMap<int, HashMap<int, Word>>();
  }
}
