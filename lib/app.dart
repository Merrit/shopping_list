import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_list/list/shopping_list.dart';
import 'package:shopping_list/preferences/preferences.dart';

class App extends ChangeNotifier {
  // App is a singleton.
  App._privateConstructor();
  static final App instance = App._privateConstructor();

  late ShoppingList currentList;

  List<ShoppingList> lists = [];

  late final User user;

  /// Populate the inital data the app will need.
  Future<void> init() async {
    // await _setEmulator();  // Enable to use local Firebase emulator.
    await Preferences.initPrefs();
    await fetchListsData();
    currentList = _initCurrentList();
  }

  /// Populate [currentList] on app startup.
  ShoppingList _initCurrentList() {
    final lastUsedList = Preferences.lastUsedList();
    return lists.firstWhere(
      (list) => list.name == lastUsedList,
      orElse: () => lists.first,
    );
  }

  /// Fetch data from Firebase for every list user has access to.
  Future<void> fetchListsData() async {
    final uid = user.uid;
    //
    // TODO: If no lists exist, probably create an empty list here?
    //
    final query = await FirebaseFirestore.instance
        .collection('lists')
        .where('allowedUsers.$uid', isEqualTo: true)
        .get();
    lists.clear();
    if (query.docs.isNotEmpty) {
      // Add as objects to lists.
      query.docs.forEach((doc) {
        lists.add(ShoppingList.fromJson(doc.data()!));
        // lists[doc.id] = Map<String, dynamic>.from(doc.data());
      });
    } else {
      // If no lists yet exist,
      // Create new default list in Firebase & also add as object to lists.
      final newList = await createList(listName: 'My List');
      lists.add(ShoppingList.fromJson(newList));
    }
    notifyListeners();
  }

  /// The StreamBuilder for [ListScreen] listens to this in order
  /// to build the main list UI. Updates automatically with new items.
  Stream<DocumentSnapshot> listStream() {
    return FirebaseFirestore.instance
        .collection('lists')
        .doc(currentList.name)
        .snapshots();
  }

  /// Create a new list document in Firebase.
  Future<Map<String, dynamic>> createList({required String listName}) async {
    final uid = user.uid;
    final newList = <String, dynamic>{
      'name': listName,
      'owner': uid,
      'allowedUsers': {uid: true},
      'aisles': ['Unsorted'],
      'items': {},
    };
    await FirebaseFirestore.instance.collection('lists').doc().set(
          newList,
          SetOptions(merge: true),
        );
    return newList;
  }
}
