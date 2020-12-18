import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/globals.dart';

class FirestoreUser extends ChangeNotifier {
  /// Provides direct access to this user's section in Firestore.
  DocumentReference userDoc;

  FirestoreUser() {
    this.userDoc =
        FirebaseFirestore.instance.collection('users').doc(Globals.user.uid);
  }

  static String _currentListName = '';

  String get currentListName {
    return _currentListName;
  }

  set currentListName(String value) {
    _currentListName = value;
    _setListItems();
    notifyListeners();
    Globals.prefs.setString('lastUsedList', value);
  }

  /// The stream the app's StreamBuilder listens to in order
  /// to build the main list UI.
  CollectionReference listItems;

  void _setListItems() {
    listItems = FirebaseFirestore.instance
        .collection('users')
        .doc(Globals.user.uid)
        .collection('lists')
        .doc(_currentListName)
        .collection('items');
  }

  /// Populate the inital data the main app screen will need.
  Future<bool> setInitialData() async {
    await Globals.initPrefs();
    // Check what lists the user has, if any.
    List<String> storedLists = await _getCurrentLists();
    if (storedLists.length > 0) {
      // Check for a stored 'last used list'.
      String lastUsedList = await _getLastUsedList();
      if (storedLists.contains(lastUsedList)) {
        _currentListName = lastUsedList;
      } else {
        // We have to set a list so widgets
        // don't throw errors by loading nothing.
        _currentListName = storedLists[0];
      }
    } else {
      // No stored lists. Create a default list.
      _currentListName = 'Shopping List';
    }
    _setListItems();
    return true;
  }

  static Future<List<String>> _getCurrentLists() async {
    // Find what lists exist.
    QuerySnapshot listsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(Globals.user.uid)
        .collection('lists')
        .get();
    List<String> listNames = [];
    listsSnapshot.docs.forEach((list) {
      listNames.add(list.id);
    });
    return listNames;
  }

  /// Returns null if none present.
  static Future<String> _getLastUsedList() async {
    String lastList = Globals.prefs.getString('lastUsedList');
    return lastList;
  }
}
