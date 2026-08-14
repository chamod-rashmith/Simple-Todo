import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';

class TodoStatsBannerWidget extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final double ratio;

  const TodoStatsBannerWidget({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (ratio * 100).toInt();

    String subtitle;
    if (totalCount == 0) {
      subtitle = 'Ready to plan your day';
    } else if (completedCount == totalCount) {
      subtitle = 'All tasks completed. Excellent work.';
    } else {
      subtitle = '$completedCount of $totalCount tasks completed';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DAILY PROGRESS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSubtle,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: ratio),
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: AppColors.white.withValues(alpha: 0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
