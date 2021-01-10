import 'package:bocagoi/models/abstractions.dart';
import 'package:bocagoi/models/language.dart';
import 'package:bocagoi/models/master_word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';

class Word implements DbObject, IHaveID, IHaveRequiredFields {
  Word(
      {this.id,
      this.text,
      this.description,
      this.pronunciation,
      this.alternateSpelling,
      this.article,
      this.languageID,
      this.masterWordID});

  int id;

  String text;
  String description;
  String pronunciation;
  String alternateSpelling;
  String article;

  int languageID;
  int masterWordID;

  Language language;

  Future<Language> get languageFuture async {
    return language =
        await Dependencies.get<IDatabase>().languages.get(languageID);
  }

  MasterWord masterWord;

  Future<MasterWord> get masterWordFuture async {
    return masterWord =
        await Dependencies.get<IDatabase>().masterWords.get(masterWordID);
  }

  static Word fromMap(Map<String, dynamic> json) => Word.fromJson(json);

  Word.fromJson(Map<String, dynamic> json) {
    if (json == null){
      throw Exception("Cannot deserialize word because map was empty");
    }

    id = json["id"] as int;
    text = json["text"] as String;
    description = json["description"] as String;
    pronunciation = json["pronunciation"] as String;
    alternateSpelling = json["alternateSpelling"] as String;
    article = json["article"] as String;
    languageID = json["languageID"] as int;
    masterWordID = json["masterWordID"] as int;
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
      "masterWordID": word.masterWordID,
    };
  }

  Map<String, dynamic> toJson() => toMap(this);

  Word.from(Word w) {
    id = w.id;
    text = w.text;
    description = w.description;
    pronunciation = w.pronunciation;
    alternateSpelling = w.alternateSpelling;
    article = w.article;
    languageID = w.languageID;
    masterWordID = w.masterWordID;
  }

  @override
  bool areRequiredFieldsSet() =>
      text != null && languageID != null && masterWordID != null;
}
