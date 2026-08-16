import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:simple_todo/core/widgets/app_bottom_nav_bar.dart';
import 'package:simple_todo/features/notes/domain/entities/note_entity.dart';
import 'package:simple_todo/features/notes/presentation/widgets/note_card_widget.dart';
import 'package:simple_todo/features/notes/presentation/widgets/notes_category_selector_widget.dart';

void main() {
  final testNote = NoteEntity(
    id: 'note_1',
    title: 'Meeting Notes',
    content: 'Discuss **Clean Architecture** roadmap.',
    category: 'Work',
    isPinned: true,
    createdAt: DateTime(2026, 8, 16, 10, 0),
    updatedAt: DateTime(2026, 8, 16, 10, 0),
  );

  group('Notes Presentation Widgets Tests', () {
    testWidgets('NoteCardWidget renders title, category tag, and pinned badge', (tester) async {
      bool tapped = false;
      bool pinToggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NoteCardWidget(
              note: testNote,
              onTap: () => tapped = true,
              onTogglePin: () => pinToggled = true,
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('Meeting Notes'), findsOneWidget);
      expect(find.text('WORK'), findsOneWidget);
      expect(find.text('Important'), findsOneWidget);
      expect(find.byIcon(Icons.push_pin_rounded), findsOneWidget);

      await tester.tap(find.text('Meeting Notes'));
      expect(tapped, true);

      await tester.tap(find.byIcon(Icons.push_pin_rounded));
      expect(pinToggled, true);
    });

    testWidgets('NotesCategorySelectorWidget triggers callback on category tap', (tester) async {
      String? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotesCategorySelectorWidget(
              categories: const ['All', 'Work', 'Personal'],
              selectedCategory: 'All',
              onSelectCategory: (cat) => selected = cat,
            ),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Work'), findsOneWidget);

      await tester.tap(find.text('Work'));
      expect(selected, 'Work');
    });

    testWidgets('AppBottomNavBar renders 2 tabs (Tasks & Notes) and handles tap', (tester) async {
      int? selectedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: 0,
              onTap: (idx) => selectedIndex = idx,
            ),
          ),
        ),
      );

      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);

      await tester.tap(find.text('Notes'));
      expect(selectedIndex, 1);
    });
  });
}
