import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/todo/presentation/bloc/todo_bloc.dart';
import 'features/todo/presentation/bloc/todo_event.dart';
import 'features/todo/presentation/pages/todo_dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const SimpleTodoApp());
}

class SimpleTodoApp extends StatelessWidget {
  const SimpleTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Todo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BlocProvider<TodoBloc>(
        create: (context) => sl<TodoBloc>()..add(LoadTodosEvent()),
        child: const TodoDashboardPage(),
      ),
    );
  }
}
