import '../../domain/entities/note_entity.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final bool isPinned;
  final String createdAt;
  final String updatedAt;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: (json['content'] as String?) ?? '',
      category: (json['category'] as String?) ?? 'General',
      isPinned: (json['isPinned'] as bool?) ?? false,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'isPinned': isPinned,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
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
