import 'package:drift/drift.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
export 'package:ledger_app/core/domain/entities/category.dart';

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get type => textEnum<CategoryType>()();

  IntColumn get color => integer()();

  IntColumn get icon => integer()();

  BoolColumn get isTechnical => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
