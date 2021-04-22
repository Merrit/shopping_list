part of 'shopping_list_cubit.dart';

class ShoppingListState extends Equatable {
  final String name;
  final List<Item> items;

  const ShoppingListState({
    required this.name,
    required this.items,
  });

  factory ShoppingListState.initial() {
    return ShoppingListState(
      name: '',
      items: [],
    );
  }

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'ShoppingListState: name: $name';
}
