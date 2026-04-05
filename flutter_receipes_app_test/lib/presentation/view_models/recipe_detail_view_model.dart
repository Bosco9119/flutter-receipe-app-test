import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/recipe_entity.dart';
import '../../domain/entities/recipe_type_entity.dart';
import '../../domain/repositories/recipe_repository.dart';

class RecipeDetailViewModel extends ChangeNotifier {
  RecipeDetailViewModel(this._repository, this.recipeId);

  final RecipeRepository _repository;
  final String recipeId;

  StreamSubscription<List<RecipeEntity>>? _subscription;
  List<RecipeTypeEntity> _types = [];
  RecipeEntity? _recipe;
  bool _initialized = false;

  RecipeEntity? get recipe => _recipe;
  bool get isInitialized => _initialized;
  bool get hasRecipe => _recipe != null;

  String displayTypeName(String typeId) {
    for (final t in _types) {
      if (t.id == typeId) {
        return t.icon != null ? '${t.icon} ${t.name}' : t.name;
      }
    }
    return typeId;
  }

  Future<void> start() async {
    await _subscription?.cancel();
    try {
      _types = await _repository.loadRecipeTypes();
    } catch (_) {
      _types = [];
    }
    notifyListeners();

    _subscription = _repository.watchRecipes().listen((list) {
      RecipeEntity? found;
      for (final r in list) {
        if (r.id == recipeId) {
          found = r;
          break;
        }
      }
      _recipe = found;
      _initialized = true;
      notifyListeners();
    });
  }

  Future<bool> deleteRecipe() async {
    try {
      await _repository.deleteRecipe(recipeId);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
