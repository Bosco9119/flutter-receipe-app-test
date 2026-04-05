import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/cloud_sync_mode.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/recipe_cloud_sync_repository.dart';
import '../../l10n/app_localizations.dart';
import '../view_models/recipe_cloud_sync_view_model.dart';

/// Shows local vs cloud diff, then runs sync or restore on confirm.
Future<void> showRecipeCloudBackupDialog(
  BuildContext context,
  AuthSessionEntity session,
  CloudSyncMode mode,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return ChangeNotifierProvider(
        create: (_) {
          final vm = RecipeCloudSyncViewModel(
            sl<RecipeCloudSyncRepository>(),
            session,
            mode,
          );
          Future<void>.microtask(vm.loadComparison);
          return vm;
        },
        child: _RecipeCloudBackupDialogBody(mode: mode),
      );
    },
  );
}

class _RecipeCloudBackupDialogBody extends StatelessWidget {
  const _RecipeCloudBackupDialogBody({required this.mode});

  final CloudSyncMode mode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final vm = context.watch<RecipeCloudSyncViewModel>();

    final title = mode == CloudSyncMode.sync
        ? l10n.cloudSyncDialogTitle
        : l10n.cloudRestoreDialogTitle;
    final subtitle = mode == CloudSyncMode.sync
        ? l10n.cloudSyncDialogSubtitle
        : l10n.cloudRestoreDialogSubtitle;

    final isSync = mode == CloudSyncMode.sync;
    final headerIcon = isSync ? Icons.cloud_upload_rounded : Icons.cloud_download_rounded;
    final headerGradient = [
      scheme.primaryContainer,
      Color.lerp(scheme.primaryContainer, scheme.primary, 0.5)!
          .withValues(alpha: isSync ? 0.95 : 0.88),
    ];

    final maxDialogHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400, maxHeight: maxDialogHeight),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: headerGradient,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: scheme.shadow.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        headerIcon,
                        size: 32,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  scheme.onSurface.withValues(alpha: 0.72),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: vm.loading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 48,
                              width: 48,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: scheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.cloudDiffLoading,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (vm.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Material(
                                color: scheme.errorContainer
                                    .withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.error_outline_rounded,
                                        size: 22,
                                        color: scheme.error,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          vm.errorMessage!,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: scheme.onErrorContainer,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (vm.diff != null) ...[
                            _DiffSection(
                              icon: Icons.smartphone_rounded,
                              iconBackground: scheme.primaryContainer,
                              iconColor: scheme.onPrimaryContainer,
                              title: isSync
                                  ? l10n.cloudDiffOnlyOnDeviceSync
                                  : l10n.cloudDiffOnlyOnDeviceRestore,
                              recipes: vm.diff!.localOnly,
                              theme: theme,
                              l10n: l10n,
                            ),
                            const SizedBox(height: 10),
                            _DiffSection(
                              icon: Icons.cloud_rounded,
                              iconBackground: scheme.tertiaryContainer,
                              iconColor: scheme.onTertiaryContainer,
                              title: isSync
                                  ? l10n.cloudDiffOnlyInCloudSync
                                  : l10n.cloudDiffOnlyInCloudRestore,
                              recipes: vm.diff!.cloudOnly,
                              theme: theme,
                              l10n: l10n,
                            ),
                            const SizedBox(height: 10),
                            _DiffSection(
                              icon: Icons.sync_alt_rounded,
                              iconBackground: scheme.secondaryContainer,
                              iconColor: scheme.onSecondaryContainer,
                              title: isSync
                                  ? l10n.cloudDiffOnBothSync
                                  : l10n.cloudDiffOnBothRestore,
                              recipes: vm.diff!.inBoth,
                              theme: theme,
                              l10n: l10n,
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: vm.applying
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(l10n.cloudBackupCancel),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: (vm.loading || vm.diff == null || vm.applying)
                        ? null
                        : () async {
                            final ok = await vm.apply();
                            if (!context.mounted) {
                              return;
                            }
                            if (ok) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  content: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          isSync
                                              ? l10n.cloudBackupDone
                                              : l10n.cloudRestoreDone,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: vm.applying
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.onPrimary,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSync
                                    ? Icons.cloud_upload_rounded
                                    : Icons.cloud_download_rounded,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isSync
                                    ? l10n.cloudSyncRunConfirm
                                    : l10n.cloudRestoreRunConfirm,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiffSection extends StatelessWidget {
  const _DiffSection({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.recipes,
    required this.theme,
    required this.l10n,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final List<RecipeEntity> recipes;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${recipes.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (recipes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.remove_circle_outline_rounded,
                      size: 18,
                      color: scheme.outline,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.cloudNoRecipesInSection,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...recipes.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.restaurant_menu_rounded,
                        size: 16,
                        color: scheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          r.title,
                          style: theme.textTheme.bodySmall?.copyWith(
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
