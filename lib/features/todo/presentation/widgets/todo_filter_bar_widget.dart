import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';

class TodoFilterBarWidget extends StatelessWidget {
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  const TodoFilterBarWidget({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'key': 'all', 'label': 'All Tasks'},
      {'key': 'active', 'label': 'Pending'},
      {'key': 'completed', 'label': 'Completed'},
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.hairline, width: 1.0),
      ),
      child: Row(
        children: filters.map((f) {
          final isSelected = f['key'] == activeFilter;
          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(f['key']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
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
                child: Text(
                  f['label']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
