import 'package:shopping_list_repository/src/validators/number_validator.dart';

class QuantityValidator {
  final String input;

  const QuantityValidator(this.input);

  String validate() {
    final isValidNumber = NumberValidator(input).isValidNumber();
    if (isValidNumber) {
      return input;
    } else {
      return '1';
    }
  }
}
