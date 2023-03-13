import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

void main() {
  final aisles = <Aisle>[];
  final items = <Item>[];

  setUp(() {
    aisles.clear();
    items.clear();
  });

  test('Custom aisle sort', () {
    aisles.addAll([
      const Aisle(name: 'Veggies'),
      const Aisle(name: 'Bakery'),
      const Aisle(name: 'Fruit'),
    ]);
    items.addAll([
      Item(name: 'Bread', aisle: 'Bakery'),
      Item(name: 'Mango', aisle: 'Fruit'),
      Item(name: 'Bok choy', aisle: 'Veggies'),
    ]);
    final validatedItems = ListItemsValidator.validateItems(
      aisles: aisles,
      items: items,
      sortBy: 'Aisle-custom',
      sortAscending: true,
    );
    final expected = <Item>[
      Item(name: 'Bok choy', aisle: 'Veggies'),
      Item(name: 'Bread', aisle: 'Bakery'),
      Item(name: 'Mango', aisle: 'Fruit'),
    ];
    expect(validatedItems, expected);
  });

  test('Duplicate items are removed', () {
    final itemsWithDuplicate = <Item>[
      Item(name: 'Arthur Dent'),
      Item(name: 'Arthur Dent'),
    ];
    final validatedItems = ListItemsValidator.validateItems(
      aisles: [],
      items: itemsWithDuplicate,
      sortBy: 'Name',
      sortAscending: true,
    );
    expect(validatedItems.length, 1);
  });

  test('Missing aisle items don\'t get removed', () {
    aisles.addAll([
      const Aisle(name: 'Veggies'),
      const Aisle(name: 'Fruit'),
    ]);
    items.addAll([
      Item(name: 'Bread', aisle: 'Bakery'),
      Item(name: 'Mango', aisle: 'Fruit'),
      Item(name: 'Bok choy', aisle: 'Veggies'),
    ]);
    final validatedItems = ListItemsValidator.validateItems(
      aisles: aisles,
      items: items,
      sortBy: 'Aisle-custom',
      sortAscending: true,
    );
    final expected = <Item>[
      Item(name: 'Bok choy', aisle: 'Veggies'),
      Item(name: 'Mango', aisle: 'Fruit'),
      Item(name: 'Bread'),
    ];
    expect(validatedItems, expected);
  });
}
