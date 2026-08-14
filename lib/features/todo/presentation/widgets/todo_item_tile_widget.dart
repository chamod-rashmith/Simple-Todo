import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/todo_item.dart';

class TodoItemTileWidget extends StatelessWidget {
  final TodoItemEntity todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItemTileWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  Widget _buildPriorityBadge(TodoPriority priority) {
    String label;
    Color color;

    switch (priority) {
      case TodoPriority.high:
        label = 'HIGH';
        color = AppColors.priorityHigh;
        break;
      case TodoPriority.medium:
        label = 'MED';
        color = AppColors.priorityMedium;
        break;
      case TodoPriority.low:
        label = 'LOW';
        color = AppColors.priorityLow;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = todo.dueDate != null
        ? DateFormat('MMM d, h:mm a').format(todo.dueDate!)
        : null;

    final isPastDue = todo.dueDate != null &&
        todo.dueDate!.isBefore(DateTime.now()) &&
        !todo.isCompleted;

    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.delete_outline_rounded,
              color: AppColors.white,
              size: 22,
            ),
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: todo.isCompleted ? AppColors.hairline : AppColors.hairline,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Monochromatic Animated Checkbox
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: todo.isCompleted ? AppColors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: todo.isCompleted ? AppColors.black : AppColors.outlineVariant,
                        width: 1.8,
                      ),
                    ),
                    child: todo.isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: AppColors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 14),

                // Task Details Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: todo.isCompleted ? FontWeight.w400 : FontWeight.w600,
                          color: todo.isCompleted
                              ? AppColors.textSubtle
                              : AppColors.textPrimary,
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: AppColors.textMuted,
                          height: 1.3,
                        ),
                      ),

                      // Description
                      if (todo.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          todo.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: todo.isCompleted
                                ? AppColors.textSubtle.withValues(alpha: 0.7)
                                : AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      // Metadata Tags Row (Category, Priority, Due Date)
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          // Category Chip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.chipBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              todo.category,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),

                          // Priority Badge
                          _buildPriorityBadge(todo.priority),

                          // Due Date / Overdue Indicator
                          if (formattedDate != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isPastDue
                                    ? AppColors.black
                                    : AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.alarm_rounded,
                                    size: 12,
                                    color: isPastDue ? AppColors.white : AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isPastDue ? 'OVERDUE ($formattedDate)' : formattedDate,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isPastDue ? FontWeight.w700 : FontWeight.w500,
                                      color: isPastDue ? AppColors.white : AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
