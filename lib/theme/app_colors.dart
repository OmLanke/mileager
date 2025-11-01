import 'package:flutter/material.dart';

/// Neo-Brutalist Color Palette
/// High contrast, bold colors with strong visual hierarchy
class AppColors {
  // Primary Colors - Bold and Eye-catching
  static const Color primary = Color(0xFF000000); // Pure Black
  static const Color secondary = Color(0xFFFFD700); // Golden Yellow
  static const Color accent = Color(0xFFFF6B6B); // Coral Red

  // Background Colors
  static const Color background = Color(0xFFF5F5DC); // Beige/Cream
  static const Color surface = Color(0xFFFFFFFF); // Pure White

  // Functional Colors
  static const Color success = Color(0xFF4ECB71); // Bright Green
  static const Color warning = Color(0xFFFFA500); // Orange
  static const Color error = Color(0xFFFF3B30); // Red
  static const Color info = Color(0xFF00D4FF); // Cyan

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF4A4A4A);
  static const Color textTertiary = Color(0xFF8E8E8E);

  // Border & Shadow
  static const Color border = Color(0xFF000000);
  static const Color shadow = Color(0xFF000000);

  // Chart Colors - Bold and Distinct
  static const List<Color> chartColors = [
    Color(0xFFFF6B6B), // Coral Red
    Color(0xFF4ECDC4), // Turquoise
    Color(0xFFFFD700), // Golden Yellow
    Color(0xFF95E1D3), // Mint
    Color(0xFFFFA07A), // Light Salmon
    Color(0xFF98D8C8), // Seafoam
  ];

  // Card Colors - Various backgrounds for visual interest
  static const Color cardPrimary = Color(0xFFFFD700); // Yellow
  static const Color cardSecondary = Color(0xFF00D4FF); // Cyan
  static const Color cardTertiary = Color(0xFFFF6B6B); // Coral
  static const Color cardQuaternary = Color(0xFF4ECB71); // Green
}
