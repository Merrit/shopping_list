import 'package:flutter/foundation.dart';
import 'package:shopping_list/list/item.dart';

class ShoppingListState extends ChangeNotifier {
  // final List<String> aisles;
  // final List<Item> items;
  String name = '';

  changeListName(String newName) {}

  createItem(Item item) {}

  deleteItems(List<Item> itemsToDelete) {}

  updateItems(List<Item> itemsToUpdate) {}
}
