part of 'item_details_cubit.dart';

class ItemDetailsState extends Equatable {
  final Item _item;
  final String name;
  final String quantity;
  final String aisle;
  final String price;
  final String total;
  final bool hasTax;

  const ItemDetailsState({
    required Item item,
    required this.name,
    required this.quantity,
    required this.aisle,
    required this.price,
    required this.total,
    required this.hasTax,
  }) : _item = item;

  @override
  List<Object> get props => [
        _item,
        name,
        quantity,
        aisle,
        price,
        total,
        hasTax,
      ];

  @override
  bool get stringify => true;

  ItemDetailsState copyWith({
    String? name,
    String? quantity,
    String? aisle,
    String? price,
    String? total,
    bool? hasTax,
  }) {
    return ItemDetailsState(
      item: _item,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      aisle: aisle ?? this.aisle,
      price: price ?? this.price,
      total: total ?? this.total,
      hasTax: hasTax ?? this.hasTax,
    );
  }
}
