import 'package:bocagoi/services/database.dart';

abstract class IHaveID {
  int id;
}

abstract class IHaveRelations extends IHaveID {
  void FindRelations(Database database);
}

abstract class SerializesToMap{

}
