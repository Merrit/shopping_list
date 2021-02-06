import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdvancedTextField extends StatelessWidget {
  AdvancedTextField({
    this.callback,
    this.width,
    String initialValue,
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
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) => _hotkey(event),
        child: TextField(
          controller: controller,
          autofocus: true,
          onSubmitted: (value) => callback(controller.text),
        ),
      ),
    );
  }

  void _hotkey(RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
      callback('');
    }
  }
}
