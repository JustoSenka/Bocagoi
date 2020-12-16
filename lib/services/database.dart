import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/object_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IDatabase {

  Future<bool> batchRequests(void Function() function) async {
    try {
      batch();
      await function();
      final res = await commit();
      return res;
    }
    catch (e){
      cancel();
      print(e.toString());
      rethrow;
      return false;
    }
  }

  void batch();

  Future<bool> commit();

  void cancel();

  IObjectProvider<Book> get books;

  IObjectProvider<Word> get words;

  IObjectProvider<MasterWord> get masterWords;

  IObjectProvider<Language> get languages;
}

class Database extends IDatabase {
  Database();

  static const String _pathBooks = "books";
  static const String _pathWords = "words";
  static const String _pathMasterWords = "master-words";
  static const String _pathLanguages = "languages";

  WriteBatch _batch;

  void batch() {
    if (_batch != null) {
      final msg =
          "Cannot start a batch database operation, because the other batch was not commited";
      print(msg);
      return;
      throw Exception(msg);
    }

    _batch = FirebaseFirestore.instance.batch();

    _Books.batch(_batch);
    _Words.batch(_batch);
    _MasterWords.batch(_batch);
    _Languages.batch(_batch);
  }

  Future<bool> commit() async {
    if (_batch == null) {
      final msg =
          "Cannot commit batch database operation because batch hasn't started";
      print(msg);
      return false;
      throw Exception(msg);
    }

    try {
      _Books.commit();
      _Words.commit();
      _MasterWords.commit();
      _Languages.commit();

      await _batch.commit();
    } catch (e) {
      print(e.toString());
      return false;
    } finally {
      _batch = null;
    }

    return true;
  }

  void cancel() {
    _batch = null;
    _Books.commit();
    _Words.commit();
    _MasterWords.commit();
    _Languages.commit();
  }

  final IObjectProvider<Book> _Books = ObjectProvider<Book>(
    path: _pathBooks,
    constructor: Book.fromMap,
    serializer: Book.toMap,
  );

  final IObjectProvider<Word> _Words = ObjectProvider<Word>(
    path: _pathWords,
    constructor: Word.fromMap,
    serializer: Word.toMap,
  );

  final IObjectProvider<MasterWord> _MasterWords = ObjectProvider<MasterWord>(
    path: _pathMasterWords,
    constructor: MasterWord.fromMap,
    serializer: MasterWord.toMap,
  );

  final IObjectProvider<Language> _Languages = ObjectProvider<Language>(
    path: _pathLanguages,
    constructor: Language.fromMap,
    serializer: Language.toMap,
  );

  @override
  IObjectProvider<Book> get books => _Books;

  @override
  IObjectProvider<Language> get languages => _Languages;

  @override
  IObjectProvider<MasterWord> get masterWords => _MasterWords;

  @override
  IObjectProvider<Word> get words => _Words;
}
