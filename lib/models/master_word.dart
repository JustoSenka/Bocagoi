import 'package:bocagoi/models/abstractions.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/services/database.dart';
import 'package:bocagoi/services/dependencies.dart';
import 'package:bocagoi/utils/extensions.dart';

class MasterWord implements DbObject, IHaveID, IHaveRequiredFields {
  MasterWord({this.id, Set<int> translationsID})
      : translationsID = translationsID ?? Set<int>();

  int id;
  Set<int> translationsID;

  // key -> languageID
  Map<int, Word> translations;

  Future<Map<int, Word>> get translationsFuture async {
    final words = await Dependencies.get<IDatabase>()
        .words
        .getMany(translationsID.toList());
    // Change key from wordID to languageID.
    return translations =
        words.map((key, value) => MapEntry(value.languageID, value));
  }

  static MasterWord fromMap(Map<String, dynamic> json) =>
      MasterWord.fromJson(json);

  MasterWord.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    translationsID =
        translationsID.ConvertAndReplaceWithListInt(json["translationsID"]);
  }

  static Map<String, dynamic> toMap(MasterWord masterWord) =>
      masterWord.toJson();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "translationsID": translationsID.toList(growable: false),
    };
  }

  @override
  bool areRequiredFieldsSet() =>
      translationsID != null && translationsID.isNotEmpty;
}
