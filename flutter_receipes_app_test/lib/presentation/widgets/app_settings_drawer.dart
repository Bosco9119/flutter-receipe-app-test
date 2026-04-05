import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../view_models/app_settings_view_model.dart';
import '../view_models/auth_view_model.dart';

class AppSettingsDrawer extends StatelessWidget {
  const AppSettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settings = context.watch<AppSettingsViewModel>();
    final auth = context.watch<AuthViewModel>();

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          children: [
            Text(
              l10n.settings,
              style: theme.textTheme.titleLarge,
            ),
            const Divider(),
            Text(
              l10n.themeSection,
              style: theme.textTheme.titleSmall,
            ),
            ListTile(
              title: Text(l10n.themeLight),
              selected: settings.themeMode == ThemeMode.light,
              onTap: () {
                settings.setThemeMode(ThemeMode.light);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(l10n.themeDark),
              selected: settings.themeMode == ThemeMode.dark,
              onTap: () {
                settings.setThemeMode(ThemeMode.dark);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(l10n.themeSystem),
              selected: settings.themeMode == ThemeMode.system,
              onTap: () {
                settings.setThemeMode(ThemeMode.system);
                Navigator.of(context).pop();
              },
            ),
            const Divider(),
            Text(
              l10n.language,
              style: theme.textTheme.titleSmall,
            ),
            ListTile(
              title: Text(l10n.english),
              selected: settings.locale.languageCode == 'en',
              onTap: () {
                settings.setLocale(const Locale('en'));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(l10n.indonesian),
              selected: settings.locale.languageCode == 'id',
              onTap: () {
                settings.setLocale(const Locale('id'));
                Navigator.of(context).pop();
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text(
                l10n.logout,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: () {
                Navigator.of(context).pop();
                auth.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
