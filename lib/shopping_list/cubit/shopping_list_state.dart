part of 'shopping_list_cubit.dart';

class ShoppingListState {
  final String name;
  final List<Item> items;
  final List<Item> checkedItems;

  ShoppingListState({
    required this.name,
    required this.items,
    required this.checkedItems,
  });

  factory ShoppingListState.initial() {
    return ShoppingListState(
      name: '',
      items: [],
      checkedItems: [],
    );
  }

  List<Item> activeItems() {
    return items.where((item) => !item.isComplete).toList();
  }

  List<Item> completedItems() {
    return items.where((item) => item.isComplete).toList();
  }

  ShoppingListState copyWith({
    String? name,
    List<Item>? items,
    List<Item>? checkedItems,
  }) {
    return ShoppingListState(
      name: name ?? this.name,
      items: items ?? this.items,
      checkedItems: checkedItems ?? this.checkedItems,
    );
  }

  @override
  String toString() => 'ShoppingListState: name: $name';
}
