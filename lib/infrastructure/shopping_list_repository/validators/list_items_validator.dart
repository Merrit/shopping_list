import '../../../logs/logging_manager.dart';
import '../shopping_list_repository.dart';

class ListItemsValidator {
  static List<Item> validateItems({
    required List<Aisle> aisles,
    required List<Item> items,
    required String sortBy,
    required bool sortAscending,
  }) {
    List<Item> validatedItems;
    validatedItems = _validateDuplicates(items);
    validatedItems = _AisleValidator(
      items: validatedItems,
      aisles: aisles,
    ).validate();
    validatedItems = _ItemSortValidator.sort(
      items: validatedItems,
      aisles: aisles,
      ascending: sortAscending,
      sortBy: sortBy,
    );
    return validatedItems;
  }

  static List<Item> _validateDuplicates(List<Item> items) {
    return items.toSet().toList();
  }
}

class _AisleValidator {
  final List<Item> items;
  final List<Aisle> aisles;

  const _AisleValidator({required this.items, required this.aisles});

  /// Clean out aisles that have been deleted.
  List<Item> validate() {
    List<Item> validatedItems = [];
    final aisleNames = aisles.map((aisle) => aisle.name).toList();
    for (var item in items) {
      final bool aisleExists = aisleNames.contains(item.aisle);
      validatedItems.add(aisleExists ? item : item.copyWith(aisle: 'None'));
    }
    return validatedItems;
  }
}

/// Sort the list of items according to the user's preference.
class _ItemSortValidator {
  static List<Item> sort({
    required List<Item> items,
    required List<Aisle> aisles,
    required bool ascending,
    required String sortBy,
  }) {
    final List<Item> originalItems = List<Item>.from(items);
    switch (sortBy) {
      case 'Name':
        items.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        if (!ascending) items = items.reversed.toList();
        break;
      case 'Quantity':
        items.sort((a, b) => a.quantity.compareTo(b.quantity));
        if (!ascending) items = items.reversed.toList();
        break;
      case 'Aisle':
        items = _AisleSorter(
          ascending: ascending,
          items: items,
        ).sort();
        break;
      case 'Aisle-custom':
        items = _AisleSorter(
          aisles: aisles,
          ascending: ascending,
          items: items,
        ).sortCustom();
        break;
      case 'Price':
        items.sort((a, b) => a.price.compareTo(b.price));
        if (!ascending) items = items.reversed.toList();
        break;
      case 'Total':
        items.sort((a, b) => a.total.compareTo(b.total));
        if (!ascending) items = items.reversed.toList();
        break;
      default:
        log.w('Error sorting items');
    }
    assert(originalItems.length == items.length);
    return items;
  }
}

class _AisleSorter {
  List<Aisle>? aisles;
  bool ascending;
  List<Item> items;

  _AisleSorter({
    this.aisles,
    required this.ascending,
    required this.items,
  });

  List<Item> sort() {
    _sortAlphabetical();
    _sortNoneAislesToEnd();
    if (!ascending) items = items.reversed.toList();
    return items;
  }

  void _sortAlphabetical() {
    items.sort(
      (a, b) => a.aisle.toLowerCase().compareTo(b.aisle.toLowerCase()),
    );
  }

  void _sortNoneAislesToEnd() {
    final noneAisles = items.where((item) => item.aisle == 'None').toList();
    items.removeWhere((item) => noneAisles.contains(item));
    items.addAll(noneAisles);
  }

  /// User has arranged aisles into a custom order,
  /// now sort the items to match that order.
  List<Item> sortCustom() {
    assert(aisles != null);
    final sortedItems = <Item>[];
    aisles?.forEach((aisle) {
      final matchedItems =
          items.where((item) => item.aisle == aisle.name).toList();
      sortedItems.addAll(matchedItems);
    });
    // If the item has an aisle that doesn't exist in the
    // ShoppingList's aisles, it won't have been added.
    // So we add it at then end so it doesn't get lost.
    for (var item in items) {
      if (sortedItems.contains(item) == false) sortedItems.add(item);
    }
    return sortedItems;
  }
}
