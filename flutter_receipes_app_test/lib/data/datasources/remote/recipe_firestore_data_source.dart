import '../../models/recipe_model.dart';

/// Firestore: `users/{ownerId}/recipes/{recipeId}`.
///
/// Configure Firebase Console rules, e.g. match `/users/{userId}/recipes/{id}` where `request.auth.uid == userId`.
abstract class RecipeFirestoreDataSource {
  Future<List<RecipeModel>> fetchRecipes(String ownerId);

  Future<void> upsertRecipe(String ownerId, RecipeModel recipe);

  Future<void> deleteRecipe(String ownerId, String recipeId);
}
