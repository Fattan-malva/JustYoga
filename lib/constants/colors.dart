// constants/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF94191C);
  static const Color secondary = Color(0xFFFFD700);

  // Light Theme Colors
  static const Color bg = Color(0xFFF8F9FA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color card = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFE2E8F0);
  static const Color darkTextSecondary = Color(0xFFA0AEC0);
  static const Color darkTextMuted = Color(0xFF6B7280);
  static const Color darkBorder = Color(0xFF2D3748);
  static const Color darkCard = Color(0xFF1E1E1E);

  // Common Colors
  static const Color success = Color(0xFF48BB78);
  static const Color error = Color(0xFFF56565);
  static const Color warning = Color(0xFFED8936);
  static const Color info = Color(0xFF4299E1);
}

// Helper function to create MaterialColor from Color
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}
