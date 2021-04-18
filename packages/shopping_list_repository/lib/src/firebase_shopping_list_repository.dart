import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list_repository/src/models/shopping_list.dart';

import 'entities/shopping_list_entity.dart';
import 'shopping_list_repository.dart';

class FirebaseShoppingListRepository implements ShoppingListRepository {
  final shoppingListCollection = FirebaseFirestore.instance.collection('lists');

  @override
  Future<void> createNewShoppingList(ShoppingList shoppingList) {
    return shoppingListCollection.add(shoppingList.toEntity().toDocument());
  }

  @override
  Stream<List<ShoppingList>> shoppingLists() {
    return shoppingListCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ShoppingList.fromEntity(
          ShoppingListEntity.fromSnapshot(doc),
        );
      }).toList();
    });
  }

  @override
  Future<void> updateShoppingList(ShoppingList update) {
    return shoppingListCollection
        .doc(update.id)
        .update(update.toEntity().toDocument());
  }

  @override
  Future<void> deleteShoppingList(ShoppingList shoppingList) {
    return shoppingListCollection.doc(shoppingList.id).delete();
  }
}
