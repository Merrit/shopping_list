import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../application/shopping_list/cubit/shopping_list_cubit.dart';
import 'shortcuts_manager.dart';

/// Shortcuts that are available everywhere in the app.
///
/// This widget is to be wrapped around the widget intended as a route.
class AppShortcuts extends StatelessWidget {
  final Widget child;

  const AppShortcuts({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _shortcuts = <LogicalKeySet, Intent>{
      LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyN,
      ): CreateItemIntent(
          FocusManager.instance.primaryFocus?.context ?? context),
      LogicalKeySet(
        LogicalKeyboardKey.control,
        LogicalKeyboardKey.keyQ,
      ): const QuitIntent(),
    };

    final _actions = <Type, Action<Intent>>{
      CreateItemIntent: CreateItemAction(),
      QuitIntent: QuitAction(),
    };

    return Shortcuts(
      manager: LoggingShortcutManager(),
      shortcuts: _shortcuts,
      child: Actions(
        dispatcher: LoggingActionDispatcher(),
        actions: _actions,
        child: child,
      ),
    );
  }
}

/// An intent that is bound to QuitAction in order to quit this application.
class QuitIntent extends Intent {
  const QuitIntent();
}

/// An action that is bound to QuitIntent in order to quit this application.
class QuitAction extends Action<QuitIntent> {
  @override
  Object? invoke(QuitIntent intent) {
    print('Quit requested, exiting.');
    // Not available on web, importing causes crashes.
    // exit(0);
  }
}

/// An intent that is bound to CreateItemAction.
class CreateItemIntent extends Intent {
  final BuildContext context;

  const CreateItemIntent(
    this.context,
  );
}

/// An action that is bound to CreateItemIntent.
class CreateItemAction extends Action<CreateItemIntent> {
  @override
  Object? invoke(CreateItemIntent intent) {
    final context = intent.context;
    context.read<ShoppingListCubit>().tiggerShowCreateItemDialog();
    return null;
  }
}
