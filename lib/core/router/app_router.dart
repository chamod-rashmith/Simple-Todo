import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../features/todo/domain/entities/todo_item.dart';
import '../../features/todo/presentation/pages/todo_dashboard_page.dart';
import '../../features/todo/presentation/pages/todo_form_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const TodoDashboardPage(),
    ),
    GoRoute(
      path: '/create',
      name: 'create_todo',
      builder: (context, state) => const TodoFormPage(),
    ),
    GoRoute(
      path: '/edit',
      name: 'edit_todo',
      builder: (context, state) {
        final todo = state.extra as TodoItemEntity?;
        return TodoFormPage(initialTodo: todo);
      },
    ),
  ],
);
