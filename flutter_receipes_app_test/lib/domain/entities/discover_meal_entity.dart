import 'package:flutter/foundation.dart';

/// A recipe preview from TheMealDB (not stored locally until imported).
@immutable
class DiscoverMealEntity {
  const DiscoverMealEntity({
    required this.sourceId,
    required this.storageId,
    required this.title,
    required this.category,
    required this.area,
    required this.ingredients,
    required this.steps,
    this.imageUrl,
    this.instructionsRaw,
  });

  /// API `idMeal`.
  final String sourceId;

  /// Proposed local id: `themedb_{idMeal}`.
  final String storageId;

  final String title;
  final String category;
  final String area;
  final String? imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final String? instructionsRaw;

  String get badgeLabel {
    if (area.isNotEmpty && category.isNotEmpty) {
      return '$area · $category';
    }
    if (category.isNotEmpty) {
      return category;
    }
    if (area.isNotEmpty) {
      return area;
    }
    return '';
  }

  String? get descriptionBlurb {
    final parts = <String>[];
    if (area.isNotEmpty) {
      parts.add(area);
    }
    if (category.isNotEmpty) {
      parts.add(category);
    }
    if (parts.isEmpty) {
      return null;
    }
    return parts.join(' · ');
  }
}
