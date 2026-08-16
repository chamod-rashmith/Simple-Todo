import '../../../../core/usecases/usecase.dart';
import '../repositories/notes_repository.dart';

class TogglePinNoteUseCase implements UseCase<void, String> {
  final NotesRepository repository;

  TogglePinNoteUseCase(this.repository);

  @override
  Future<void> call(String id) async {
    return await repository.togglePinNote(id);
  }
}
