import 'package:drift/drift.dart';
import 'package:ledger_app/core/domain/entities/category.dart';
import 'package:ledger_app/core/domain/enums/app_icon.dart';
export 'package:ledger_app/core/domain/entities/category.dart';

export 'package:ledger_app/core/domain/enums/app_icon.dart';

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get type => textEnum<CategoryType>()();

  IntColumn get color => integer()();

  TextColumn get icon => textEnum<AppIcon>()();

  BoolColumn get isTechnical => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
