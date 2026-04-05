import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Themed confirmation dialog. [title] and [message] should come from [AppLocalizations].
///
/// Optional [titleIcon] / [titleIconColor] are supplied by the caller and appear
/// to the left of [title] on the same row.
///
/// Cancel always uses [AppLocalizations.cancel]. Confirm uses [confirmLabel] if set,
/// otherwise [AppLocalizations.dialogConfirm].
Future<bool?> showConfirmDialog(
  BuildContext context,
  String title,
  String message, {
  String? confirmLabel,
  bool destructive = false,
  IconData? titleIcon,
  Color? titleIconColor,
}) {
  final l10n = AppLocalizations.of(context)!;

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final scheme = theme.colorScheme;
      final confirmText = confirmLabel ?? l10n.dialogConfirm;

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (titleIcon != null) ...[
              Icon(
                titleIcon,
                size: 28,
                color: titleIconColor ?? scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              foregroundColor: scheme.onSurfaceVariant,
            ),
            child: Text(l10n.cancel),
          ),
          const SizedBox(width: 4),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              backgroundColor:
                  destructive ? scheme.error : scheme.primary,
              foregroundColor:
                  destructive ? scheme.onError : scheme.onPrimary,
            ),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
}
