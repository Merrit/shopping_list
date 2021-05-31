import '../repository.dart';

class QuantityValidator {
  final String? input;

  const QuantityValidator(this.input);

  static const String _defaultQuantity = '1';

  String validate() {
    if (input == null) return _defaultQuantity;
    final isValidNumber = NumberValidator(input!).isValidNumber();
    return (isValidNumber) ? input! : _defaultQuantity;
  }
}
