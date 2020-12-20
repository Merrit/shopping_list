import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';

/// Create a new list document in Firebase.
void createNewList(
    {@required BuildContext context, @required String listName}) {
  Provider.of<FirestoreUser>(context, listen: false)
      .userDoc
      .collection('lists')
      .doc(listName)
      .set({'listName': listName}, SetOptions(merge: true));

  Provider.of<FirestoreUser>(context, listen: false).listNames.add(listName);
}
