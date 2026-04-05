import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Placeholder until the full create-recipe flow is implemented.
class RecipeCreatePlaceholderPage extends StatelessWidget {
  const RecipeCreatePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newRecipe),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.createRecipeComingSoon,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
