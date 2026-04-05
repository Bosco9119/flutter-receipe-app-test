import '../entities/recipe_entity.dart';
import '../entities/recipe_type_entity.dart';

/// Recipe persistence + recipe type resolution (asset / remote).
abstract class RecipeRepository {
  Stream<List<RecipeEntity>> watchRecipes();

  Future<List<RecipeEntity>> loadRecipes();

  Future<List<RecipeTypeEntity>> loadRecipeTypes();

  Future<void> upsertRecipe(RecipeEntity recipe);

  Future<void> deleteRecipe(String id);
}
