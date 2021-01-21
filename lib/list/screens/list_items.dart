import 'package:flutter/material.dart';
import 'package:shopping_list/firestore/firestore_user.dart';

/// Holds the state for the current list.
class ListItems extends ChangeNotifier {
  Map<String, bool> _checkedItems = {};

  /// List items are added here as Map<itemName, isChecked>.
  Map<String, bool> get checkedItems {
    return _checkedItems;
  }

  /// Track whether the item's checkbox is checked or not.
  void setItemState(
      {@required String itemName,
      @required bool isChecked,
      bool isUpdate = false}) {
    assert(itemName != null && isChecked != null);
    _checkedItems[itemName] = isChecked;
    if (isUpdate) notifyListeners();
  }

  void reset() => _checkedItems.clear();

  /// Set items' complete status.
  void completeItems(FirestoreUser firestoreUser) {
    Map<String, bool> toBeCompleted = {};
    _checkedItems.forEach((itemName, value) {
      if (value) toBeCompleted[itemName] = true;
    });
    firestoreUser.setIsComplete(items: toBeCompleted);
    _checkedItems.clear();
    notifyListeners();
  }

  void deleteItems(FirestoreUser firestoreUser, {bool deleteAll = false}) {
    List<String> itemsToDelete = [];
    if (deleteAll) {
      _checkedItems.forEach((itemName, _) => itemsToDelete.add(itemName));
      _checkedItems.clear();
    } else {
      _checkedItems.forEach((itemName, isChecked) {
        if (isChecked) {
          itemsToDelete.add(itemName);
        }
      });
      itemsToDelete.forEach((item) => _checkedItems.remove(item));
    }
    notifyListeners();
    firestoreUser.deleteItems(items: itemsToDelete);
  }

  /// Restore items from the `Completed` list back to the regular list.
  void restoreItems(FirestoreUser firestoreUser) {
    Map<String, bool> itemsToRestore = {};
    _checkedItems.forEach((itemName, isChecked) {
      if (isChecked) {
        itemsToRestore[itemName] = false;
        _checkedItems[itemName] = false;
      }
    });
    firestoreUser.setIsComplete(items: itemsToRestore);
    notifyListeners();
  }
}
