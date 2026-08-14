import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';

class TodoShimmerLoadingWidget extends StatefulWidget {
  final int itemCount;

  const TodoShimmerLoadingWidget({
    super.key,
    this.itemCount = 4,
  });

  @override
  State<TodoShimmerLoadingWidget> createState() => _TodoShimmerLoadingWidgetState();
}

class _TodoShimmerLoadingWidgetState extends State<TodoShimmerLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.hairline, width: 1.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.hairline.withValues(alpha: _animation.value),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.hairline.withValues(alpha: _animation.value),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 160,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.hairline.withValues(alpha: _animation.value * 0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.chipBackground.withValues(alpha: _animation.value),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 45,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.chipBackground.withValues(alpha: _animation.value),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
