
extension MapExtension<T> on Map<int, T> {
  /*int getNextFreeKey() {
    var i = 1;
    while (containsKey(i)){
      i++;
    }
    return i;
  }*/

  Map<String, T> Stringify() {
    return map((key, value) => MapEntry(key.toString(), value));
  }
}

extension ListIntExtension on List<int>  {

  List<int> ConvertAndReplaceWithListInt(dynamic anotherList){
    return (anotherList as List<dynamic>)?.cast<int>() ?? this;
  }
}

extension SetIntExtension on Set<int>  {

  Set<int> ConvertAndReplaceWithListInt(dynamic anotherList){
    return (anotherList as List<dynamic>)?.cast<int>()?.toSet() ?? this;
  }
}


Type typeOf<T>() => T;
