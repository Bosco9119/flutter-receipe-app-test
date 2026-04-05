import 'package:flutter/foundation.dart';

import 'recipe_entity.dart';

/// Result of comparing local recipes vs Firestore for one user.
@immutable
class RecipeCloudDiff {
  const RecipeCloudDiff({
    required this.localOnly,
    required this.cloudOnly,
    required this.inBoth,
  });

  /// Present locally, not in cloud.
  final List<RecipeEntity> localOnly;

  /// Present in cloud, not locally.
  final List<RecipeEntity> cloudOnly;

  /// Same id in both (payload may differ).
  final List<RecipeEntity> inBoth;

  static RecipeCloudDiff compute(
    List<RecipeEntity> local,
    List<RecipeEntity> cloud,
  ) {
    final localMap = {for (final r in local) r.id: r};
    final cloudMap = {for (final r in cloud) r.id: r};
    final localOnly = <RecipeEntity>[];
    final cloudOnly = <RecipeEntity>[];
    final inBoth = <RecipeEntity>[];
    for (final r in local) {
      if (cloudMap.containsKey(r.id)) {
        inBoth.add(r);
      } else {
        localOnly.add(r);
      }
    }
    for (final r in cloud) {
      if (!localMap.containsKey(r.id)) {
        cloudOnly.add(r);
      }
    }
    return RecipeCloudDiff(
      localOnly: localOnly,
      cloudOnly: cloudOnly,
      inBoth: inBoth,
    );
  }
}
