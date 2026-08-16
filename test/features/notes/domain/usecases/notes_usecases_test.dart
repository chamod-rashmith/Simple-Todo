import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/core/usecases/usecase.dart';
import 'package:simple_todo/features/notes/domain/entities/note_entity.dart';
import 'package:simple_todo/features/notes/domain/repositories/notes_repository.dart';
import 'package:simple_todo/features/notes/domain/usecases/add_note_usecase.dart';
import 'package:simple_todo/features/notes/domain/usecases/delete_note_usecase.dart';
import 'package:simple_todo/features/notes/domain/usecases/get_notes_usecase.dart';
import 'package:simple_todo/features/notes/domain/usecases/toggle_pin_note_usecase.dart';
import 'package:simple_todo/features/notes/domain/usecases/update_note_usecase.dart';

class FakeNotesRepository implements NotesRepository {
  final List<NoteEntity> _notes = [];

  @override
  Future<List<NoteEntity>> getNotes() async {
    return List.from(_notes);
  }

  @override
  Future<void> addNote(NoteEntity note) async {
    _notes.add(note);
  }

  @override
  Future<void> updateNote(NoteEntity note) async {
    final idx = _notes.indexWhere((n) => n.id == note.id);
    if (idx != -1) {
      _notes[idx] = note;
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    _notes.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> togglePinNote(String id) async {
    final idx = _notes.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notes[idx] = _notes[idx].copyWith(isPinned: !_notes[idx].isPinned);
    }
  }
}

void main() {
  late FakeNotesRepository repository;
  late GetNotesUseCase getNotesUseCase;
  late AddNoteUseCase addNoteUseCase;
  late UpdateNoteUseCase updateNoteUseCase;
  late DeleteNoteUseCase deleteNoteUseCase;
  late TogglePinNoteUseCase togglePinNoteUseCase;

  final testNote = NoteEntity(
    id: 'note_100',
    title: 'Design System Notes',
    content: 'Obsidian Minimalist theme',
    category: 'Design',
    isPinned: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  setUp(() {
    repository = FakeNotesRepository();
    getNotesUseCase = GetNotesUseCase(repository);
    addNoteUseCase = AddNoteUseCase(repository);
    updateNoteUseCase = UpdateNoteUseCase(repository);
    deleteNoteUseCase = DeleteNoteUseCase(repository);
    togglePinNoteUseCase = TogglePinNoteUseCase(repository);
  });

  group('Notes Use Cases Tests', () {
    test('AddNoteUseCase and GetNotesUseCase work correctly', () async {
      await addNoteUseCase(testNote);
      final notes = await getNotesUseCase(NoParams());

      expect(notes.length, 1);
      expect(notes.first.id, 'note_100');
      expect(notes.first.title, 'Design System Notes');
    });

    test('UpdateNoteUseCase modifies existing note in repository', () async {
      await addNoteUseCase(testNote);
      final updated = testNote.copyWith(title: 'Updated Design System');

      await updateNoteUseCase(updated);
      final notes = await getNotesUseCase(NoParams());

      expect(notes.first.title, 'Updated Design System');
    });

    test('TogglePinNoteUseCase toggles pin status', () async {
      await addNoteUseCase(testNote);
      await togglePinNoteUseCase('note_100');
      var notes = await getNotesUseCase(NoParams());
      expect(notes.first.isPinned, true);

      await togglePinNoteUseCase('note_100');
      notes = await getNotesUseCase(NoParams());
      expect(notes.first.isPinned, false);
    });

    test('DeleteNoteUseCase removes note from repository', () async {
      await addNoteUseCase(testNote);
      await deleteNoteUseCase('note_100');
      final notes = await getNotesUseCase(NoParams());
      expect(notes.isEmpty, true);
    });
  });
}
