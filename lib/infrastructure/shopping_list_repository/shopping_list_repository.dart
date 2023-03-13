import '../../shopping_list/shopping_list.dart';

export '../../shopping_list/validators/validators.dart';
export 'firebase_shopping_list_repository.dart';

abstract class ShoppingListRepository {
  Future<void> createNewShoppingList(ShoppingList shoppingList);

  Future<List<ShoppingList>> shoppingLists();

  Stream<List<ShoppingList>> shoppingListsStream();

  Future<void> updateShoppingList(ShoppingList shoppingList);

  Future<void> deleteShoppingList(ShoppingList shoppingList);
}
