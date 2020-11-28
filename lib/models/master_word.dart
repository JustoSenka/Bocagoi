import 'dart:collection';
import 'package:bocagoi/models/abstractions.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/utils/extensions.dart';

class MasterWord implements IHaveID {

  int id;
  List<int> translationsID = List<int>();

  /// Language ID -> Word
  HashMap<int, Word> translations = HashMap<int, Word>();

  static MasterWord fromMap(Map<String, dynamic> json) =>
      MasterWord.fromJson(json);

  MasterWord.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    translationsID = translationsID.ConvertAndReplaceWithListInt(json["translationsID"]);
  }

  static Map<String, dynamic> toMap(MasterWord masterWord) =>
      <String, dynamic>{"id": masterWord.id};

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "translationsID": translationsID,
    };
  }
}
