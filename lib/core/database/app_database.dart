import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@TableIndex(name: 'idx_todos_created_at', columns: {#createdAt})
@TableIndex(name: 'idx_todos_status_due', columns: {#isCompleted, #dueDate})
@TableIndex(name: 'idx_todos_category', columns: {#category})
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

@TableIndex(name: 'idx_notes_pinned_updated', columns: {#isPinned, #updatedAt})
@TableIndex(name: 'idx_notes_category', columns: {#category})
class NoteEntries extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get category => text()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [TodoItemEntries, NoteEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'simple_todo'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(noteEntries);
          }
          if (from < 3) {
            await m.createIndex(idxTodosCreatedAt);
            await m.createIndex(idxTodosStatusDue);
            await m.createIndex(idxTodosCategory);
            await m.createIndex(idxNotesPinnedUpdated);
            await m.createIndex(idxNotesCategory);
          }
        },
      );
}


