
import 'dart:collection';
import 'package:bocagoi/models/word.dart';

class MasterWord {

  int id;

  /// key - Language ID
  HashMap<int, Word> translations;

  MasterWord.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    translations = json["trans"] as HashMap<int, Word>;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "trans": translations,
    };
  }
}