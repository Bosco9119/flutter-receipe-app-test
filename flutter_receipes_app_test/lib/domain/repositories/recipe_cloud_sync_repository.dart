import '../entities/auth_session_entity.dart';
import '../entities/recipe_cloud_diff.dart';

/// Firestore backup under `users/{ownerId}/recipes/{recipeId}`.
/// Only for Google sign-in ([sessionEligibleForCloudSync]); rules should enforce `request.auth.uid == ownerId`.
abstract class RecipeCloudSyncRepository {
  bool canUseCloud(AuthSessionEntity session);

  Future<RecipeCloudDiff> compare(AuthSessionEntity session);

  /// Local wins: delete cloud-only docs, upsert every local recipe to cloud.
  Future<void> syncToCloud(AuthSessionEntity session);

  /// Cloud wins: delete local-only recipes, upsert every cloud recipe locally.
  Future<void> restoreFromCloud(AuthSessionEntity session);
}
