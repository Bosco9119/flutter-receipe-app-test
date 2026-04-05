import 'package:flutter/material.dart';

import '../../domain/entities/discover_meal_entity.dart';
import 'recipe_image_fill.dart';

class DiscoverMealCard extends StatelessWidget {
  const DiscoverMealCard({
    super.key,
    required this.meal,
    required this.badgeLabel,
    this.onTap,
  });

  final DiscoverMealEntity meal;
  final String badgeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: scheme.shadow.withValues(alpha: 0.12),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  RecipeImageFill(imagePath: meal.imageUrl),
                  if (badgeLabel.trim().isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Material(
                        color: scheme.surface.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Text(
                            badgeLabel,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 170;
                  final titleStyle =
                      (compact
                              ? theme.textTheme.titleSmall
                              : theme.textTheme.titleMedium)
                          ?.copyWith(fontWeight: FontWeight.bold);

                  return Text(
                    meal.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
