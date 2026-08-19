import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/core/database/app_database.dart';

void main() {
  group('🗄️ AppDatabase Schema v3 & Indexing Tests', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    test('schemaVersion must be 3', () {
      expect(database.schemaVersion, equals(3));
    });

    test('TodoItemEntries supports insert and querying with indexes', () async {
      final now = DateTime.now().toIso8601String();
      await database.into(database.todoItemEntries).insert(
            TodoItemEntriesCompanion.insert(
              id: 'todo_idx_1',
              title: 'Indexed Todo Task',
              description: 'Testing composite indexes',
              category: 'Work',
              priority: 'high',
              isCompleted: const Value(false),
              assignedDate: Value(now),
              dueDate: Value(now),
              createdAt: now,
            ),
          );

      final todos = await (database.select(database.todoItemEntries)
            ..where((t) => t.category.equals('Work'))
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
          .get();

      expect(todos.length, equals(1));
      expect(todos.first.id, equals('todo_idx_1'));
      expect(todos.first.title, equals('Indexed Todo Task'));
    });

    test('NoteEntries supports insert and sorted querying with composite index (isPinned, updatedAt)', () async {
      final now = DateTime.now();
      final nowIso = now.toIso8601String();
      final earlierIso = now.subtract(const Duration(hours: 1)).toIso8601String();

      // Insert unpinned note
      await database.into(database.noteEntries).insert(
            NoteEntriesCompanion.insert(
              id: 'note_1',
              title: 'Standard Note',
              content: 'Unpinned content',
              category: 'General',
              isPinned: const Value(false),
              createdAt: earlierIso,
              updatedAt: earlierIso,
            ),
          );

      // Insert pinned note
      await database.into(database.noteEntries).insert(
            NoteEntriesCompanion.insert(
              id: 'note_2',
              title: 'Pinned Note',
              content: 'Pinned content',
              category: 'Work',
              isPinned: const Value(true),
              createdAt: nowIso,
              updatedAt: nowIso,
            ),
          );

      final notes = await (database.select(database.noteEntries)
            ..orderBy([
              (t) => OrderingTerm(expression: t.isPinned, mode: OrderingMode.desc),
              (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
            ]))
          .get();

      expect(notes.length, equals(2));
      // First item must be the pinned note thanks to index ordering
      expect(notes.first.id, equals('note_2'));
      expect(notes.first.isPinned, isTrue);
      expect(notes.last.id, equals('note_1'));
      expect(notes.last.isPinned, isFalse);
    });
  });
}
