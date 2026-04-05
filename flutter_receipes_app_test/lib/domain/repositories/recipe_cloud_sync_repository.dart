import '../entities/auth_session_entity.dart';

/// Future Firestore layer: mirror recipes under
/// `users/{recipeOwnerStorageId(session)}/...` (see [recipe_owner_id.dart]; same id as local Hive for Google UIDs).
///
/// Not implemented yet; register a concrete class when enabling cloud sync.
abstract class RecipeCloudSyncRepository {
  /// Intended to upload or merge local recipe changes for the signed-in user.
  Future<void> syncLocalRecipesForUser(AuthSessionEntity session);
}
