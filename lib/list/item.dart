import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

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

  Item({
    required this.aisle,
    required this.hasTax,
    required this.isComplete,
    required this.name,
    required this.notes,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  void setIsComplete(bool value) {
    isComplete = value;
    notifyListeners();
  }
}
