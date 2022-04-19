import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/shopping_list_view.dart';

class CreateItemIntent extends Intent {
  const CreateItemIntent();
}

class CreateItemShortcut extends StatelessWidget {
  final Widget child;

  const CreateItemShortcut({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(
          LogicalKeyboardKey.alt,
          LogicalKeyboardKey.keyN,
        ): const CreateItemIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          CreateItemIntent: CallbackAction<CreateItemIntent>(
            onInvoke: (intent) =>
                ActiveListView.showCreateItemDialog(context: context),
          )
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}
