import 'package:equatable/equatable.dart';

enum TodoPriority { low, medium, high }

class TodoItemEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isCompleted;
  final TodoPriority priority;
  final DateTime? dueDate;
  final DateTime createdAt;

  const TodoItemEntity({
    required this.id,
    required this.title,
    this.description = '',
    this.category = 'Personal',
    this.isCompleted = false,
    this.priority = TodoPriority.medium,
    this.dueDate,
    required this.createdAt,
  });

  TodoItemEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
    TodoPriority? priority,
    DateTime? dueDate,
    DateTime? createdAt,
  }) {
    return TodoItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        isCompleted,
        priority,
        dueDate,
        createdAt,
      ];
}
