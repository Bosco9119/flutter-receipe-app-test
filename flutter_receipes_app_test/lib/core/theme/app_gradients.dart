import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Background gradients used behind scrollable content for depth without hurting contrast.
abstract final class AppGradients {
  static const LinearGradient lightBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.lightGradientTop,
      AppColors.lightGradientMid,
      AppColors.lightGradientBottom,
    ],
    stops: [0.0, 0.45, 1.0],
  );

  static const LinearGradient darkBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.darkGradientTop,
      AppColors.darkGradientMid,
      AppColors.darkGradientBottom,
    ],
    stops: [0.0, 0.55, 1.0],
  );

  /// Warm horizontal strip for top-of-screen banners (recipe list, discover, etc.).
  static LinearGradient warmHeaderBanner(ColorScheme scheme) {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.lerp(scheme.primary, const Color(0xFF9A3412), 0.22)!,
        scheme.primary,
        Color.lerp(scheme.primary, const Color(0xFFF59E0B), 0.38)!,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }
}
