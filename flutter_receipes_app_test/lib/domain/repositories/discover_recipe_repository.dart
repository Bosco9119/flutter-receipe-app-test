import '../entities/discover_meal_entity.dart';

abstract class DiscoverRecipeRepository {
  /// One random meal from TheMealDB, or null if the API returns no meal.
  Future<DiscoverMealEntity?> fetchRandomMeal();
}
