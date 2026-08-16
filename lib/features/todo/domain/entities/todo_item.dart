import 'package:equatable/equatable.dart';

enum TodoPriority { low, medium, high }

class TodoItemEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isCompleted;
  final TodoPriority priority;
  final DateTime? assignedDate;
  final DateTime? dueDate;
  final DateTime createdAt;

  const TodoItemEntity({
    required this.id,
    required this.title,
    this.description = '',
    this.category = 'Personal',
    this.isCompleted = false,
    this.priority = TodoPriority.medium,
    this.assignedDate,
    this.dueDate,
    required this.createdAt,
  });

  /// The effective day this task is planned for (assignedDate fallback to createdAt)
  DateTime get effectiveAssignedDate => assignedDate ?? createdAt;

  /// Checks if two DateTimes fall on the exact same calendar day
  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Whether this task is assigned to or planned for today
  bool get isAssignedToday {
    final now = DateTime.now();
    return _isSameDay(effectiveAssignedDate, now);
  }

  /// Whether this task has a deadline today
  bool get isDueToday {
    if (dueDate == null) return false;
    return _isSameDay(dueDate!, DateTime.now());
  }

  /// Whether this task is past its deadline and still incomplete
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  TodoItemEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
    TodoPriority? priority,
    DateTime? assignedDate,
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
      assignedDate: assignedDate ?? this.assignedDate,
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
        assignedDate,
        dueDate,
        createdAt,
      ];
}

