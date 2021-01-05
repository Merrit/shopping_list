import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/globals.dart';

/// Create a new list document in Firebase.
Future<void> createNewList(
    {@required BuildContext context, @required String listName}) async {
  FirestoreUser user = Provider.of<FirestoreUser>(context, listen: false);
  String uid = Globals.user.uid;

  FirebaseFirestore.instance.collection('lists').doc().set(
    {
      'listName': listName,
      'owner': uid,
      'allowedUsers': {uid: true},
      'aisles': ['Unsorted'],
    },
    SetOptions(merge: true),
  );

  await user.getCurrentLists();

  if (user.lists.length == 1) {
    user.currentList = user.lists.keys.first;
    user.currentListName = user.lists.values.first['listName'];
  }

  return null;
}
