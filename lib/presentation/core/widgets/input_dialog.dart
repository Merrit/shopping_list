import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopping_list/domain/core/core.dart';

/// Allows to easily specify dialog properties such as the text field only
/// accepting input as a double, which type of soft keyboard to show, etc.
enum InputDialogs {
  multiLine,
  onlyDouble,
  onlyInt,
}

class InputDialog extends StatelessWidget {
  final bool autofocus;
  final BuildContext context;
  final InputDialogs? type;
  final String title;
  final String? hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatter;

  InputDialog({
    this.autofocus = true,
    required this.context,
    this.type,
    this.title = '',
    this.hintText,
    this.keyboardType,
    this.formatter,
    String? initialValue,
    bool preselectText = false,
  }) : maxLines = (type == InputDialogs.multiLine) ? 5 : 1 {
    controller.text = initialValue ?? '';
    if (preselectText && initialValue != null) {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: initialValue.length,
      );
    }
  }

  final FocusNode hotkeyFocusNode = FocusNode();
  final FocusNode textFieldFocusNode = FocusNode();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: AlertDialog(
          title: Text(title),
          content: TextFormField(
            controller: controller,
            focusNode: textFieldFocusNode,
            autofocus: autofocus,
            decoration: InputDecoration(hintText: hintText),
            keyboardType: keyboardType,
            inputFormatters: formatter,
            minLines: 1,
            maxLines: maxLines,
            textInputAction: TextInputAction.newline,
            // For non-multiline fields onFieldSubmitted has enter => submit.
            // For multiline fields the hotkey Ctrl + Enter works instead.
            onFieldSubmitted: (value) =>
                (type == InputDialogs.multiLine) ? null : _onSubmitted(),
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
      ),
    );
  }

  void _onSubmitted() {
    if (controller.text == '') {
      Navigator.pop(context);
    } else {
      Navigator.pop(context, controller.text);
    }
  }

  /// Hotkey actions.
  ///
  /// Ctrl + Enter hotkey to submit when focused on multi-line input.
  late final actions = <Type, Action<Intent>>{
    SubmitIntent: CallbackAction<SubmitIntent>(
      onInvoke: (SubmitIntent intent) {
        Navigator.pop(context, controller.text);
      },
    ),
  };

  /// Hotkeys.
  final shortcuts = <LogicalKeySet, Intent>{
    LogicalKeySet(
      LogicalKeyboardKey.control,
      LogicalKeyboardKey.enter,
    ): const SubmitIntent(),
  };

  /// Convenience function to show a dialog with a TextFormField so that the user
  /// can enter some data. Return is the String entered, or an empty string if the
  /// field was left blank.
  static Future<String?> show({
    required BuildContext context,
    bool? autofocus,
    InputDialogs? type,
    String? title,
    String? hintText,
    String? initialValue,
    bool? preselectText,
  }) async {
    TextInputType? keyboardType;
    List<TextInputFormatter>? formatter;

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
      case InputDialogs.multiLine:
        keyboardType = TextInputType.multiline;
        formatter = null;
        break;
      default:
        formatter = null; // No restrictions on text entry.
    }

    bool shouldAutofocus;
    if (autofocus != null) {
      shouldAutofocus = autofocus;
    } else {
      if (platformIsWebMobile(context)) {
        shouldAutofocus = false;
      } else {
        shouldAutofocus = true;
      }
    }

    var result = await showDialog<String>(
      context: context,
      builder: (context) {
        return InputDialog(
          context: context,
          autofocus: shouldAutofocus,
          type: type,
          title: title ?? '',
          hintText: hintText,
          keyboardType: keyboardType,
          formatter: formatter,
          initialValue: initialValue,
          preselectText: preselectText ?? false,
        );
      },
    );

    if (result == null) return result;

    // Format as a full double, for example text entered as '.49' becomes '0.49'
    // and '5' becomes '5.00'.
    if (type == InputDialogs.onlyDouble) {
      final _asDouble = double.tryParse(result);
      if (_asDouble != null) result = _asDouble.toStringAsFixed(2).toString();
    }

    return result;
  }
}

/// Part of the hotkeys.
class SubmitIntent extends Intent {
  const SubmitIntent();
}
