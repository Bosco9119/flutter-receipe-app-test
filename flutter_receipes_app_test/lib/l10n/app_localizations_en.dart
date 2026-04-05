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
  String get malay => 'Malay';

  @override
  String get chinese => 'Chinese (Simplified)';

  @override
  String get recipes => 'Recipes';

  @override
  String get login => 'Log in';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginDemoHint => 'Hint: demo / demo';

  @override
  String get loginOrDivider => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get googleSignInFailed =>
      'Google sign-in failed. Check Firebase configuration and try again.';

  @override
  String get logout => 'Log out';

  @override
  String get settings => 'Settings';

  @override
  String get settingsDrawerLocalOnly =>
      'Local sign-in (no Gmail on this account)';

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
  String get sortRecipesTooltip => 'Sort recipes';

  @override
  String get sortSheetTitle => 'Sort by';

  @override
  String get sortTitleAZ => 'Title A–Z';

  @override
  String get sortTitleZA => 'Title Z–A';

  @override
  String get sortPrepShortFirst => 'Prep time (shortest first)';

  @override
  String get sortPrepLongFirst => 'Prep time (longest first)';

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
  String get recipeDescriptionLabel => 'Description';

  @override
  String get recipeDescriptionHint =>
      'Optional short summary (like bundled recipes.json).';

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

  @override
  String get settingsCloudBackupSection => 'Cloud backup';

  @override
  String get settingsSyncToCloud => 'Sync to cloud';

  @override
  String get settingsRestoreFromCloud => 'Restore from cloud';

  @override
  String get cloudSyncRequiresGoogle =>
      'Sign in with Google to use cloud backup.';

  @override
  String get cloudSyncDialogTitle => 'Sync to cloud';

  @override
  String get cloudSyncDialogSubtitle =>
      'Cloud will match your device: uploads, updates, and removes extra cloud recipes.';

  @override
  String get cloudRestoreDialogTitle => 'Restore from cloud';

  @override
  String get cloudRestoreDialogSubtitle =>
      'Device will match the cloud: downloads, updates, and removes extra local recipes.';

  @override
  String get cloudDiffLoading => 'Comparing device and cloud…';

  @override
  String get cloudDiffOnlyOnDeviceSync =>
      'Only on device — will upload to cloud';

  @override
  String get cloudDiffOnlyInCloudSync =>
      'Only in cloud — will be removed from cloud';

  @override
  String get cloudDiffOnBothSync =>
      'On both — cloud copy will be replaced from device';

  @override
  String get cloudDiffOnlyOnDeviceRestore =>
      'Only on device — will be removed from device';

  @override
  String get cloudDiffOnlyInCloudRestore =>
      'Only in cloud — will be downloaded to device';

  @override
  String get cloudDiffOnBothRestore =>
      'On both — device copy will be replaced from cloud';

  @override
  String get cloudSyncRunConfirm => 'Apply sync';

  @override
  String get cloudRestoreRunConfirm => 'Apply restore';

  @override
  String get cloudBackupCancel => 'Cancel';

  @override
  String get cloudBackupDone => 'Cloud backup updated.';

  @override
  String get cloudRestoreDone => 'Restored from cloud.';

  @override
  String get cloudNoRecipesInSection => 'None';

  @override
  String get settingsDiscoverSection => 'Explore';

  @override
  String get drawerDiscoverRecipes => 'Discover random recipes';

  @override
  String get discoverRecipesTitle => 'Discover recipes';

  @override
  String get discoverRecipesSubtitle => 'Random meals from TheMealDB';

  @override
  String get discoverLoadTenButton => 'Load 10 random recipes';

  @override
  String discoverFetchProgress(int done, int total) {
    return '$done of $total requests completed';
  }

  @override
  String get discoverEmptyHint =>
      'Tap the button above to load ten random meals from TheMealDB (one request at a time).';

  @override
  String get discoverErrorAllFailed =>
      'Every request failed. Check your connection and try again.';

  @override
  String get discoverErrorNoRecipes => 'No recipes were returned. Try again.';

  @override
  String discoverSomeRequestsFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requests failed',
      one: '1 request failed',
    );
    return '$_temp0';
  }

  @override
  String get discoverPrepOnImport => 'Set prep time when you save';

  @override
  String get discoverServingsOnImport => 'Set servings when you save';

  @override
  String get discoverUnknownCategory => 'TheMealDB';

  @override
  String get discoverBackToList => 'Back to discover';

  @override
  String get discoverDetailImportCta => 'Add to my recipes';

  @override
  String get importRecipeTitle => 'Add to my recipes';

  @override
  String get importRecipeSavedMessage => 'Recipe added to your collection.';
}
