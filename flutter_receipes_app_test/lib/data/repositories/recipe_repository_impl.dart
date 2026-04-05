import 'dart:async';

import '../../domain/entities/recipe_entity.dart';
import '../../domain/entities/recipe_type_entity.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/local/recipe_local_data_source.dart';
import '../datasources/local/recipe_type_asset_data_source.dart';
import '../datasources/remote/recipe_remote_data_source.dart';
import '../models/recipe_model.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl({
    required RecipeLocalDataSource local,
    required RecipeTypeAssetDataSource typeAsset,
    required RecipeRemoteDataSource remoteTypes,
  })  : _local = local,
        _typeAsset = typeAsset,
        _remoteTypes = remoteTypes;

  final RecipeLocalDataSource _local;
  final RecipeTypeAssetDataSource _typeAsset;
  final RecipeRemoteDataSource _remoteTypes;

  @override
  Stream<List<RecipeEntity>> watchRecipes() {
    return _local.watchRecipes().map(
          (list) => list.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<List<RecipeTypeEntity>> loadRecipeTypes() async {
    try {
      final remote = await _remoteTypes.fetchRecipeTypes();
      if (remote.isNotEmpty) {
        return remote.map((m) => m.toEntity()).toList();
      }
    } catch (_) {
      // Fall back to bundled JSON for offline-first UX.
    }
    final localTypes = await _typeAsset.loadFromAsset();
    return localTypes.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> upsertRecipe(RecipeEntity recipe) async {
    final models = await _local.readRecipes();
    final next = List<RecipeModel>.from(models);
    final index = next.indexWhere((e) => e.id == recipe.id);
    final model = RecipeModel.fromEntity(recipe);
    if (index >= 0) {
      next[index] = model;
    } else {
      next.add(model);
    }
    await _local.writeRecipes(next);
  }

  @override
  Future<void> deleteRecipe(String id) async {
    final models = await _local.readRecipes();
    final next = models.where((e) => e.id != id).toList();
    await _local.writeRecipes(next);
  }
}
