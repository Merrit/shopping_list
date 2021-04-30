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
      case 'aisle':
        items.sort(
          (a, b) => a.aisle.toLowerCase().compareTo(b.aisle.toLowerCase()),
        );
        if (ascending) items = items.reversed.toList();
        break;
      default:
        print('Error sorting items');
    }
    return items;
  }
}
