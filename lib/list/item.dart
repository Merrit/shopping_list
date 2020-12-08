import 'package:flutter/foundation.dart';

/// Represents a single item in a list.
/// May optionally contain sub-items.
class Item {
  /// Name of the item or product.
  String itemName;

  /// Category or aisle. For example "Dairy", or "Electronics".
  String category;

  /// Number of items. For example 3, for "3 Cabbages".
  int amount;

  List subItems = [];

  Item({
    @required this.itemName,
    this.category = "",
    this.amount = 0,
  });
}
