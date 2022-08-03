part of 'item_details_cubit.dart';

/// TODO: This shouldn't extract the `Item` details for no reason, duplicating
/// all these fields and making maintenance harder. Refactor to use just the
/// item as the state.

/// Holds the state while editing the details of a single item.
class ItemDetailsState {
  final Item _item;
  final String name;
  final String quantity;
  final String aisle;
  final String price;
  final String total;
  final bool hasTax;
  final bool onSale;
  final bool buyWhenOnSale;
  final String notes;
  final List<String> labels;

  const ItemDetailsState({
    required Item item,
    required this.name,
    required this.quantity,
    required this.aisle,
    required this.price,
    required this.total,
    required this.hasTax,
    required this.onSale,
    required this.buyWhenOnSale,
    required this.notes,
    required this.labels,
  }) : _item = item;

  ItemDetailsState copyWith({
    String? name,
    String? quantity,
    String? aisle,
    String? price,
    String? total,
    bool? hasTax,
    bool? onSale,
    bool? buyWhenOnSale,
    String? notes,
    List<String>? labels,
  }) {
    return ItemDetailsState(
      item: _item,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      aisle: aisle ?? this.aisle,
      price: price ?? this.price,
      total: total ?? this.total,
      hasTax: hasTax ?? this.hasTax,
      onSale: onSale ?? this.onSale,
      buyWhenOnSale: buyWhenOnSale ?? this.buyWhenOnSale,
      notes: notes ?? this.notes,
      labels: labels ?? this.labels,
    );
  }
}
