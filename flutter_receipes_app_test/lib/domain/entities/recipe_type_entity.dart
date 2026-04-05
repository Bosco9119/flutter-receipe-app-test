import 'package:flutter/foundation.dart';

@immutable
class RecipeTypeEntity {
  const RecipeTypeEntity({
    required this.id,
    required this.name,
    this.description,
    this.icon,
  });

  final String id;
  final String name;
  final String? description;
  final String? icon;
}
