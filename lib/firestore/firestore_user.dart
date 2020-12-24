import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/globals.dart';
import 'package:shopping_list/preferences.dart';

class FirestoreUser extends ChangeNotifier {
  /// Provides direct access to this user's section in Firestore.
  DocumentReference userDoc;

  DocumentReference get currentListReference {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Globals.user.uid)
        .collection('lists')
        .doc(_currentListName);
  }

  static String _currentListName = '';

  List<Widget> drawerListWidgets = [];
  static bool editingDrawer = false;

  /// The stream the app's StreamBuilder listens to in order
  /// to build the main list UI.
  CollectionReference listItems;

  List<String> listNames;

  FirestoreUser() {
    this.userDoc =
        FirebaseFirestore.instance.collection('users').doc(Globals.user.uid);
  }

  String get currentListName {
    return _currentListName;
  }

  set currentListName(String value) {
    if (value == '') {
      try {
        value = listNames[0];
      } catch (e) {
        value = 'No lists yet';
      }
    }
    _currentListName = value;
    _setListItems();
    notifyListeners();
    Preferences.lastUsedList = value;
  }

  void _setListItems() {
    listItems = FirebaseFirestore.instance
        .collection('users')
        .doc(Globals.user.uid)
        .collection('lists')
        .doc(_currentListName)
        .collection('items');
  }

  List<String> _aisles = [];

  /// The aisles by which list items are grouped.
  List<String> get aisles => _aisles;

  Future<void> _getAislesData() async {
    QuerySnapshot querySnapshot =
        await currentListReference.collection('aisles').get();
    if (_aisles.isEmpty) {
      // This was getting run twice for some reason on
      // hot restart, duplicating the list?! So we check.
      // TODO: Figure out why and fix better.
      querySnapshot.docs.forEach((element) => _aisles.add(element.id));
    }
  }

  Future<void> addAisle({@required String newAisle}) async {
    if (!_aisles.contains(newAisle)) {
      _aisles.add(newAisle);
      _aisles.sort();
      currentListReference
          .collection('aisles')
          .doc(newAisle)
          .set({'aisleName': newAisle});
      notifyListeners();
    }
  }

  Future<void> removeAisle({@required String aisle}) async {
    _aisles.remove(aisle);
    currentListReference.collection('aisles').doc(aisle).delete();
    notifyListeners();
  }

  /// Populate the inital data the main app screen will need.
  Future<bool> setInitialData() async {
    await Preferences.initPrefs();
    // Check what lists the user has, if any.
    List<String> storedLists = await _getCurrentLists();
    if (storedLists.length > 0) {
      // Check for a stored 'last used list'.
      String lastUsedList = Preferences.lastUsedList;
      if (storedLists.contains(lastUsedList)) {
        _currentListName = lastUsedList;
      } else {
        // We have to set a list so widgets
        // don't throw errors by loading nothing.
        _currentListName = storedLists[0];
      }
    } else {
      // No stored lists.
      _currentListName = 'No lists yet';
    }
    _getAislesData();
    _setListItems();
    aisles;
    return true;
  }

  Future<List<String>> _getCurrentLists() async {
    // Find what lists exist.
    QuerySnapshot listsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(Globals.user.uid)
        .collection('lists')
        .get();
    listNames = [];
    listsSnapshot.docs.forEach((list) {
      listNames.add(list.id);
    });
    return listNames;
  }

  // void buildDrawerListTiles(BuildContext context) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(Globals.user.uid)
  //       .collection('lists')
  //       .snapshots()
  //       .listen((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((QueryDocumentSnapshot document) {
  //       drawerListWidgets.add(ListTile(
  //         title: Center(child: Text(document.id)),
  //         trailing: editingDrawer ? Icon(Icons.remove_circle) : null,
  //         onTap: () {
  //           Provider.of<FirestoreUser>(context, listen: false).currentListName =
  //               document.id;
  //           // setCurrentList();
  //           setState(() => Navigator.pop(context));
  //         },
  //       ));
  //     });
  //   });
  // }
}
