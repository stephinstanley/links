import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool isLoading;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String confirmLabel;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.isLoading,
    required this.onConfirm,
    this.onCancel,
    this.confirmLabel = 'Delete',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: isLoading
              ? null
              : (onCancel ?? () => Navigator.of(context).pop()),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: isLoading
              ? SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onError,
                    ),
                  ),
                )
              : Text(confirmLabel),
        ),
      ],
    );
  }
}
