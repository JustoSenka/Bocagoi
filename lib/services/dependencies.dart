
import 'dart:collection';

import 'package:bocagoi/utils/extensions.dart';

// At some point replace this with proper DI Container
// Good for now as long as deps don't have other deps.
class Dependencies {

  static Dependencies _singleInstance = Dependencies();

  final Map<Type, dynamic> map = HashMap<Type, dynamic>();

  // T -> Interface type
  // K -> Actual class type
  static void add<TBase, TImpl extends TBase>(TImpl obj){
    _singleInstance.map[typeOf<TBase>()] = obj;
  }

  // T -> Interface type, actual class type returned might be different
  static TBase get<TBase>(){
    return _singleInstance.map[typeOf<TBase>()] as TBase;
  }

  static void printDebug(){
    var str = "\n-- Dependencies map: \n\n";
    _singleInstance.map.forEach((key, dynamic value) => str += "$key -> $value \n");
    str += "\n-- Dependencies map end.\n\n";
    print(str);
  }

  static void recreate(){
    _singleInstance = Dependencies();
  }
}