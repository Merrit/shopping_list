import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_list/presentation/shopping_list/pages/shopping_list_view.dart';

class CreateItemIntent extends Intent {
  const CreateItemIntent();
}

class CreateItemShortcut extends StatelessWidget {
  final Widget child;

  const CreateItemShortcut({required this.child});

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
