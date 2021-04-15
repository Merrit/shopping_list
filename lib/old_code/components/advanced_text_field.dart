import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdvancedTextField extends StatelessWidget {
  AdvancedTextField({
    required this.callback,
    required this.width,
    required String initialValue,
  }) {
    controller.text = initialValue;
  }

  final controller = TextEditingController();
  final void Function(String) callback;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Shortcuts(
        shortcuts: shortcuts,
        child: Actions(
          actions: actions,
          child: Focus(
            autofocus: true,
            child: TextField(
              controller: controller,
              autofocus: true,
              onSubmitted: (value) => callback(controller.text),
            ),
          ),
        ),
      ),
    );
  }

  /// Hotkey actions.
  ///
  /// Escape key to cancel editing.
  late final actions = <Type, Action<Intent>>{
    EscapeIntent: CallbackAction<EscapeIntent>(
      onInvoke: (EscapeIntent intent) {
        callback('');
      },
    ),
  };

  /// Hotkeys.
  final shortcuts = <LogicalKeySet, Intent>{
    LogicalKeySet(LogicalKeyboardKey.escape): const EscapeIntent(),
  };
}

/// Part of the hotkeys.
class EscapeIntent extends Intent {
  const EscapeIntent();
}
