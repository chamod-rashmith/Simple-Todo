import 'package:equatable/equatable.dart';
import '../../domain/entities/todo_item.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final TodoItemEntity todo;
  const AddTodoEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}

class ToggleTodoEvent extends TodoEvent {
  final String id;
  const ToggleTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteTodoEvent extends TodoEvent {
  final String id;
  const DeleteTodoEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterTodosEvent extends TodoEvent {
  final String filter; // 'all', 'active', 'completed'
  const FilterTodosEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SelectCategoryEvent extends TodoEvent {
  final String category; // 'All' or specific category
  const SelectCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchQueryEvent extends TodoEvent {
  final String query;
  const SearchQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}
