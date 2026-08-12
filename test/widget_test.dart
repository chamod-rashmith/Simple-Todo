import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/core/database/app_database.dart';
import 'package:simple_todo/core/di/injection_container.dart';
import 'package:simple_todo/core/di/modules/todo_module.dart';
import 'package:simple_todo/main.dart';

void main() {
  setUp(() async {
    await sl.reset();
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    sl.registerLazySingleton<AppDatabase>(() => db);
    initTodoModule(sl);
  });

  tearDown(() async {
    await sl<AppDatabase>().close();
    await sl.reset();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SimpleTodoApp());
    expect(find.byType(SimpleTodoApp), findsOneWidget);
  });
}
