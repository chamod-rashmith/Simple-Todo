import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/get_notes_usecase.dart';
import '../../domain/usecases/toggle_pin_note_usecase.dart';
import '../../domain/usecases/update_note_usecase.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetNotesUseCase getNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final TogglePinNoteUseCase togglePinNoteUseCase;

  NotesBloc({
    required this.getNotesUseCase,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
    required this.togglePinNoteUseCase,
  }) : super(const NotesState()) {
    on<LoadNotesEvent>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<TogglePinNoteEvent>(_onTogglePinNote);
    on<SearchNotesEvent>(_onSearchNotes);
    on<SelectNoteCategoryEvent>(_onSelectCategory);
  }

  Future<void> _onLoadNotes(
    LoadNotesEvent event,
    Emitter<NotesState> emit,
  ) async {
    emit(state.copyWith(status: NotesStatus.loading));
    try {
      final notes = await getNotesUseCase(NoParams());
      final filtered = _applyFilter(notes, state.selectedCategory, state.searchQuery);
      emit(state.copyWith(
        status: NotesStatus.success,
        allNotes: notes,
        filteredNotes: filtered,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.failure,
        errorMessage: 'Failed to load notes',
      ));
    }
  }

  Future<void> _onAddNote(
    AddNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await addNoteUseCase(event.note);
      final notes = await getNotesUseCase(NoParams());
      final filtered = _applyFilter(notes, state.selectedCategory, state.searchQuery);
      emit(state.copyWith(
        status: NotesStatus.success,
        allNotes: notes,
        filteredNotes: filtered,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.failure,
        errorMessage: 'Failed to add note',
      ));
    }
  }

  Future<void> _onUpdateNote(
    UpdateNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await updateNoteUseCase(event.note);
      final notes = await getNotesUseCase(NoParams());
      final filtered = _applyFilter(notes, state.selectedCategory, state.searchQuery);
      emit(state.copyWith(
        status: NotesStatus.success,
        allNotes: notes,
        filteredNotes: filtered,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.failure,
        errorMessage: 'Failed to update note',
      ));
    }
  }

  Future<void> _onDeleteNote(
    DeleteNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await deleteNoteUseCase(event.id);
      final notes = await getNotesUseCase(NoParams());
      final filtered = _applyFilter(notes, state.selectedCategory, state.searchQuery);
      emit(state.copyWith(
        status: NotesStatus.success,
        allNotes: notes,
        filteredNotes: filtered,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.failure,
        errorMessage: 'Failed to delete note',
      ));
    }
  }

  Future<void> _onTogglePinNote(
    TogglePinNoteEvent event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await togglePinNoteUseCase(event.id);
      final notes = await getNotesUseCase(NoParams());
      final filtered = _applyFilter(notes, state.selectedCategory, state.searchQuery);
      emit(state.copyWith(
        status: NotesStatus.success,
        allNotes: notes,
        filteredNotes: filtered,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotesStatus.failure,
        errorMessage: 'Failed to toggle pin',
      ));
    }
  }

  void _onSearchNotes(
    SearchNotesEvent event,
    Emitter<NotesState> emit,
  ) {
    final filtered = _applyFilter(state.allNotes, state.selectedCategory, event.query);
    emit(state.copyWith(
      searchQuery: event.query,
      filteredNotes: filtered,
    ));
  }

  void _onSelectCategory(
    SelectNoteCategoryEvent event,
    Emitter<NotesState> emit,
  ) {
    final filtered = _applyFilter(state.allNotes, event.category, state.searchQuery);
    emit(state.copyWith(
      selectedCategory: event.category,
      filteredNotes: filtered,
    ));
  }

  List<NoteEntity> _applyFilter(
    List<NoteEntity> notes,
    String category,
    String query,
  ) {
    var result = List<NoteEntity>.from(notes);

    if (category != 'All') {
      result = result.where((n) => n.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((n) {
        final matchTitle = n.title.toLowerCase().contains(q);
        final matchContent = n.content.toLowerCase().contains(q);
        final matchCategory = n.category.toLowerCase().contains(q);
        return matchTitle || matchContent || matchCategory;
      }).toList();
    }

    return result;
  }
}
