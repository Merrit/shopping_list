// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:money2/money2.dart';

/// Handles math operations involving money, since representing
/// money as a regular int or double can cause rounding errors.
class MoneyHandler {
  final Currency currency = Currency.create('USD', 2, pattern: r'0.00');

  MoneyHandler();

  static const String _defaultTotal = '0.00';

  /// Returns the total price, with or without tax.
  String totalPrice({
    String? price,
    required String quantity,
    String? taxRate,
  }) {
    if (price == null) return _defaultTotal;
    final _price = _parseStringToMoney(price);
    final _quantity = int.tryParse(quantity);
    if (_quantity == null) return _defaultTotal;
    final total = _price * _quantity;
    if (taxRate == null) {
      return total.toString();
    } else {
      final totalWithTax = _addTax(amount: total, taxRate: taxRate);
      return totalWithTax.toString();
    }
  }

  Money _parseStringToMoney(String amount) {
    return currency.parse(amount, pattern: '0.00');
  }

  Money _addTax({required Money amount, required String taxRate}) {
    var _taxRate = double.tryParse(taxRate);
    if (_taxRate != null) {
      _taxRate = (_taxRate / 100) + 1;
      final totalWithTax = amount * _taxRate;
      return totalWithTax;
    } else {
      return currency.parse('0.00');
    }
  }
}
