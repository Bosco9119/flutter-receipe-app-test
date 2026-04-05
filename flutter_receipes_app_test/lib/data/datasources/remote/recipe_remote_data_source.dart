import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/recipe_type_model.dart';

/// Optional network source for recipe types (self-hosted JSON, CMS, etc.).
abstract class RecipeRemoteDataSource {
  Future<List<RecipeTypeModel>> fetchRecipeTypes();
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  RecipeRemoteDataSourceImpl({
    http.Client? client,
    this.typesUrl,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  /// When null, remote fetch is skipped and the repository falls back to assets.
  final Uri? typesUrl;

  @override
  Future<List<RecipeTypeModel>> fetchRecipeTypes() async {
    final url = typesUrl;
    if (url == null) {
      return [];
    }
    final response = await _client.get(url);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load recipe types (${response.statusCode})');
    }
    final decoded = jsonDecode(response.body);
    return RecipeTypeModel.listFromDecoded(decoded);
  }
}
