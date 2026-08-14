import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/notification_service.dart';
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

  /// Prompts user to pick a date & time, then requests notification permission if needed.
  Future<void> _pickDueDateTime() async {
    // 1. Pick Date
    final initialDate = _selectedDueDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (pickedDate == null || !mounted) return;

    // 2. Pick Time
    final initialTime = _selectedDueDate != null
        ? TimeOfDay(hour: _selectedDueDate!.hour, minute: _selectedDueDate!.minute)
        : TimeOfDay.now();

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime == null || !mounted) return;

    // 3. Combine into single DateTime
    final selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      _selectedDueDate = selectedDateTime;
    });

    // 4. Proactively request notification permissions on reminder set
    if (sl.isRegistered<NotificationService>()) {
      await sl<NotificationService>().requestPermission();
    }
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
          const SizedBox(height: 20),

          // Due Date & Reminder Section
          const Text(
            'REMINDER & DUE DATE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickDueDateTime,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: _selectedDueDate != null
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : AppColors.chipBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedDueDate != null
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : AppColors.hairline,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    size: 20,
                    color: _selectedDueDate != null
                        ? AppColors.primary
                        : AppColors.textMuted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedDueDate != null
                          ? DateFormat('EEE, MMM d, yyyy • h:mm a').format(_selectedDueDate!)
                          : 'Set deadline & reminder notification',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _selectedDueDate != null ? FontWeight.w600 : FontWeight.w400,
                        color: _selectedDueDate != null
                            ? AppColors.primary
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                  if (_selectedDueDate != null)
                    GestureDetector(
                      onTap: () => setState(() => _selectedDueDate = null),
                      child: const Icon(
                        Icons.cancel_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    )
                  else
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                ],
              ),
            ),
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
