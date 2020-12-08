import 'package:flutter/cupertino.dart';
import 'package:shopping_list/list/list.dart';

class ListCollection {
  Map<String, ShoppingList> lists = {};

  void createNewList({@required String listName}) {
    lists[listName] = ShoppingList(storeName: listName);
  }
}
