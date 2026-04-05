import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_gradients.dart';
import '../../l10n/app_localizations.dart';
import '../view_models/discover_recipe_view_model.dart';
import '../widgets/discover_meal_card.dart';
import '../widgets/discover_recipes_grid_layout.dart';
import 'discover_meal_detail_page.dart';

class DiscoverRecipesPage extends StatelessWidget {
  const DiscoverRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<DiscoverRecipeViewModel>();

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: DecoratedBox(
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
                      tooltip: l10n.backToRecipes,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.discoverRecipesTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: scheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                height: 1.12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.discoverRecipesSubtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: scheme.onPrimary.withValues(alpha: 0.92),
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: vm.isLoading
                        ? null
                        : () => vm.loadTenSequential(),
                    icon: vm.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: scheme.onPrimary,
                            ),
                          )
                        : const Icon(Icons.shuffle, size: 20),
                    label: Text(l10n.discoverLoadTenButton),
                  ),
                  if (vm.completedFetches > 0 || vm.isLoading) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: vm.isLoading ? vm.progress : 1,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.discoverFetchProgress(
                        vm.completedFetches,
                        DiscoverRecipeViewModel.batchSize,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (vm.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      vm.errorMessage == 'all_failed'
                          ? l10n.discoverErrorAllFailed
                          : l10n.discoverErrorNoRecipes,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.error,
                      ),
                    ),
                  ],
                  if (vm.failedFetches > 0 && vm.meals.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.discoverSomeRequestsFailed(vm.failedFetches),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (vm.meals.isEmpty && !vm.isLoading)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.discoverEmptyHint,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            )
          else if (vm.meals.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: discoverGridColumnCount(context),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: discoverGridChildAspectRatio(context),
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final meal = vm.meals[index];
                    final badge = meal.badgeLabel.trim().isNotEmpty
                        ? meal.badgeLabel
                        : l10n.discoverUnknownCategory;
                    return DiscoverMealCard(
                      meal: meal,
                      badgeLabel: badge,
                      onTap: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => DiscoverMealDetailPage(meal: meal),
                          ),
                        );
                      },
                    );
                  },
                  childCount: vm.meals.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
