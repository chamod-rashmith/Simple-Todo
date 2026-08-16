import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_datasource.dart';
import '../models/note_model.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource localDataSource;

  NotesRepositoryImpl(this.localDataSource);

  @override
  Future<List<NoteEntity>> getNotes() async {
    final models = await localDataSource.getNotes();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addNote(NoteEntity note) async {
    final model = NoteModelX.fromEntity(note);
    await localDataSource.addNote(model);
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    final model = NoteModelX.fromEntity(note);
    await localDataSource.updateNote(model);
  }

  @override
  Future<void> togglePinNote(String id) async {
    await localDataSource.togglePinNote(id);
  }

  @override
  Future<void> deleteNote(String id) async {
    await localDataSource.deleteNote(id);
  }
}
