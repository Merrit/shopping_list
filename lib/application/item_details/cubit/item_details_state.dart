part of 'item_details_cubit.dart';

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
      notes: notes ?? this.notes,
      labels: labels ?? this.labels,
    );
  }
}
