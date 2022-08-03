import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../shopping_list_repository.dart';

part 'item.g.dart';

@immutable
@JsonSerializable()
class Item extends Equatable {
  final String name;
  final String aisle;
  final String notes;
  final bool isComplete;
  final bool hasTax;
  final bool onSale;
  final bool buyWhenOnSale;
  final String quantity;
  final String price;
  final String total;

  const Item._internal({
    required this.name,
    required this.aisle,
    required this.notes,
    required this.isComplete,
    required this.hasTax,
    required this.onSale,
    required this.buyWhenOnSale,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory Item({
    required String name,
    String? aisle,
    String? notes,
    bool? isComplete,
    bool? hasTax,
    bool? onSale,
    bool? buyWhenOnSale,
    String? quantity,
    String? price,
    String? total,
  }) {
    final validatedQuantity = QuantityValidator(quantity).validate();
    return Item._internal(
      name: name,
      aisle: aisle ?? 'None',
      notes: notes ?? '',
      isComplete: isComplete ?? false,
      hasTax: hasTax ?? false,
      onSale: onSale ?? false,
      buyWhenOnSale: buyWhenOnSale ?? false,
      quantity: validatedQuantity,
      price: price ?? '0.00',
      total: total ?? '0.00',
    );
  }

  Item copyWith({
    String? name,
    String? aisle,
    String? notes,
    bool? isComplete,
    bool? hasTax,
    bool? onSale,
    bool? buyWhenOnSale,
    String? quantity,
    String? price,
    String? total,
  }) {
    return Item(
      name: name ?? this.name,
      aisle: aisle ?? this.aisle,
      notes: notes ?? this.notes,
      isComplete: isComplete ?? this.isComplete,
      hasTax: hasTax ?? this.hasTax,
      onSale: onSale ?? this.onSale,
      buyWhenOnSale: buyWhenOnSale ?? this.buyWhenOnSale,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  @override
  List<Object> get props {
    return [
      name,
      aisle,
      notes,
      isComplete,
      hasTax,
      onSale,
      buyWhenOnSale,
      quantity,
      price,
      total,
    ];
  }

  @override
  String toString() {
    return '''\n
Item {
  name: $name,
  aisle: $aisle,
  notes: $notes,
  isComplete: $isComplete,
  hasTax: $hasTax,
  onSale: $onSale,
  buyWhenOnSale: $buyWhenOnSale,
  quantity: $quantity,
  price: $price,
  total: $total,
}\n''';
  }
}
