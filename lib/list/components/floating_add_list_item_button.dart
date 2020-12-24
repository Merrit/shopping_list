import 'package:flutter/material.dart';
import 'package:shopping_list/list/components/add_item_dialog.dart';

class FloatingAddListItemButton extends StatefulWidget {
  @override
  _FloatingAddListItemButtonState createState() =>
      _FloatingAddListItemButtonState();
}

class _FloatingAddListItemButtonState extends State<FloatingAddListItemButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddItemDialog();
            });
      },
    );
  }
}
