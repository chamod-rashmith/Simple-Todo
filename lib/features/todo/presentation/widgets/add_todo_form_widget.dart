import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/todo_item.dart';

class AddTodoFormWidget extends StatefulWidget {
  final ValueChanged<TodoItemEntity> onSubmit;

  const AddTodoFormWidget({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddTodoFormWidget> createState() => _AddTodoFormWidgetState();
}

class _AddTodoFormWidgetState extends State<AddTodoFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Personal';
  TodoPriority _selectedPriority = TodoPriority.medium;
  DateTime? _selectedDueDate;

  final List<String> _categories = ['Personal', 'Work', 'Design', 'Health'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newTodo = TodoItemEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        priority: _selectedPriority,
        dueDate: _selectedDueDate,
        createdAt: DateTime.now(),
      );
      widget.onSubmit(newTodo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Input
          TextFormField(
            controller: _titleController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'What needs to be done?',
              labelText: 'Task Title',
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter a task title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Description Input
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Add notes or subtasks...',
              labelText: 'Description (Optional)',
            ),
          ),
          const SizedBox(height: 20),

          // Category Chips
          const Text(
            'CATEGORY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _categories.map((cat) {
              final isSelected = cat == _selectedCategory;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedCategory = cat);
                },
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.chipBackground,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide.none,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Priority Selection
          const Text(
            'PRIORITY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: TodoPriority.values.map((priority) {
              final isSelected = priority == _selectedPriority;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: OutlinedButton(
                    onPressed: () => setState(() => _selectedPriority = priority),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isSelected ? AppColors.primary : Colors.transparent,
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.hairline,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      priority.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Create Task'),
            ),
          ),
        ],
      ),
    );
  }
}
