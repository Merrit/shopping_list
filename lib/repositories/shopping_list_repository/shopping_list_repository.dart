import 'repository.dart';

abstract class ShoppingListRepository {
  Future<void> createNewShoppingList(ShoppingList shoppingList);

  Future<List<ShoppingList>> shoppingLists();

  Stream<List<ShoppingList>> shoppingListsStream();

  Future<void> updateShoppingList(ShoppingList shoppingList);

  Future<void> deleteShoppingList(ShoppingList shoppingList);
}
