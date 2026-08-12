import 'package:equatable/equatable.dart';
import '../../domain/entities/todo_item.dart';

enum TodoStatus { initial, loading, loaded, error }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<TodoItemEntity> todos;
  final List<TodoItemEntity> filteredTodos;
  final String activeFilter; // 'all', 'active', 'completed'
  final String selectedCategory; // 'All', 'Personal', 'Work', 'Design', etc.
  final String searchQuery;
  final String? errorMessage;

  const TodoState({
    this.status = TodoStatus.initial,
    this.todos = const [],
    this.filteredTodos = const [],
    this.activeFilter = 'all',
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.errorMessage,
  });

  int get totalCount => todos.length;
  int get completedCount => todos.where((t) => t.isCompleted).length;
  double get completionRatio => totalCount == 0 ? 0.0 : completedCount / totalCount;

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
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      filteredTodos: filteredTodos ?? this.filteredTodos,
      activeFilter: activeFilter ?? this.activeFilter,
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
        selectedCategory,
        searchQuery,
        errorMessage,
      ];
}
