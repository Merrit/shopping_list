import 'package:flutter/foundation.dart';
import 'package:shopping_list/list/item.dart';

class Product extends Item {
  String itemName;
  String category;
  int amount;
  List subItems = [];

  Product({
    @required this.itemName,
    this.category = "",
    this.amount = 0,
  });
}
