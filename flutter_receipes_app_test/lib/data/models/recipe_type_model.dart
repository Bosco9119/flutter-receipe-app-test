import '../../domain/entities/recipe_type_entity.dart';

class RecipeTypeModel {
  const RecipeTypeModel({
    required this.id,
    required this.name,
    this.description,
    this.icon,
  });

  final String id;
  final String name;
  final String? description;
  final String? icon;

  factory RecipeTypeModel.fromJson(Map<String, dynamic> json) {
    return RecipeTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );
  }

  /// Parses API/asset payloads: either `{ "recipeTypes": [...] }` or a raw `[...]` list.
  static List<RecipeTypeModel> listFromDecoded(dynamic decoded) {
    final List<dynamic> list;
    if (decoded is List<dynamic>) {
      list = decoded;
    } else if (decoded is Map<String, dynamic>) {
      final types = decoded['recipeTypes'];
      if (types is! List<dynamic>) {
        throw const FormatException('Expected "recipeTypes" array in recipe types JSON');
      }
      list = types;
    } else {
      throw const FormatException('Invalid recipe types JSON root');
    }
    return list
        .map((e) => RecipeTypeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (description != null) 'description': description,
        if (icon != null) 'icon': icon,
      };

  RecipeTypeEntity toEntity() => RecipeTypeEntity(
        id: id,
        name: name,
        description: description,
        icon: icon,
      );
}
