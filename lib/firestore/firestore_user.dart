import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/globals.dart';
import 'package:shopping_list/preferences.dart';

class FirestoreUser extends ChangeNotifier {
  /// Provides direct access to this user's section in Firestore.
  DocumentReference userDoc;

  Map<String, dynamic> lists = {};

  void deleteList(String listID) {
    FirebaseFirestore.instance.collection('lists').doc(listID).delete();
    lists.remove(listID);
    if (currentList == listID) currentList = '';
    notifyListeners();
  }

  List<Widget> drawerListWidgets = [];
  static bool editingDrawer = false;

  /// The stream the app's StreamBuilder listens to in order
  /// to build the main list UI.
  CollectionReference listItems;

  Map<String, String> get listNames {
    Map<String, String> _names = {};
    lists.forEach((key, value) => _names[key] = value.data()['listName']);
    return _names;
  }

  void removeListName(String listID) {
    lists.remove(listID);
    notifyListeners();
  }

  FirestoreUser() {
    this.userDoc =
        FirebaseFirestore.instance.collection('users').doc(Globals.user.uid);
  }

  String get currentList {
    return _currentList;
  }

  static String _currentList = '';

  set currentList(String listID) {
    if (listID == '' && lists.isNotEmpty) {
      _currentList = lists.keys.first;
    } else if (listID == '' && lists.isEmpty) {
      _currentList = 'No lists yet';
    } else {
      _currentList = listID;
    }
    setListStream();
    notifyListeners();
    Preferences.lastUsedList = listID;
  }

  Stream<DocumentSnapshot> listStream;

  void setListStream() {
    listStream = (_currentList != 'No lists yet')
        ? FirebaseFirestore.instance
            .collection('lists')
            .doc(_currentList)
            .snapshots()
        : null;
  }

  String get currentListName {
    if (lists.isNotEmpty && lists.keys.contains(currentList)) {
      _currentListName = lists[currentList]['listName'];
    } else {
      _currentListName = 'No lists yet';
    }
    return _currentListName;
  }

  String _currentListName = '';

  set currentListName(String listName) {
    _currentListName = listName;
    notifyListeners();
  }

  List<String> _aisles = [];

  /// The aisles by which list items are grouped.
  List<String> get aisles => _aisles;

  Future<void> _getAislesData() async {
    if (lists.isNotEmpty && _aisles.isEmpty) {
      List<String> currentListAisles =
          List<String>.from(lists[currentList]['aisles']);
      if (currentListAisles != null) _aisles = currentListAisles;
    }
    if (_aisles.isEmpty) {
      _aisles.add('Unsorted');
    }
    return null;
  }

  Future<void> addAisle({@required String newAisle}) async {
    if (!_aisles.contains(newAisle)) {
      _aisles.add(newAisle);
      _aisles.sort();
      FirebaseFirestore.instance
          .collection('lists')
          .doc(currentList)
          .update({'aisles': _aisles});
      notifyListeners();
    }
  }

  Future<void> removeAisle({@required String aisle}) async {
    _aisles.remove(aisle);
    FirebaseFirestore.instance.collection('lists').doc(currentList).set(
      {'aisles': _aisles},
      SetOptions(merge: true),
    );
    notifyListeners();
  }

  /// Populate the inital data the main app screen will need.
  Future<bool> setInitialData() async {
    // await _setEmulator();
    await Preferences.initPrefs();
    // Check what lists the user has, if any.
    await getCurrentLists();
    _loadInitialCurrentList();
    setListStream();
    _getAislesData();
    return true;
  }

  void _loadInitialCurrentList() {
    if (lists.length > 0) {
      // Check for a stored 'last used list'.
      var lastUsedList = Preferences.lastUsedList;
      var listIDs = [];
      lists.forEach((key, value) => listIDs.add(key));
      if (listIDs.contains(lastUsedList)) {
        _currentList = lastUsedList;
      } else {
        // We have to set a list so widgets
        // don't throw errors by loading nothing.
        _currentList = lists.keys.first;
      }
    } else {
      // No stored lists.
      _currentList = 'No lists yet';
    }
  }

  Future<void> _setEmulator() async {
    String host = defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2:8080'
        : 'localhost:8080';
    FirebaseFirestore.instance.settings =
        Settings(host: host, sslEnabled: false);
    return;
  }

  Future<void> getCurrentLists() async {
    var uid = Globals.user.uid;
    var query = await FirebaseFirestore.instance
        .collection('lists')
        .where('allowedUsers.$uid', isEqualTo: true)
        .get();
    lists.clear();
    query.docs.forEach((doc) {
      lists[doc.id] = Map<String, dynamic>.from(doc.data());
    });
    notifyListeners();
    return null;
  }
}
