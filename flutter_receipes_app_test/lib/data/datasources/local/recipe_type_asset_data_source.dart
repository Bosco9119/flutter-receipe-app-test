import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/recipe_type_model.dart';

abstract class RecipeTypeAssetDataSource {
  Future<List<RecipeTypeModel>> loadFromAsset();
}

class RecipeTypeAssetDataSourceImpl implements RecipeTypeAssetDataSource {
  RecipeTypeAssetDataSourceImpl({this.assetPath = 'assets/data/recipetypes.json'});

  final String assetPath;

  @override
  Future<List<RecipeTypeModel>> loadFromAsset() async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    return RecipeTypeModel.listFromDecoded(decoded);
  }
}
