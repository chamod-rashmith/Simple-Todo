import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_markdown_view.dart';
import '../../domain/entities/todo_item.dart';

/// Modal bottom sheet displaying complete details of a Todo with rich Markdown formatting
class TodoDetailModal extends StatelessWidget {
  final TodoItemEntity todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoDetailModal({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required TodoItemEntity todo,
    required VoidCallback onToggle,
    required VoidCallback onDelete,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TodoDetailModal(
        todo: todo,
        onToggle: onToggle,
        onDelete: onDelete,
      ),
    );
  }

  Widget _buildPriorityBadge(TodoPriority priority) {
    String label;
    Color color;

    switch (priority) {
      case TodoPriority.high:
        label = 'HIGH PRIORITY';
        color = AppColors.priorityHigh;
        break;
      case TodoPriority.medium:
        label = 'MEDIUM PRIORITY';
        color = AppColors.priorityMedium;
        break;
      case TodoPriority.low:
        label = 'LOW PRIORITY';
        color = AppColors.priorityLow;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
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
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    String? formattedAssignedDate;
    final assigned = todo.assignedDate;
    if (assigned != null) {
      if (todo.isAssignedToday) {
        formattedAssignedDate = 'Today • ${DateFormat('EEEE, MMM d, yyyy').format(assigned)}';
      } else if (assigned.year == tomorrow.year &&
          assigned.month == tomorrow.month &&
          assigned.day == tomorrow.day) {
        formattedAssignedDate = 'Tomorrow • ${DateFormat('EEEE, MMM d, yyyy').format(assigned)}';
      } else {
        formattedAssignedDate = DateFormat('EEEE, MMM d, yyyy').format(assigned);
      }
    }

    final formattedDueDate = todo.dueDate != null
        ? DateFormat('EEEE, MMM d, yyyy • h:mm a').format(todo.dueDate!)
        : null;

    final formattedCreatedDate =
        DateFormat('MMM d, yyyy • h:mm a').format(todo.createdAt);

    final isPastDue = todo.isOverdue;

    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: SafeArea(
        top: false,
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
            const SizedBox(height: 14),

            // Status and Action Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: todo.isCompleted
                        ? AppColors.black
                        : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        todo.isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 14,
                        color: todo.isCompleted
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        todo.isCompleted ? 'COMPLETED' : 'IN PROGRESS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: todo.isCompleted
                              ? AppColors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Edit Task',
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/edit', extra: todo);
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
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
              ],
            ),
            const SizedBox(height: 8),

            // Scrollable Content Area
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      todo.title,
                      style: AppTypography.headline.copyWith(
                        fontSize: 20,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.textMuted,
                        color: todo.isCompleted
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Badges & Metadata Row
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Category
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

                        // Priority
                        _buildPriorityBadge(todo.priority),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Assigned / Planned Date Info
                    if (formattedAssignedDate != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: todo.isAssignedToday
                              ? AppColors.surfaceContainerHigh
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.hairline),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 18,
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'SCHEDULED / ASSIGNED DAY',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    formattedAssignedDate,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Due Date / Deadline Info
                    if (formattedDueDate != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isPastDue
                              ? AppColors.error.withValues(alpha: 0.08)
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isPastDue
                                ? AppColors.error.withValues(alpha: 0.3)
                                : AppColors.hairline,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.alarm_rounded,
                              size: 18,
                              color: isPastDue ? AppColors.error : AppColors.textPrimary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isPastDue ? 'OVERDUE DEADLINE' : 'DEADLINE & REMINDER',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                      color: isPastDue
                                          ? AppColors.error
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    formattedDueDate,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isPastDue
                                          ? AppColors.error
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Markdown Description Section
                    if (todo.description.trim().isNotEmpty) ...[
                      const Text(
                        'NOTES & DETAILS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.hairline),
                        ),
                        child: AppMarkdownView(
                          markdown: todo.description,
                          style: AppTypography.body.copyWith(
                            fontSize: 14,
                            height: 1.5,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Timestamp footer
                    Text(
                      'Created: $formattedCreatedDate',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSubtle,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Sticky Bottom Action Buttons Row
            Row(
              children: [
                // Edit Button
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.push('/edit', extra: todo);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.hairline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text(
                      'Edit',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Toggle Button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        onToggle();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: todo.isCompleted
                            ? AppColors.surfaceContainerHigh
                            : AppColors.black,
                        foregroundColor: todo.isCompleted
                            ? AppColors.textPrimary
                            : AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            todo.isCompleted
                                ? Icons.undo_rounded
                                : Icons.check_circle_outline_rounded,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            todo.isCompleted
                                ? 'Mark Pending'
                                : 'Mark Completed',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Delete Button
                SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      onDelete();
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.hairline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
