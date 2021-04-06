import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:money2/money2.dart';
import 'package:shopping_list/database/list_manager.dart';
import 'package:shopping_list/preferences/preferences.dart';

class App extends ChangeNotifier {
  // late ShoppingList currentList;
  final currency = Currency.create('USD', 2);
  String? currentList = '';
  // final Query database = ListManager.instance.lists();
  static final App instance = App._singleton();
  // List<String> lists = [];
  // late Future<List<ShoppingList>> _lists;
  final _log = Logger('App');
  late User user;

  App._singleton() {
    _log.info('Initialized');
  }

  /// Populate the inital data the app will need.
  Future<void> init() async {
    // await _setEmulator();  // Enable to use local Firebase emulator.
    await Preferences.instance.initPrefs();
    // await _fetchListsData();
    await _setCurrentList();
    // _listenToDatabase();
    // _log.info('currentList: $currentList');
  }

  // void _listenToDatabase() {
  //   database.snapshots().listen((event) {
  //     event.docChanges.forEach((doc) {
  //       if (doc.type == DocumentChangeType.added) {
  //         final listId = doc.doc.id;
  //         _addToLists(listId);
  //       }
  //     });
  //   });
  // }

//   ONLY GET LIST OF LISTS ON DEMAND, MAKE A METHOD FOR THAT

//   IF SAVED CURRENT LIST IS NOT AVAILABLE, ONLY THEN GET LIST OF LISTS AND USE FIRST

//   void _addToLists(String listId) {
// firstListPopulated = Future.value(true);
//     lists.add(listId);
//   }

  // Future<List<ShoppingList>> lists() async {

  // }

  // Future<void> _fetchListsData() async {
  //   _lists = await ListManager().lists();
  //   notifyListeners();
  // }

  /// Populate [currentList] on app startup.
  Future<void> _setCurrentList() async {
    currentList = Preferences.instance.lastUsedListName();
    _log.info('lastUsedListName: $currentList');
  }

  // /// The StreamBuilder for [ListScreen] listens to this in order
  // /// to build the main list UI. Updates automatically with new items.
  // Stream<DocumentSnapshot> listStream() {
  //   return FirebaseFirestore.instance
  //       .collection('lists')
  //       .doc(currentList.name)
  //       .snapshots();
  // }

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
