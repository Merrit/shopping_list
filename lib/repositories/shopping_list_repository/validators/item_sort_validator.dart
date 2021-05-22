import '../repository.dart';

/// Sort the list of items according to the user's preference.
class ItemSortValidator {
  final List<Item> _originalItems;
  List<Item> _items;

  ItemSortValidator({
    required List<Item> items,
  })  : _originalItems = items,
        _items = List<Item>.from(items);

  List<Item> sort({
    required List<Aisle> aisles,
    required bool ascending,
    required String sortBy,
  }) {
    switch (sortBy) {
      case 'Name':
        _items.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        if (!ascending) _items = _items.reversed.toList();
        break;
      case 'Quantity':
        _items.sort((a, b) => a.quantity.compareTo(b.quantity));
        if (!ascending) _items = _items.reversed.toList();
        break;
      case 'Aisle':
        _items = _AisleSorter(
          ascending: ascending,
          items: _items,
        ).sort();
        break;
      case 'Aisle-custom':
        _items = _AisleSorter(
          aisles: aisles,
          ascending: ascending,
          items: _items,
        ).sortCustom();
        break;
      case 'Price':
        _items.sort((a, b) => a.price.compareTo(b.price));
        if (!ascending) _items = _items.reversed.toList();
        break;
      case 'Total':
        _items.sort((a, b) => a.total.compareTo(b.total));
        if (!ascending) _items = _items.reversed.toList();
        break;
      default:
        print('Error sorting items');
    }
    assert(_originalItems.length == _items.length);
    return _items;
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
