import 'package:get_it/get_it.dart';
import '../../../features/notes/data/datasources/notes_local_datasource.dart';
import '../../../features/notes/data/repositories/notes_repository_impl.dart';
import '../../../features/notes/domain/repositories/notes_repository.dart';
import '../../../features/notes/domain/usecases/add_note_usecase.dart';
import '../../../features/notes/domain/usecases/delete_note_usecase.dart';
import '../../../features/notes/domain/usecases/get_notes_usecase.dart';
import '../../../features/notes/domain/usecases/toggle_pin_note_usecase.dart';
import '../../../features/notes/domain/usecases/update_note_usecase.dart';
import '../../../features/notes/presentation/bloc/notes_bloc.dart';
import '../../database/app_database.dart';

void initNotesModule(GetIt sl) {
  // 1. Data Source
  sl.registerLazySingleton<NotesLocalDataSource>(
    () => NotesLocalDataSourceImpl(sl<AppDatabase>()),
  );

  // 2. Repository
  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(sl<NotesLocalDataSource>()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<GetNotesUseCase>(
    () => GetNotesUseCase(sl<NotesRepository>()),
  );
  sl.registerLazySingleton<AddNoteUseCase>(
    () => AddNoteUseCase(sl<NotesRepository>()),
  );
  sl.registerLazySingleton<UpdateNoteUseCase>(
    () => UpdateNoteUseCase(sl<NotesRepository>()),
  );
  sl.registerLazySingleton<DeleteNoteUseCase>(
    () => DeleteNoteUseCase(sl<NotesRepository>()),
  );
  sl.registerLazySingleton<TogglePinNoteUseCase>(
    () => TogglePinNoteUseCase(sl<NotesRepository>()),
  );

  // 4. BLoC Factory
  sl.registerFactory<NotesBloc>(
    () => NotesBloc(
      getNotesUseCase: sl(),
      addNoteUseCase: sl(),
      updateNoteUseCase: sl(),
      deleteNoteUseCase: sl(),
      togglePinNoteUseCase: sl(),
    ),
  );
}
