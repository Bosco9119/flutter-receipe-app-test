import 'package:flutter/material.dart';

import 'local_file_image.dart';

/// Full-bleed recipe image (network, asset, or local file).
class RecipeImageFill extends StatelessWidget {
  const RecipeImageFill({super.key, this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    if (path == null || path.isEmpty) {
      return ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: const Center(child: Icon(Icons.restaurant, size: 48)),
      );
    }
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
        errorBuilder: (context, error, stackTrace) => ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: const Icon(Icons.broken_image_outlined, size: 40),
        ),
      );
    }
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: const Icon(Icons.broken_image_outlined, size: 40),
        ),
      );
    }
    final fileImage = buildLocalFileImage(path, fit: BoxFit.cover);
    if (fileImage != null) {
      return fileImage;
    }
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: const Icon(Icons.image_not_supported_outlined),
    );
  }
}
