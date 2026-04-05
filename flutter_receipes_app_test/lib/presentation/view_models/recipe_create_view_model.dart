import 'package:flutter/foundation.dart';

import '../../domain/entities/recipe_entity.dart';
import '../../domain/entities/recipe_type_entity.dart';
import '../../domain/repositories/recipe_repository.dart';

class RecipeCreateViewModel extends ChangeNotifier {
  RecipeCreateViewModel(
    this._repository, {
    this.initialTypeId,
    this.requireUserToPickRecipeType = false,
  });

  final RecipeRepository _repository;
  final String? initialTypeId;

  /// When true (e.g. TheMealDB import), no default type is selected after types load.
  final bool requireUserToPickRecipeType;

  List<RecipeTypeEntity> _types = [];
  bool _loadingTypes = true;
  bool _submitting = false;
  String? _selectedTypeId;
  String? _lastError;

  List<RecipeTypeEntity> get types => List.unmodifiable(_types);
  bool get isLoadingTypes => _loadingTypes;
  bool get isSubmitting => _submitting;
  String? get selectedTypeId => _selectedTypeId;
  String? get lastError => _lastError;

  Future<void> loadTypes() async {
    _loadingTypes = true;
    _lastError = null;
    notifyListeners();
    try {
      _types = await _repository.loadRecipeTypes();
      final preset = initialTypeId;
      if (preset != null && _types.any((t) => t.id == preset)) {
        _selectedTypeId = preset;
      } else if (!requireUserToPickRecipeType) {
        _selectedTypeId ??= _types.isNotEmpty ? _types.first.id : null;
      } else {
        _selectedTypeId = null;
      }
    } catch (e) {
      _lastError = e.toString();
    } finally {
      _loadingTypes = false;
      notifyListeners();
    }
  }

  void setSelectedTypeId(String? id) {
    if (_selectedTypeId == id) {
      return;
    }
    _selectedTypeId = id;
    notifyListeners();
  }

  Future<bool> saveRecipe(RecipeEntity recipe) async {
    _submitting = true;
    _lastError = null;
    notifyListeners();
    try {
      await _repository.upsertRecipe(recipe);
      return true;
    } catch (e) {
      _lastError = e.toString();
      return false;
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }
}
