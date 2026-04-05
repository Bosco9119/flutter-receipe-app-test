import 'dart:convert';

/// Raw meal payload from TheMealDB `random.php` / lookup endpoints.
class TheMealDbMealDto {
  const TheMealDbMealDto({
    required this.raw,
  });

  final Map<String, dynamic> raw;

  String? get idMeal => raw['idMeal'] as String?;
  String? get strMeal => raw['strMeal'] as String?;
  String? get strCategory => raw['strCategory'] as String?;
  String? get strArea => raw['strArea'] as String?;
  String? get strInstructions => raw['strInstructions'] as String?;
  String? get strMealThumb => raw['strMealThumb'] as String?;

  static TheMealDbMealDto? fromApiJson(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    final meals = decoded['meals'];
    if (meals is! List<dynamic> || meals.isEmpty) {
      return null;
    }
    final first = meals.first;
    if (first is! Map<String, dynamic>) {
      return null;
    }
    return TheMealDbMealDto(raw: first);
  }
}
