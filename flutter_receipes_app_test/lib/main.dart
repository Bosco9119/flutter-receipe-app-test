import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'data/bootstrap/recipe_bootstrap.dart' show ensureSampleRecipesSeededIfNeeded;
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stackTrace) {
    debugPrint('Firebase.initializeApp skipped or failed: $e');
    debugPrint('$stackTrace');
  }

  await configureDependencies();
  await ensureSampleRecipesSeededIfNeeded();
  runApp(const RecipeApp());
}
