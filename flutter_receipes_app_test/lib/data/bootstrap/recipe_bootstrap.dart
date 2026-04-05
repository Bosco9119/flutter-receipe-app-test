import 'package:flutter/services.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/local/recipe_local_data_source.dart';
import '../sample/recipe_bundled_parser.dart';
import '../sample/sample_recipes.dart';

/// Seeds bundled recipes only for the **current** persisted user when their list is empty.
///
/// Call after [configureDependencies] (cold start) and from [RecipeListViewModel.initialize]
/// so a fresh login also gets samples for that account. No Firestore.
Future<void> ensureSampleRecipesSeededIfNeeded() async {
  final auth = sl<AuthRepository>();
  if (auth.readPersistedSession() == null) {
    return;
  }
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
