import 'package:equatable/equatable.dart';
import '../../domain/entities/note_entity.dart';

enum NotesStatus { initial, loading, success, failure }

class NotesState extends Equatable {
  final NotesStatus status;
  final List<NoteEntity> allNotes;
  final List<NoteEntity> filteredNotes;
  final String selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  const NotesState({
    this.status = NotesStatus.initial,
    this.allNotes = const [],
    this.filteredNotes = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.errorMessage,
  });

  List<NoteEntity> get pinnedNotes =>
      filteredNotes.where((note) => note.isPinned).toList();

  List<NoteEntity> get unpinnedNotes =>
      filteredNotes.where((note) => !note.isPinned).toList();

  int get totalCount => allNotes.length;
  int get pinnedCount => allNotes.where((n) => n.isPinned).length;

  List<String> get availableCategories {
    final categories = {'All', 'General', 'Personal', 'Work', 'Ideas', 'Urgent'};
    for (final note in allNotes) {
      if (note.category.trim().isNotEmpty) {
        categories.add(note.category.trim());
      }
    }
    return categories.toList();
  }

  NotesState copyWith({
    NotesStatus? status,
    List<NoteEntity>? allNotes,
    List<NoteEntity>? filteredNotes,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return NotesState(
      status: status ?? this.status,
      allNotes: allNotes ?? this.allNotes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allNotes,
        filteredNotes,
        selectedCategory,
        searchQuery,
        errorMessage,
      ];
}
