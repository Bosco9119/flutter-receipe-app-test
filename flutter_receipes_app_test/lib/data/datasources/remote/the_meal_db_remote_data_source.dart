import '../../models/the_meal_db_meal_dto.dart';

abstract class TheMealDbRemoteDataSource {
  Future<TheMealDbMealDto?> fetchRandomMeal();
}
