import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/todo_item.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/toggle_todo_usecase.dart';
import '../../domain/usecases/update_todo_usecase.dart';
import 'todo_event.dart';
import 'todo_state.dart';

/// ============================================================================
/// TodoBloc
/// ============================================================================
///
/// **Clean Architecture Presentation State Management (BLoC):**
/// Manages state for todo lists, filtering, searching, task additions, updates, status
/// toggles, deletions, and automated local notification reminders.
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final ToggleTodoUseCase toggleTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;
  final NotificationService notificationService;

  TodoBloc({
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.updateTodoUseCase,
    required this.toggleTodoUseCase,
    required this.deleteTodoUseCase,
    required this.notificationService,
  }) : super(const TodoState()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
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
      // 1. Save task to persistent storage via domain use case
      await addTodoUseCase(event.todo);

      // 2. Schedule local reminder if task has a future deadline
      await notificationService.scheduleTodoReminder(event.todo);

      // 3. Reload list to update presentation state
      add(LoadTodosEvent());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to add todo'));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    try {
      // 1. Update task in storage
      await updateTodoUseCase(event.todo);

      // 2. Reschedule notification reminder if applicable
      if (!event.todo.isCompleted) {
        await notificationService.scheduleTodoReminder(event.todo);
      } else {
        await notificationService.cancelTodoReminder(event.todo.id);
      }

      // 3. Reload list
      add(LoadTodosEvent());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update todo'));
    }
  }

  Future<void> _onToggleTodo(ToggleTodoEvent event, Emitter<TodoState> emit) async {
    try {
      // Find matching item in current state to determine if it is being completed or reopened
      final existingIndex = state.todos.indexWhere((t) => t.id == event.id);
      if (existingIndex != -1) {
        final currentTodo = state.todos[existingIndex];
        if (!currentTodo.isCompleted) {
          // Task is about to be marked as completed -> cancel pending reminder
          await notificationService.cancelTodoReminder(event.id);
        } else {
          // Task is being unmarked/reopened -> reschedule reminder if applicable
          await notificationService.scheduleTodoReminder(currentTodo);
        }
      }

      await toggleTodoUseCase(event.id);
      add(LoadTodosEvent());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update todo'));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    try {
      // Cancel any scheduled system notification for the deleted task
      await notificationService.cancelTodoReminder(event.id);

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
