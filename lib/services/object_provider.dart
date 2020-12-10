import 'dart:collection';

import 'package:bocagoi/models/abstractions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IObjectProvider<T extends IHaveID> {
  IObjectProvider(
      {String path,
      T Function(Map<String, dynamic>) constructor,
      Map<String, dynamic> Function(T) serializer});

  final Set<int> _idsTaken = HashSet<int>();

  WriteBatch _batch;

  void batch(WriteBatch batch) {
    _batch = batch;
    _idsTaken.clear();
  }

  void commit() {
    _batch = null;
    _idsTaken.clear();
  }

  Future<bool> add(T obj);

  Future<bool> delete(int id);

  Future<bool> deleteAll();

  Future<T> get(int id);

  Future<Map<int, T>> getMany(List<int> list);

  Future<Map<int, T>> getAll();

  Future<bool> update(T obj);

  Future<int> getNextFreeID();

  Future<List<int>> getNextFreeIDs(int amountOfIds);
}

class ObjectProvider<T extends IHaveID> extends IObjectProvider<T> {
  ObjectProvider({this.path, this.constructor, this.serializer});

  String path;
  T Function(Map<String, dynamic>) constructor;
  Map<String, dynamic> Function(T) serializer;

  Future<bool> add(T obj) async {
    obj.id ??= await getNextFreeID();
    return await update(obj);
  }

  Future<bool> delete(int id) async {
    try {
      var collection = _getCollection(path);
      var doc = collection.doc(id.toString());

      if (_batch == null) {
        await doc.delete();
      } else {
        _batch.delete(doc);
      }

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteAll() async {
    try {
      final map = await getAll();
      var collection = _getCollection(path);
      await Future.wait(map.entries
          .map((e) async => await collection.doc(e.key.toString()).delete()));
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<T> get(int id) async {
    try {
      var collection = _getCollection(path);
      var doc = collection.doc(id.toString());

      var data = await doc.get();
      return constructor(data.data());
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<int, T>> getMany(List<int> list) async {
    try {
      var collection = _getCollection(path);
      // var docs = list.map((id) => collection.doc(id.toString()));

      if (list.isNotEmpty) {
        var data = await collection.where("id", whereIn: list).get();
        var map = _produceHashMapFromSnapshot(data, constructor);
        return map;
      } else {
        return HashMap<int, T>();
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<int, T>> getAll() async {
    try {
      var snapshot = await _getCollection(path).get();
      var map = _produceHashMapFromSnapshot(snapshot, constructor);
      return map;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> update(T obj) async {
    if (obj.id == null) {
      throw Exception("Should not update an object which is not persisted");
    }

    try {
      var collection = _getCollection(path);
      var doc = collection.doc(obj.id.toString());

      if (_batch == null) {
        await doc.set(serializer(obj));
      } else {
        _batch.set(doc, serializer(obj));
      }

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<int> getNextFreeID() async {
    final snapshot = await _getCollection(path).get();
    final set =
        snapshot.docs.map<dynamic>((e) => e.data()["id"]).cast<int>().toSet();

    var id = 1;
    while (set.contains(id) && _idsTaken.contains(id)) {
      id++;
    }

    // If batch editing, every time return new ids
    if (_batch != null) {
      _idsTaken.add(id);
    }

    return id;
  }

  Future<List<int>> getNextFreeIDs(int amountOfIds) async {
    final snapshot = await _getCollection(path).get();
    final set =
        snapshot.docs.map<dynamic>((e) => e.data()["id"]).cast<int>().toSet();

    final list = <int>[];
    var id = 1;
    for (var i = 0; i < amountOfIds; i++) {
      while (set.contains(id) && _idsTaken.contains(id)) {
        id++;
      }
      list.add(id);
      id++;
    }

    return list;
  }
}

CollectionReference _getCollection(String path) {
  return FirebaseFirestore.instance.collection(path);
}

HashMap<int, U> _produceHashMapFromSnapshot<U extends IHaveID>(
    QuerySnapshot snapshot, U Function(Map<String, dynamic>) constructor) {
  var entries = snapshot.docs.map((e) {
    var obj = constructor(e.data());
    return MapEntry(obj.id, obj);
  });

  return HashMap.fromEntries(entries);
}
