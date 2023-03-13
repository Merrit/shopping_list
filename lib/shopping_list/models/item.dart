import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../shopping_list.dart';

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
  final bool haveCoupon;
  final String quantity;
  final String price;
  final String total;
  final String taxRate;

  const Item._internal({
    required this.name,
    required this.aisle,
    required this.notes,
    required this.isComplete,
    required this.hasTax,
    required this.onSale,
    required this.buyWhenOnSale,
    required this.haveCoupon,
    required this.quantity,
    required this.price,
    required this.total,
    required this.taxRate,
  });

  factory Item({
    /// Can be passed in for unit tests.
    MoneyHandler? moneyHandler,
    required String name,
    String? aisle,
    String? notes,
    bool? isComplete,
    bool? hasTax,
    bool? onSale,
    bool? buyWhenOnSale,
    bool? haveCoupon,
    String? quantity,
    String? price,
    String? taxRate,
  }) {
    final validatedQuantity = QuantityValidator(quantity).validate();
    moneyHandler ??= MoneyHandler();
    final String total = moneyHandler.totalPrice(
      price: price,
      quantity: validatedQuantity,
      taxRate: taxRate,
    );
    return Item._internal(
      name: name,
      aisle: aisle ?? 'None',
      notes: notes ?? '',
      isComplete: isComplete ?? false,
      hasTax: hasTax ?? false,
      onSale: onSale ?? false,
      buyWhenOnSale: buyWhenOnSale ?? false,
      haveCoupon: haveCoupon ?? false,
      quantity: validatedQuantity,
      price: price ?? '0.00',
      total: total,
      taxRate: taxRate ?? '0.00',
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
    bool? haveCoupon,
    String? quantity,
    String? price,
    String? taxRate,
  }) {
    return Item(
      name: name ?? this.name,
      aisle: aisle ?? this.aisle,
      notes: notes ?? this.notes,
      isComplete: isComplete ?? this.isComplete,
      hasTax: hasTax ?? this.hasTax,
      onSale: onSale ?? this.onSale,
      buyWhenOnSale: buyWhenOnSale ?? this.buyWhenOnSale,
      haveCoupon: haveCoupon ?? this.haveCoupon,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      taxRate: taxRate ?? this.taxRate,
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
      haveCoupon,
      quantity,
      price,
      total,
      taxRate,
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
  haveCoupon: $haveCoupon,
  quantity: $quantity,
  price: $price,
  total: $total,
  taxRate: $taxRate,
}\n''';
  }
}
