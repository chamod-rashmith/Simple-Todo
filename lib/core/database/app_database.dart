import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class TodoItemEntries extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get priority => text()();
  TextColumn get assignedDate => text().nullable()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [TodoItemEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'simple_todo'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

