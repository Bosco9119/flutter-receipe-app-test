import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/recipe_assets.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/utils/prep_time_parse.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/entities/the_meal_db_import_prefill.dart';
import '../../l10n/app_localizations.dart';
import '../view_models/recipe_create_view_model.dart';
import '../widgets/recipe_image_fill.dart';

class RecipeCreatePage extends StatefulWidget {
  const RecipeCreatePage({
    super.key,
    this.recipeBeingEdited,
    this.theMealDbPrefill,
  });

  /// When set, the form pre-fills and save updates this recipe (same id).
  final RecipeEntity? recipeBeingEdited;

  /// Seeds the form from a discovered TheMealDB meal; user chooses type and prep time.
  final TheMealDbImportPrefill? theMealDbPrefill;

  @override
  State<RecipeCreatePage> createState() => _RecipeCreatePageState();
}

class _RecipeCreatePageState extends State<RecipeCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepController = TextEditingController();
  final _servingsController = TextEditingController();
  String? _pickedImagePath;

  /// When editing, user cleared photo → save uses default image instead of previous path.
  bool _clearExistingImage = false;

  /// When importing from TheMealDB, user cleared the suggested network image.
  bool _clearImportImage = false;
  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _stepControllers = [];

  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    final edit = widget.recipeBeingEdited;
    final prefill = widget.theMealDbPrefill;
    assert(
      edit == null || prefill == null,
      'recipeBeingEdited and theMealDbPrefill cannot both be set.',
    );
    if (edit != null) {
      _titleController.text = edit.title;
      _descriptionController.text = edit.description?.trim() ?? '';
      _prepController.text = '${edit.prepMinutes}';
      _servingsController.text = '${edit.servings}';
      for (final line in edit.ingredients) {
        _ingredientControllers.add(TextEditingController(text: line));
      }
      if (_ingredientControllers.isEmpty) {
        _ingredientControllers.add(TextEditingController());
      }
      for (final line in edit.steps) {
        _stepControllers.add(TextEditingController(text: line));
      }
      if (_stepControllers.isEmpty) {
        _stepControllers.add(TextEditingController());
      }
    } else if (prefill != null) {
      _titleController.text = prefill.title;
      _descriptionController.text = prefill.description?.trim() ?? '';
      _prepController.text = '';
      _servingsController.text = '4';
      for (final line in prefill.ingredients) {
        _ingredientControllers.add(TextEditingController(text: line));
      }
      if (_ingredientControllers.isEmpty) {
        _ingredientControllers.add(TextEditingController());
      }
      for (final line in prefill.steps) {
        _stepControllers.add(TextEditingController(text: line));
      }
      if (_stepControllers.isEmpty) {
        _stepControllers.add(TextEditingController());
      }
    } else {
      _ingredientControllers.addAll([
        TextEditingController(),
        TextEditingController(),
      ]);
      _stepControllers.addAll([
        TextEditingController(),
        TextEditingController(),
      ]);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _prepController.dispose();
    _servingsController.dispose();
    for (final c in _ingredientControllers) {
      c.dispose();
    }
    for (final c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addIngredient() {
    setState(() => _ingredientControllers.add(TextEditingController()));
  }

  void _removeIngredient(int index) {
    if (_ingredientControllers.length <= 1) {
      return;
    }
    setState(() {
      _ingredientControllers[index].dispose();
      _ingredientControllers.removeAt(index);
    });
  }

  void _addStep() {
    setState(() => _stepControllers.add(TextEditingController()));
  }

  void _removeStep(int index) {
    if (_stepControllers.length <= 1) {
      return;
    }
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    if (kIsWeb) {
      return;
    }
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 88,
    );
    if (file != null && mounted) {
      setState(() => _pickedImagePath = file.path);
    }
  }

  void _clearPickedPhoto() {
    setState(() {
      _pickedImagePath = null;
      if (widget.recipeBeingEdited != null) {
        _clearExistingImage = true;
      }
      if (widget.theMealDbPrefill != null) {
        _clearImportImage = true;
      }
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final vm = context.read<RecipeCreateViewModel>();
    if (vm.selectedTypeId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.recipeTypeRequired)));
      return;
    }

    final ingredients = _ingredientControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final steps = _stepControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.ingredientsRequired)));
      return;
    }
    if (steps.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.stepsRequired)));
      return;
    }

    final prep = parsePrepMinutesFromText(_prepController.text) ?? 15;
    final servingsParsed = int.tryParse(_servingsController.text.trim());
    final servings = servingsParsed != null && servingsParsed > 0
        ? servingsParsed
        : 2;

    final base = widget.recipeBeingEdited;
    final picked = _pickedImagePath?.trim();
    final String imagePath;
    if (picked != null && picked.isNotEmpty) {
      imagePath = picked;
    } else if (base != null && !_clearExistingImage) {
      final prev = base.imagePath?.trim();
      imagePath = (prev != null && prev.isNotEmpty)
          ? prev
          : RecipeAssets.defaultRecipeImage;
    } else if (widget.theMealDbPrefill != null && !_clearImportImage) {
      final url = widget.theMealDbPrefill!.imageUrl?.trim();
      imagePath = (url != null && url.isNotEmpty)
          ? url
          : RecipeAssets.defaultRecipeImage;
    } else {
      imagePath = RecipeAssets.defaultRecipeImage;
    }

    final descText = _descriptionController.text.trim();
    final recipe = RecipeEntity(
      id:
          base?.id ??
          widget.theMealDbPrefill?.proposedRecipeId ??
          'local_${_uuid.v4()}',
      typeId: vm.selectedTypeId!,
      title: _titleController.text.trim(),
      description: descText.isEmpty ? null : descText,
      ingredients: ingredients,
      steps: steps,
      imagePath: imagePath,
      updatedAt: DateTime.now().toUtc(),
      prepMinutes: prep,
      servings: servings,
      isHalal: base?.isHalal ?? true,
      isVegetarian: base?.isVegetarian ?? false,
      isVegan: base?.isVegan ?? false,
    );

    final ok = await vm.saveRecipe(recipe);
    if (!mounted) {
      return;
    }
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.lastError ?? l10n.createRecipeFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<RecipeCreateViewModel>();

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow,
      body: vm.isLoadingTypes
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CreateHeader(
                  l10n: l10n,
                  scheme: scheme,
                  theme: theme,
                  isEditing: widget.recipeBeingEdited != null,
                  isTheMealDbImport: widget.theMealDbPrefill != null,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _RecipePhotoSection(
                                    l10n: l10n,
                                    scheme: scheme,
                                    theme: theme,
                                    pickedPath: _pickedImagePath,
                                    existingStoragePath: _clearExistingImage
                                        ? null
                                        : widget.recipeBeingEdited?.imagePath,
                                    networkPrefillUrl: _clearImportImage
                                        ? null
                                        : widget.theMealDbPrefill?.imageUrl,
                                    onPickGallery: () =>
                                        _pickImage(ImageSource.gallery),
                                    onPickCamera: () =>
                                        _pickImage(ImageSource.camera),
                                    onClear: _clearPickedPhoto,
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      labelText: l10n.recipeTitleLabel,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return l10n.fieldRequired;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                      labelText: l10n.recipeDescriptionLabel,
                                      hintText: l10n.recipeDescriptionHint,
                                      alignLabelWithHint: true,
                                    ),
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 2,
                                    maxLines: 5,
                                  ),
                                  const SizedBox(height: 16),
                                  InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: l10n.recipeTypeLabel,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: vm.selectedTypeId,
                                        hint: Text(l10n.selectRecipeTypeHint),
                                        items: vm.types
                                            .map(
                                              (t) => DropdownMenuItem(
                                                value: t.id,
                                                child: Text(
                                                  t.icon != null
                                                      ? '${t.icon} ${t.name}'
                                                      : t.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: vm.types.isEmpty
                                            ? null
                                            : vm.setSelectedTypeId,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  LayoutBuilder(
                                    builder: (context, c) {
                                      final row = c.maxWidth >= 480;
                                      final prepField = TextFormField(
                                        controller: _prepController,
                                        decoration: InputDecoration(
                                          labelText: l10n.prepTimeLabel,
                                          hintText: l10n.prepTimeHint,
                                        ),
                                        textInputAction: TextInputAction.next,
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return l10n.fieldRequired;
                                          }
                                          if (parsePrepMinutesFromText(v) ==
                                              null) {
                                            return l10n.prepTimeInvalid;
                                          }
                                          return null;
                                        },
                                      );
                                      final servingsField = TextFormField(
                                        controller: _servingsController,
                                        decoration: InputDecoration(
                                          labelText: l10n.servingsLabel,
                                          hintText: l10n.servingsHint,
                                        ),
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return l10n.fieldRequired;
                                          }
                                          final n = int.tryParse(v.trim());
                                          if (n == null || n < 1) {
                                            return l10n.servingsInvalid;
                                          }
                                          return null;
                                        },
                                      );
                                      if (row) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: prepField),
                                            const SizedBox(width: 16),
                                            Expanded(child: servingsField),
                                          ],
                                        );
                                      }
                                      return Column(
                                        children: [
                                          prepField,
                                          const SizedBox(height: 16),
                                          servingsField,
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  _DynamicListHeader(
                                    title: l10n.ingredientsSectionLabel,
                                    actionLabel: l10n.addIngredient,
                                    onAdd: _addIngredient,
                                  ),
                                  const SizedBox(height: 8),
                                  ...List.generate(
                                    _ingredientControllers.length,
                                    (i) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    _ingredientControllers[i],
                                                decoration: InputDecoration(
                                                  hintText: l10n.ingredientHint(
                                                    i + 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _removeIngredient(i),
                                              icon: Icon(
                                                Icons.remove_circle_outline,
                                                color: scheme.error,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _DynamicListHeader(
                                    title: l10n.stepsSectionLabel,
                                    actionLabel: l10n.addStep,
                                    onAdd: _addStep,
                                    outlinedAction: true,
                                  ),
                                  const SizedBox(height: 8),
                                  ...List.generate(_stepControllers.length, (
                                    i,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: scheme.primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${i + 1}',
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                    color: scheme
                                                        .onPrimaryContainer,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _stepControllers[i],
                                              decoration: InputDecoration(
                                                hintText: l10n.stepHint(i + 1),
                                                alignLabelWithHint: true,
                                              ),
                                              minLines: 2,
                                              maxLines: 4,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => _removeStep(i),
                                            icon: Icon(
                                              Icons.remove_circle_outline,
                                              color: scheme.error,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _CreateFooter(
                  l10n: l10n,
                  scheme: scheme,
                  busy: vm.isSubmitting,
                  submitLabel: widget.recipeBeingEdited != null
                      ? l10n.saveRecipeChanges
                      : l10n.createRecipeSubmit,
                  onCancel: () => Navigator.of(context).pop(),
                  onCreate: _submit,
                ),
              ],
            ),
    );
  }
}

class _RecipePhotoSection extends StatelessWidget {
  const _RecipePhotoSection({
    required this.l10n,
    required this.scheme,
    required this.theme,
    required this.pickedPath,
    this.existingStoragePath,
    this.networkPrefillUrl,
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onClear,
  });

  final AppLocalizations l10n;
  final ColorScheme scheme;
  final ThemeData theme;
  final String? pickedPath;
  final String? existingStoragePath;
  final String? networkPrefillUrl;
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.recipePhotoLabel,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: _buildPreview(),
            ),
          ),
        ),
        if (!kIsWeb) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: onPickGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l10n.pickFromGallery),
              ),
              OutlinedButton.icon(
                onPressed: onPickCamera,
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(l10n.takePhoto),
              ),
              if (pickedPath != null && pickedPath!.trim().isNotEmpty)
                TextButton(onPressed: onClear, child: Text(l10n.clearPhoto))
              else if (existingStoragePath != null &&
                  existingStoragePath!.trim().isNotEmpty)
                TextButton(onPressed: onClear, child: Text(l10n.clearPhoto))
              else if (networkPrefillUrl != null &&
                  networkPrefillUrl!.trim().isNotEmpty)
                TextButton(onPressed: onClear, child: Text(l10n.clearPhoto)),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Text(
          l10n.recipePhotoHelper,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        if (kIsWeb) ...[
          const SizedBox(height: 6),
          Text(
            l10n.recipePhotoWebNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (networkPrefillUrl != null &&
              networkPrefillUrl!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onClear, child: Text(l10n.clearPhoto)),
          ],
        ],
      ],
    );
  }

  Widget _buildPreview() {
    final picked = pickedPath?.trim();
    if (picked != null && picked.isNotEmpty) {
      return RecipeImageFill(imagePath: picked);
    }
    final existing = existingStoragePath?.trim();
    if (existing != null && existing.isNotEmpty) {
      return RecipeImageFill(imagePath: existing);
    }
    final network = networkPrefillUrl?.trim();
    if (network != null && network.isNotEmpty) {
      return RecipeImageFill(imagePath: network);
    }
    return Center(
      child: Icon(
        Icons.add_photo_alternate_outlined,
        size: 56,
        color: scheme.onSurfaceVariant.withValues(alpha: 0.55),
      ),
    );
  }
}

