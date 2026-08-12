import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_item_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoItemModel>> getTodos();
  Future<void> saveTodos(List<TodoItemModel> todos);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _kTodosKey = 'CACHED_TODOS_V1';

  TodoLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<TodoItemModel>> getTodos() async {
    final jsonString = sharedPreferences.getString(_kTodosKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map((item) => TodoItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    // Initial mock data if empty
    return _initialMockData;
  }

  @override
  Future<void> saveTodos(List<TodoItemModel> todos) async {
    final jsonString = jsonEncode(todos.map((t) => t.toJson()).toList());
    await sharedPreferences.setString(_kTodosKey, jsonString);
  }

  static List<TodoItemModel> get _initialMockData {
    final now = DateTime.now();
    return [
      TodoItemModel(
        id: '1',
        title: 'Review Stitch Cupertino Wireframes',
        description: 'Check layout responsiveness and monochromatic contrast.',
        category: 'Design',
        isCompleted: true,
        priority: 'high',
        createdAt: now.subtract(const Duration(hours: 4)).toIso8601String(),
      ),
      TodoItemModel(
        id: '2',
        title: 'Implement Clean Architecture Data Layer',
        description: 'Setup repositories, data sources, and extension mappers.',
        category: 'Work',
        isCompleted: false,
        priority: 'high',
        dueDate: now.add(const Duration(days: 1)).toIso8601String(),
        createdAt: now.subtract(const Duration(hours: 2)).toIso8601String(),
      ),
      TodoItemModel(
        id: '3',
        title: 'Decompose Presentation Pages into Widgets',
        description: 'Extract small modular widgets to keep code clean and readable.',
        category: 'Work',
        isCompleted: false,
        priority: 'medium',
        dueDate: now.add(const Duration(days: 2)).toIso8601String(),
        createdAt: now.subtract(const Duration(hours: 1)).toIso8601String(),
      ),
      TodoItemModel(
        id: '4',
        title: 'Morning Mindfulness & Coffee',
        description: '15 mins meditation and espresso.',
        category: 'Personal',
        isCompleted: true,
        priority: 'low',
        createdAt: now.subtract(const Duration(hours: 8)).toIso8601String(),
      ),
    ];
  }
}
