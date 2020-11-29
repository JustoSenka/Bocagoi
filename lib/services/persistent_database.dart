import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:flutter/material.dart';

/// An abstraction layer on IDatabase.
/// It's purpose is to add/modify data in persistent manner.
/// For example, creating a word, will also create a master word for it.
/// Deleting word will remove it from the master and from the books as well.
/// Some operations might be illegal as well if persistence does not allow it.
/// While IDatabase will forcefully delete/create everything what's requested.
abstract class IPersistentDatabase {
  Future addNewWord(Word word, {Book book});

  Future deleteWord(Word word);

  Future updateChangesToWord(Word word);
}

class PersistentDatabase extends IPersistentDatabase {
  PersistentDatabase(this.database);

  final IDatabase database;

  /// Creates new master.
  /// Creates new word and links to master.
  /// Add master to book if provided.
  Future addNewWord(Word word, {Book book}) async {
    final master = MasterWord();
    master.id = await database.masterWords.getNextFreeID();
    word.id = await database.words.getNextFreeID();

    master.translationsID.add(word.id);
    word.masterWordID = master.id;

    await database.masterWords.add(master);
    await database.words.add(word);

    if (book != null) {
      book.masterWordsID.add(master.id);
      await database.books.update(book);
    }
  }

  /// Deletes word.
  /// Deletes it from the master.
  /// Deletes master if it becomes empty.
  /// Removes master from all books it is in.
  Future deleteWord(Word word) async {
    await database.words.delete(word.id);

    final master = await word.masterWordFuture;
    master.translationsID.remove(word.id);
    if (master.translationsID.isEmpty) {
      await database.masterWords.delete(master.id);
    }

    // This would benefit from batching commands
    // Also not sure if the forEach will wait for asyncs to be completed.
    final books = await database.books.getAll();
    books.forEach((key, book) async {
      if (book.masterWordsID.contains(master.id)) {
        book.masterWordsID.remove(master.id);
        await database.books.update(book);
      }
    });
  }

  /// Updates changes to a word
  /// Updating language might lead to conflicts if master has already a word
  /// in the same language. New master will be created if that happens.
  Future updateChangesToWord(Word word) async {
    if (word.id == null){
      throw Exception("Should not update an object which is not persisted");
    }

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
      await database.masterWords.add(master);

      word.masterWordID = newMaster.id;
    }

    await database.words.update(word);
  }
}
