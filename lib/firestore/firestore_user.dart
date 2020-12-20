import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/globals.dart';

class FirestoreUser extends ChangeNotifier {
  /// Provides direct access to this user's section in Firestore.
  DocumentReference userDoc;

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
    // TODO: Create prefs class with getters/methods and prepend every setting
    // with the unique user id.
    Globals.prefs.setString('lastUsedList', value);
  }

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
      // No stored lists.
      _currentListName = 'No lists yet';
    }
    _setListItems();
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

  /// Returns null if none present.
  static Future<String> _getLastUsedList() async {
    String lastList = Globals.prefs.getString('lastUsedList');
    return lastList;
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
