import 'package:equatable/equatable.dart';
import '../../domain/entities/todo_item.dart';

enum TodoStatus { initial, loading, loaded, error }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<TodoItemEntity> todos;
  final List<TodoItemEntity> filteredTodos;
  final String activeFilter; // 'all', 'active', 'completed'
  final String dateFilter; // 'all', 'today', 'upcoming', 'overdue'
  final String selectedCategory; // 'All', 'Personal', 'Work', 'Design', etc.
  final String searchQuery;
  final String? errorMessage;

  const TodoState({
    this.status = TodoStatus.initial,
    this.todos = const [],
    this.filteredTodos = const [],
    this.activeFilter = 'all',
    this.dateFilter = 'all',
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.errorMessage,
  });

  // --- Total (All time) stats ---
  int get totalCount => todos.length;
  int get completedCount => todos.where((t) => t.isCompleted).length;
  double get completionRatio => totalCount == 0 ? 0.0 : completedCount / totalCount;

  // --- Daily Progress (Today's tasks) stats ---
  List<TodoItemEntity> get todayTodos =>
      todos.where((t) => t.isAssignedToday || t.isDueToday).toList();
  int get todayTotalCount => todayTodos.length;
  int get todayCompletedCount => todayTodos.where((t) => t.isCompleted).length;
  double get todayCompletionRatio =>
      todayTotalCount == 0 ? 0.0 : todayCompletedCount / todayTotalCount;

  List<String> get availableCategories {
    final set = {'All', 'Personal', 'Work', 'Design', 'Health'};
    for (final t in todos) {
      if (t.category.isNotEmpty) set.add(t.category);
    }
    return set.toList();
  }

  TodoState copyWith({
    TodoStatus? status,
    List<TodoItemEntity>? todos,
    List<TodoItemEntity>? filteredTodos,
    String? activeFilter,
    String? dateFilter,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      filteredTodos: filteredTodos ?? this.filteredTodos,
      activeFilter: activeFilter ?? this.activeFilter,
      dateFilter: dateFilter ?? this.dateFilter,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
        filteredTodos,
        activeFilter,
        dateFilter,
        selectedCategory,
        searchQuery,
        errorMessage,
      ];
}
