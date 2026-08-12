import 'package:flutter/material.dart';

/// Design Tokens & Monochromatic Color Palette based on Stitch "Obsidian & Alabaster"
abstract class AppColors {
  // Pure Monochromatic Base
  static const Color primary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);
  
  static const Color background = Color(0xFFF9F9FE);
  static const Color onBackground = Color(0xFF1A1C1F);
  
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFD9DADE);
  static const Color surfaceContainerLow = Color(0xFFF3F3F8);
  static const Color surfaceContainer = Color(0xFFEDEDF2);
  static const Color surfaceContainerHigh = Color(0xFFE8E8ED);
  
  // Grays & Hierarchy
  static const Color textPrimary = Color(0xFF1A1C1F);
  static const Color textSecondary = Color(0xFF5E5E61);
  static const Color textMuted = Color(0xFF8E8E93);
  
  // Borders & Dividers
  static const Color hairline = Color(0xFFE5E5EA);
  static const Color outline = Color(0xFF7E7576);
  static const Color outlineVariant = Color(0xFFCFC4C5);
  
  // Accents & Categories
  static const Color accentDark = Color(0xFF1B1B1B);
  static const Color chipBackground = Color(0xFFF2F2F7);
  
  // Priority Indicator Colors
  static const Color priorityHigh = Color(0xFFE53935);
  static const Color priorityMedium = Color(0xFFFB8C00);
  static const Color priorityLow = Color(0xFF43A047);
  
  // Functional Status
  static const Color error = Color(0xFFBA1A1A);
  static const Color success = Color(0xFF2E7D32);
}
