import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/recipe_cloud_diff.dart';
import '../../domain/entities/recipe_owner_id.dart';
import '../../domain/repositories/recipe_cloud_sync_repository.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/remote/recipe_firestore_data_source.dart';
import '../models/recipe_model.dart';

class RecipeCloudSyncRepositoryImpl implements RecipeCloudSyncRepository {
  RecipeCloudSyncRepositoryImpl({
    required RecipeFirestoreDataSource firestore,
    required RecipeRepository recipeRepository,
  })  : _firestore = firestore,
        _recipeRepository = recipeRepository;

  final RecipeFirestoreDataSource _firestore;
  final RecipeRepository _recipeRepository;

  void _requireCloud(AuthSessionEntity session) {
    if (!canUseCloud(session)) {
      throw StateError('Cloud backup requires Google sign-in');
    }
  }

  String _ownerId(AuthSessionEntity session) => recipeOwnerStorageId(session);

  @override
  bool canUseCloud(AuthSessionEntity session) =>
      sessionEligibleForCloudSync(session);

  @override
  Future<RecipeCloudDiff> compare(AuthSessionEntity session) async {
    _requireCloud(session);
    final ownerId = _ownerId(session);
    final local = await _recipeRepository.loadRecipes();
    final cloudModels = await _firestore.fetchRecipes(ownerId);
    final cloud = cloudModels.map((m) => m.toEntity()).toList();
    return RecipeCloudDiff.compute(local, cloud);
  }

  @override
  Future<void> syncToCloud(AuthSessionEntity session) async {
    _requireCloud(session);
    final ownerId = _ownerId(session);
    final local = await _recipeRepository.loadRecipes();
    final cloud = await _firestore.fetchRecipes(ownerId);
    final localIds = local.map((r) => r.id).toSet();

    for (final c in cloud) {
      if (!localIds.contains(c.id)) {
        await _firestore.deleteRecipe(ownerId, c.id);
      }
    }
    for (final r in local) {
      await _firestore.upsertRecipe(ownerId, RecipeModel.fromEntity(r));
    }
  }

  @override
  Future<void> restoreFromCloud(AuthSessionEntity session) async {
    _requireCloud(session);
    final ownerId = _ownerId(session);
    final local = await _recipeRepository.loadRecipes();
    final cloud = await _firestore.fetchRecipes(ownerId);
    final cloudIds = cloud.map((c) => c.id).toSet();

    for (final r in local) {
      if (!cloudIds.contains(r.id)) {
        await _recipeRepository.deleteRecipe(r.id);
      }
    }
    for (final c in cloud) {
      await _recipeRepository.upsertRecipe(c.toEntity());
    }
  }
}
