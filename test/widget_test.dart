import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo/core/di/injection_container.dart';
import 'package:simple_todo/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await initDependencies();

    await tester.pumpWidget(const SimpleTodoApp());
    expect(find.byType(SimpleTodoApp), findsOneWidget);
  });
}
