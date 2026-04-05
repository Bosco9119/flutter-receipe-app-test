import '../../domain/entities/recipe_entity.dart';

class RecipeModel {
  const RecipeModel({
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

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String,
      typeId: json['typeId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imagePath: json['imagePath'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>).cast<String>(),
      steps: (json['steps'] as List<dynamic>).cast<String>(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      prepMinutes: (json['prepMinutes'] as num?)?.toInt() ?? 15,
      servings: (json['servings'] as num?)?.toInt() ?? 2,
      isHalal: json['isHalal'] as bool? ?? true,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'typeId': typeId,
        'title': title,
        if (description != null) 'description': description,
        'imagePath': imagePath,
        'ingredients': ingredients,
        'steps': steps,
        'updatedAt': updatedAt.toIso8601String(),
        'prepMinutes': prepMinutes,
        'servings': servings,
        'isHalal': isHalal,
        'isVegetarian': isVegetarian,
        'isVegan': isVegan,
      };

  factory RecipeModel.fromEntity(RecipeEntity entity) {
    return RecipeModel(
      id: entity.id,
      typeId: entity.typeId,
      title: entity.title,
      description: entity.description,
      imagePath: entity.imagePath,
      ingredients: List<String>.from(entity.ingredients),
      steps: List<String>.from(entity.steps),
      updatedAt: entity.updatedAt,
      prepMinutes: entity.prepMinutes,
      servings: entity.servings,
      isHalal: entity.isHalal,
      isVegetarian: entity.isVegetarian,
      isVegan: entity.isVegan,
    );
  }

  RecipeEntity toEntity() {
    return RecipeEntity(
      id: id,
      typeId: typeId,
      title: title,
      description: description,
      imagePath: imagePath,
      ingredients: List<String>.from(ingredients),
      steps: List<String>.from(steps),
      updatedAt: updatedAt,
      prepMinutes: prepMinutes,
      servings: servings,
      isHalal: isHalal,
      isVegetarian: isVegetarian,
      isVegan: isVegan,
    );
  }
}
