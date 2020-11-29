import 'dart:collection';

import 'package:bocagoi/models/abstractions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IObjectProvider<T extends IHaveID> {
  Future<String> add(T obj);

  Future<void> delete(int id);

  Future<T> get(int id);

  Future<HashMap<int, T>> getMultiple(Iterable<int> list);

  Future<HashMap<int, T>> getAll();

  Future<void> update(T obj);
}

class ObjectProvider<T extends IHaveID> extends IObjectProvider<T> {
  ObjectProvider({this.path, this.constructor, this.serializer});

  String path;
  T Function(Map<String, dynamic>) constructor;
  Map<String, dynamic> Function(T) serializer;

  Future<String> add(T obj) async {
    obj.id ??= await getNextFreeID();

    await update(obj);
    return obj.id.toString();

    /* This type of adding will generate random id
    var collection = _getCollection(pathBooks);
    var r = await collection.add(obj.toMap());
    print("Book added: " + r.id);
    return r.id;
    */
  }

  Future<void> delete(int id) async {
    try {
      var collection = _getCollection(path);
      var doc = collection.doc(id.toString());
      await doc.delete();
    } catch (e) {
      print(e.toString());
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

  Future<HashMap<int, T>> getMultiple(Iterable<int> list) async {
    try {
      var collection = _getCollection(path);
      var doc = collection.where("id", arrayContains: list);

      var data = await doc.get();
      var map = _produceHashMapFromSnapshot(data, constructor);

      return map;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<HashMap<int, T>> getAll() async {
    try {
      var snapshot = await _getCollection(path).get();
      var map = _produceHashMapFromSnapshot(snapshot, constructor);
      return map;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> update(T obj) async {
    if (obj.id == null){
      throw Exception("Should not update an object which is not persisted");
    }

    try {
      var collection = _getCollection(path);
      var doc = collection.doc(obj.id.toString());
      await doc.set(serializer(obj));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<int> getNextFreeID() async {
    final snapshot = await _getCollection(path).get();
    final set =
        snapshot.docs.map<dynamic>((e) => e.data()["id"]).cast<int>().toSet();

    var i = 1;
    while (set.contains(i)) {
      i++;
    }
    return i;
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
