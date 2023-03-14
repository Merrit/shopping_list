import 'package:freezed_annotation/freezed_annotation.dart';

import '../shopping_list.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class Item with _$Item {
  /// Private constructor required for Freezed to enable getters.
  const Item._();

  const factory Item._private({
    required String name,
    required String aisle,
    required String notes,
    required bool isComplete,
    required bool hasTax,
    required bool onSale,
    required bool buyWhenOnSale,
    required bool haveCoupon,
    required String quantity,

    /// Optional user-defined unit of measure for the quantity.
    ///
    /// For example, "1 lb", "300 grams" or "2 cups".
    @JsonKey(required: false) String? quantityUnit,
    required String price,
    required String taxRate,
  }) = _Private;

  /// Total price of the item, including tax if applicable.
  String get total => MoneyHandler().totalPrice(
        price: price,
        quantity: quantity,
        taxRate: taxRate,
      );

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
    String? quantityUnit,
    String? price,
    String? taxRate,
  }) {
    final validatedQuantity = QuantityValidator(quantity).validate();
    moneyHandler ??= MoneyHandler();

    return Item._private(
      name: name,
      aisle: aisle ?? 'None',
      notes: notes ?? '',
      isComplete: isComplete ?? false,
      hasTax: hasTax ?? false,
      onSale: onSale ?? false,
      buyWhenOnSale: buyWhenOnSale ?? false,
      haveCoupon: haveCoupon ?? false,
      quantity: validatedQuantity,
      quantityUnit: quantityUnit,
      price: price ?? '0.00',
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
  quantityUnit: $quantityUnit,
  price: $price,
  total: $total,
  taxRate: $taxRate,
}\n''';
  }
}
