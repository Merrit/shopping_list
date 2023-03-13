import 'package:freezed_annotation/freezed_annotation.dart';

import '../shopping_list.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class Item with _$Item {
  const factory Item._({
    required String name,
    required String aisle,
    required String notes,
    required bool isComplete,
    required bool hasTax,
    required bool onSale,
    required bool buyWhenOnSale,
    required bool haveCoupon,
    required String quantity,
    required String price,
    required String total,
    required String taxRate,
  }) = _Item;

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
    return Item._(
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

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

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
