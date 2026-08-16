import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';

class TodoDateFilterBarWidget extends StatelessWidget {
  final String activeDateFilter;
  final ValueChanged<String> onDateFilterChanged;

  const TodoDateFilterBarWidget({
    super.key,
    required this.activeDateFilter,
    required this.onDateFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'key': 'all', 'label': 'All Dates', 'icon': Icons.calendar_view_week_rounded},
      {'key': 'today', 'label': 'Today', 'icon': Icons.today_rounded},
      {'key': 'upcoming', 'label': 'Upcoming', 'icon': Icons.upcoming_rounded},
      {'key': 'overdue', 'label': 'Overdue', 'icon': Icons.warning_amber_rounded},
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final f = filters[index];
          final isSelected = f['key'] == activeDateFilter;
          final isOverdueKey = f['key'] == 'overdue';

          Color selectedBg = AppColors.black;
          Color selectedFg = AppColors.white;
          if (isOverdueKey && isSelected) {
            selectedBg = AppColors.error;
          }

          return InkWell(
            onTap: () => onDateFilterChanged(f['key'] as String),
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? selectedBg : AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? selectedBg
                      : (isOverdueKey ? AppColors.error.withValues(alpha: 0.3) : AppColors.hairline),
                  width: isSelected ? 1.4 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: selectedBg.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    f['icon'] as IconData,
                    size: 13,
                    color: isSelected
                        ? selectedFg
                        : (isOverdueKey ? AppColors.error : AppColors.textSecondary),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    f['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? selectedFg
                          : (isOverdueKey ? AppColors.error : AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
