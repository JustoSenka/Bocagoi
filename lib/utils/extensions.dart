import 'dart:collection';

extension MapExtension<T> on Map<int, T> {
  int getNextFreeKey() {
    var i = 1;
    while (this.containsKey(i)) i++;
    return i;
  }

  Map<String, T> Stringify() {
    return this.map((key, value) => MapEntry(key.toString(), value));
  }
}
