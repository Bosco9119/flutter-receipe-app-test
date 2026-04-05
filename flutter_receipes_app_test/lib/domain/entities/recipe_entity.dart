import 'package:flutter/foundation.dart';

@immutable
class RecipeEntity {
  const RecipeEntity({
    required this.id,
    required this.typeId,
    required this.title,
    required this.ingredients,
    required this.steps,
    this.description,
    this.imagePath,
    required this.updatedAt,
    this.prepMinutes = 15,
    this.servings = 2,
    this.isHalal = true,
    this.isVegetarian = false,
    this.isVegan = false,
  });

  final String id;
  final String typeId;
  final String title;
  final String? description;
  final String? imagePath;
  final List<String> ingredients;
  final List<String> steps;
  final DateTime updatedAt;
  final int prepMinutes;
  final int servings;
  final bool isHalal;
  final bool isVegetarian;
  final bool isVegan;

  RecipeEntity copyWith({
    String? id,
    String? typeId,
    String? title,
    String? description,
    String? imagePath,
    List<String>? ingredients,
    List<String>? steps,
    DateTime? updatedAt,
    int? prepMinutes,
    int? servings,
    bool? isHalal,
    bool? isVegetarian,
    bool? isVegan,
  }) {
    return RecipeEntity(
      id: id ?? this.id,
      typeId: typeId ?? this.typeId,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      updatedAt: updatedAt ?? this.updatedAt,
      prepMinutes: prepMinutes ?? this.prepMinutes,
      servings: servings ?? this.servings,
      isHalal: isHalal ?? this.isHalal,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
    );
  }
}
