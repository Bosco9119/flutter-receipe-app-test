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
  String get noRecipesMatch => 'No recipes match your search or filter.';

  @override
  String get backToRecipes => 'Back to Recipes';

  @override
  String get createRecipeTitle => 'Create New Recipe';

  @override
  String get recipeTitleLabel => 'Recipe title *';

  @override
  String get recipeTypeLabel => 'Recipe type *';

  @override
  String get selectRecipeTypeHint => 'Select a type';

  @override
  String get prepTimeLabel => 'Prep time *';

  @override
  String get prepTimeHint => 'e.g. 30 or 30 minutes';

  @override
  String get servingsLabel => 'Servings *';

  @override
  String get servingsHint => 'e.g. 4';

  @override
  String get prepTimeInvalid =>
      'Enter a prep time with a number (e.g. 15 or 20 min).';

  @override
  String get servingsInvalid => 'Enter a whole number ≥ 1.';

  @override
  String get fieldRequired => 'Required';

  @override
  String get recipePhotoLabel => 'Recipe photo';

  @override
  String get recipePhotoHelper =>
      'Optional. Choose from gallery or camera on your phone. If you skip, the default image is used.';

  @override
  String get recipePhotoWebNote =>
      'Photo picker runs on mobile and desktop apps. Here the default image will be used unless you build for a platform with gallery/camera.';

  @override
  String get pickFromGallery => 'Gallery';

  @override
  String get takePhoto => 'Camera';

  @override
  String get clearPhoto => 'Remove photo';

  @override
  String get ingredientsSectionLabel => 'Ingredients *';

  @override
  String get addIngredient => '+ Add ingredient';

  @override
  String ingredientHint(int n) {
    return 'Ingredient $n';
  }

  @override
  String get stepsSectionLabel => 'Steps *';

  @override
  String get addStep => '+ Add step';

  @override
  String stepHint(int n) {
    return 'Step $n';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get dialogConfirm => 'Confirm';

  @override
  String get createRecipeSubmit => 'Create recipe';

  @override
  String get createRecipeFailed => 'Could not save recipe.';

  @override
  String get recipeTypeRequired => 'Choose a recipe type.';

  @override
  String get ingredientsRequired => 'Add at least one ingredient.';

  @override
  String get stepsRequired => 'Add at least one step.';

  @override
  String get recipeNotFound => 'Recipe not found';

  @override
  String get recipeNotFoundMessage =>
      'This recipe may have been deleted or is no longer available.';

  @override
  String get editRecipe => 'Edit';

  @override
  String get deleteRecipe => 'Delete';

  @override
  String get deleteRecipeTitle => 'Delete recipe?';

  @override
  String get deleteRecipeMessage =>
      'This cannot be undone. The recipe will be removed from your device.';

  @override
  String get deleteRecipeConfirm => 'Delete';

  @override
  String get deleteRecipeFailed => 'Could not delete recipe.';

  @override
  String get ingredientsHeading => 'Ingredients';

  @override
  String get instructionsHeading => 'Instructions';

  @override
  String get recipeUpdated => 'Recipe updated.';

  @override
  String get editRecipeTitle => 'Edit recipe';

  @override
  String get saveRecipeChanges => 'Save changes';
}
