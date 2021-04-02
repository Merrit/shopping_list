import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shopping_list/list/item.dart';

part 'shopping_list.g.dart';

@JsonSerializable(explicitToJson: true)
class ShoppingList extends ChangeNotifier {
  ShoppingList(this.aisles, this.items, this.name);

  final List<String> aisles;

  final Map<String, Item> items;

  final String name;

  /// Add a new item to the list.
  void addItem(Item item) {
    // Add to Firebase.
    FirebaseFirestore.instance.collection('lists').doc(name).set({
      'items': {item.name: item.toJson()}
    }, SetOptions(merge: true));
    // Add to local cache.

    // lists[currentList]['items'][itemName] = item;
    // Make sure this isn't in completedItems already.
    // This could be necessary if the user adds a list item of something
    // they had previously checked off their list.
    // completedItems.remove(itemName);
    notifyListeners();
  }

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return _$ShoppingListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ShoppingListToJson(this);
}
