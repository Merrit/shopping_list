part of 'shopping_list_cubit.dart';

/// Holds the state for the active shopping list.
class ShoppingListState {
  final List<Aisle> aisles;
  final int color; // Customizable color for list name.
  final List<Item> items;
  final List<Label> labels;
  final String name;
  final String sortBy;
  final bool sortAscending;
  final String taxRate;

  // State specific to the running app instance, rather than the ShoppingList.
  final List<Item> checkedItems;

  final bool showCreateItemDialog;

  ShoppingListState({
    required this.aisles,
    required this.color,
    required this.items,
    required this.labels,
    required this.name,
    required this.sortBy,
    required this.sortAscending,
    required this.taxRate,
    required this.checkedItems,
    required this.showCreateItemDialog,
  });

  factory ShoppingListState.initial() {
    return ShoppingListState(
      aisles: [],
      color: Colors.white.value,
      items: [],
      labels: [],
      name: '',
      sortBy: 'Name',
      sortAscending: false,
      taxRate: '0',
      checkedItems: [],
      showCreateItemDialog: false,
    );
  }

  List<Item> get activeItems {
    return items.where((item) => !item.isComplete).toList();
  }

  List<Item> get completedItems {
    return items.where((item) => item.isComplete).toList();
  }

  ShoppingListState copyWith({
    List<Aisle>? aisles,
    int? color,
    List<Item>? items,
    List<Label>? labels,
    String? name,
    String? sortBy,
    bool? sortAscending,
    String? taxRate,
    List<Item>? checkedItems,
    bool? showCreateItemDialog,
  }) {
    return ShoppingListState(
      aisles: aisles ?? this.aisles,
      color: color ?? this.color,
      items: items ?? this.items,
      labels: labels ?? this.labels,
      name: name ?? this.name,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      taxRate: taxRate ?? this.taxRate,
      checkedItems: checkedItems ?? this.checkedItems,
      showCreateItemDialog: showCreateItemDialog ?? this.showCreateItemDialog,
    );
  }

  @override
  String toString() => '''\n
ShoppingListState:
aisles: $aisles,
color: $color,
items: $items,
labels: $labels,
name: $name,
sortBy: $sortBy,
sortAscending: $sortAscending,
taxRate: $taxRate
checkedItems: $checkedItems,
showCreateItemDialog: $showCreateItemDialog,
\n''';
}
