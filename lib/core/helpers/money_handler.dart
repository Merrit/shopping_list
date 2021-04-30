import 'package:money2/money2.dart';

class MoneyHandler {
  final Currency currency = Currency.create('USD', 2, pattern: r'0.00');

  MoneyHandler();

  String totalPrice({
    required String price,
    required String quantity,
    String? taxRate,
  }) {
    Money _price;
    try {
      _price = currency.parse(price, pattern: '0.00');
    } on MoneyParseException catch (e) {
      print('MoneyParseException: \n'
          '$e');
      return '0.00';
    }
    final _quantity = int.tryParse(quantity);
    if (_quantity == null) {
      return '0.00';
    }
    final total = _price * _quantity;
    if (taxRate == null) {
      return total.toString();
    } else {
      var _taxRate = double.tryParse(taxRate);
      if (_taxRate != null) {
        _taxRate = (_taxRate / 100) + 1;
        final totalWithTax = total * _taxRate;
        return totalWithTax.toString();
      } else {
        return '0.00';
      }
    }
  }
}
