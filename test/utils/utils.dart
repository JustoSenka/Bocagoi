import 'dart:collection';

import 'package:bocagoi/models/abstractions.dart';
import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/object_provider.dart';

class TestObjectProvider<T extends DbObject> extends IObjectProvider<T> {
  TestObjectProvider() {
    map = HashMap<int, T>();
  }

  Map<int, T> map;

  @override
  Future<bool> add(T obj) async {
    obj.id ??= await getNextFreeID();

    if (map.containsKey(obj.id)){
      ObjectAlreadyExistsException(obj);
    }

    map[obj.id] = obj;
    return true;
  }

  @override
  Future<bool> delete(int id) async {
    map.remove(id);
    return true;
  }

  @override
  Future<bool> deleteAll() async {
    map.clear();
    return true;
  }

  @override
  Future<T> get(int id) async {
    return map[id];
  }

  @override
  Future<Map<int, T>> getAll() async {
    return map;
  }

  @override
  Future<Map<int, T>> getMany(List<int> list) async {
    return HashMap.fromEntries(map.entries.where((e) => list.contains(e.key)));
  }

  @override
  Future<bool> update(T obj) async {
    if (obj.id == null) {
      throw ObjectDoesNotExistException(obj);
    }

    map[obj.id] = obj;
    return true;
  }

  @override
  Future<int> getNextFreeID() async {
    var i = 1;
    while (map.containsKey(i)) {
      i++;
    }
    return i;
  }

  @override
  Future<List<int>> getNextFreeIDs(int amountOfIds) async {
    final list = <int>[];
    var id = 1;
    for (var i = 0; i < amountOfIds; i++) {
      while (map.containsKey(id)) {
        id++;
      }
      list.add(id);
      id++;
    }

    return list;
  }
}

class TestDatabase extends IDatabase {
  final IObjectProvider<Book> _Books = TestObjectProvider<Book>();
  final IObjectProvider<Word> _Words = TestObjectProvider<Word>();
  final IObjectProvider<Language> _Languages = TestObjectProvider<Language>();
  final IObjectProvider<MasterWord> _MasterWords =
      TestObjectProvider<MasterWord>();

  @override
  IObjectProvider<Book> get books => _Books;

  @override
  IObjectProvider<Language> get languages => _Languages;

  @override
  IObjectProvider<MasterWord> get masterWords => _MasterWords;

  @override
  IObjectProvider<Word> get words => _Words;

  @override
  void batch() {}

  @override
  Future<bool> commit() async {
    return true;
  }

  @override
  void cancel() {}
}
