import 'dart:convert';

import '../../domain/entities/recipe_entity.dart';

/// Parses `assets/data/recipes.json` shape (`recipes` array, bundled field names).
List<RecipeEntity> parseBundledRecipesJson(String raw) {
  final root = jsonDecode(raw);
  if (root is! Map<String, dynamic>) {
    throw const FormatException('Recipes JSON root must be an object');
  }
  final list = root['recipes'];
  if (list is! List<dynamic>) {
    throw const FormatException('Expected "recipes" array');
  }
  final updatedAt = DateTime.now().toUtc();
  return list
      .map((e) => _recipeFromBundledMap(e as Map<String, dynamic>, updatedAt))
      .toList();
}

RecipeEntity _recipeFromBundledMap(Map<String, dynamic> json, DateTime updatedAt) {
  final prep = json['prep_time_minutes'] ?? json['prepMinutes'];
  final servings = json['servings'];
  final image = json['image'] as String?;

  return RecipeEntity(
    id: json['id'] as String,
    typeId: json['type'] as String? ?? json['typeId'] as String,
    title: json['name'] as String? ?? json['title'] as String,
    description: json['description'] as String?,
    ingredients: (json['ingredients'] as List<dynamic>).cast<String>(),
    steps: (json['steps'] as List<dynamic>).cast<String>(),
    imagePath: image,
    updatedAt: updatedAt,
    prepMinutes: (prep as num?)?.toInt() ?? 15,
    servings: (servings as num?)?.toInt() ?? 2,
    isHalal: json['isHalal'] as bool? ?? true,
    isVegetarian: json['isVegetarian'] as bool? ?? false,
    isVegan: json['isVegan'] as bool? ?? false,
  );
}
