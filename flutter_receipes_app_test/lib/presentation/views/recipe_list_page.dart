import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../view_models/recipe_list_view_model.dart';
import '../widgets/app_settings_drawer.dart';
import '../widgets/recipe_card.dart';
import 'recipe_create_placeholder_page.dart';

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
          child: _ListHeader(
            l10n: l10n,
            scheme: scheme,
            theme: theme,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                final filterButton = IconButton.filledTonal(
                  onPressed: () => _openFilterSheet(context, vm, l10n),
                  icon: const Icon(Icons.filter_list),
                  tooltip: l10n.filterRecipes,
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
                      filterButton,
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 200,
                        child: dropdown,
                      ),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: searchField),
                        const SizedBox(width: 4),
                        filterButton,
                      ],
                    ),
                    const SizedBox(height: 12),
                    dropdown,
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
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const RecipeCreatePlaceholderPage(),
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
                crossAxisCount: _gridColumns(context),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.74,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final recipe = visible[index];
                  return RecipeCard(
                    recipe: recipe,
                    typeLabel: vm.typeDisplayName(recipe.typeId),
                    prepLabel: l10n.prepTimeMinutes(recipe.prepMinutes),
                    servingsLabel: l10n.servingsCount(recipe.servings),
                  );
                },
                childCount: visible.length,
              ),
            ),
          ),
      ],
    );
  }

  int _gridColumns(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1100) {
      return 3;
    }
    if (w >= 700) {
      return 2;
    }
    return 1;
  }

  void _openFilterSheet(
    BuildContext context,
    RecipeListViewModel vm,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            children: [
              ListTile(
                title: Text(l10n.allTypes),
                trailing: vm.selectedTypeId == null
                    ? Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary)
                    : null,
                onTap: () {
                  vm.setSelectedTypeId(null);
                  Navigator.pop(ctx);
                },
              ),
              const Divider(height: 1),
              ...vm.recipeTypes.map(
                (t) => ListTile(
                  title: Text(
                    t.icon != null ? '${t.icon} ${t.name}' : t.name,
                  ),
                  trailing: vm.selectedTypeId == t.id
                      ? Icon(
                          Icons.check,
                          color: Theme.of(ctx).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    vm.setSelectedTypeId(t.id);
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
        24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            scheme.primary,
            Color.lerp(scheme.primary, scheme.primaryContainer, 0.35)!,
            scheme.tertiary,
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.myRecipes,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.myRecipesSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.92),
                  ),
                ),
              ],
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
            DropdownMenuItem<String?>(
              value: null,
              child: Text(l10n.allTypes),
            ),
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
