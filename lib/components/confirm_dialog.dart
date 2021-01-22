import 'package:flutter/material.dart';

/// A simple confirm/cancel dialog that returns true or false respectively.
class ConfirmDialog extends StatelessWidget {
  /// Text to display to the user in the dialog.
  final String content;

  ConfirmDialog({@required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
