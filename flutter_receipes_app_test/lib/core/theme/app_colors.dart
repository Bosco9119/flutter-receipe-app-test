import 'package:flutter/material.dart';

/// Semantic palette tuned for contrast in both light and dark Material 3 schemes.
abstract final class AppColors {
  static const Color seed = Color(0xFF006A6A);

  static const Color lightGradientTop = Color(0xFFE8F5F4);
  static const Color lightGradientMid = Color(0xFFF5FAF9);
  static const Color lightGradientBottom = Color(0xFFFFFFFF);

  static const Color darkGradientTop = Color(0xFF0B1F1E);
  static const Color darkGradientMid = Color(0xFF0E2C2A);
  static const Color darkGradientBottom = Color(0xFF051413);

  static const Color onGradientLightPrimary = Color(0xFF0B1F1E);
  static const Color onGradientLightSecondary = Color(0xFF3F4948);

  static const Color onGradientDarkPrimary = Color(0xFFE0F2F1);
  static const Color onGradientDarkSecondary = Color(0xFFB0CBC8);
}
