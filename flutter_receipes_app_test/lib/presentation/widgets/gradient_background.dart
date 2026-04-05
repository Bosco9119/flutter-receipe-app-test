import 'package:flutter/material.dart';

import '../../core/theme/app_gradients.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.isDark,
    required this.child,
  });

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final gradient = isDark
        ? AppGradients.darkBackground
        : AppGradients.lightBackground;
    return DecoratedBox(
      decoration: BoxDecoration(gradient: gradient),
      child: child,
    );
  }
}
