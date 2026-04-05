import 'dart:io';

import 'package:flutter/material.dart';

Widget? buildLocalFileImage(String path, {required BoxFit fit}) {
  if (path.isEmpty) {
    return null;
  }
  return Image.file(
    File(path),
    fit: fit,
    errorBuilder: (context, error, stackTrace) => ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: const Icon(Icons.broken_image_outlined, size: 40),
    ),
  );
}
