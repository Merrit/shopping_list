import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';
import 'package:shopping_list/repositories/shopping_list_repository/validators/list_items_validator.dart';

void main() {
  final aisles = <Aisle>[];
  final items = <Item>[];

  setUp(() {
    aisles.clear();
    items.clear();
  });

  test('Custom aisle sort', () {
    aisles.addAll([
      Aisle(name: 'Veggies'),
      Aisle(name: 'Bakery'),
      Aisle(name: 'Fruit'),
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
      Aisle(name: 'Veggies'),
      Aisle(name: 'Fruit'),
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
