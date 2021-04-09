import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_list/database/list_manager.dart';
import 'package:shopping_list/list/item.dart';
import 'package:shopping_list/list/shopping_list.dart';
import 'package:shopping_list/list/state/checked_items.dart';

class ListItemsState extends ChangeNotifier {
  final List<Item> completedItems = [];
  bool hasCompletedItems = false;
  final List<Item> items = [];
  final ListManager listManager = ListManager.instance;
  late final DocumentReference listReference;

  ListItemsState._singleton() : listReference = ShoppingList.listReference;
  static final instance = ListItemsState._singleton();

  void trackItem(Item item) {
    if (item.isComplete) {
      _addToCompleted(item);
    } else {
      _addToItems(item);
    }
    hasCompletedItems = _checkForCompleted();
  }

  void _addToCompleted(Item item) {
    items.removeWhere((element) => element.name == item.name);
    completedItems.add(item);
  }

  void _addToItems(Item item) {
    completedItems.removeWhere((element) => element.name == item.name);
    items.add(item);
  }

  bool _checkForCompleted() => completedItems.isNotEmpty;

  void setItemsCompletion(List<String> names, bool setComplete) {
    final itemsToChange =
        (setComplete) ? _setCompleted(names) : _setNotCompleted(names);
    listManager.updateItems(itemsToChange, listReference);
    _waitForFirebaseThenNotify();
  }

  List<Item> _setCompleted(List<String> names) {
    final itemsToChange = <Item>[];
    names.forEach((name) {
      var item = items.firstWhere((element) => element.name == name);
      item.isComplete = true;
      itemsToChange.add(item);
    });
    CheckedItems.instance.clearCheckedItems();
    return itemsToChange;
  }

  List<Item> _setNotCompleted(List<String> names) {
    final itemsToChange = <Item>[];
    names.forEach((name) {
      var item = completedItems.firstWhere((element) => element.name == name);
      item.isComplete = false;
      itemsToChange.add(item);
      completedItems.removeWhere((element) => element.name == name);
    });
    return itemsToChange;
  }

  Future<void> _waitForFirebaseThenNotify() async {
    await Future.delayed(Duration(seconds: 5));
    notifyListeners();
  }
}
