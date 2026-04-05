import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/recipe_assets.dart';
import '../../core/utils/prep_time_parse.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../l10n/app_localizations.dart';
import '../view_models/recipe_create_view_model.dart';
import '../widgets/local_file_image.dart';

class RecipeCreatePage extends StatefulWidget {
  const RecipeCreatePage({super.key});

  @override
  State<RecipeCreatePage> createState() => _RecipeCreatePageState();
}

class _RecipeCreatePageState extends State<RecipeCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _prepController = TextEditingController();
  final _servingsController = TextEditingController();
  String? _pickedImagePath;
  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _stepControllers = [];

  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _ingredientControllers.addAll([
      TextEditingController(),
      TextEditingController(),
    ]);
    _stepControllers.addAll([
      TextEditingController(),
      TextEditingController(),
    ]);
  }

  @override
  void dispose() {
    _titleController.dispose();
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
    setState(() => _pickedImagePath = null);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final vm = context.read<RecipeCreateViewModel>();
    if (vm.selectedTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.recipeTypeRequired)),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.ingredientsRequired)),
      );
      return;
    }
    if (steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.stepsRequired)),
      );
      return;
    }

    final prep = parsePrepMinutesFromText(_prepController.text) ?? 15;
    final servingsParsed = int.tryParse(_servingsController.text.trim());
    final servings = servingsParsed != null && servingsParsed > 0 ? servingsParsed : 2;

    final imagePath =
        (_pickedImagePath != null && _pickedImagePath!.trim().isNotEmpty)
            ? _pickedImagePath!.trim()
            : RecipeAssets.defaultRecipeImage;

    final recipe = RecipeEntity(
      id: 'local_${_uuid.v4()}',
      typeId: vm.selectedTypeId!,
      title: _titleController.text.trim(),
      description: null,
      ingredients: ingredients,
      steps: steps,
      imagePath: imagePath,
      updatedAt: DateTime.now().toUtc(),
      prepMinutes: prep,
      servings: servings,
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
                                    onPickGallery: () => _pickImage(ImageSource.gallery),
                                    onPickCamera: () => _pickImage(ImageSource.camera),
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
                                                  overflow: TextOverflow.ellipsis,
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
                                          if (parsePrepMinutesFromText(v) == null) {
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  ...List.generate(_ingredientControllers.length, (i) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: _ingredientControllers[i],
                                              decoration: InputDecoration(
                                                hintText: l10n.ingredientHint(i + 1),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => _removeIngredient(i),
                                            icon: Icon(
                                              Icons.remove_circle_outline,
                                              color: scheme.error,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 16),
                                  _DynamicListHeader(
                                    title: l10n.stepsSectionLabel,
                                    actionLabel: l10n.addStep,
                                    onAdd: _addStep,
                                    outlinedAction: true,
                                  ),
                                  const SizedBox(height: 8),
                                  ...List.generate(_stepControllers.length, (i) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: scheme.primaryContainer,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${i + 1}',
                                              style: theme.textTheme.titleSmall?.copyWith(
                                                color: scheme.onPrimaryContainer,
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
    required this.onPickGallery,
    required this.onPickCamera,
    required this.onClear,
  });

  final AppLocalizations l10n;
  final ColorScheme scheme;
  final ThemeData theme;
  final String? pickedPath;
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
                TextButton(
                  onPressed: onClear,
                  child: Text(l10n.clearPhoto),
                ),
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
        ],
      ],
    );
  }

  Widget _buildPreview() {
    final path = pickedPath?.trim();
    if (!kIsWeb && path != null && path.isNotEmpty) {
      final fileWidget = buildLocalFileImage(path, fit: BoxFit.cover);
      if (fileWidget != null) {
        return fileWidget;
      }
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
  });

  final AppLocalizations l10n;
  final ColorScheme scheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scheme.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
          child: Column(
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
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  l10n.createRecipeTitle,
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
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
          TextButton(
            onPressed: onAdd,
            child: Text(actionLabel),
          ),
      ],
    );
  }
}

class _CreateFooter extends StatelessWidget {
  const _CreateFooter({
    required this.l10n,
    required this.scheme,
    required this.busy,
    required this.onCancel,
    required this.onCreate,
  });

  final AppLocalizations l10n;
  final ColorScheme scheme;
  final bool busy;
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
                      : Text(l10n.createRecipeSubmit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
