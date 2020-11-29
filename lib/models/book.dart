import 'dart:collection';

import 'package:bocagoi/models/abstractions.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/utils/extensions.dart';

class Book implements IHaveID {
  Book({this.id, this.name, this.description, List<int> wordsID});

  int id;
  String name;
  String description;
  Set<int> masterWordsID = Set<int>();

  Map<int, MasterWord> masterWords;
  Future<Map<int, MasterWord>> get masterWordsFuture async {
    return masterWords = await Dependencies.get<IDatabase>().masterWords.getMultiple(masterWordsID);
  }

  // ------------
  static Book fromMap(Map<String, dynamic> json) => Book.fromJson(json);
  Book.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    name = json["name"] as String;
    description = json["description"] as String;
    masterWordsID = masterWordsID.ConvertAndReplaceWithListInt(json["wordsID"]);
  }

  static Map<String, dynamic> toMap(Book book) {
    return <String, dynamic>{
      "id": book.id,
      "name": book.name,
      "description": book.description,
      "wordsID": book.masterWordsID,
    };
  }

  Map<String, dynamic> toJson() {
    var res = toMap(this);
    res["wordsID"] = masterWordsID;
    return res;
  }
}
