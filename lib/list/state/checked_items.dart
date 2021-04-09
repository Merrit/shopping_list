import 'package:flutter/foundation.dart';

class CheckedItems extends ChangeNotifier {
  bool containsCheckedItems = false;
  final List<String> itemList = [];

  CheckedItems._singleton();
  static final instance = CheckedItems._singleton();

  List<String> get items => itemList;

  bool isItemChecked(String name) => itemList.contains(name);

  void toggleCheckedStatus(String name) {
    if (itemList.contains(name)) {
      itemList.remove(name);
    } else {
      itemList.add(name);
    }
    _setContainsCheckedItems();
    notifyListeners();
  }

  void _setContainsCheckedItems() {
    containsCheckedItems = itemList.isEmpty ? false : true;
  }

  void clearCheckedItems() {
    itemList.clear();
    _setContainsCheckedItems();
    notifyListeners();
  }
}
