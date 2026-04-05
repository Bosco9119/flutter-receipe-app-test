import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Recipe Book'**
  String get appTitle;

  /// No description provided for @architecturePreview.
  ///
  /// In en, this message translates to:
  /// **'Architecture layer is wired. Recipe flows will plug in here.'**
  String get architecturePreview;

  /// No description provided for @themeSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get themeSection;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// No description provided for @recipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipes;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @loginUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsernameLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginDemoHint.
  ///
  /// In en, this message translates to:
  /// **'Hint: demo / demo'**
  String get loginDemoHint;

  /// No description provided for @loginOrDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get loginOrDivider;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Check Firebase configuration and try again.'**
  String get googleSignInFailed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @streamDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'Live recipe count (reactive stream)'**
  String get streamDemoTitle;

  /// No description provided for @recipeCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No recipes}=1{1 recipe}other{{count} recipes}}'**
  String recipeCount(int count);

  /// No description provided for @myRecipes.
  ///
  /// In en, this message translates to:
  /// **'My Recipes'**
  String get myRecipes;

  /// No description provided for @myRecipesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover and manage your favorite recipes'**
  String get myRecipesSubtitle;

  /// No description provided for @searchRecipesHint.
  ///
  /// In en, this message translates to:
  /// **'Search recipes…'**
  String get searchRecipesHint;

  /// No description provided for @filterRecipes.
  ///
  /// In en, this message translates to:
  /// **'Filter by type'**
  String get filterRecipes;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypes;

  /// No description provided for @newRecipe.
  ///
  /// In en, this message translates to:
  /// **'New Recipe'**
  String get newRecipe;

  /// No description provided for @recipesFound.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No recipes found}=1{1 recipe found}other{{count} recipes found}}'**
  String recipesFound(int count);

  /// No description provided for @prepTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute}other{{minutes} minutes}}'**
  String prepTimeMinutes(int minutes);

  /// No description provided for @servingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 serving}other{{count} servings}}'**
  String servingsCount(int count);

  /// No description provided for @noRecipesMatch.
  ///
  /// In en, this message translates to:
  /// **'No recipes match your search or filter.'**
  String get noRecipesMatch;

  /// No description provided for @backToRecipes.
  ///
  /// In en, this message translates to:
  /// **'Back to Recipes'**
  String get backToRecipes;

  /// No description provided for @createRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Recipe'**
  String get createRecipeTitle;

  /// No description provided for @recipeTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipe title *'**
  String get recipeTitleLabel;

  /// No description provided for @recipeTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipe type *'**
  String get recipeTypeLabel;

  /// No description provided for @selectRecipeTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select a type'**
  String get selectRecipeTypeHint;

  /// No description provided for @prepTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Prep time *'**
  String get prepTimeLabel;

  /// No description provided for @prepTimeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 30 or 30 minutes'**
  String get prepTimeHint;

  /// No description provided for @servingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Servings *'**
  String get servingsLabel;

  /// No description provided for @servingsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 4'**
  String get servingsHint;

  /// No description provided for @prepTimeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a prep time with a number (e.g. 15 or 20 min).'**
  String get prepTimeInvalid;

  /// No description provided for @servingsInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number ≥ 1.'**
  String get servingsInvalid;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// No description provided for @recipePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipe photo'**
  String get recipePhotoLabel;

  /// No description provided for @recipePhotoHelper.
  ///
  /// In en, this message translates to:
  /// **'Optional. Choose from gallery or camera on your phone. If you skip, the default image is used.'**
  String get recipePhotoHelper;

  /// No description provided for @recipePhotoWebNote.
  ///
  /// In en, this message translates to:
  /// **'Photo picker runs on mobile and desktop apps. Here the default image will be used unless you build for a platform with gallery/camera.'**
  String get recipePhotoWebNote;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get pickFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get takePhoto;

  /// No description provided for @clearPhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get clearPhoto;

  /// No description provided for @ingredientsSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Ingredients *'**
  String get ingredientsSectionLabel;

  /// No description provided for @addIngredient.
  ///
  /// In en, this message translates to:
  /// **'+ Add ingredient'**
  String get addIngredient;

  /// No description provided for @ingredientHint.
  ///
  /// In en, this message translates to:
  /// **'Ingredient {n}'**
  String ingredientHint(int n);

  /// No description provided for @stepsSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps *'**
  String get stepsSectionLabel;

  /// No description provided for @addStep.
  ///
  /// In en, this message translates to:
  /// **'+ Add step'**
  String get addStep;

  /// No description provided for @stepHint.
  ///
  /// In en, this message translates to:
  /// **'Step {n}'**
  String stepHint(int n);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @dialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dialogConfirm;

  /// No description provided for @createRecipeSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create recipe'**
  String get createRecipeSubmit;

  /// No description provided for @createRecipeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save recipe.'**
  String get createRecipeFailed;

  /// No description provided for @recipeTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a recipe type.'**
  String get recipeTypeRequired;

  /// No description provided for @ingredientsRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least one ingredient.'**
  String get ingredientsRequired;

  /// No description provided for @stepsRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least one step.'**
  String get stepsRequired;

  /// No description provided for @recipeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Recipe not found'**
  String get recipeNotFound;

  /// No description provided for @recipeNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'This recipe may have been deleted or is no longer available.'**
  String get recipeNotFoundMessage;

  /// No description provided for @editRecipe.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editRecipe;

  /// No description provided for @deleteRecipe.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteRecipe;

  /// No description provided for @deleteRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete recipe?'**
  String get deleteRecipeTitle;

  /// No description provided for @deleteRecipeMessage.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. The recipe will be removed from your device.'**
  String get deleteRecipeMessage;

  /// No description provided for @deleteRecipeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteRecipeConfirm;

  /// No description provided for @deleteRecipeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete recipe.'**
  String get deleteRecipeFailed;

  /// No description provided for @ingredientsHeading.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredientsHeading;

  /// No description provided for @instructionsHeading.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructionsHeading;

  /// No description provided for @recipeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Recipe updated.'**
  String get recipeUpdated;

  /// No description provided for @editRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit recipe'**
  String get editRecipeTitle;

  /// No description provided for @saveRecipeChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveRecipeChanges;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
