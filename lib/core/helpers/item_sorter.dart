import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

class ItemSorter {
  List<Item> sort({
    required bool ascending,
    required List<Item> currentItems,
    required String sortBy,
  }) {
    var items = List<Item>.from(currentItems);
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
        items.sort(
          (a, b) => a.aisle.toLowerCase().compareTo(b.aisle.toLowerCase()),
        );
        if (!ascending) items = items.reversed.toList();
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
    return items;
  }
}
