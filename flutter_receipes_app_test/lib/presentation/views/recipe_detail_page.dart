import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di/injection.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../l10n/app_localizations.dart';
import '../view_models/recipe_create_view_model.dart';
import '../view_models/recipe_detail_view_model.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/recipe_image_fill.dart';
import 'recipe_create_page.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<RecipeDetailViewModel>();

    if (!vm.isInitialized) {
      return Scaffold(
        backgroundColor: scheme.surfaceContainerLow,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!vm.hasRecipe) {
      return Scaffold(
        backgroundColor: scheme.surfaceContainerLow,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(l10n.recipeNotFound),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.recipeNotFoundMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    final recipe = vm.recipe!;
    final typeLabel = vm.displayTypeName(recipe.typeId);

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: scheme.primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 8, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back, color: scheme.onPrimary),
                          label: Text(
                            l10n.backToRecipes,
                            style: TextStyle(color: scheme.onPrimary),
                          ),
                        ),
                        const Spacer(),
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            backgroundColor:
                                scheme.onPrimary.withValues(alpha: 0.22),
                            foregroundColor: scheme.onPrimary,
                          ),
                          onPressed: () => _openEdit(context, recipe),
                          tooltip: l10n.editRecipe,
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        const SizedBox(width: 4),
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            backgroundColor:
                                scheme.onPrimary.withValues(alpha: 0.22),
                            foregroundColor: scheme.onPrimary,
                          ),
                          onPressed: () => _confirmDelete(context),
                          tooltip: l10n.deleteRecipe,
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(
                        recipe.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
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
                                  RecipeImageFill(imagePath: recipe.imagePath),
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
                                          typeLabel,
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
                              child: LayoutBuilder(
                                builder: (context, inner) {
                                  if (inner.maxWidth < 320) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _MetaRow(
                                          icon: Icons.schedule_outlined,
                                          text: l10n.prepTimeMinutes(
                                            recipe.prepMinutes,
                                          ),
                                          scheme: scheme,
                                          theme: theme,
                                        ),
                                        const SizedBox(height: 10),
                                        _MetaRow(
                                          icon: Icons.people_outline,
                                          text: l10n.servingsCount(
                                            recipe.servings,
                                          ),
                                          scheme: scheme,
                                          theme: theme,
                                        ),
                                      ],
                                    );
                                  }
                                  return Row(
                                    children: [
                                      Icon(
                                        Icons.schedule_outlined,
                                        size: 22,
                                        color: scheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          l10n.prepTimeMinutes(
                                            recipe.prepMinutes,
                                          ),
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.people_outline,
                                        size: 22,
                                        color: scheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          l10n.servingsCount(recipe.servings),
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: scheme.outlineVariant,
                            ),
                            if (recipe.description != null &&
                                recipe.description!.trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  0,
                                ),
                                child: Text(
                                  recipe.description!.trim(),
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
                            ...recipe.ingredients.map(
                              (line) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: scheme.primaryContainer,
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
                            ...List.generate(recipe.steps.length, (i) {
                              final step = recipe.steps[i];
                              final n = i + 1;
                              return Padding(
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
                                        '$n',
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
                                        step,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(height: 1.35),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final vm = context.read<RecipeDetailViewModel>();
    final ok = await showConfirmDialog(
      context,
      l10n.deleteRecipeTitle,
      l10n.deleteRecipeMessage,
      confirmLabel: l10n.deleteRecipeConfirm,
      destructive: true,
      titleIcon: Icons.delete_outline_rounded,
      titleIconColor: scheme.error,
    );
    if (ok != true || !context.mounted) {
      return;
    }
    final deleted = await vm.deleteRecipe();
    if (!context.mounted) {
      return;
    }
    if (deleted) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.deleteRecipeFailed)),
      );
    }
  }

  Future<void> _openEdit(BuildContext context, RecipeEntity recipe) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => RecipeCreateViewModel(
            sl(),
            initialTypeId: recipe.typeId,
          )..loadTypes(),
          child: RecipeCreatePage(recipeBeingEdited: recipe),
        ),
      ),
    );
    if (changed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.recipeUpdated)),
      );
    }
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.text,
    required this.scheme,
    required this.theme,
  });

  final IconData icon;
  final String text;
  final ColorScheme scheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
          color: scheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
