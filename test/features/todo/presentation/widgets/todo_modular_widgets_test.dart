import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/core/theme/app_theme.dart';
import 'package:simple_todo/features/todo/domain/entities/todo_item.dart';
import 'package:simple_todo/features/todo/presentation/widgets/form/category_picker_chips_widget.dart';
import 'package:simple_todo/features/todo/presentation/widgets/form/priority_picker_segmented_widget.dart';
import 'package:simple_todo/features/todo/presentation/widgets/todo_category_selector_widget.dart';
import 'package:simple_todo/features/todo/presentation/widgets/todo_empty_state_widget.dart';
import 'package:simple_todo/features/todo/presentation/widgets/todo_filter_bar_widget.dart';
import 'package:simple_todo/features/todo/presentation/widgets/todo_header_widget.dart';
import 'package:simple_todo/features/todo/presentation/widgets/todo_item_tile_widget.dart';
import 'package:simple_todo/features/todo/presentation/widgets/todo_stats_banner_widget.dart';

void main() {
  group('Todo Modular Presentation Widgets Tests', () {
    testWidgets('TodoHeaderWidget displays active pending task count and title', (tester) async {
      String? searchQuery;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: TodoHeaderWidget(
              activeTaskCount: 5,
              onSearchChanged: (query) => searchQuery = query,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('5 pending'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Groceries');
      await tester.pumpAndSettle();
      expect(searchQuery, equals('Groceries'));
    });

    testWidgets('TodoStatsBannerWidget renders progress ratio and percentage', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: TodoStatsBannerWidget(
              completedCount: 3,
              totalCount: 5,
              ratio: 0.6,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('60%'), findsOneWidget);
      expect(find.text('3 of 5 tasks completed'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('TodoCategorySelectorWidget toggles selected category', (tester) async {
      String selected = 'All';
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: TodoCategorySelectorWidget(
                  categories: const ['All', 'Work', 'Personal'],
                  selectedCategory: selected,
                  onSelectCategory: (cat) => setState(() => selected = cat),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Work'), findsOneWidget);
      await tester.tap(find.text('Work'));
      await tester.pumpAndSettle();
      expect(selected, equals('Work'));
    });

    testWidgets('TodoFilterBarWidget triggers onFilterChanged on tab tap', (tester) async {
      String activeFilter = 'all';
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: TodoFilterBarWidget(
                  activeFilter: activeFilter,
                  onFilterChanged: (f) => setState(() => activeFilter = f),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle();
      expect(activeFilter, equals('active'));

      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();
      expect(activeFilter, equals('completed'));
    });

    testWidgets('TodoItemTileWidget displays details, priority, and responds to toggle tap', (tester) async {
      bool toggled = false;

      final testTodo = TodoItemEntity(
        id: '1',
        title: 'Review PR',
        description: 'Check clean architecture code',
        category: 'Work',
        priority: TodoPriority.high,
        dueDate: DateTime.now().add(const Duration(hours: 3)),
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: TodoItemTileWidget(
              todo: testTodo,
              onToggle: () => toggled = true,
              onDelete: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Review PR'), findsOneWidget);
      expect(find.text('Check clean architecture code'), findsOneWidget);
      expect(find.text('Work'), findsOneWidget);
      expect(find.text('HIGH'), findsOneWidget);

      await tester.tap(find.text('Review PR'));
      expect(toggled, isTrue);
    });

    testWidgets('TodoEmptyStateWidget displays message and triggers action button', (tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: TodoEmptyStateWidget(
              title: 'Empty List',
              subtitle: 'No tasks here',
              onAction: () => actionTriggered = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Empty List'), findsOneWidget);
      expect(find.text('No tasks here'), findsOneWidget);

      await tester.tap(find.text('Add New Task'));
      expect(actionTriggered, isTrue);
    });

    testWidgets('CategoryPickerChipsWidget and PriorityPickerSegmentedWidget select values', (tester) async {
      String cat = 'Personal';
      TodoPriority priority = TodoPriority.medium;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    CategoryPickerChipsWidget(
                      categories: const ['Personal', 'Work', 'Health'],
                      selectedCategory: cat,
                      onSelected: (val) => setState(() => cat = val),
                    ),
                    PriorityPickerSegmentedWidget(
                      selectedPriority: priority,
                      onSelected: (val) => setState(() => priority = val),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Work'), findsOneWidget);
      await tester.tap(find.text('Work'));
      await tester.pumpAndSettle();
      expect(cat, equals('Work'));

      await tester.tap(find.text('HIGH'));
      await tester.pumpAndSettle();
      expect(priority, equals(TodoPriority.high));
    });
  });
}
