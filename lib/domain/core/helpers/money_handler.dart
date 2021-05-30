import 'package:money2/money2.dart';

/// Handles math operations involving money, since representing
/// money as a regular int or double can cause rounding errors.
class MoneyHandler {
  final Currency currency = Currency.create('USD', 2, pattern: r'0.00');

  MoneyHandler();

  /// Returns the total price, with or without tax.
  String totalPrice({
    required String price,
    required String quantity,
    String? taxRate,
  }) {
    final _price = _parseStringToMoney(price);
    final _quantity = int.tryParse(quantity);
    if (_quantity == null) return '0.00';
    final total = _price * _quantity;
    if (taxRate == null) {
      return total.toString();
    } else {
      final totalWithTax = _addTax(amount: total, taxRate: taxRate);
      return totalWithTax.toString();
    }
  }

  Money _parseStringToMoney(String amount) {
    Money _parsedAmount;
    try {
      _parsedAmount = currency.parse(amount, pattern: '0.00');
    } on MoneyParseException catch (e) {
      print('MoneyParseException: \n'
          '$e');
      _parsedAmount = Money.parse('0.00', currency);
    }
    return _parsedAmount;
  }

  Money _addTax({required Money amount, required String taxRate}) {
    var _taxRate = double.tryParse(taxRate);
    if (_taxRate != null) {
      _taxRate = (_taxRate / 100) + 1;
      final totalWithTax = amount * _taxRate;
      return totalWithTax;
    } else {
      return Money.parse('0.00', currency);
    }
  }
}
