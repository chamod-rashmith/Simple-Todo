// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => _NoteModel(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String? ?? '',
  category: json['category'] as String? ?? 'General',
  isPinned: json['isPinned'] as bool? ?? false,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$NoteModelToJson(_NoteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'isPinned': instance.isPinned,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
