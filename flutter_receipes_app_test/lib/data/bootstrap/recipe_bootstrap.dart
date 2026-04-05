import 'package:flutter/services.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/local/recipe_local_data_source.dart';
import '../sample/recipe_bundled_parser.dart';
import '../sample/sample_recipes.dart';

/// Loads [assets/data/recipes.json] when storage is empty; falls back to in-code samples.
Future<void> ensureSampleRecipesSeeded() async {
  final local = sl<RecipeLocalDataSource>();
  final existing = await local.readRecipes();
  if (existing.isNotEmpty) {
    return;
  }
  final repo = sl<RecipeRepository>();
  List<RecipeEntity> toInsert;
  try {
    final raw = await rootBundle.loadString('assets/data/recipes.json');
    toInsert = parseBundledRecipesJson(raw);
  } catch (_) {
    toInsert = buildSampleRecipes();
  }
  for (final recipe in toInsert) {
    await repo.upsertRecipe(recipe);
  }
}
