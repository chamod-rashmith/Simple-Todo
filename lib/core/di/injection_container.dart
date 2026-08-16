import 'package:get_it/get_it.dart';
import '../database/app_database.dart';
import 'modules/notes_module.dart';
import 'modules/notification_module.dart';
import 'modules/security_module.dart';
import 'modules/todo_module.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // External / Database
  final appDatabase = AppDatabase();
  sl.registerLazySingleton<AppDatabase>(() => appDatabase);

  // Core Modules
  initSecurityModule(sl);
  await initNotificationModule(sl);

  // Feature Modules
  initTodoModule(sl);
  initNotesModule(sl);
}
