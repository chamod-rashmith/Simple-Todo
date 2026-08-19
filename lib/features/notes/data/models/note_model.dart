import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/note_entity.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
abstract class NoteModel with _$NoteModel {
  const factory NoteModel({
    required String id,
    required String title,
    @Default('') String content,
    @Default('General') String category,
    @Default(false) bool isPinned,
    required String createdAt,
    required String updatedAt,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}

/// Extension Mappers to convert between Data Model and Domain Entity
extension NoteModelX on NoteModel {
  static NoteModel fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      category: entity.category,
      isPinned: entity.isPinned,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      content: content,
      category: category,
      isPinned: isPinned,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }
}
