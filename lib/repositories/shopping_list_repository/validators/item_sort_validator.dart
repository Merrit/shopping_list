import '../repository.dart';

/// Sort the list of items according to the user's preference.
class ItemSortValidator {
  List<Item> _items;

  ItemSortValidator({required List<Item> items})
      : _items = List<Item>.from(items);

  List<Item> sort({required bool ascending, required String sortBy}) {
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
        _items.sort(
          (a, b) => a.aisle.toLowerCase().compareTo(b.aisle.toLowerCase()),
        );
        if (!ascending) _items = _items.reversed.toList();
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
    return _items;
  }
}
