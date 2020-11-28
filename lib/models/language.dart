import 'package:bocagoi/models/abstractions.dart';

class Language implements IHaveID {
  int id;
  String name;

  static Language fromMap(Map<String, dynamic> json) => Language.fromJson(json);

  Language.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    name = json["name"] as String;
  }

  static Map<String, dynamic> toMap(Language lang) => lang.toJson();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
    };
  }
}
