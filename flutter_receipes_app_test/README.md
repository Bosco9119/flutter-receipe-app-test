# MyFoodJourney

A **Flutter** recipe management app built with **Dart**, following **MVVM**, **Material Design 3**, and clean layering. Recipes are stored locally with **Hive**, synced to **Firebase (Firestore)** for cloud backup, and the app integrates **TheMealDB** for discover/import flows. **Firebase Authentication** (including Google Sign-In) provides login and session handling with encrypted credential storage where applicable.

---

## Requirements coverage (assignment checklist)

| Requirement | Implementation |
|-------------|----------------|
| **Dart + Flutter** | Entire UI and logic in Dart on Flutter (`sdk: ^3.11.4`). |
| **Storage** | **Hive** (`hive` / `hive_flutter`) for JSON-backed recipe persistence per signed-in user; **SharedPreferences** for settings/session metadata; **Firestore** for optional cloud sync/restore. |
| **Recipe types from JSON** | `assets/data/recipetypes.json` drives types; UI uses a **dropdown** (and related filtering) aligned with that data. Remote fetch can override when networking is configured (`RecipeRemoteDataSource`). |
| **Sample recipes** | Bundled `assets/data/recipes.json` plus bootstrap logic so new accounts get sample data where applicable. |
| **Recipe list + filter** | List page with **search**, **type filter**, and **sort** (e.g. title, prep time). |
| **Create recipe** | Create flow with **image** (camera/gallery/network URL), **ingredients**, **steps**, and **recipe type**. |
| **Detail + CRUD** | Detail page shows image, ingredients, and steps; **edit** and **delete** supported. |
| **Material Design** | Material 3 themes, cards, dialogs, and responsive layouts. |
| **Persistence** | Recipes survive app restart via Hive; cloud sync optional via Firestore. |
| **Stability & layout** | Responsive patterns (e.g. wide vs narrow filter row), scrollable screens, no intentional overflow; test on small devices. |

### Bonus topics

| Bonus | How it is demonstrated |
|-------|-------------------------|
| **Reactive programming** | **Streams**: `RecipeLocalDataSource.watchRecipes()` feeds `RecipeListViewModel`; UI uses **`Provider` + `context.watch`** for binding. Auth/session streams where applicable. |
| **Architecture (MVVM + Provider)** | **Domain** (entities, repository contracts) → **Data** (models, Hive/Firestore/API) → **Presentation** (views + `ChangeNotifier` view models). **Provider** supplies view models at the widget tree. |
| **Authentication** | **Firebase Auth** + **Google Sign-In**; local demo path; session persistence via repository + preferences; **crypto** helpers for sensitive handling as implemented. |
| **Networking** | **HTTP** to **TheMealDB** (`TheMealDbRemoteDataSource`), mappers/transforms into domain models; optional **remote recipe types** URL; **Firestore** for cloud recipe documents. |
| **Dependency injection** | **GetIt** singleton/service locator (`lib/core/di/injection.dart`) registers data sources, repositories, and services once at startup. |
| **Tests** | **Unit tests** (e.g. crypto, bundled recipe JSON parser); **widget test** (login UI). Run with `flutter test`. |

---

## Architecture

- **MVVM**: Pages/widgets are mostly passive; **`ChangeNotifier` view models** (`lib/presentation/view_models/`) hold state and call repositories.
- **Layering**:
  - **`domain/`** — entities, repository interfaces (e.g. `RecipeRepository`, `AuthRepository`).
  - **`data/`** — models, Hive/Firestore/API data sources, repository implementations.
  - **`presentation/`** — pages, widgets, view models.
  - **`core/`** — DI, theme, security, constants.

This keeps UI testable and swaps (local vs cloud, asset vs network) behind interfaces.

---

## Main features (implemented)

- **Localization**: English, Malay, Chinese (Simplified) via ARB + `flutter gen-l10n`.
- **Appearance**: **Light / Dark / System** theme modes (persisted).
- **Discover**: Browse/shuffle meals from **TheMealDB**, map to app models, **save** into the user’s local recipe list.
- **Cloud**: **Firestore** sync/restore (compare local vs cloud, confirm in UI) for signed-in users with Firebase configured.
- **CRUD**: Full create, read, update, delete for recipes with validation and image handling (network URL, assets, or local file paths).

---

## Tech stack

| Area | Packages / services |
|------|---------------------|
| UI | `flutter`, `provider`, Material 3 |
| Local DB | `hive`, `hive_flutter` |
| DI | `get_it` |
| HTTP | `http` |
| Auth / cloud | `firebase_core`, `firebase_auth`, `google_sign_in`, `cloud_firestore` |
| Images | `image_picker`, `path_provider` |
| Security | `crypto`, `encrypt` |
| IDs | `uuid` |
| i18n | `intl`, `flutter_localizations` |

---

## Prerequisites

- **Flutter** SDK compatible with `sdk: ^3.11.4` (see `pubspec.yaml`).
- **Firebase**: For Google Sign-In / Firestore, add your own `firebase_options.dart` (FlutterFire) and platform configs (`google-services.json`, `GoogleService-Info.plist`) matching your Firebase project. The app initializes Firebase in `main.dart` when options exist.
- **TheMealDB**: Uses the public API (no key required for basic usage).

---

## Setup & build

```bash
cd flutter_receipes_app_test   # or your clone folder name
flutter pub get
flutter gen-l10n               # if ARB files changed
flutter analyze
flutter run
```

**Release build examples**

```bash
flutter build apk
# or
flutter build ios
```

Ensure Firebase files are in place before relying on auth or Firestore.

---

## Tests

```bash
flutter test
```

Includes unit tests under `test/unit/` and widget tests under `test/`.

---

## Project layout (abbreviated)

```
lib/
  app.dart                 # App root, providers
  main.dart                # Entry, Firebase init, DI
  core/                    # DI, theme, security
  domain/                  # Entities, repository abstractions
  data/                    # Hive, Firestore, API, repositories
  presentation/            # Pages, widgets, view models
  l10n/                    # ARB sources
assets/data/               # recipetypes.json, recipes.json, images
```

---

## Git hosting & deliverables

- Push this repository to a **public Git host** (GitHub, GitLab, etc.).
- Zip the project for submission if required; confirm **`flutter pub get`** and **`flutter build`** succeed on a clean machine with Flutter installed.

---

## Credits & API

- **TheMealDB** — [https://www.themealdb.com/](https://www.themealdb.com/) (community API; respect their terms of use).

---

## Author

Submission for **FOURTITUDE ASIA** — Flutter Application Developer assessment (202408).  
App product name: **MyFoodJourney**.
