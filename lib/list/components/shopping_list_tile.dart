import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// The tile that represents each item in the main list screen.
class ShoppingListTile extends StatelessWidget {
  final DocumentSnapshot document;

  ShoppingListTile({
    @required this.document,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(document.data()['itemName']),
      onTap: () {
        document.reference.delete();
      },
    );
  }
}
