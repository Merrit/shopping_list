import '../repository.dart';

class ListItemsValidator {
  static List<Item> validateItems({
    required List<Aisle> aisles,
    required List<Item> items,
    required List<Label> labels,
    required String sortBy,
    required bool sortAscending,
  }) {
    List<Item> validatedItems;
    validatedItems = _validateDuplicates(items);
    validatedItems = _LabelValidator(
      items: validatedItems,
      labels: labels,
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

class _LabelValidator {
  final List<Item> items;
  final List<Label> labels;

  const _LabelValidator({required this.items, required this.labels});

  /// Clean out labels that have been deleted.
  List<Item> validate() {
    List<Item> validatedItems = [];
    final labelNames = labels.map((label) => label.name).toList();
    for (var item in items) {
      final labels = List<String>.from(item.labels);
      labels.removeWhere(
        (String label) => (labelNames.contains(label) == false),
      );
      validatedItems.add(item.copyWith(labels: labels));
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
    final List<Item> _originalItems = List<Item>.from(items);
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
        print('Error sorting items');
    }
    assert(_originalItems.length == items.length);
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
    items.forEach((item) {
      if (sortedItems.contains(item) == false) sortedItems.add(item);
    });
    return sortedItems;
  }
}