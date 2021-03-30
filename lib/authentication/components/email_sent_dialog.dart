import 'package:flutter/material.dart';
import 'package:shopping_list/main.dart';

class EmailSentDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Success!'),
      content: Text('A verification email has been sent.\n'
          '\n'
          'Please check your email.'),
      actions: [
        TextButton(
          onPressed: () => RestartWidget.restartApp(context),
          child: Text('Ok'),
        ),
      ],
    );
  }
}
