// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Recipe Book';

  @override
  String get architecturePreview =>
      'Architecture layer is wired. Recipe flows will plug in here.';

  @override
  String get themeSection => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get recipes => 'Recipes';

  @override
  String get login => 'Log in';

  @override
  String get logout => 'Log out';

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get streamDemoTitle => 'Live recipe count (reactive stream)';

  @override
  String recipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipes',
      one: '1 recipe',
      zero: 'No recipes',
    );
    return '$_temp0';
  }

  @override
  String get myRecipes => 'My Recipes';

  @override
  String get myRecipesSubtitle => 'Discover and manage your favorite recipes';

  @override
  String get searchRecipesHint => 'Search recipes…';

  @override
  String get filterRecipes => 'Filter by type';

  @override
  String get allTypes => 'All Types';

  @override
  String get newRecipe => 'New Recipe';

  @override
  String recipesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipes found',
      one: '1 recipe found',
      zero: 'No recipes found',
    );
    return '$_temp0';
  }

  @override
  String prepTimeMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String servingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servings',
      one: '1 serving',
    );
    return '$_temp0';
  }

  @override
  String get createRecipeComingSoon =>
      'Create recipe screen will be added here — ingredients, steps, and photo picker hook into your MVVM layer next.';

  @override
  String get noRecipesMatch => 'No recipes match your search or filter.';
}
