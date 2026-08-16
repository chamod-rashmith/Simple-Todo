import '../../../../core/usecases/usecase.dart';
import '../repositories/notes_repository.dart';

class DeleteNoteUseCase implements UseCase<void, String> {
  final NotesRepository repository;

  DeleteNoteUseCase(this.repository);

  @override
  Future<void> call(String id) async {
    return await repository.deleteNote(id);
  }
}
