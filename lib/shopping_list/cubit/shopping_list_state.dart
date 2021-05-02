part of 'shopping_list_cubit.dart';

class ShoppingListState {
  final String name;
  final List<Aisle> aisles;
  final List<Item> items;
  final String taxRate;
  final List<Label> labels;

  // State specific to the running app instance, rather than the ShoppingList.
  final List<Item> checkedItems;
  final int columnSortIndex;
  final bool sortAscending;

  ShoppingListState({
    required this.name,
    required this.aisles,
    required this.items,
    required this.taxRate,
    required this.labels,
    required this.checkedItems,
    required this.columnSortIndex,
    required this.sortAscending,
  });

  factory ShoppingListState.initial() {
    return ShoppingListState(
      name: '',
      aisles: [],
      items: [],
      taxRate: '0',
      labels: [],
      checkedItems: [],
      columnSortIndex: 0,
      sortAscending: false,
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
    List<Aisle>? aisles,
    List<Item>? items,
    String? taxRate,
    List<Label>? labels,
    List<Item>? checkedItems,
    int? columnSortIndex,
    bool? sortAscending,
  }) {
    return ShoppingListState(
      name: name ?? this.name,
      aisles: aisles ?? this.aisles,
      items: items ?? this.items,
      taxRate: taxRate ?? this.taxRate,
      labels: labels ?? this.labels,
      checkedItems: checkedItems ?? this.checkedItems,
      columnSortIndex: columnSortIndex ?? this.columnSortIndex,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  @override
  String toString() => '''\n
ShoppingListState: name: $name,
'aisles: $aisles,
items: $items,
labels: $labels,
checkedItems: $checkedItems,
taxRate: $taxRate
\n''';
}
