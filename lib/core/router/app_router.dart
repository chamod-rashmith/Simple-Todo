import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../features/notes/domain/entities/note_entity.dart';
import '../../features/notes/presentation/pages/note_editor_page.dart';
import '../../features/notes/presentation/pages/notes_dashboard_page.dart';
import '../../features/todo/domain/entities/todo_item.dart';
import '../../features/todo/presentation/pages/todo_dashboard_page.dart';
import '../../features/todo/presentation/pages/todo_form_page.dart';
import 'main_shell_page.dart';

// 3 Navigator Keys: 1 Root Navigator (Full Screen) + 2 Shell Tab Navigators
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> tasksNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'tasksTab');
final GlobalKey<NavigatorState> notesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'notesTab');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Persistent 2-Tab Bottom Navigation Shell (Tasks & Notes)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellPage(navigationShell: navigationShell);
      },
      branches: [
        // Shell Branch 1: Tasks / Todos
        StatefulShellBranch(
          navigatorKey: tasksNavigatorKey,
          routes: [
            GoRoute(
              path: '/',
              name: 'dashboard',
              builder: (context, state) => const TodoDashboardPage(),
            ),
          ],
        ),

        // Shell Branch 2: Notes
        StatefulShellBranch(
          navigatorKey: notesNavigatorKey,
          routes: [
            GoRoute(
              path: '/notes',
              name: 'notes_dashboard',
              builder: (context, state) => const NotesDashboardPage(),
            ),
          ],
        ),
      ],
    ),

    // Full Screen Canvas / Modal Routes (Root Navigator - hides bottom navigation)
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/create',
      name: 'create_todo',
      builder: (context, state) => const TodoFormPage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/edit',
      name: 'edit_todo',
      builder: (context, state) {
        final todo = state.extra as TodoItemEntity?;
        return TodoFormPage(initialTodo: todo);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/notes/create',
      name: 'create_note',
      builder: (context, state) => const NoteEditorPage(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/notes/edit',
      name: 'edit_note',
      builder: (context, state) {
        final note = state.extra as NoteEntity?;
        return NoteEditorPage(initialNote: note);
      },
    ),
  ],
);
