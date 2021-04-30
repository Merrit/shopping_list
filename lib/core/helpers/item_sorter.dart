import 'package:shopping_list_repository/shopping_list_repository.dart';

class ItemSorter {
  List<Item> sort({
    required bool ascending,
    required List<Item> currentItems,
    required String sortBy,
  }) {
    var sortedList = List<Item>.from(currentItems);
    switch (sortBy) {
      case 'name':
        sortedList.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        if (ascending) sortedList = sortedList.reversed.toList();
        break;
      default:
        print('Error sorting items');
    }
    print('oldList:\n'
        '$currentItems');
    print('newList:\n'
        '$sortedList');
    return sortedList;
  }
}
