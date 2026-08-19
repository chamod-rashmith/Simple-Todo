// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoItemModel _$TodoItemModelFromJson(Map<String, dynamic> json) =>
    _TodoItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Personal',
      isCompleted: json['isCompleted'] as bool? ?? false,
      priority: json['priority'] as String? ?? 'medium',
      assignedDate: json['assignedDate'] as String?,
      dueDate: json['dueDate'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$TodoItemModelToJson(_TodoItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'isCompleted': instance.isCompleted,
      'priority': instance.priority,
      'assignedDate': instance.assignedDate,
      'dueDate': instance.dueDate,
      'createdAt': instance.createdAt,
    };
