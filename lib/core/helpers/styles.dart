import 'package:flutter/widgets.dart';

// Possible constants to represent:
//
// Animation timings
// Sizes and breakpoints
// Insets and paddings
// Corner radius
// Shadows
// Strokes
// Font families, sizes, and styles

class Insets {
  static const double xsmall = 4;
  static const double small = 8;

  static const listViewWithFloatingButton = EdgeInsets.only(
    left: 4,
    right: 4,
    top: 4,
    // Padding for the bottom edge so the floating
    // button won't cover any list items.
    bottom: 100,
  );
}

class TextStyles {
  static const TextStyle raleway = TextStyle();

  static TextStyle body1 = raleway.copyWith();
}
