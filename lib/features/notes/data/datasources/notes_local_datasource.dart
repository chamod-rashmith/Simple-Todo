import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/note_model.dart';

abstract class NotesLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<void> addNote(NoteModel model);
  Future<void> updateNote(NoteModel model);
  Future<void> togglePinNote(String id);
  Future<void> deleteNote(String id);
}

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  final AppDatabase database;

  NotesLocalDataSourceImpl(this.database);

  @override
  Future<List<NoteModel>> getNotes() async {
    final rows = await (database.select(database.noteEntries)
          ..orderBy([
            (t) => OrderingTerm(expression: t.isPinned, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
          ]))
        .get();

    return rows.map((row) {
      return NoteModel(
        id: row.id,
        title: row.title,
        content: row.content,
        category: row.category,
        isPinned: row.isPinned,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
    }).toList();
  }

  @override
  Future<void> addNote(NoteModel model) async {
    await database.into(database.noteEntries).insertOnConflictUpdate(
          NoteEntriesCompanion.insert(
            id: model.id,
            title: model.title,
            content: model.content,
            category: model.category,
            isPinned: Value(model.isPinned),
            createdAt: model.createdAt,
            updatedAt: model.updatedAt,
          ),
        );
  }

  @override
  Future<void> updateNote(NoteModel model) async {
    await (database.update(database.noteEntries)
          ..where((t) => t.id.equals(model.id)))
        .write(
      NoteEntriesCompanion(
        title: Value(model.title),
        content: Value(model.content),
        category: Value(model.category),
        isPinned: Value(model.isPinned),
        updatedAt: Value(model.updatedAt),
      ),
    );
  }

  @override
  Future<void> togglePinNote(String id) async {
    final current = await (database.select(database.noteEntries)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    if (current != null) {
      await (database.update(database.noteEntries)
            ..where((t) => t.id.equals(id)))
          .write(
        NoteEntriesCompanion(
          isPinned: Value(!current.isPinned),
          updatedAt: Value(DateTime.now().toIso8601String()),
        ),
      );
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    await (database.delete(database.noteEntries)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}
