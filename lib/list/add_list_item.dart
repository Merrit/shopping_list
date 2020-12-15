import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';

/// Add a new item to the current shopping list.
void addListItem({@required BuildContext context, @required String itemName}) {
  var _firestoreUser = Provider.of<FirestoreUser>(context, listen: false);
  _firestoreUser.userDoc
      .collection('lists')
      .doc(_firestoreUser.currentListName)
      .collection('items')
      .add({
    'itemName': itemName,
  });
}
