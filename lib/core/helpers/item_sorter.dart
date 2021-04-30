import 'package:shopping_list_repository/shopping_list_repository.dart';

class ItemSorter {
  List<Item> sort({
    required bool ascending,
    required List<Item> currentItems,
    required String sortBy,
  }) {
    var items = List<Item>.from(currentItems);
    switch (sortBy) {
      case 'name':
        items.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        if (ascending) items = items.reversed.toList();
        break;
      case 'quantity':
        items.sort((a, b) => a.quantity.compareTo(b.quantity));
        if (ascending) items = items.reversed.toList();
        break;
      case 'aisle':
        items.sort(
          (a, b) => a.aisle.toLowerCase().compareTo(b.aisle.toLowerCase()),
        );
        if (ascending) items = items.reversed.toList();
        break;
      case 'price':
        items.sort((a, b) => a.price.compareTo(b.price));
        if (ascending) items = items.reversed.toList();
        break;
      case 'total':
        items.sort((a, b) => a.total.compareTo(b.total));
        if (ascending) items = items.reversed.toList();
        break;
      default:
        print('Error sorting items');
    }
    return items;
  }
}
