import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Center(
          child: Container(
            width: 230,
            height: 52,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Sliding Active Pill Indicator
                AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  alignment: currentIndex == 0
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tab Buttons
                Row(
                  children: [
                    Expanded(
                      child: _TabButton(
                        icon: Icons.check_circle_outline_rounded,
                        activeIcon: Icons.check_circle_rounded,
                        label: 'Tasks',
                        isSelected: currentIndex == 0,
                        onTap: () => onTap(0),
                      ),
                    ),
                    Expanded(
                      child: _TabButton(
                        icon: Icons.sticky_note_2_outlined,
                        activeIcon: Icons.sticky_note_2_rounded,
                        label: 'Notes',
                        isSelected: currentIndex == 1,
                        onTap: () => onTap(1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 18,
                color: isSelected ? AppColors.black : AppColors.textSubtle,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.button.copyWith(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.black : AppColors.textSubtle,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Bottom Navigation Bar (Tasks Tab)')
Widget previewBottomNavTasks() {
  return Scaffold(
    backgroundColor: AppColors.background,
    body: const Center(child: Text('Tasks Screen')),
    bottomNavigationBar: AppBottomNavBar(
      currentIndex: 0,
      onTap: (_) {},
    ),
  );
}

@Preview(name: 'Bottom Navigation Bar (Notes Tab)')
Widget previewBottomNavNotes() {
  return Scaffold(
    backgroundColor: AppColors.background,
    body: const Center(child: Text('Notes Screen')),
    bottomNavigationBar: AppBottomNavBar(
      currentIndex: 1,
      onTap: (_) {},
    ),
  );
}
