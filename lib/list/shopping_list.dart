import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_list/database/list_manager.dart';
import 'package:shopping_list/list/item.dart';

class ShoppingList extends ChangeNotifier {
  late final List<String> aisles;
  late final String id;
  late final ListManager listManager;
  static late final DocumentReference listReference;
  late String name = '';

  // ShoppingList({
  //   required DocumentSnapshot listSnapshot,
  //   required Map<String, dynamic> snapshotData,
  // })   : aisles = List<String>.from(snapshotData['aisles']),
  //       id = listSnapshot.id,
  //       listManager = ListManager.instance,
  //       listReference = listSnapshot.reference,
  //       name = snapshotData['name'];

  ShoppingList._singleton();
  static final _instance = ShoppingList._singleton();

  factory ShoppingList(
      {required DocumentSnapshot listSnapshot,
      required Map<String, dynamic> snapshotData}) {
    _instance.aisles = List<String>.from(snapshotData['aisles']);
    _instance.id = listSnapshot.id;
    _instance.listManager = ListManager.instance;
    ShoppingList.listReference = listSnapshot.reference;
    _instance.name = snapshotData['name'];
    return _instance;
  }

  Stream<DocumentSnapshot> listStream() => listReference.snapshots();

  void createNewItem(Item item) {
    FirebaseFirestore.instance.collection('lists').doc(id).set({
      'items': {item.name: item.toJson()}
    }, SetOptions(merge: true));
  }

  void updateItems(List<Item> items) {
    listManager.updateItems(items, listReference);
  }
}
