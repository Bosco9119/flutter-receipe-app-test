import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'presentation/view_models/app_settings_view_model.dart';
import 'presentation/view_models/auth_view_model.dart';
import 'presentation/view_models/recipe_list_view_model.dart';
import 'presentation/views/login_page.dart';
import 'presentation/views/recipe_list_page.dart';

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppSettingsViewModel(sl()),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(sl()),
        ),
        ChangeNotifierProvider(
          create: (_) {
            final vm = RecipeListViewModel(sl(), sl());
            unawaited(vm.initialize());
            return vm;
          },
        ),
      ],
      child: const _RecipeAppView(),
    );
  }
}

class _RecipeAppView extends StatelessWidget {
  const _RecipeAppView();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsViewModel>();
    final auth = context.watch<AuthViewModel>();

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      locale: settings.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: auth.isAuthenticated
          ? const RecipeListPage()
          : const LoginPage(),
    );
  }
}
