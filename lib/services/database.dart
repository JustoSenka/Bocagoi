import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/object_provider.dart';

abstract class IDatabase {
  ObjectProvider<Book> get books;

  ObjectProvider<Word> get words;

  ObjectProvider<MasterWord> get masterWords;

  ObjectProvider<Language> get languages;
}

class Database extends IDatabase {
  static const String _pathBooks = "books";
  static const String _pathWords = "words";
  static const String _pathMasterWords = "masterWords";
  static const String _pathLanguages = "languages";

  final ObjectProvider<Book> _Books = ObjectProvider<Book>(
    path: _pathBooks,
    constructor: Book.fromMap,
    serializer: Book.toMap,
  );

  final ObjectProvider<Word> _Words = ObjectProvider<Word>(
    path: _pathWords,
    constructor: Word.fromMap,
    serializer: Word.toMap,
  );

  final ObjectProvider<MasterWord> _MasterWords = ObjectProvider<MasterWord>(
    path: _pathMasterWords,
    constructor: MasterWord.fromMap,
    serializer: MasterWord.toMap,
  );

  final ObjectProvider<Language> _Languages = ObjectProvider<Language>(
    path: _pathLanguages,
    constructor: Language.fromMap,
    serializer: Language.toMap,
  );

  @override
  ObjectProvider<Book> get books => _Books;

  @override
  ObjectProvider<Language> get languages => _Languages;

  @override
  ObjectProvider<MasterWord> get masterWords => _MasterWords;

  @override
  ObjectProvider<Word> get words => _Words;
}
