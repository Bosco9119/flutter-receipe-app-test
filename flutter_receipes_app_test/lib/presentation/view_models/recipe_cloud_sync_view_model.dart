import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/cloud_sync_mode.dart';
import '../../domain/entities/recipe_cloud_diff.dart';
import '../../domain/repositories/recipe_cloud_sync_repository.dart';

class RecipeCloudSyncViewModel extends ChangeNotifier {
  RecipeCloudSyncViewModel(
    this._repository,
    this._session,
    this.mode,
  );

  final RecipeCloudSyncRepository _repository;
  final AuthSessionEntity _session;
  final CloudSyncMode mode;

  RecipeCloudDiff? diff;
  bool loading = false;
  bool applying = false;
  String? errorMessage;

  Future<void> loadComparison() async {
    loading = true;
    errorMessage = null;
    diff = null;
    notifyListeners();
    try {
      diff = await _repository.compare(_session);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> apply() async {
    applying = true;
    errorMessage = null;
    notifyListeners();
    try {
      if (mode == CloudSyncMode.sync) {
        await _repository.syncToCloud(_session);
      } else {
        await _repository.restoreFromCloud(_session);
      }
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      applying = false;
      notifyListeners();
    }
  }
}
