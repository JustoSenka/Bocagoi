import 'package:bocagoi/models/abstractions.dart';

class Word implements IHaveID {
  Word({this.id, this.text, this.description, this.pronunciation,
      this.alternateSpelling, this.article, this.languageID});

  int id;

  String text;
  String description;
  String pronunciation;
  String alternateSpelling;
  String article;

  int languageID;

  static Word fromMap(Map<String, dynamic> json) => Word.fromJson(json);
  Word.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    text = json["text"] as String;
    description = json["description"] as String;
    pronunciation = json["pronunciation"] as String;
    alternateSpelling = json["alternateSpelling"] as String;
    article = json["article"] as String;
    languageID = json["languageID"] as int;
  }

  static Map<String, dynamic> toMap(Word word) {
    return <String, dynamic>{
      "id": word.id,
      "text": word.text,
      "description": word.description,
      "pronunciation": word.pronunciation,
      "alternateSpelling": word.alternateSpelling,
      "article": word.article,
      "languageID": word.languageID,
    };
  }

  Map<String, dynamic> toJson() => toMap(this);

  Word.from(Word w){
    id = w.id;
    text = w.text;
    description = w.description;
    pronunciation = w.pronunciation;
    alternateSpelling = w.alternateSpelling;
    article = w.article;
    languageID = w.languageID;
  }
}
