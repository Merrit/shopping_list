part of 'item_details_cubit.dart';

class ItemDetailsState {
  final Item _item;
  final String name;
  final String quantity;
  final String aisle;
  final String price;
  final String total;
  final bool hasTax;
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
      notes: notes ?? this.notes,
      labels: labels ?? this.labels,
    );
  }
}
