import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class TodoEmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onAction;

  const TodoEmptyStateWidget({
    super.key,
    this.title = 'No Tasks Found',
    this.subtitle = 'You are all caught up or no tasks match your active filter.',
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 38,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTypography.headline,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTypography.bodySecondary,
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.black),
                label: const Text(
                  'Add New Task',
                  style: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.black, width: 1.2),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
