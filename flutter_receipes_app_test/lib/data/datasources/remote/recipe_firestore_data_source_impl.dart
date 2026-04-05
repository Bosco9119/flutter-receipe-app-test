import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/recipe_model.dart';
import 'recipe_firestore_data_source.dart';

class RecipeFirestoreDataSourceImpl implements RecipeFirestoreDataSource {
  RecipeFirestoreDataSourceImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _recipes(String ownerId) =>
      _db.collection('users').doc(ownerId).collection('recipes');

  RecipeModel _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Missing recipe document ${doc.id}');
    }
    final json = Map<String, dynamic>.from(data);
    json['id'] = doc.id;
    final ua = json['updatedAt'];
    if (ua is Timestamp) {
      json['updatedAt'] = ua.toDate().toUtc().toIso8601String();
    }
    return RecipeModel.fromJson(json);
  }

  @override
  Future<List<RecipeModel>> fetchRecipes(String ownerId) async {
    final snap = await _recipes(ownerId).get();
    return snap.docs.map(_fromDoc).toList();
  }

  @override
  Future<void> upsertRecipe(String ownerId, RecipeModel recipe) async {
    await _recipes(ownerId).doc(recipe.id).set(recipe.toJson());
  }

  @override
  Future<void> deleteRecipe(String ownerId, String recipeId) async {
    await _recipes(ownerId).doc(recipeId).delete();
  }
}
