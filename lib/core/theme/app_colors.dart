import 'package:material_ui/material_ui.dart';

/// Pure Monochromatic (Black & White Only) Color Tokens
/// Inspired by minimalist obsidian & alabaster editorial aesthetics.
abstract class AppColors {
  // Pure Monochromatic Base
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  
  static const Color primary = black;
  static const Color onPrimary = white;
  
  static const Color background = Color(0xFFFAFAFA);
  static const Color onBackground = Color(0xFF09090B);
  
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF121214);
  static const Color onSurfaceDark = Color(0xFFF4F4F5);
  
  static const Color surfaceContainerLow = Color(0xFFF4F4F6);
  static const Color surfaceContainer = Color(0xFFEBECEF);
  static const Color surfaceContainerHigh = Color(0xFFE2E3E8);
  
  // Grayscale & Hierarchy
  static const Color textPrimary = Color(0xFF09090B);
  static const Color textSecondary = Color(0xFF52525B);
  static const Color textMuted = Color(0xFF71717A);
  static const Color textSubtle = Color(0xFFA1A1AA);
  
  // Crisp Hairlines & Borders
  static const Color hairline = Color(0xFFE4E4E7);
  static const Color borderSubtle = Color(0xFFD4D4D8);
  static const Color outline = Color(0xFF27272A);
  static const Color outlineVariant = Color(0xFFD4D4D8);
  
  // Neutral Chips & Accents
  static const Color chipBackground = Color(0xFFF4F4F5);
  static const Color chipSelected = Color(0xFF000000);
  static const Color chipTextSelected = Color(0xFFFFFFFF);
  
  // Functional & Priority Accent Colors (for clear utility on top of B&W foundation)
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityLow = Color(0xFF10B981);
  
  // Functional Status
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
}
