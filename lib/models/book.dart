import 'package:bocagoi/models/abstractions.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/utils/extensions.dart';

class Book implements IHaveID {
  Book({this.id, this.name, this.description, List<int> wordsID});

  int id;
  String name;
  String description;

  List<int> wordsID = [];
  List<Word> word = [];

  // ------------
  static Book fromMap(Map<String, dynamic> json) => Book.fromJson(json);
  Book.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    name = json["name"] as String;
    description = json["description"] as String;
    wordsID = wordsID.ConvertAndReplaceWithListInt(json["wordsID"]);
  }

  static Map<String, dynamic> toMap(Book book) {
    return <String, dynamic>{
      "id": book.id,
      "name": book.name,
      "description": book.description,
      "wordsID": book.wordsID,
    };
  }

  Map<String, dynamic> toJson() {
    var res = toMap(this);
    res["wordsID"] = wordsID;
    return res;
  }
}
