import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'data/bootstrap/recipe_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await ensureSampleRecipesSeeded();
  runApp(const RecipeApp());
}
