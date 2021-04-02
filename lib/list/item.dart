import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  Item({
    required this.aisle,
    required this.isComplete,
    required this.name,
    required this.notes,
    required this.price,
    required this.quantity,
    required this.total,
  });

  String aisle;
  bool isComplete;
  String name;
  String notes;
  double price;
  double quantity;
  double total;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
