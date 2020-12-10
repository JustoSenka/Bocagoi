import 'dart:collection';

import 'package:bocagoi/models/abstractions.dart';

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

extension ListIntExtension on List<int> {
  List<int> ConvertAndReplaceWithListInt(dynamic anotherList) {
    return (anotherList as List<dynamic>)?.cast<int>() ?? this ?? List<int>();
  }
}

extension SetIntExtension on Set<int> {
  Set<int> ConvertAndReplaceWithListInt(dynamic anotherList) {
    return ((anotherList as List<dynamic>)?.cast<int>()?.toSet() ?? this) ??
        Set<int>();
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));

  List<Tuple<E, T>> zip<T>(Iterable<T> list) {
    final newList = <Tuple<E, T>>[];

    forEach((e) {
      newList.add(Tuple<E, T>(e, null));
    });

    var i = 0;
    list.forEach((e) {
      newList[i++].item2 = e;
    });

    return newList;
  }
}

extension Maps<E, T> on Map<E, List<T>> {
  Map<E, Map<E, T>> innerGroupBy(E Function(T t) key) {
    final map = HashMap<E, Map<E, T>>();
    forEach((id, value) {
      map[id] =
          HashMap.fromEntries(value.map((e) => MapEntry(key(e), e)));
    });
    return map;
  }
}


Type typeOf<T>() => T;
