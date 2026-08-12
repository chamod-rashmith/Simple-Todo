import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class TodoEmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const TodoEmptyStateWidget({
    super.key,
    this.title = 'All Caught Up!',
    this.subtitle = 'No tasks found. Tap the + button to create a new task.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.chipBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 36,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTypography.bodySecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
