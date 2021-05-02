import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../shopping_list_repository.dart';

part 'item.g.dart';

@immutable
@JsonSerializable()
class Item extends Equatable {
  final String name;
  final String aisle;
  final String notes;
  final bool isComplete;
  final bool hasTax;
  final String quantity;
  final String price;
  final String total;

  @JsonKey(defaultValue: <String>[])
  final List<String> labels;

  Item({
    required this.name,
    this.aisle = 'None',
    this.notes = '',
    this.isComplete = false,
    this.hasTax = false,
    String quantity = '1',
    this.price = '0.00',
    this.total = '0.00',
    this.labels = const [],
  }) : quantity = QuantityValidator(quantity).validate();

  Item copyWith({
    String? name,
    String? aisle,
    String? notes,
    bool? isComplete,
    bool? hasTax,
    String? quantity,
    String? price,
    String? total,
    List<String>? labels,
  }) {
    return Item(
      name: name ?? this.name,
      aisle: aisle ?? this.aisle,
      notes: notes ?? this.notes,
      isComplete: isComplete ?? this.isComplete,
      hasTax: hasTax ?? this.hasTax,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
      labels: labels ?? this.labels,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  @override
  List<Object?> get props => [
        name,
        aisle,
        notes,
        isComplete,
        hasTax,
        quantity,
        price,
        total,
        labels,
      ];

  @override
  String toString() {
    return '''\n
Item {
  name: $name,
  aisle: $aisle,
  notes: $notes,
  isComplete: $isComplete,
  hasTax: $hasTax,
  quantity: $quantity,
  price: $price,
  total: $total,
  labels: $labels,
}\n''';
  }
}
