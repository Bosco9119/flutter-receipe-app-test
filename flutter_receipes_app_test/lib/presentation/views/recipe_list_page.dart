import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_gradients.dart';
import '../../domain/entities/recipe_list_sort.dart';
import '../../l10n/app_localizations.dart';
import '../view_models/discover_recipe_view_model.dart';
import '../view_models/recipe_create_view_model.dart';
import '../view_models/recipe_detail_view_model.dart';
import '../view_models/recipe_list_view_model.dart';
import '../widgets/app_settings_drawer.dart';
import '../widgets/recipe_card.dart';
import 'discover_recipes_page.dart';
import 'recipe_create_page.dart';
import 'recipe_detail_page.dart';

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<RecipeListViewModel>();

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      drawer: const AppSettingsDrawer(),
      body: vm.isReady
          ? _RecipeListBody(l10n: l10n)
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) => ChangeNotifierProvider(
                create: (_) =>
                    DiscoverRecipeViewModel(sl())..resetForNewSession(),
                child: const DiscoverRecipesPage(),
              ),
            ),
          );
        },
        tooltip: l10n.drawerDiscoverRecipes,
        child: const Icon(Icons.public),
      ),
    );
  }
}

class _RecipeListBody extends StatefulWidget {
  const _RecipeListBody({required this.l10n});

  final AppLocalizations l10n;

  @override
  State<_RecipeListBody> createState() => _RecipeListBodyState();
}

class _RecipeListBodyState extends State<_RecipeListBody> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = context.read<RecipeListViewModel>();
    _searchController.text = vm.searchQuery;
    _searchController.addListener(() {
      vm.setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = widget.l10n;
    final vm = context.watch<RecipeListViewModel>();
    final visible = vm.visibleRecipes;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _ListHeader(l10n: l10n, scheme: scheme, theme: theme),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 560;
                final searchField = TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchRecipesHint,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: scheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                );
                final sortButton = IconButton.filledTonal(
                  onPressed: () => _openSortSheet(context, vm, l10n),
                  icon: const Icon(Icons.filter_list),
                  tooltip: l10n.sortRecipesTooltip,
                );
                final dropdown = _TypeDropdown(
                  l10n: l10n,
                  vm: vm,
                  scheme: scheme,
                );
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: searchField),
                      const SizedBox(width: 8),
                      SizedBox(width: 200, child: dropdown),
                      const SizedBox(width: 8),
                      sortButton,
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    searchField,
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: dropdown),
                        const SizedBox(width: 8),
                        sortButton,
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.recipesFound(visible.length),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push<bool>(
                      MaterialPageRoute<bool>(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) =>
                              RecipeCreateViewModel(sl())..loadTypes(),
                          child: const RecipeCreatePage(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: Text(l10n.newRecipe),
                ),
              ],
            ),
          ),
        ),
        if (visible.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.noRecipesMatch,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridColumnCount(context),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: _gridChildAspectRatio(context),
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final recipe = visible[index];
                return RecipeCard(
                  recipe: recipe,
                  typeLabel: vm.typeDisplayName(recipe.typeId),
                  prepLabel: l10n.prepTimeMinutes(recipe.prepMinutes),
                  servingsLabel: l10n.servingsCount(recipe.servings),
                  onTap: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => ChangeNotifierProvider(
                          create: (_) =>
                              RecipeDetailViewModel(sl(), recipe.id)..start(),
                          child: const RecipeDetailPage(),
                        ),
                      ),
                    );
                  },
                );
              }, childCount: visible.length),
            ),
          ),
      ],
    );
  }

  /// Responsive columns: 3 wide desktop, 2 from ~phone portrait up, 1 only on very narrow widths.
  int _gridColumnCount(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1000) {
      return 3;
    }
    if (w >= 360) {
      return 2;
    }
    return 1;
  }

  /// Width/height of each grid child. Higher value → shorter tiles, less empty space under text.
  double _gridChildAspectRatio(BuildContext context) {
    switch (_gridColumnCount(context)) {
      case 3:
        return 0.72;
      case 2:
        return 0.62;
      default:
        return 0.80;
    }
  }

  void _openSortSheet(
    BuildContext context,
    RecipeListViewModel vm,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  l10n.sortSheetTitle,
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
              ),
              ...RecipeListSort.values.map(
                (mode) => ListTile(
                  title: Text(_sortOptionLabel(mode, l10n)),
                  trailing: vm.sort == mode
                      ? Icon(Icons.check, color: scheme.primary)
                      : null,
                  onTap: () {
                    vm.setSort(mode);
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _sortOptionLabel(RecipeListSort mode, AppLocalizations l10n) {
    switch (mode) {
      case RecipeListSort.titleAscending:
        return l10n.sortTitleAZ;
      case RecipeListSort.titleDescending:
        return l10n.sortTitleZA;
      case RecipeListSort.prepTimeAscending:
        return l10n.sortPrepShortFirst;
      case RecipeListSort.prepTimeDescending:
        return l10n.sortPrepLongFirst;
    }
  }
}

class _ListHeader extends StatelessWidget {
  const _ListHeader({
    required this.l10n,
    required this.scheme,
    required this.theme,
  });

  final AppLocalizations l10n;
  final ColorScheme scheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.paddingOf(context).top + 12,
        16,
        16,
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.warmHeaderBanner(scheme),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (ctx) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
                tooltip: MaterialLocalizations.of(ctx).openAppDrawerTooltip,
              );
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.myRecipes,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.myRecipesSubtitle,
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
    );
  }
}

class _TypeDropdown extends StatelessWidget {
  const _TypeDropdown({
    required this.l10n,
    required this.vm,
    required this.scheme,
  });

  final AppLocalizations l10n;
  final RecipeListViewModel vm;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: vm.selectedTypeId,
          isExpanded: true,
          hint: Text(l10n.allTypes),
          borderRadius: BorderRadius.circular(12),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text(l10n.allTypes)),
            ...vm.recipeTypes.map(
              (t) => DropdownMenuItem<String?>(
                value: t.id,
                child: Text(
                  t.icon != null ? '${t.icon} ${t.name}' : t.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
          onChanged: (id) => vm.setSelectedTypeId(id),
        ),
      ),
    );
  }
}
