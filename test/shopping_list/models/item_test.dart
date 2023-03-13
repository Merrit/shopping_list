import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

void main() {
  group('Item:', () {
    final Item testItem = Item(
      name: 'Test Item',
      aisle: 'None',
      notes: '',
      isComplete: false,
      hasTax: false,
      onSale: false,
      buyWhenOnSale: false,
      haveCoupon: false,
      quantity: '1',
      price: '0.00',
      taxRate: '0.00',
    );

    test('can be created', () {
      expect(Item(name: 'Test Item'), isA<Item>());
    });

    test('fromJson() returns a valid model', () {
      final Map<String, dynamic> jsonMap = {
        'name': 'Test Item',
        'aisle': 'None',
        'notes': '',
        'isComplete': false,
        'hasTax': false,
        'onSale': false,
        'buyWhenOnSale': false,
        'haveCoupon': false,
        'quantity': '1',
        'price': '0.00',
        'total': '0.00',
        'taxRate': '0.00',
      };
      expect(Item.fromJson(jsonMap), isA<Item>());
    });

    test('toJson() returns correct Map<String, dynamic>', () {
      final Map<String, dynamic> jsonMap = {
        'name': 'Test Item',
        'aisle': 'None',
        'notes': '',
        'isComplete': false,
        'hasTax': false,
        'onSale': false,
        'buyWhenOnSale': false,
        'haveCoupon': false,
        'quantity': '1',
        'price': '0.00',
        'total': '0.00',
        'taxRate': '0.00',
      };
      expect(testItem.toJson(), jsonMap);
    });

    test('copyWith() returns updated Item', () {
      final Item updatedItem = testItem.copyWith(
        name: 'Updated Item',
        aisle: 'Aisle 1',
        notes: 'Updated Notes',
      );
      expect(updatedItem.name, 'Updated Item');
      expect(updatedItem.aisle, 'Aisle 1');
      expect(updatedItem.notes, 'Updated Notes');
      expect(updatedItem.isComplete, false);
      expect(updatedItem.hasTax, false);
      expect(updatedItem.onSale, false);
      expect(updatedItem.buyWhenOnSale, false);
      expect(updatedItem.haveCoupon, false);
      expect(updatedItem.quantity, '1');
      expect(updatedItem.price, '0.00');
      expect(updatedItem.total, '0.00');
      expect(updatedItem.taxRate, '0.00');
    });

    test('== returns true when Items are equal', () {
      final Item item1 = Item(
        name: 'Test Item',
        aisle: 'None',
        notes: '',
        isComplete: false,
        hasTax: false,
        onSale: false,
        buyWhenOnSale: false,
        haveCoupon: false,
        quantity: '1',
        price: '0.00',
        taxRate: '0.00',
      );
      final Item item2 = Item(
        name: 'Test Item',
        aisle: 'None',
        notes: '',
        isComplete: false,
        hasTax: false,
        onSale: false,
        buyWhenOnSale: false,
        haveCoupon: false,
        quantity: '1',
        price: '0.00',
        taxRate: '0.00',
      );
      expect(item1 == item2, true);
    });
  });
}
