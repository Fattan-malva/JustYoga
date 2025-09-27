import 'package:flutter/material.dart';
import 'colors.dart';

class Styles {
  static final title = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static final subtitle = TextStyle(
      fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textMuted);
  static final caption = TextStyle(fontSize: 12, color: AppColors.textMuted);
}

// Theme-aware styles
class AppStyles {
  static TextStyle title(BuildContext context) {
    return TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).textTheme.titleLarge?.color ??
            AppColors.textPrimary);
  }

  static TextStyle subtitle(BuildContext context) {
    return TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).textTheme.bodyMedium?.color ??
            AppColors.textMuted);
  }

  static TextStyle caption(BuildContext context) {
    return TextStyle(
        fontSize: 12,
        color: Theme.of(context).textTheme.bodySmall?.color ??
            AppColors.textMuted);
  }
}
