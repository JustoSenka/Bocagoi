import 'package:bocagoi/services/database.dart';

abstract class DbObject implements IHaveID, IHaveRequiredFields {}

abstract class IHaveID {
  int id;
}

abstract class IHaveRequiredFields {
  bool areRequiredFieldsSet();
}

abstract class IHaveRelations extends IHaveID {
  void FindRelations(Database database);
}

abstract class SerializesToMap {}

class Tuple<T, K> {
  T item1;
  K item2;

  Tuple(this.item1, this.item2);
}
