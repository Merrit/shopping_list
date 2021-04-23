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

  ShoppingListState copyWith({
    String? name,
    List<Item>? items,
  }) {
    return ShoppingListState(
      name: name ?? this.name,
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [name, items];

  @override
  String toString() => 'ShoppingListState: name: $name';
}
