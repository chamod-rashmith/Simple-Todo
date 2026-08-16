import '../../domain/entities/todo_item.dart';

class TodoItemModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isCompleted;
  final String priority;
  final String? assignedDate;
  final String? dueDate;
  final String createdAt;

  const TodoItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isCompleted,
    required this.priority,
    this.assignedDate,
    this.dueDate,
    required this.createdAt,
  });

  factory TodoItemModel.fromJson(Map<String, dynamic> json) {
    return TodoItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      category: (json['category'] as String?) ?? 'Personal',
      isCompleted: (json['isCompleted'] as bool?) ?? false,
      priority: (json['priority'] as String?) ?? 'medium',
      assignedDate: json['assignedDate'] as String?,
      dueDate: json['dueDate'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'isCompleted': isCompleted,
      'priority': priority,
      'assignedDate': assignedDate,
      'dueDate': dueDate,
      'createdAt': createdAt,
    };
  }
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
