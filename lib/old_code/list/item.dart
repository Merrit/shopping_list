import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shopping_list/list/shopping_list.dart';

part 'item.g.dart';

@JsonSerializable()
class Item extends ChangeNotifier {
  String aisle;
  bool hasTax;
  bool isComplete;
  String name;
  String notes;
  String price;
  String quantity;
  String total;

  Map<String, Map<String, dynamic>>? originalJsonData;

  @JsonKey(ignore: true)
  late ShoppingList parentList;

  Item({
    required this.aisle,
    required this.hasTax,
    required this.isComplete,
    required this.name,
    required this.notes,
    required this.price,
    required this.quantity,
    required this.total,
    this.originalJsonData,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
