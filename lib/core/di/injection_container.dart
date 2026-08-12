import 'package:get_it/get_it.dart';
import '../database/app_database.dart';
import 'modules/todo_module.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // External / Database
  final appDatabase = AppDatabase();
  sl.registerLazySingleton<AppDatabase>(() => appDatabase);

  // Feature Modules
  initTodoModule(sl);
}
