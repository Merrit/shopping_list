import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// The tile that represents each item in the main list screen.
class ShoppingListTile extends StatelessWidget {
  final DocumentSnapshot document;
  final String item;

  ShoppingListTile({
    @required this.document,
  }) : this.item = document.data()['itemName'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 3, child: Text(item)),
              Expanded(flex: 1, child: Text('')), // #
              Expanded(flex: 1, child: Text('')), // $
              Expanded(flex: 1, child: Text('')), // $ total
              Expanded(
                  flex: 1,
                  child: Checkbox(value: false, onChanged: (value) {})),
            ],
          )
        ],
      ),
    );
  }
}
