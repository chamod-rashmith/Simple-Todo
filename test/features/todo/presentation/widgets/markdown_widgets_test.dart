import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/core/theme/app_theme.dart';
import 'package:simple_todo/core/widgets/app_markdown_view.dart';
import 'package:simple_todo/features/todo/domain/entities/todo_item.dart';
import 'package:simple_todo/features/todo/presentation/widgets/form/markdown_toolbar_widget.dart';
import 'package:simple_todo/features/todo/presentation/widgets/form/todo_description_markdown_editor.dart';
import 'package:simple_todo/features/todo/presentation/widgets/todo_detail_modal.dart';

void main() {
  group('Markdown Presentation Widgets Tests', () {
    testWidgets('AppMarkdownView renders markdown text correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppMarkdownView(
              markdown: '**Bold Title** with *italic* and `code`',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppMarkdownView), findsOneWidget);
      expect(find.textContaining('Bold Title'), findsWidgets);
    });

    testWidgets('MarkdownToolbarWidget inserts markdown tokens into controller', (tester) async {
      final controller = TextEditingController(text: 'sample text');
      controller.selection = const TextSelection(baseOffset: 0, extentOffset: 6); // selects 'sample'

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: MarkdownToolbarWidget(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap Bold button ('B')
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();

      expect(controller.text, contains('**sample** text'));
    });

    testWidgets('TodoDescriptionMarkdownEditor switches between Write and Preview modes', (tester) async {
      final controller = TextEditingController(text: '## Test Header\n- Item 1\n- Item 2');

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: SingleChildScrollView(
              child: TodoDescriptionMarkdownEditor(controller: controller),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initial state: Write mode is active
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Markdown supported'), findsOneWidget);

      // Switch to Preview mode
      await tester.tap(find.text('Preview'));
      await tester.pumpAndSettle();

      // In Preview mode, AppMarkdownView is shown
      expect(find.byType(AppMarkdownView), findsOneWidget);

      // Switch back to Write mode
      await tester.tap(find.text('Write'));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('TodoDetailModal displays full details with markdown description and triggers actions', (tester) async {
      bool toggled = false;
      bool deleted = false;

      final testTodo = TodoItemEntity(
        id: 'test_123',
        title: 'Review PR with Markdown',
        description: '### Checklist\n- [x] Tested\n- [ ] Approved',
        category: 'Work',
        priority: TodoPriority.high,
        dueDate: DateTime.now().add(const Duration(hours: 3)),
        createdAt: DateTime.now(),
        isCompleted: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    TodoDetailModal.show(
                      context,
                      todo: testTodo,
                      onToggle: () => toggled = true,
                      onDelete: () => deleted = true,
                    );
                  },
                  child: const Text('Open Modal'),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open Modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Review PR with Markdown'), findsOneWidget);
      expect(find.text('WORK'), findsNothing); // Category is 'Work'
      expect(find.text('Work'), findsOneWidget);
      expect(find.text('HIGH PRIORITY'), findsOneWidget);
      expect(find.byType(AppMarkdownView), findsOneWidget);

      // Tap Mark Completed
      await tester.tap(find.text('Mark Completed'));
      await tester.pumpAndSettle();

      expect(toggled, isTrue);
      expect(deleted, isFalse);
    });
  });
}
