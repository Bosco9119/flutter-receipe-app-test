import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/local/recipe_local_data_source.dart';
import '../../data/datasources/local/recipe_type_asset_data_source.dart';
import '../../data/datasources/remote/firebase_identity_data_source.dart';
import '../../data/datasources/remote/firebase_identity_data_source_impl.dart';
import '../../data/datasources/remote/recipe_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../security/crypto_service.dart';

final GetIt sl = GetIt.instance;

/// Registers application-wide dependencies (data sources, repositories, services).
///
/// [remoteRecipeTypesUrl] enables the networking bonus path; when null, assets are used.
Future<void> configureDependencies({Uri? remoteRecipeTypesUrl}) async {
  final preferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(preferences);

  sl.registerLazySingleton<CryptoService>(CryptoService.new);

  sl.registerLazySingleton<FirebaseIdentityDataSource>(
    FirebaseIdentityDataSourceImpl.new,
  );

  await Hive.initFlutter();
  final recipeBox = await Hive.openBox<String>('recipe_app_storage');
  sl.registerSingleton<Box<String>>(recipeBox);

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      preferences: sl(),
      crypto: sl(),
      firebaseIdentity: sl(),
    ),
  );

  sl.registerLazySingleton<RecipeLocalDataSource>(
    () => RecipeLocalDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<RecipeTypeAssetDataSource>(
    RecipeTypeAssetDataSourceImpl.new,
  );
  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(
      typesUrl: remoteRecipeTypesUrl,
    ),
  );
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(
      local: sl(),
      typeAsset: sl(),
      remoteTypes: sl(),
    ),
  );
}
