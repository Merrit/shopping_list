import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';

/// Add a new item to the current shopping list.
void addListItem(
    {@required BuildContext context, @required String itemName, String aisle}) {
  var _aisle = aisle ?? 'Unsorted';
  FirestoreUser user = Provider.of<FirestoreUser>(context, listen: false);

  FirebaseFirestore.instance.collection('lists').doc(user.currentList).set(
    {
      'items': {
        itemName: {
          'itemName': itemName,
          'aisle': _aisle,
        },
      },
    },
    SetOptions(merge: true),
  );

  //   .Provider
  //   .of<FirestoreUser>(context, listen: false)
  //   .currentListReference
  //   .collection('items')
  //   .add({
  // 'itemName': itemName,
  // 'aisle': _aisle,
  // });
}
