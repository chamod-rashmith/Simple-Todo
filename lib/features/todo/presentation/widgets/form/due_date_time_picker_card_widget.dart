import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';

class DueDateTimePickerCardWidget extends StatelessWidget {
  final DateTime? selectedDueDate;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const DueDateTimePickerCardWidget({
    super.key,
    required this.selectedDueDate,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = selectedDueDate != null;
    final formattedText = hasDate
        ? DateFormat('EEE, MMM d, yyyy • h:mm a').format(selectedDueDate!)
        : 'Set deadline & reminder notification';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: hasDate ? AppColors.surfaceContainerLow : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasDate ? AppColors.black : AppColors.hairline,
            width: hasDate ? 1.2 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasDate
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_none_rounded,
              size: 20,
              color: hasDate ? AppColors.black : AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                formattedText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: hasDate ? FontWeight.w700 : FontWeight.w400,
                  color: hasDate ? AppColors.black : AppColors.textMuted,
                ),
              ),
            ),
            if (hasDate)
              GestureDetector(
                onTap: onClear,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.cancel_rounded,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                ),
              )
            else
              const Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: AppColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}
