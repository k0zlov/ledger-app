import 'package:drift/drift.dart';

enum CategoryType {
  any,
  expense,
  income,
}

@DataClassName('CategoryModel')
class Categories extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get type => textEnum<CategoryType>()();

  TextColumn get colorHex => text()();

  @override
  Set<Column> get primaryKey => {id};
}
