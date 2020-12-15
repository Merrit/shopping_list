import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/globals.dart';

/// Provides direct access to this user's section in Firestore.
class FirestoreUser extends ChangeNotifier {
  DocumentReference userDoc;

  FirestoreUser() {
    this.userDoc =
        FirebaseFirestore.instance.collection('users').doc(Globals.user.uid);
    // this.userDoc = getUserDoc();
  }

  String _currentListName = '';
  String get currentListName => _currentListName;
  set currentListName(String value) {
    _currentListName = value;
    notifyListeners();
  }

  // Future<DocumentReference> getUserDoc() async {
  //   return await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(Globals.user.uid);
  // }
}
