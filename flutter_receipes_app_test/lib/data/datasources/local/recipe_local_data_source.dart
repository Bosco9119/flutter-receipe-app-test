import 'dart:async';
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../domain/entities/auth_session_entity.dart';
import '../../../domain/entities/recipe_owner_id.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../models/recipe_model.dart';

abstract class RecipeLocalDataSource {
  Stream<List<RecipeModel>> watchRecipes();

  Future<List<RecipeModel>> readRecipes();

  Future<void> writeRecipes(List<RecipeModel> recipes);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  RecipeLocalDataSourceImpl(
    this._box,
    this._auth,
  );

  final Box<String> _box;
  final AuthRepository _auth;

  String? _storageKeyOrNull() {
    final session = _auth.readPersistedSession();
    if (session == null) {
      return null;
    }
    return StorageKeys.recipesJsonForOwner(recipeOwnerStorageId(session));
  }

  List<RecipeModel> _decode(String? raw) {
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String _encode(List<RecipeModel> recipes) {
    return jsonEncode(recipes.map((e) => e.toJson()).toList());
  }

  @override
  Future<List<RecipeModel>> readRecipes() async {
    final key = _storageKeyOrNull();
    if (key == null) {
      return [];
    }
    return _decode(_box.get(key));
  }

  @override
  Future<void> writeRecipes(List<RecipeModel> recipes) async {
    final key = _storageKeyOrNull();
    if (key == null) {
      throw StateError('Cannot write recipes without an authenticated session');
    }
    await _box.put(key, _encode(recipes));
  }

  @override
  Stream<List<RecipeModel>> watchRecipes() {
    return Stream<List<RecipeModel>>.multi((controller) {
      StreamSubscription<AuthSessionEntity?>? authSub;
      StreamSubscription<BoxEvent>? boxSub;

      void bindHiveToSession(AuthSessionEntity? session) {
        boxSub?.cancel();
        boxSub = null;
        if (session == null) {
          controller.add(<RecipeModel>[]);
          return;
        }
        final key =
            StorageKeys.recipesJsonForOwner(recipeOwnerStorageId(session));
        void emit() {
          controller.add(_decode(_box.get(key)));
        }

        emit();
        boxSub = _box.watch(key: key).listen((_) => emit());
      }

      authSub = _auth.watchSession().listen(bindHiveToSession);

      controller.onCancel = () {
        boxSub?.cancel();
        authSub?.cancel();
      };
    });
  }
}
