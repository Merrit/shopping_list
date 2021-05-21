import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';
import 'package:shopping_list/repositories/shopping_list_repository/validators/item_sort_validator.dart';

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
    final validatedItems = ItemSortValidator(items: items).sort(
      aisles: aisles,
      ascending: true,
      sortBy: 'Aisle-custom',
    );
    final expected = <Item>[
      Item(name: 'Bok choy', aisle: 'Veggies'),
      Item(name: 'Bread', aisle: 'Bakery'),
      Item(name: 'Mango', aisle: 'Fruit'),
    ];
    expect(validatedItems, expected);
  });
}
