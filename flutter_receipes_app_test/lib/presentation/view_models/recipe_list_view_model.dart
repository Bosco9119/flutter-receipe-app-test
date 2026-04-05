import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/recipe_entity.dart';
import '../../domain/entities/recipe_type_entity.dart';
import '../../domain/repositories/recipe_repository.dart';

/// MVVM state for the recipe list: search, type filter, and live data from storage.
class RecipeListViewModel extends ChangeNotifier {
  RecipeListViewModel(this._repository);

  final RecipeRepository _repository;

  List<RecipeTypeEntity> _types = [];
  List<RecipeEntity> _recipes = [];
  StreamSubscription<List<RecipeEntity>>? _subscription;
  String _searchQuery = '';
  String? _selectedTypeId;
  bool _ready = false;

  bool get isReady => _ready;
  List<RecipeTypeEntity> get recipeTypes => List.unmodifiable(_types);
  String get searchQuery => _searchQuery;
  String? get selectedTypeId => _selectedTypeId;

  Future<void> initialize() async {
    _types = await _repository.loadRecipeTypes();
    await _subscription?.cancel();
    _subscription = _repository.watchRecipes().listen((list) {
      _recipes = list;
      notifyListeners();
    });
    _ready = true;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    if (_searchQuery == value) {
      return;
    }
    _searchQuery = value;
    notifyListeners();
  }

  void setSelectedTypeId(String? id) {
    if (_selectedTypeId == id) {
      return;
    }
    _selectedTypeId = id;
    notifyListeners();
  }

  List<RecipeEntity> get visibleRecipes {
    final q = _searchQuery.trim().toLowerCase();
    return _recipes.where((r) {
      final typeOk = _selectedTypeId == null || r.typeId == _selectedTypeId;
      final searchOk = q.isEmpty || r.title.toLowerCase().contains(q);
      return typeOk && searchOk;
    }).toList()
      ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
  }

  String typeDisplayName(String typeId) {
    for (final t in _types) {
      if (t.id == typeId) {
        return t.name;
      }
    }
    return typeId;
  }

  @override
  void dispose() {
    final sub = _subscription;
    if (sub != null) {
      unawaited(sub.cancel());
    }
    super.dispose();
  }
}
