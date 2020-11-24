import 'dart:collection';

import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/utils/extensions.dart';
import 'package:localstorage/localstorage.dart';

abstract class IDatabase {
  Future<HashMap<int, Book>> GetBooks();

  Future Save();

  Future Clean();
}

class Database extends IDatabase {
  LocalStorage _storage = LocalStorage("Books.json");

  HashMap<int, Book> _books;
  String _booksKey = "Books";

  Future<HashMap<int, Book>> GetBooks() async {
    print("GetBooks: Start");
    await _storage.ready;
    print("GetBooks: Storage Ready");

    if (_books != null) {
      print("GetBooks: Returning cached instance");
      return _books;
    }

    _books = _storage.getItem(_booksKey) as HashMap<int, Book>;
    if (_books != null) {
      print("GetBooks: Loaded from file");
      return _books;
    }

    _books = HashMap<int, Book>();
    print("GetBooks: Instantiating empty map");

    return _books;
  }

  Future Save() async {
    await _storage.ready;

    _storage.setItem(_booksKey, _books.Stringify());
  }

  Future Clean() async {
    await _storage.ready;

    _storage.deleteItem(_booksKey);
  }
}
