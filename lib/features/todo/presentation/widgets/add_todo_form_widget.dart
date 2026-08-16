import 'package:material_ui/material_ui.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/todo_item.dart';
import 'form/assigned_date_picker_card_widget.dart';
import 'form/category_picker_chips_widget.dart';
import 'form/due_date_time_picker_card_widget.dart';
import 'form/form_section_label_widget.dart';
import 'form/priority_picker_segmented_widget.dart';
import 'form/todo_description_markdown_editor.dart';

class AddTodoFormWidget extends StatefulWidget {
  final TodoItemEntity? initialTodo;
  final ValueChanged<TodoItemEntity> onSubmit;

  const AddTodoFormWidget({
    super.key,
    this.initialTodo,
    required this.onSubmit,
  });

  @override
  State<AddTodoFormWidget> createState() => _AddTodoFormWidgetState();
}

class _AddTodoFormWidgetState extends State<AddTodoFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late String _selectedCategory;
  late TodoPriority _selectedPriority;
  DateTime? _selectedAssignedDate;
  DateTime? _selectedDueDate;

  final List<String> _categories = ['Personal', 'Work', 'Design', 'Health'];

  bool get isEditing => widget.initialTodo != null;

  @override
  void initState() {
    super.initState();
    final todo = widget.initialTodo;
    _titleController = TextEditingController(text: todo?.title ?? '');
    _descriptionController = TextEditingController(text: todo?.description ?? '');
    _selectedCategory = todo?.category ?? 'Personal';
    _selectedPriority = todo?.priority ?? TodoPriority.medium;
    _selectedAssignedDate = todo?.assignedDate ?? (isEditing ? null : DateTime.now());
    _selectedDueDate = todo?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDateTime() async {
    final initialDate = _selectedDueDate ?? _selectedAssignedDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
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
        : const TimeOfDay(hour: 18, minute: 0);

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
      if (isEditing) {
        final updatedTodo = widget.initialTodo!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          priority: _selectedPriority,
          assignedDate: _selectedAssignedDate,
          dueDate: _selectedDueDate,
        );
        widget.onSubmit(updatedTodo);
      } else {
        final newTodo = TodoItemEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          priority: _selectedPriority,
          assignedDate: _selectedAssignedDate ?? DateTime.now(),
          dueDate: _selectedDueDate,
          createdAt: DateTime.now(),
        );
        widget.onSubmit(newTodo);
      }
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
            autofocus: !isEditing,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              hintText: 'e.g. Design Landing Page or Submit Assignment',
              labelText: 'Task Title',
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter a task title';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Description Input with Markdown Support
          const FormSectionLabelWidget(label: 'Notes / Description (Markdown)'),
          const SizedBox(height: 8),
          TodoDescriptionMarkdownEditor(
            controller: _descriptionController,
            minLines: 12,
            minHeight: 320,
          ),
          const SizedBox(height: 22),

          // Task Assigned Date (When should this task be done?)
          const FormSectionLabelWidget(label: 'Schedule / Assigned Day'),
          const SizedBox(height: 8),
          AssignedDatePickerCardWidget(
            selectedAssignedDate: _selectedAssignedDate,
            onDateChanged: (d) => setState(() => _selectedAssignedDate = d),
          ),
          const SizedBox(height: 20),

          // Due Date & Notification Reminder
          const FormSectionLabelWidget(label: 'Deadline & Reminder (Optional)'),
          const SizedBox(height: 8),
          DueDateTimePickerCardWidget(
            selectedDueDate: _selectedDueDate,
            onTap: _pickDueDateTime,
            onClear: () => setState(() => _selectedDueDate = null),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isEditing ? Icons.save_rounded : Icons.add_task_rounded,
                    size: 20,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEditing ? 'Save Changes' : 'Create Task',
                    style: const TextStyle(
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
