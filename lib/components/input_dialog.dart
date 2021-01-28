import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Allows to easily specify dialog properties such as the text field only
/// accepting input as a double, which type of soft keyboard to show, etc.
enum InputDialogs {
  onlyDouble,
  onlyInt,
}

/// Convenience function to show a dialog with a TextFormField so that the user
/// can enter some data. Return is the String entered, or an empty string if the
/// field was left blank.
Future<String> showInputDialog({
  @required BuildContext context,
  InputDialogs type,
  String title,
  String hintText,
}) async {
  final TextEditingController controller = TextEditingController();
  final FocusNode hotkeyFocusNode = FocusNode();
  final FocusNode textFieldFocusNode = FocusNode();
  List<TextInputFormatter> formatter;
  TextInputType keyboardType;

  switch (type) {
    case InputDialogs.onlyInt:
      formatter = [FilteringTextInputFormatter.digitsOnly];
      keyboardType = TextInputType.number;
      break;
    case InputDialogs.onlyDouble:
      formatter = [
        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
      ];
      keyboardType = TextInputType.number;
      break;
    default:
      formatter = null; // No restrictions on text entry.
      keyboardType = TextInputType.visiblePassword;
  }

  var result = await showDialog(
    context: context,
    builder: (context) {
      return RawKeyboardListener(
        focusNode: hotkeyFocusNode,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
            Navigator.pop(context);
          }
          if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
            Navigator.pop(context, controller.text);
          }
        },
        child: AlertDialog(
          title: (title != null) ? Text(title) : null,
          content: TextFormField(
            controller: controller,
            focusNode: textFieldFocusNode,
            autofocus: true,
            decoration: InputDecoration(hintText: hintText),
            keyboardType: keyboardType,
            inputFormatters: formatter,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('Confirm'),
            ),
          ],
        ),
      );
    },
  );

  if (result == null) return '';

  // Format as a full double, for example text entered as '.49' becomes '0.49'
  // and '5' becomes '5.00'.
  if (type == InputDialogs.onlyDouble) {
    var _asDouble = double.tryParse(result);
    result = _asDouble.toStringAsFixed(2).toString();
  }

  return result;
}
