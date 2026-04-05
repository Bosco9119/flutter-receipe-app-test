import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_gradients.dart';
import '../../domain/entities/discover_meal_entity.dart';
import '../../domain/entities/the_meal_db_import_prefill.dart';
import '../../l10n/app_localizations.dart';
import '../view_models/recipe_create_view_model.dart';
import '../widgets/recipe_image_fill.dart';
import 'recipe_create_page.dart';

class DiscoverMealDetailPage extends StatelessWidget {
  const DiscoverMealDetailPage({super.key, required this.meal});

  final DiscoverMealEntity meal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final badge = meal.badgeLabel.trim().isNotEmpty
        ? meal.badgeLabel
        : l10n.discoverUnknownCategory;

    final numberedSteps = <MapEntry<int, String>>[];
    var stepNum = 0;
    for (final s in meal.steps) {
      final t = s.trim();
      if (t.isEmpty) {
        continue;
      }
      stepNum++;
      numberedSteps.add(MapEntry(stepNum, t));
    }

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppGradients.warmHeaderBanner(scheme),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.paddingOf(context).top + 12,
                16,
                16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(2, 8, 10, 8),
                    ),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    tooltip: l10n.discoverBackToList,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        meal.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          height: 1.12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 720,
                        minHeight: constraints.maxHeight - 32,
                      ),
                      child: Card(
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 10,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  RecipeImageFill(imagePath: meal.imageUrl),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Material(
                                      color: scheme.surface.withValues(
                                        alpha: 0.94,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        child: Text(
                                          badge,
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.schedule_outlined,
                                    size: 22,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      l10n.discoverPrepOnImport,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1, color: scheme.outlineVariant),
                            if (meal.descriptionBlurb != null &&
                                meal.descriptionBlurb!.trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  0,
                                ),
                                child: Text(
                                  meal.descriptionBlurb!.trim(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                              child: Text(
                                l10n.ingredientsHeading,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...meal.ingredients.where((s) => s.trim().isNotEmpty).map(
                                  (line) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor:
                                              scheme.primaryContainer,
                                          child: Icon(
                                            Icons.check,
                                            size: 16,
                                            color: scheme.onPrimaryContainer,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            line,
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                              child: Text(
                                l10n.instructionsHeading,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...numberedSteps.map(
                              (e) => Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  8,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: scheme.primary,
                                      child: Text(
                                        '${e.key}',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              color: scheme.onPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        e.value,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(height: 1.35),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SafeArea(
              child: FilledButton.icon(
                onPressed: () async {
                  final prefill =
                      TheMealDbImportPrefill.fromDiscoverMeal(meal);
                  final saved = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => RecipeCreateViewModel(
                          sl(),
                          requireUserToPickRecipeType: true,
                        )..loadTypes(),
                        child: RecipeCreatePage(theMealDbPrefill: prefill),
                      ),
                    ),
                  );
                  if (!context.mounted || saved != true) {
                    return;
                  }
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.clearSnackBars();
                  messenger.showSnackBar(
                    SnackBar(content: Text(l10n.importRecipeSavedMessage)),
                  );
                },
                icon: const Icon(Icons.save_alt_outlined),
                label: Text(l10n.discoverDetailImportCta),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
