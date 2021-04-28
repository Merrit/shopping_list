part of 'item_details_cubit.dart';

class ItemDetailsState extends Equatable {
  final Item _item;
  final String name;
  final String quantity;
  final String aisle;

  const ItemDetailsState({
    required Item item,
    required this.name,
    required this.quantity,
    required this.aisle,
  }) : _item = item;

  @override
  List<Object> get props => [_item, name, quantity, aisle];

  @override
  bool get stringify => true;

  ItemDetailsState copyWith({
    String? name,
    String? quantity,
    String? aisle,
  }) {
    return ItemDetailsState(
      item: _item,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      aisle: aisle ?? this.aisle,
    );
  }
}
