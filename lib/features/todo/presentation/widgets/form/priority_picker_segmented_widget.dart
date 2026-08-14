import 'package:material_ui/material_ui.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/todo_item.dart';

class PriorityPickerSegmentedWidget extends StatelessWidget {
  final TodoPriority selectedPriority;
  final ValueChanged<TodoPriority> onSelected;

  const PriorityPickerSegmentedWidget({
    super.key,
    required this.selectedPriority,
    required this.onSelected,
  });

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return AppColors.priorityHigh;
      case TodoPriority.medium:
        return AppColors.priorityMedium;
      case TodoPriority.low:
        return AppColors.priorityLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TodoPriority.values.map((priority) {
        final isSelected = priority == selectedPriority;
        final name = priority.name.toUpperCase();
        final color = _getPriorityColor(priority);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onSelected(priority),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.black : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.black : AppColors.hairline,
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? AppColors.white : AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
