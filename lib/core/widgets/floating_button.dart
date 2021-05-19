import 'package:flutter/material.dart';

/// A floating action button that is not attached to a scaffold.
class FloatingButton extends StatelessWidget {
  final Widget floatingActionButton;

  const FloatingButton({
    Key? key,
    required this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: floatingActionButton,
      ),
    );
  }
}
