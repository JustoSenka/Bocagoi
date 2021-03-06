import 'package:bocagoi/models/abstractions.dart';

class Language implements DbObject, IHaveID, IHaveRequiredFields {
  Language({this.id, this.name});

  int id;
  String name;

  static Language fromMap(Map<String, dynamic> json) => Language.fromJson(json);

  Language.fromJson(Map<String, dynamic> json) {
    if (json == null){
      throw Exception("Cannot deserialize language because map was empty");
    }

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

  @override
  bool areRequiredFieldsSet() => name != null;
}
