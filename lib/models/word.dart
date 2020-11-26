import 'package:bocagoi/models/language.dart';

class Word {
  Word({this.id, this.text, this.description, this.pronunciation,
      this.alternateSpelling, this.article, this.language});

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

  Word.from(Word w){
    // Clones don't clone the ID
    text = w.text;
    description = w.description;
    pronunciation = w.pronunciation;
    alternateSpelling = w.alternateSpelling;
    article = w.article;
    language = w.language;
  }
}
