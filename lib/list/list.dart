import 'package:flutter/foundation.dart';
import 'package:shopping_list/list/item.dart';

class ShoppingList {
  final String storeName;
  final List<Item> items;
  // customColor;

  ShoppingList({@required this.storeName}) : items = [];
}
