import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modules/todo_module.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Feature Modules
  initTodoModule(sl);
}
