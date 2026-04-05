import 'package:flutter/material.dart';

/// Warm, food-friendly palette (terracotta / spice seed + soft cream backgrounds).
abstract final class AppColors {
  /// Seeds Material 3 [ColorScheme] — warm orange–red for appetizing UI chrome.
  static const Color seed = Color(0xFFC2410C);

  static const Color lightGradientTop = Color(0xFFFFF8F0);
  static const Color lightGradientMid = Color(0xFFFFF0E5);
  static const Color lightGradientBottom = Color(0xFFFFFFFF);

  static const Color darkGradientTop = Color(0xFF1C1410);
  static const Color darkGradientMid = Color(0xFF261A14);
  static const Color darkGradientBottom = Color(0xFF100C09);

  static const Color onGradientLightPrimary = Color(0xFF3E2723);
  static const Color onGradientLightSecondary = Color(0xFF6D4C41);

  static const Color onGradientDarkPrimary = Color(0xFFFFEDE3);
  static const Color onGradientDarkSecondary = Color(0xFFD7CCC8);
}
