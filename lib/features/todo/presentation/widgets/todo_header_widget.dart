import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class TodoHeaderWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const TodoHeaderWidget({
    super.key,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMMM d').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr.toUpperCase(),
                  style: AppTypography.labelUppercase,
                ),
                const SizedBox(height: 4),
                const Text(
                  'My Tasks',
                  style: AppTypography.display,
                ),
              ],
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.hairline),
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textMuted,
              size: 20,
            ),
            fillColor: AppColors.surfaceContainerLow,
          ),
        ),
      ],
    );
  }
}