class _CreateHeader extends StatelessWidget {
  const _CreateHeader({
    required this.l10n,
    required this.scheme,
    required this.theme,
    required this.isEditing,
    required this.isTheMealDbImport,
  });

  final AppLocalizations l10n;
  final ColorScheme scheme;
  final ThemeData theme;
  final bool isEditing;
  final bool isTheMealDbImport;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
                child: Text(
                  isEditing
                      ? l10n.editRecipeTitle
                      : isTheMealDbImport
                      ? l10n.importRecipeTitle
                      : l10n.createRecipeTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineMedium?.copyWith(
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
    );
  }
}

class _DynamicListHeader extends StatelessWidget {
  const _DynamicListHeader({
    required this.title,
    required this.actionLabel,
    required this.onAdd,
    this.outlinedAction = false,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAdd;
  final bool outlinedAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        if (outlinedAction)
          OutlinedButton(
            onPressed: onAdd,
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.primary,
              side: BorderSide(color: scheme.primary),
            ),
            child: Text(actionLabel),
          )
        else
          TextButton(onPressed: onAdd, child: Text(actionLabel)),
      ],
    );
  }
}

class _CreateFooter extends StatelessWidget {
  const _CreateFooter({
    required this.l10n,
    required this.scheme,
    required this.busy,
    required this.submitLabel,
    required this.onCancel,
    required this.onCreate,
  });

  final AppLocalizations l10n;
  final ColorScheme scheme;
  final bool busy;
  final String submitLabel;
  final VoidCallback onCancel;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: scheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: busy ? null : onCancel,
                  child: Text(l10n.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: busy ? null : onCreate,
                  child: busy
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(submitLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
