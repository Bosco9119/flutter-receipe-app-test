import 'package:flutter/foundation.dart';

import '../../domain/entities/discover_meal_entity.dart';
import '../../domain/repositories/discover_recipe_repository.dart';

class DiscoverRecipeViewModel extends ChangeNotifier {
  DiscoverRecipeViewModel(this._repository);

  final DiscoverRecipeRepository _repository;

  static const int batchSize = 10;

  final List<DiscoverMealEntity> _meals = [];
  int _completedFetches = 0;
  bool _loading = false;
  String? _errorMessage;
  int _failedFetches = 0;

  List<DiscoverMealEntity> get meals => List.unmodifiable(_meals);
  int get completedFetches => _completedFetches;
  bool get isLoading => _loading;
  String? get errorMessage => _errorMessage;
  int get failedFetches => _failedFetches;
  double get progress => batchSize == 0 ? 0 : _completedFetches / batchSize;

  /// Clears list and counters (e.g. when opening the screen for a fresh batch).
  void resetForNewSession() {
    _meals.clear();
    _completedFetches = 0;
    _failedFetches = 0;
    _errorMessage = null;
    notifyListeners();
  }

  /// Calls TheMealDB [batchSize] times in sequence. Skips duplicate `sourceId`s.
  Future<void> loadTenSequential() async {
    _loading = true;
    _errorMessage = null;
    _failedFetches = 0;
    _meals.clear();
    _completedFetches = 0;
    notifyListeners();

    final seen = <String>{};

    for (var i = 0; i < batchSize; i++) {
      try {
        final meal = await _repository.fetchRandomMeal();
        if (meal != null && seen.add(meal.sourceId)) {
          _meals.add(meal);
        }
      } catch (e, st) {
        _failedFetches++;
        assert(() {
          debugPrint('DiscoverRecipeViewModel.loadTenSequential: $e\n$st');
          return true;
        }());
      }
      _completedFetches = i + 1;
      notifyListeners();
    }

    if (_meals.isEmpty) {
      _errorMessage =
          _failedFetches == batchSize ? 'all_failed' : 'no_recipes';
    } else {
      _errorMessage = null;
    }

    _loading = false;
    notifyListeners();
  }
}
