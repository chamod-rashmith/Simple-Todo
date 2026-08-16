import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';

/// ============================================================================
/// AssignedDatePickerCardWidget
/// ============================================================================
///
/// Dedicated UI component for assigning a task to a specific day (Assigned Date).
/// Provides quick preset chips ("Today", "Tomorrow") and a custom date picker.
class AssignedDatePickerCardWidget extends StatelessWidget {
  final DateTime? selectedAssignedDate;
  final ValueChanged<DateTime?> onDateChanged;

  const AssignedDatePickerCardWidget({
    super.key,
    required this.selectedAssignedDate,
    required this.onDateChanged,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _pickCustomDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = selectedAssignedDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
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

    if (picked != null) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    final isToday = selectedAssignedDate != null && _isSameDay(selectedAssignedDate!, now);
    final isTomorrow = selectedAssignedDate != null && _isSameDay(selectedAssignedDate!, tomorrow);
    final isCustom = selectedAssignedDate != null && !isToday && !isTomorrow;

    String dateDisplayText;
    if (selectedAssignedDate == null || isToday) {
      dateDisplayText = 'Today • ${DateFormat('EEE, MMM d').format(now)}';
    } else if (isTomorrow) {
      dateDisplayText = 'Tomorrow • ${DateFormat('EEE, MMM d').format(tomorrow)}';
    } else {
      dateDisplayText = DateFormat('EEEE, MMM d, yyyy').format(selectedAssignedDate!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Presets Row
        Row(
          children: [
            // Today Chip
            _buildPresetChip(
              label: 'Today',
              isSelected: isToday || selectedAssignedDate == null,
              onTap: () => onDateChanged(now),
            ),
            const SizedBox(width: 8),

            // Tomorrow Chip
            _buildPresetChip(
              label: 'Tomorrow',
              isSelected: isTomorrow,
              onTap: () => onDateChanged(tomorrow),
            ),
            const SizedBox(width: 8),

            // Custom Date Button
            Expanded(
              child: _buildPresetChip(
                label: isCustom ? DateFormat('MMM d').format(selectedAssignedDate!) : 'Pick Date',
                isSelected: isCustom,
                icon: Icons.calendar_month_rounded,
                onTap: () => _pickCustomDate(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Selected Date Summary Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.event_available_rounded,
                size: 18,
                color: AppColors.black,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Planned for: $dateDisplayText',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetChip({
    required String label,
    required bool isSelected,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.black : AppColors.hairline,
            width: isSelected ? 1.4 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
