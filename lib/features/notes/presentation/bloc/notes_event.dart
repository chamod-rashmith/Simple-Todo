import 'package:equatable/equatable.dart';
import '../../domain/entities/note_entity.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotesEvent extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final NoteEntity note;

  const AddNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class UpdateNoteEvent extends NotesEvent {
  final NoteEntity note;

  const UpdateNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteNoteEvent extends NotesEvent {
  final String id;

  const DeleteNoteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class TogglePinNoteEvent extends NotesEvent {
  final String id;

  const TogglePinNoteEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchNotesEvent extends NotesEvent {
  final String query;

  const SearchNotesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SelectNoteCategoryEvent extends NotesEvent {
  final String category;

  const SelectNoteCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}
