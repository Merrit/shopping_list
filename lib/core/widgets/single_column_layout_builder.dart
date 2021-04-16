import 'package:flutter/material.dart';

/// Padding for pages that are only ever a single column, like the login page.
///
/// Adaptive to large and small screens.
class SingleColumnPagePadding extends StatelessWidget {
  final Widget child;

  const SingleColumnPagePadding({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: constraints.maxWidth / 4,
              right: constraints.maxWidth / 4,
            ),
            child: child,
          );
        } else {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: child,
          );
        }
      },
    );
  }
}
