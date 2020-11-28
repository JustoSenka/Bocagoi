import 'dart:collection';

import 'package:bocagoi/models/abstractions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ObjectProvider<T extends IHaveID> {
  ObjectProvider({this.path, this.constructor, this.serializer});

  String path;
  T Function(Map<String, dynamic>) constructor;
  Map<String, dynamic> Function(T) serializer;

  Future<String> add(T obj) async {
    if (obj.id == null){
      throw Exception("Object should have an id already assigned");
    }

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
    try {
      var collection = _getCollection(path);
      var doc = collection.doc(obj.id.toString());
      await doc.set(serializer(obj));
    } catch (e) {
      print(e.toString());
      return null;
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
}
