import 'package:flutter/material.dart';

/// Grid sizing aligned with [RecipeListPage] without modifying that file.
int discoverGridColumnCount(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  if (w >= 1000) {
    return 3;
  }
  if (w >= 360) {
    return 2;
  }
  return 1;
}

/// Slightly wider/shorter tiles than [RecipeListPage] — discover cards only show title + blurb under the image.
double discoverGridChildAspectRatio(BuildContext context) {
  switch (discoverGridColumnCount(context)) {
    case 3:
      return 0.78;
    case 2:
      return 0.72;
    default:
      return 0.88;
  }
}
