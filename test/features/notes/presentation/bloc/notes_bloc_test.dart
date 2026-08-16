import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/features/notes/domain/entities/note_entity.dart';
import 'package:simple_todo/features/notes/domain/repositories/notes_repository.dart';
import 'package:simple_todo/features/notes/domain/usecases/add_note_usecase.dart';
import 'package:simple_todo/features/notes/domain/usecases/delete_note_usecase.dart';
import 'package:simple_todo/features/notes/domain/usecases/get_notes_usecase.dart';
import 'package:simple_todo/features/notes/domain/usecases/toggle_pin_note_usecase.dart';
import 'package:simple_todo/features/notes/domain/usecases/update_note_usecase.dart';
import 'package:simple_todo/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:simple_todo/features/notes/presentation/bloc/notes_event.dart';
import 'package:simple_todo/features/notes/presentation/bloc/notes_state.dart';

class MockNotesRepository implements NotesRepository {
  List<NoteEntity> notes = [];

  @override
  Future<List<NoteEntity>> getNotes() async => List.from(notes);

  @override
  Future<void> addNote(NoteEntity note) async => notes.add(note);

  @override
  Future<void> updateNote(NoteEntity note) async {
    final idx = notes.indexWhere((n) => n.id == note.id);
    if (idx != -1) notes[idx] = note;
  }

  @override
  Future<void> deleteNote(String id) async =>
      notes.removeWhere((n) => n.id == id);

  @override
  Future<void> togglePinNote(String id) async {
    final idx = notes.indexWhere((n) => n.id == id);
    if (idx != -1) {
      notes[idx] = notes[idx].copyWith(isPinned: !notes[idx].isPinned);
    }
  }
}

void main() {
  late MockNotesRepository mockRepository;
  late NotesBloc bloc;

  final note1 = NoteEntity(
    id: '1',
    title: 'Flutter Clean Architecture',
    content: 'Domain, Data, Presentation layers with GetIt and Drift',
    category: 'Work',
    isPinned: true,
    createdAt: DateTime(2026, 8, 16),
    updatedAt: DateTime(2026, 8, 16),
  );

  final note2 = NoteEntity(
    id: '2',
    title: 'Grocery List',
    content: '- [ ] Milk\n- [x] Eggs\n- [ ] Coffee',
    category: 'Personal',
    isPinned: false,
    createdAt: DateTime(2026, 8, 15),
    updatedAt: DateTime(2026, 8, 15),
  );

  setUp(() {
    mockRepository = MockNotesRepository();
    bloc = NotesBloc(
      getNotesUseCase: GetNotesUseCase(mockRepository),
      addNoteUseCase: AddNoteUseCase(mockRepository),
      updateNoteUseCase: UpdateNoteUseCase(mockRepository),
      deleteNoteUseCase: DeleteNoteUseCase(mockRepository),
      togglePinNoteUseCase: TogglePinNoteUseCase(mockRepository),
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('NotesBloc Tests', () {
    test('initial state should be NotesState.initial', () {
      expect(bloc.state.status, NotesStatus.initial);
      expect(bloc.state.allNotes, isEmpty);
      expect(bloc.state.selectedCategory, 'All');
    });

    test('LoadNotesEvent emits success status and calculates pinned/unpinned correctly', () async {
      mockRepository.notes = [note1, note2];

      bloc.add(LoadNotesEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const NotesState(status: NotesStatus.loading),
          NotesState(
            status: NotesStatus.success,
            allNotes: [note1, note2],
            filteredNotes: [note1, note2],
          ),
        ]),
      );

      expect(bloc.state.pinnedNotes.length, 1);
      expect(bloc.state.pinnedNotes.first.id, '1');
      expect(bloc.state.unpinnedNotes.length, 1);
      expect(bloc.state.unpinnedNotes.first.id, '2');
      expect(bloc.state.totalCount, 2);
      expect(bloc.state.pinnedCount, 1);
    });

    test('SearchNotesEvent filters notes by query across title, content, or category', () async {
      mockRepository.notes = [note1, note2];
      bloc.add(LoadNotesEvent());
      await bloc.stream.firstWhere((s) => s.status == NotesStatus.success);

      bloc.add(const SearchNotesEvent('coffee'));

      await expectLater(
        bloc.stream,
        emits(predicate<NotesState>((state) {
          return state.searchQuery == 'coffee' &&
              state.filteredNotes.length == 1 &&
              state.filteredNotes.first.id == '2';
        })),
      );
    });

    test('SelectNoteCategoryEvent filters notes by category', () async {
      mockRepository.notes = [note1, note2];
      bloc.add(LoadNotesEvent());
      await bloc.stream.firstWhere((s) => s.status == NotesStatus.success);

      bloc.add(const SelectNoteCategoryEvent('Work'));

      await expectLater(
        bloc.stream,
        emits(predicate<NotesState>((state) {
          return state.selectedCategory == 'Work' &&
              state.filteredNotes.length == 1 &&
              state.filteredNotes.first.id == '1';
        })),
      );
    });
  });
}
