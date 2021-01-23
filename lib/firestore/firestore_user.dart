import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shopping_list/globals.dart';
import 'package:shopping_list/preferences.dart';

/// [FirestoreUser] is the Provider-powered hub that handles Firebase data.
class FirestoreUser extends ChangeNotifier {
  /// All lists the user has access to.
  ///
  /// Takes the form of `{listUID: dynamic}`.
  Map<String, dynamic> lists = {};

  /// Add a new item to the current shopping list.
  void addListItem(Map<String, dynamic> item) {
    var itemName = item['itemName'];
    // Add to Firebase.
    FirebaseFirestore.instance.collection('lists').doc(currentList).set({
      'items': {itemName: item}
    }, SetOptions(merge: true));
    // Add to local cache.
    lists[currentList]['items'][itemName] = item;
    // Make sure this isn't in completedItems already.
    // This could be necessary if the user adds a list item of something
    // they had previously checked off their list.
    completedItems.remove(itemName);
    notifyListeners();
  }

  /// `Map<itemName, bool>` with `bool` representing complete or not.
  Map<String, dynamic> completedItems = {};

  /// Set the `isComplete` status for completedItems.
  void setIsComplete({@required Map<String, bool> items}) {
    // Update local cache of items.
    items.forEach((itemName, value) {
      lists[currentList]['items'][itemName]['isComplete'] = value;
    });
    // Update completedItems.
    var _listItems = lists[currentList]['items'];
    _listItems.forEach((item, value) {
      if (value['isComplete'] == true) {
        completedItems[value['itemName']] = value;
      } else {
        completedItems.remove(value['itemName']);
      }
    });
    // Update Firebase items.
    updateAllItems(items: _listItems);
    // Notify widgets like Checked Items of changes.
    notifyListeners();
  }

  /// Update a single item.
  void updateItem(Map<String, dynamic> item) {
    var itemName = item['itemName'];
    // .set() is required, .update() will replace the entire 'items' field.
    FirebaseFirestore.instance.collection('lists').doc(currentList).set({
      'items': {itemName: item}
    }, SetOptions(merge: true));
  }

  /// Update the entire collection of items at once.
  void updateAllItems({@required Map<String, dynamic> items}) {
    FirebaseFirestore.instance
        .collection('lists')
        .doc(currentList)
        .update({'items': items});
  }

  void deleteItems({@required List<String> items}) {
    Map<String, dynamic> _currentItems = lists[currentList]['items'];
    items.forEach((item) {
      _currentItems.remove(item);
      completedItems.remove(item);
    });
    updateAllItems(items: _currentItems);
    notifyListeners();
  }

  /// The unique id for the current list.
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
    completedItems.clear();
    populateCompletedItems();
    _getAislesData();
    _setListStream();
    notifyListeners();
    Preferences.lastUsedList = listID;
  }

  void populateCompletedItems() {
    Map<String, dynamic> items;
    if (lists.length > 0) items = lists[currentList]['items'];
    if (items != null) {
      items.forEach((key, value) {
        if (value['isComplete'] == true) {
          completedItems[value['itemName']] = value;
        }
      });
    }
  }

  /// Name of the currently active list, for example: `Costco`.
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

  /// Fetch data from Firebase for every list user has access to.
  Future<void> fetchListsData() async {
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

  /// Create a new list document in Firebase.
  Future<void> createNewList({@required String listName}) async {
    String uid = Globals.user.uid;
    FirebaseFirestore.instance.collection('lists').doc().set(
      {
        'listName': listName,
        'owner': uid,
        'allowedUsers': {uid: true},
        'aisles': ['Unsorted'],
        'items': {},
      },
      SetOptions(merge: true),
    );
    await fetchListsData();
    if (lists.length == 1) {
      currentList = lists.keys.first;
      currentListName = lists.values.first['listName'];
    }
    return null;
  }

  void deleteList(String listID) {
    FirebaseFirestore.instance.collection('lists').doc(listID).delete();
    lists.remove(listID);
    if (currentList == listID) currentList = '';
    notifyListeners();
  }

  /// The stream `ListScreen()`'s StreamBuilder listens to in order
  /// to build the main list UI. Updates automatically with new items.
  Stream<DocumentSnapshot> listStream;

  void _setListStream() {
    listStream = (_currentList != 'No lists yet')
        ? FirebaseFirestore.instance
            .collection('lists')
            .doc(_currentList)
            .snapshots()
        : null;
  }

  /// The aisles by which list items are grouped.
  List<String> get aisles => _aisles;

  List<String> _aisles = [];

  /// Populate _aisles with data for the active list.
  Future<void> _getAislesData() async {
    if (lists.isNotEmpty) {
      _aisles.clear();
      var currentListAisles = List<String>.from(lists[currentList]['aisles']);
      if (currentListAisles != null) _aisles = currentListAisles;
    }
    if (_aisles.isEmpty) _aisles.add('Unsorted');
    return null;
  }

  void addAisle({@required String newAisle}) {
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

  void updateAisle({@required String item, String aisle}) {
    lists[currentList]['items'][item]['aisle'] = aisle;
    FirebaseFirestore.instance.collection('lists').doc(currentList).set(
      {
        'items': {
          item: {'aisle': aisle},
        },
      },
      SetOptions(merge: true),
    );
    notifyListeners();
  }

  void removeAisle({@required String aisle}) {
    _aisles.remove(aisle);
    // Grab the item data with correct type so we can update all item aisles.
    var items = lists[currentList]['items'];
    items.forEach((key, value) {
      if (!_aisles.contains(value['aisle'])) value['aisle'] = 'Unsorted';
    });
    var fireStore =
        FirebaseFirestore.instance.collection('lists').doc(currentList);
    // Update the aisles for the list on Firebase.
    fireStore.set(
      {'aisles': _aisles},
      SetOptions(merge: true),
    );
    // Update the aisles for the items in the list on Firebase.
    fireStore.set(
      {'items': items},
      SetOptions(merge: true),
    );
    notifyListeners();
  }

  /// Populate the inital data the main app screen will need.
  ///
  /// This is called on app startup to pre-load important data.
  Future<bool> setInitialData() async {
    // await _setEmulator();  // Enable to use local Firebase emulator.
    await Preferences.initPrefs();
    // Check what lists the user has, if any.
    await fetchListsData();
    _loadInitialCurrentList();
    _setListStream();
    _getAislesData();
    return true;
  }

  /// On startup, if any lists exist we set one as 'current' or active.
  void _loadInitialCurrentList() {
    if (lists.length > 0) {
      // Check for a stored 'last used list'.
      var lastUsedList = Preferences.lastUsedList;
      var listIDs = [];
      lists.forEach((key, value) => listIDs.add(key));
      if (listIDs.contains(lastUsedList)) {
        _currentList = lastUsedList;
      } else {
        // Current list from Preferences doesn't exist, but..
        // We have to set a list so widgets
        // don't throw errors by loading nothing.
        _currentList = lists.keys.first;
      }
    } else {
      // No lists found.
      _currentList = 'No lists yet';
    }
    populateCompletedItems();
  }

  /// Enable settings so the app will use the local Firebase emulator.
  // ignore: unused_element
  Future<void> _setEmulator() async {
    String host = defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2:8080'
        : 'localhost:8080';
    FirebaseFirestore.instance.settings =
        Settings(host: host, sslEnabled: false);
    return;
  }
}
