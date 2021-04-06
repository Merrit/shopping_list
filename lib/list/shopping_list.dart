import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_list/list/item.dart';

class ShoppingList extends ChangeNotifier {
  final List<String> aisles;
  final String id;
  Map<String, Map<String, dynamic>> items = {};
  final DocumentReference listReference;
  String name = '';

  ShoppingList({
    required DocumentSnapshot listSnapshot,
    required Map<String, dynamic> snapshotData,
  })   : aisles = List<String>.from(snapshotData['aisles']),
        id = listSnapshot.id,
        listReference = listSnapshot.reference,
        name = snapshotData['name'] {
    _listenToStream();
  }

  void _listenToStream() {
    listStream().listen((event) {
      event.data()!.forEach((key, value) {
        if (key == 'items') {
          final list = Map<String, Map<String, dynamic>>.from(value);
          _updateItems(list);
        }
      });
    });
  }

  void _updateItems(Map<String, Map<String, dynamic>> itemsFromFirebase) {
    items = itemsFromFirebase;
    notifyListeners();
  }

  Stream<DocumentSnapshot> listStream() => listReference.snapshots();

  void createNewItem(Item item) =>
      FirebaseFirestore.instance.collection('lists').doc(id).set({
        'items': {item.name: item.toJson()}
      }, SetOptions(merge: true));

  bool containsCompletedItems() {
    final containsCompleted = items.values.any((item) {
      return item['isComplete'] == true;
    });
    return containsCompleted;
  }
}
