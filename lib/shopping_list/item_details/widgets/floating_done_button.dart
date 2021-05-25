import 'package:flutter/material.dart';
import 'package:shopping_list/core/core.dart';

class FloatingDoneButton extends StatelessWidget {
  const FloatingDoneButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingButton(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Done'),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
