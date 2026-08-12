import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/todo_item.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/toggle_todo_usecase.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final ToggleTodoUseCase toggleTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  TodoBloc({
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.toggleTodoUseCase,
    required this.deleteTodoUseCase,
  }) : super(const TodoState()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<FilterTodosEvent>(_onFilterTodos);
    on<SelectCategoryEvent>(_onSelectCategory);
    on<SearchQueryEvent>(_onSearchQuery);
  }

  Future<void> _onLoadTodos(LoadTodosEvent event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      final todos = await getTodosUseCase(NoParams());
      final filtered = _applyFilters(todos, state.activeFilter, state.selectedCategory, state.searchQuery);
      emit(state.copyWith(
        status: TodoStatus.loaded,
        todos: todos,
        filteredTodos: filtered,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TodoStatus.error,
        errorMessage: 'Failed to load todos',
      ));
    }
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await addTodoUseCase(event.todo);
      add(LoadTodosEvent());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to add todo'));
    }
  }

  Future<void> _onToggleTodo(ToggleTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await toggleTodoUseCase(event.id);
      add(LoadTodosEvent());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update todo'));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      await deleteTodoUseCase(event.id);
      add(LoadTodosEvent());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to delete todo'));
    }
  }

  void _onFilterTodos(FilterTodosEvent event, Emitter<TodoState> emit) {
    final filtered = _applyFilters(state.todos, event.filter, state.selectedCategory, state.searchQuery);
    emit(state.copyWith(
      activeFilter: event.filter,
      filteredTodos: filtered,
    ));
  }

  void _onSelectCategory(SelectCategoryEvent event, Emitter<TodoState> emit) {
    final filtered = _applyFilters(state.todos, state.activeFilter, event.category, state.searchQuery);
    emit(state.copyWith(
      selectedCategory: event.category,
      filteredTodos: filtered,
    ));
  }

  void _onSearchQuery(SearchQueryEvent event, Emitter<TodoState> emit) {
    final filtered = _applyFilters(state.todos, state.activeFilter, state.selectedCategory, event.query);
    emit(state.copyWith(
      searchQuery: event.query,
      filteredTodos: filtered,
    ));
  }

  List<TodoItemEntity> _applyFilters(
    List<TodoItemEntity> todos,
    String filter,
    String category,
    String query,
  ) {
    return todos.where((item) {
      // Filter status
      if (filter == 'active' && item.isCompleted) return false;
      if (filter == 'completed' && !item.isCompleted) return false;

      // Filter category
      if (category != 'All' && item.category.toLowerCase() != category.toLowerCase()) {
        return false;
      }

      // Filter search
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(q);
        final matchDesc = item.description.toLowerCase().contains(q);
        if (!matchTitle && !matchDesc) return false;
      }

      return true;
    }).toList();
  }
}
