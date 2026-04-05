import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/cloud_sync_mode.dart';
import '../../domain/entities/recipe_owner_id.dart';
import '../../l10n/app_localizations.dart';
import '../view_models/app_settings_view_model.dart';
import '../view_models/auth_view_model.dart';
import 'recipe_cloud_sync_dialog.dart';

class AppSettingsDrawer extends StatelessWidget {
  const AppSettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final settings = context.watch<AppSettingsViewModel>();
    final auth = context.watch<AuthViewModel>();
    final session = auth.session;
    final cloudEligible =
        session != null && sessionEligibleForCloudSync(session);

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
            if (session != null) ...[
              _DrawerUserProfile(
                session: session,
                l10n: l10n,
                scheme: scheme,
                theme: theme,
              ),
              const Divider(),
            ],
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
            Text(
              l10n.settingsCloudBackupSection,
              style: theme.textTheme.titleSmall,
            ),
            ListTile(
              leading: Icon(
                Icons.cloud_upload_outlined,
                color: cloudEligible ? scheme.primary : scheme.onSurfaceVariant,
              ),
              title: Text(l10n.settingsSyncToCloud),
              subtitle: cloudEligible
                  ? null
                  : Text(
                      l10n.cloudSyncRequiresGoogle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
              enabled: cloudEligible,
              onTap: cloudEligible
                  ? () {
                      Navigator.of(context).pop();
                      showRecipeCloudBackupDialog(
                        context,
                        session,
                        CloudSyncMode.sync,
                      );
                    }
                  : null,
            ),
            ListTile(
              leading: Icon(
                Icons.cloud_download_outlined,
                color: cloudEligible ? scheme.primary : scheme.onSurfaceVariant,
              ),
              title: Text(l10n.settingsRestoreFromCloud),
              subtitle: cloudEligible
                  ? null
                  : Text(
                      l10n.cloudSyncRequiresGoogle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
              enabled: cloudEligible,
              onTap: cloudEligible
                  ? () {
                      Navigator.of(context).pop();
                      showRecipeCloudBackupDialog(
                        context,
                        session,
                        CloudSyncMode.restore,
                      );
                    }
                  : null,
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

class _DrawerUserProfile extends StatelessWidget {
  const _DrawerUserProfile({
    required this.session,
    required this.l10n,
    required this.scheme,
    required this.theme,
  });

  final AuthSessionEntity session;
  final AppLocalizations l10n;
  final ColorScheme scheme;
  final ThemeData theme;

  static String _initials(AuthSessionEntity s) {
    final src = (s.displayName?.trim().isNotEmpty ?? false)
        ? s.displayName!
        : s.username;
    final t = src.trim();
    if (t.isEmpty) {
      return '?';
    }
    return t.length >= 2 ? t.substring(0, 2).toUpperCase() : t.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final photo = session.photoUrl?.trim();
    final networkUrl = (photo != null &&
            photo.isNotEmpty &&
            photo.startsWith('http'))
        ? photo
        : null;
    final email = session.email?.trim();
    final hasEmail = email != null && email.isNotEmpty;
    final displayName = session.displayName?.trim();
    final hasDisplay = displayName != null && displayName.isNotEmpty;

    /// Gmail-first when available; demo uses username + localized hint.
    final String primaryLine;
    final String? secondaryLine;
    if (hasEmail) {
      primaryLine = email;
      secondaryLine =
          (hasDisplay && displayName != email) ? displayName : null;
    } else {
      primaryLine = session.username;
      secondaryLine = l10n.settingsDrawerLocalOnly;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: scheme.primaryContainer,
            child: ClipOval(
              child: networkUrl != null
                  ? Image.network(
                      networkUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _fallbackAvatar(scheme),
                    )
                  : _fallbackAvatar(scheme),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryLine,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (secondaryLine != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    secondaryLine,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackAvatar(ColorScheme scheme) {
    return Container(
      width: 64,
      height: 64,
      color: scheme.primaryContainer,
      alignment: Alignment.center,
      child: Text(
        _initials(session),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
