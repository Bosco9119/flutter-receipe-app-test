import 'package:flutter/foundation.dart';

import 'discover_meal_entity.dart';

/// Values to seed [RecipeCreatePage] when saving a discovered meal locally.
@immutable
class TheMealDbImportPrefill {
  const TheMealDbImportPrefill({
    required this.proposedRecipeId,
    required this.title,
    this.description,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
  });

  final String proposedRecipeId;
  final String title;
  final String? description;
  final List<String> ingredients;
  final List<String> steps;
  final String? imageUrl;

  factory TheMealDbImportPrefill.fromDiscoverMeal(DiscoverMealEntity meal) {
    return TheMealDbImportPrefill(
      proposedRecipeId: meal.storageId,
      title: meal.title,
      description: meal.descriptionBlurb,
      ingredients: List<String>.from(meal.ingredients),
      steps: List<String>.from(meal.steps),
      imageUrl: meal.imageUrl,
    );
  }
}
