import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/todo_item.dart';

part 'todo_item_model.freezed.dart';
part 'todo_item_model.g.dart';

@freezed
abstract class TodoItemModel with _$TodoItemModel {
  const factory TodoItemModel({
    required String id,
    required String title,
    @Default('') String description,
    @Default('Personal') String category,
    @Default(false) bool isCompleted,
    @Default('medium') String priority,
    String? assignedDate,
    String? dueDate,
    required String createdAt,
  }) = _TodoItemModel;

  factory TodoItemModel.fromJson(Map<String, dynamic> json) =>
      _$TodoItemModelFromJson(json);
}

/// Extension Mappers to convert between Data Model and Domain Entity
extension TodoItemModelX on TodoItemModel {
  static TodoItemModel fromEntity(TodoItemEntity entity) {
    return TodoItemModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      isCompleted: entity.isCompleted,
      priority: entity.priority.name,
      assignedDate: entity.assignedDate?.toIso8601String(),
      dueDate: entity.dueDate?.toIso8601String(),
      createdAt: entity.createdAt.toIso8601String(),
    );
  }

  TodoItemEntity toEntity() {
    return TodoItemEntity(
      id: id,
      title: title,
      description: description,
      category: category,
      isCompleted: isCompleted,
      priority: TodoPriority.values.firstWhere(
        (p) => p.name == priority,
        orElse: () => TodoPriority.medium,
      ),
      assignedDate: assignedDate != null ? DateTime.tryParse(assignedDate!) : null,
      dueDate: dueDate != null ? DateTime.tryParse(dueDate!) : null,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }
}
