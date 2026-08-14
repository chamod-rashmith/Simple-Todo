import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/todo_item.dart';
import '../widgets/add_todo_form_widget.dart';

class CreateTodoModal extends StatelessWidget {
  const CreateTodoModal({super.key});

  static Future<TodoItemEntity?> show(BuildContext context) {
    return showModalBottomSheet<TodoItemEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreateTodoModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.hairline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Task',
                    style: AppTypography.headline,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Modular Form Widget
              AddTodoFormWidget(
                onSubmit: (todo) => Navigator.pop(context, todo),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
