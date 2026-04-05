import '../../domain/entities/discover_meal_entity.dart';
import '../models/the_meal_db_meal_dto.dart';

/// Maps TheMealDB DTOs into [DiscoverMealEntity] for presentation.
class TheMealDbMealMapper {
  const TheMealDbMealMapper();

  static const String _storageIdPrefix = 'themedb_';

  /// Splits instructions on paragraph breaks, line breaks, and sentence
  /// boundaries (`.`, `!`, `?` followed by whitespace).
  List<String> splitInstructions(String? raw) {
    final t = raw?.trim() ?? '';
    if (t.isEmpty) {
      return const [''];
    }
    final out = <String>[];
    final paragraphs = t.split(RegExp(r'\r?\n\s*\r?\n'));
    for (final p in paragraphs) {
      final lines = p.split(RegExp(r'\r?\n'));
      for (final line in lines) {
        final trimmedLine = line.trim();
        if (trimmedLine.isEmpty) {
          continue;
        }
        final sentences = trimmedLine.split(RegExp(r'(?<=[.!?])\s+'));
        for (final s in sentences) {
          final x = s.trim();
          if (x.isNotEmpty) {
            out.add(x);
          }
        }
      }
    }
    return out.isEmpty ? [t] : out;
  }

  List<String> ingredientsFromDto(TheMealDbMealDto dto) {
    final list = <String>[];
    for (var i = 1; i <= 20; i++) {
      final ing = dto.raw['strIngredient$i'] as String?;
      final meas = dto.raw['strMeasure$i'] as String?;
      final name = ing?.trim() ?? '';
      if (name.isEmpty) {
        continue;
      }
      final m = meas?.trim() ?? '';
      list.add(m.isEmpty ? name : '$m $name'.trim());
    }
    return list;
  }

  DiscoverMealEntity? toDiscoverMeal(TheMealDbMealDto? dto) {
    if (dto == null) {
      return null;
    }
    final id = dto.idMeal?.trim() ?? '';
    if (id.isEmpty) {
      return null;
    }
    final title = dto.strMeal?.trim() ?? '';
    if (title.isEmpty) {
      return null;
    }
    final category = dto.strCategory?.trim() ?? '';
    final area = dto.strArea?.trim() ?? '';
    var ingredients = List<String>.from(ingredientsFromDto(dto));
    if (ingredients.isEmpty) {
      ingredients = [''];
    }
    final parsed = splitInstructions(dto.strInstructions);
    final steps = parsed.where((s) => s.trim().isNotEmpty).toList();
    final normalized = steps.isEmpty ? const [''] : steps;

    return DiscoverMealEntity(
      sourceId: id,
      storageId: '$_storageIdPrefix$id',
      title: title,
      category: category,
      area: area,
      imageUrl: dto.strMealThumb?.trim(),
      ingredients: List<String>.unmodifiable(ingredients),
      steps: List<String>.unmodifiable(normalized),
      instructionsRaw: dto.strInstructions,
    );
  }
}
