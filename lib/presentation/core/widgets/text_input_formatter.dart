import 'dart:math' as math;

import 'package:flutter/services.dart';

// ignore_for_file: unused_field

extension BetterTextInputFormatter on FilteringTextInputFormatter {
  /// A [TextInputFormatter] that allows only a double, such as `0.42`.
  static final TextInputFormatter doubleOnly =
      FilteringTextInputFormatter.allow(
    RegExp(r'(^\d*\.?\d*)'),
  );
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    var newSelection = newValue.selection;
    var truncated = newValue.text;

    final value = newValue.text;

    if (value.contains('.') &&
        value.substring(value.indexOf('.') + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == '.') {
      truncated = '0.';

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
