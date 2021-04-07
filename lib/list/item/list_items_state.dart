import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_list/database/list_manager.dart';
import 'package:shopping_list/list/item.dart';

class ListItemsState extends ChangeNotifier {
  final Map<String, bool> checkedItems = {};
  final List<Item> completedItems = [];
  bool hasCompletedItems = false;
  final List<Item> items = [];
  final ListManager listManager = ListManager.instance;
  final DocumentReference listReference;

  ListItemsState(this.listReference);

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

  void setItemsCompletion(List<String> names, bool value) {
    final itemsToChange = <Item>[];
    names.forEach((name) {
      var item = items.firstWhere((element) => element.name == name);
      item.isComplete = value;
      itemsToChange.add(item);
    });
    listManager.updateItems(itemsToChange, listReference);
    _waitForFirebaseThenNotify();
  }

  Future<void> _waitForFirebaseThenNotify() async {
    await Future.delayed(Duration(seconds: 5));
    notifyListeners();
  }
}
