import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';

/// Add a new item to the current shopping list.
void addListItem({
  @required BuildContext context,
  @required String itemName,
  String aisle,
}) {
  var _aisle = aisle ?? 'Unsorted';
  Provider.of<FirestoreUser>(context, listen: false)
      .currentListReference
      .collection('items')
      .add({
    'itemName': itemName,
    'aisle': _aisle,
  });
}
