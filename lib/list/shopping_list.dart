import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_list/database/list_manager.dart';
import 'package:shopping_list/list/item.dart';

class ShoppingList extends ChangeNotifier {
  final List<String> aisles;
  final String id;
  final ListManager listManager;
  final DocumentReference listReference;
  String name = '';

  ShoppingList({
    required DocumentSnapshot listSnapshot,
    required Map<String, dynamic> snapshotData,
  })   : aisles = List<String>.from(snapshotData['aisles']),
        id = listSnapshot.id,
        listManager = ListManager.instance,
        listReference = listSnapshot.reference,
        name = snapshotData['name'];

  Stream<DocumentSnapshot> listStream() => listReference.snapshots();

  void createNewItem(Item item) {
    FirebaseFirestore.instance.collection('lists').doc(id).set({
      'items': {item.name: item.toJson()}
    }, SetOptions(merge: true));
  }
}
