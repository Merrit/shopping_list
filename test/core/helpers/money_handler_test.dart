import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/infrastructure/shopping_list_repository/shopping_list_repository.dart';

void main() {
  final handler = MoneyHandler();

  group('Without tax', () {
    test('Single quantity', () {
      const price = '1.00';
      const quantity = '1';
      final totalPrice = handler.totalPrice(price: price, quantity: quantity);
      expect(totalPrice, '1.00');
    });
    test('Multiple quantity', () {
      const price = '1.00';
      const quantity = '2';
      final totalPrice = handler.totalPrice(price: price, quantity: quantity);
      expect(totalPrice, '2.00');
    });
  });

  group('With tax', () {
    test('Single quantity', () {
      const price = '1.00';
      const quantity = '1';
      const tax = '13';
      final totalPrice = handler.totalPrice(
        price: price,
        quantity: quantity,
        taxRate: tax,
      );
      expect(totalPrice, '1.13');
    });
    test('Multiple quantity', () {
      const price = '1.00';
      const quantity = '2';
      const tax = '7.5';
      final totalPrice = handler.totalPrice(
        price: price,
        quantity: quantity,
        taxRate: tax,
      );
      expect(totalPrice, '2.14');
    });
  });
}
