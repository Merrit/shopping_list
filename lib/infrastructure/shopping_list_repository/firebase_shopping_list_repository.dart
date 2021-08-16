import 'package:cloud_firestore/cloud_firestore.dart';

import 'shopping_list_repository.dart';

class FirebaseShoppingListRepository implements ShoppingListRepository {
  final shoppingListCollection = FirebaseFirestore.instance.collection('lists');
  final String userId;

  FirebaseShoppingListRepository(this.userId);

  @override
  Future<void> createNewShoppingList(ShoppingList shoppingList) {
    return shoppingListCollection.add(shoppingList.toJson());
  }

  @override
  Future<List<ShoppingList>> shoppingLists() async {
    final query = shoppingListCollection.where('owner', isEqualTo: userId);
    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final json = doc.data();
      json['id'] = doc.id;
      final shoppingList = ShoppingList.fromJson(json);
      return shoppingList;
    }).toList();
  }

  @override
  Stream<List<ShoppingList>> shoppingListsStream() {
    final listsQuery = shoppingListCollection.where('owner', isEqualTo: userId);
    return listsQuery.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final json = doc.data();
        json['id'] = doc.id;
        final shoppingList = ShoppingList.fromJson(json);
        return shoppingList;
      }).toList();
    });
  }

  @override
  Future<void> updateShoppingList(ShoppingList list) {
    final json = list.toJson();
    return shoppingListCollection.doc(list.id).update(json);
  }

  @override
  Future<void> deleteShoppingList(ShoppingList shoppingList) {
    return shoppingListCollection.doc(shoppingList.id).delete();
  }
}
