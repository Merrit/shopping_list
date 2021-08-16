import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/infrastructure/shopping_list_repository/shopping_list_repository.dart';

void main() {
  test('Duplicate items are removed', () {
    final itemsWithDuplicate = <Item>[
      Item(name: 'Arthur Dent'),
      Item(name: 'Arthur Dent'),
    ];
    final validatedItems = ListItemsValidator.validateItems(
      aisles: [],
      items: itemsWithDuplicate,
      labels: [],
      sortBy: 'Name',
      sortAscending: true,
    );
    expect(validatedItems.length, 1);
  });
}
