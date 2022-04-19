import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/infrastructure/shopping_list_repository/shopping_list_repository.dart';

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
      labels: [],
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
      labels: [],
      sortBy: 'Aisle-custom',
      sortAscending: true,
    );
    final expected = <Item>[
      Item(name: 'Bok choy', aisle: 'Veggies'),
      Item(name: 'Mango', aisle: 'Fruit'),
      Item(name: 'Bread', aisle: 'Bakery'),
    ];
    expect(validatedItems, expected);
  });
}
