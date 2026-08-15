import 'package:get_it/get_it.dart';

import '../../../features/todo/data/datasources/todo_local_datasource.dart';
import '../../../features/todo/data/repositories/todo_repository_impl.dart';
import '../../../features/todo/domain/repositories/todo_repository.dart';
import '../../../features/todo/domain/usecases/add_todo_usecase.dart';
import '../../../features/todo/domain/usecases/delete_todo_usecase.dart';
import '../../../features/todo/domain/usecases/get_todos_usecase.dart';
import '../../../features/todo/domain/usecases/toggle_todo_usecase.dart';
import '../../../features/todo/domain/usecases/update_todo_usecase.dart';
import '../../../features/todo/presentation/bloc/todo_bloc.dart';
import '../../database/app_database.dart';

void initTodoModule(GetIt sl) {
  // Data Source
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(sl<AppDatabase>()),
  );

  // Repository
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(sl<TodoLocalDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<GetTodosUseCase>(
    () => GetTodosUseCase(sl<TodoRepository>()),
  );
  sl.registerLazySingleton<AddTodoUseCase>(
    () => AddTodoUseCase(sl<TodoRepository>()),
  );
  sl.registerLazySingleton<UpdateTodoUseCase>(
    () => UpdateTodoUseCase(sl<TodoRepository>()),
  );
  sl.registerLazySingleton<ToggleTodoUseCase>(
    () => ToggleTodoUseCase(sl<TodoRepository>()),
  );
  sl.registerLazySingleton<DeleteTodoUseCase>(
    () => DeleteTodoUseCase(sl<TodoRepository>()),
  );

  // BLoC Factory
  sl.registerFactory<TodoBloc>(
    () => TodoBloc(
      getTodosUseCase: sl(),
      addTodoUseCase: sl(),
      updateTodoUseCase: sl(),
      toggleTodoUseCase: sl(),
      deleteTodoUseCase: sl(),
      notificationService: sl(),
    ),
  );
}
