import 'dart:async';
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/storage_keys.dart';
import '../../models/recipe_model.dart';

abstract class RecipeLocalDataSource {
  Stream<List<RecipeModel>> watchRecipes();

  Future<List<RecipeModel>> readRecipes();

  Future<void> writeRecipes(List<RecipeModel> recipes);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  RecipeLocalDataSourceImpl(this._box);

  final Box<String> _box;

  List<RecipeModel> _decode(String? raw) {
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String _encode(List<RecipeModel> recipes) {
    return jsonEncode(recipes.map((e) => e.toJson()).toList());
  }

  @override
  Future<List<RecipeModel>> readRecipes() async {
    return _decode(_box.get(StorageKeys.recipesJson));
  }

  @override
  Future<void> writeRecipes(List<RecipeModel> recipes) async {
    await _box.put(StorageKeys.recipesJson, _encode(recipes));
  }

  @override
  Stream<List<RecipeModel>> watchRecipes() {
    return Stream<List<RecipeModel>>.multi((controller) {
      Future<void> emit() async {
        controller.add(await readRecipes());
      }

      emit();
      final sub = _box.watch(key: StorageKeys.recipesJson).listen((_) {
        emit();
      });
      controller.onCancel = () => sub.cancel();
    });
  }
}
