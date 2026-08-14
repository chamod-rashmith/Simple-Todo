import 'package:material_ui/material_ui.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/todo_item.dart';
import 'form/category_picker_chips_widget.dart';
import 'form/due_date_time_picker_card_widget.dart';
import 'form/form_section_label_widget.dart';
import 'form/priority_picker_segmented_widget.dart';

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

  Future<void> _pickDueDateTime() async {
    final initialDate = _selectedDueDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.black,
              onPrimary: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) return;

    final initialTime = _selectedDueDate != null
        ? TimeOfDay(hour: _selectedDueDate!.hour, minute: _selectedDueDate!.minute)
        : TimeOfDay.now();

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.black,
              onPrimary: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null || !mounted) return;

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
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
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
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              hintText: 'Add additional details or notes...',
              labelText: 'Description (Optional)',
            ),
          ),
          const SizedBox(height: 20),

          // Category Section
          const FormSectionLabelWidget(label: 'Category'),
          const SizedBox(height: 8),
          CategoryPickerChipsWidget(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onSelected: (cat) => setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 20),

          // Priority Section
          const FormSectionLabelWidget(label: 'Priority Level'),
          const SizedBox(height: 8),
          PriorityPickerSegmentedWidget(
            selectedPriority: _selectedPriority,
            onSelected: (p) => setState(() => _selectedPriority = p),
          ),
          const SizedBox(height: 20),

          // Due Date & Notification Reminder
          const FormSectionLabelWidget(label: 'Reminder & Deadline'),
          const SizedBox(height: 8),
          DueDateTimePickerCardWidget(
            selectedDueDate: _selectedDueDate,
            onTap: _pickDueDateTime,
            onClear: () => setState(() => _selectedDueDate = null),
          ),
          const SizedBox(height: 28),

          // Submit CTA Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_task_rounded, size: 20, color: AppColors.white),
                  SizedBox(width: 8),
                  Text(
                    'Create Task',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
