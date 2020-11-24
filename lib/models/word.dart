import 'package:bocagoi/models/language.dart';

class Word {
  int id;

  String text;
  String description;
  String pronunciation;
  String alternateSpelling;
  String article;

  Language language;

  Word.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    text = json["text"] as String;
    description = json["desc"] as String;
    pronunciation = json["pron"] as String;
    alternateSpelling = json["alte"] as String;
    article = json["arti"] as String;
    language = json["lang"] as Language;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "text": text,
      "desc": description,
      "pron": pronunciation,
      "alte": alternateSpelling,
      "arti": article,
      "lang": language,
    };
  }
}
