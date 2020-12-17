import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/globals.dart';

/// Provides direct access to this user's section in Firestore.
class FirestoreUser extends ChangeNotifier {
  DocumentReference userDoc;

  FirestoreUser() {
    this.userDoc =
        FirebaseFirestore.instance.collection('users').doc(Globals.user.uid);
  }

  String _currentListName = 'needDefault&lastUsed';
  String get currentListName => _currentListName;
  set currentListName(String value) {
    _currentListName = value;
    notifyListeners();
  }
}
