# MyFoodJourney

A Flutter recipe management app built with Dart, following MVVM architecture, Material Design 3, and clean layered structure.

Recipes are stored locally using Hive, with optional Firebase (Firestore) cloud synchronization. The app integrates TheMealDB API to discover and import new recipes, and supports Firebase Authentication (Google Sign-In) for user login and session management.

# Features
## Recipe Management
Create, edit, and delete recipes
Recipe detail view with ingredients and steps
Add images via camera, gallery, or network URL
Dynamic ingredient and step lists
Recipe filtering and search
Sorting by title or preparation time

## Import Recipes
Discover meals from TheMealDB API
Convert external recipe data to internal recipe model
Save imported recipes into the user’s local recipe collection

## Authentication
Firebase Authentication
Google Sign-In
Session persistence

## Localization
Supports multiple languages using Flutter localization:
English
Malay
Chinese (Simplified)

## Appearance
Light theme
Dark theme
System theme mode

## Data Persistence
Local storage with Hive
Optional Firestore cloud sync / restore

## Architecture
Presentation Layer
   ↓
ViewModels (ChangeNotifier)
   ↓
Domain Layer (Entities + Repositories)
   ↓
Data Layer (Hive / Firestore / API)

## Project Structure
lib/
  main.dart
  app.dart
  core/
  data/
  domain/
  presentation/
  l10n/

assets/
  data/
    recipes.json
    recipetypes.json


## Technologies Used
| Area                 | Technology                     |
| -------------------- | ------------------------------ |
| UI Framework         | Flutter                        |
| Language             | Dart                           |
| State Management     | Provider                       |
| Local Database       | Hive                           |
| Dependency Injection | GetIt                          |
| Networking           | HTTP                           |
| Authentication       | Firebase Auth + Google Sign-In |
| Cloud Database       | Firestore                      |
| Image Handling       | Image Picker                   |
| Security             | crypto, encrypt                |
| Localization         | intl, flutter_localizations    |

## Bonus Features Implemented
Reactive Programming
-Hive reactive streams
-Provider with context.watch() for UI updates
Networking Integration
-TheMealDB API integration
-Data transformation to internal recipe model
Dependency Injection
-GetIt used for registering services and repositories

## Testing:
Unit tests
Widget tests

## External API
This project uses the public TheMealDB API
https://www.themealdb.com/

## Author
Submission for FOURTITUDE ASIA – Flutter Application Developer Assessment
Application name: MyFoodJourney

## Screenshots

### Login Screen
![Login](screenshots/login.jpeg)

### Recipe List
![Recipe List](screenshots/recipe_list.jpeg)

### Recipe List Dark
![Recipe List](screenshots/recipe_list_dark.jpeg)

### Recipe Detail
![Recipe Detail](screenshots/recipe_detail.png)

### Create Recipe
![Create Recipe](screenshots/create_recipe.jpeg)

### Import Recipe from API
![Import Recipe](screenshots/import_recipe.jpeg)

### Setting Drawer
![Import Recipe](screenshots/setting_drawer.jpeg)

### Sort By
![Import Recipe](screenshots/sort.jpeg)
