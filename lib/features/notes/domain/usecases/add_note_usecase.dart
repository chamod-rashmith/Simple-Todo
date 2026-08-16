import '../../../../core/usecases/usecase.dart';
import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

class AddNoteUseCase implements UseCase<void, NoteEntity> {
  final NotesRepository repository;

  AddNoteUseCase(this.repository);

  @override
  Future<void> call(NoteEntity note) async {
    return await repository.addNote(note);
  }
}
