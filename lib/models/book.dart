import 'package:bocagoi/models/master_word.dart';

class Book {
  Book({this.id, this.name, this.description, this.words});

  int id;
  String name;
  String description;

  Set<MasterWord> words;

  Book.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    name = json["name"] as String;
    description = json["desc"] as String;
    words = json["words"] as Set<MasterWord>;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "desc": description,
      "words": words,
    };
  }
}
