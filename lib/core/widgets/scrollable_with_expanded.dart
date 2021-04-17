import 'package:flutter/material.dart';

/// Widget that provides a SingleChildScrollView which can also contain
/// items like Expanded(), Spacer(), Flexible(), etc.
class ScrollableWithExpanded extends StatelessWidget {
  final List<Widget> children;

  const ScrollableWithExpanded({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }
}
