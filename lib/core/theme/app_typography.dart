import 'package:material_ui/material_ui.dart';
import 'app_colors.dart';

/// Typography System based on Monochromatic Editorial Minimalist Design
abstract class AppTypography {
  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    color: AppColors.textPrimary,
    height: 1.15,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle title = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle labelUppercase = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AppColors.textMuted,
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.onPrimary,
  );
}
