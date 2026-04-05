import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/bootstrap/recipe_bootstrap.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/entities/recipe_list_sort.dart';
import '../../domain/entities/recipe_owner_id.dart';
import '../../domain/entities/recipe_type_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/recipe_repository.dart';

/// MVVM state for the recipe list: search, type filter, sort order, and live data.
class RecipeListViewModel extends ChangeNotifier {
  RecipeListViewModel(this._repository, this._authRepository);

  final RecipeRepository _repository;
  final AuthRepository _authRepository;

  List<RecipeTypeEntity> _types = [];
  List<RecipeEntity> _recipes = [];
  StreamSubscription<List<RecipeEntity>>? _subscription;
  StreamSubscription<AuthSessionEntity?>? _authSubscription;

  /// Clears list when switching accounts so we never show another user's recipes briefly.
  String? _lastRecipeOwnerKey;
  String _ownerKey(AuthSessionEntity? s) =>
      s == null ? '' : recipeOwnerStorageId(s);

  String _searchQuery = '';
  String? _selectedTypeId;
  RecipeListSort _sort = RecipeListSort.titleAscending;
  bool _ready = false;

  bool get isReady => _ready;
  List<RecipeTypeEntity> get recipeTypes => List.unmodifiable(_types);
  String get searchQuery => _searchQuery;
  String? get selectedTypeId => _selectedTypeId;
  RecipeListSort get sort => _sort;

  Future<void> initialize() async {
    _types = await _repository.loadRecipeTypes();

    await _authSubscription?.cancel();
    _authSubscription = _authRepository.watchSession().listen((session) async {
      final nextKey = _ownerKey(session);
      if (_lastRecipeOwnerKey != nextKey) {
        _lastRecipeOwnerKey = nextKey;
        _recipes = [];
        notifyListeners();
      }
      if (session != null) {
        await ensureSampleRecipesSeededIfNeeded();
      }
    });

    await ensureSampleRecipesSeededIfNeeded();
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

  void setSort(RecipeListSort value) {
    if (_sort == value) {
      return;
    }
    _sort = value;
    notifyListeners();
  }

  List<RecipeEntity> get visibleRecipes {
    final q = _searchQuery.trim().toLowerCase();
    final filtered = _recipes.where((r) {
      final typeOk = _selectedTypeId == null || r.typeId == _selectedTypeId;
      final searchOk = q.isEmpty || r.title.toLowerCase().contains(q);
      return typeOk && searchOk;
    }).toList();
    _sortRecipes(filtered, _sort);
    return filtered;
  }

  static void _sortRecipes(List<RecipeEntity> list, RecipeListSort sort) {
    int byTitleThenId(RecipeEntity a, RecipeEntity b) {
      final c = a.title.toLowerCase().compareTo(b.title.toLowerCase());
      return c != 0 ? c : a.id.compareTo(b.id);
    }

    switch (sort) {
      case RecipeListSort.titleAscending:
        list.sort(byTitleThenId);
      case RecipeListSort.titleDescending:
        list.sort((a, b) => byTitleThenId(b, a));
      case RecipeListSort.prepTimeAscending:
        list.sort((a, b) {
          final c = a.prepMinutes.compareTo(b.prepMinutes);
          return c != 0 ? c : byTitleThenId(a, b);
        });
      case RecipeListSort.prepTimeDescending:
        list.sort((a, b) {
          final c = b.prepMinutes.compareTo(a.prepMinutes);
          return c != 0 ? c : byTitleThenId(a, b);
        });
    }
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
    final authSub = _authSubscription;
    if (authSub != null) {
      unawaited(authSub.cancel());
    }
    super.dispose();
  }
}
