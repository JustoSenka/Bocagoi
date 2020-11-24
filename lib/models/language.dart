class Language {
  int id;
  String name;

  Language.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    name = json["name"] as String;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
    };
  }
}
