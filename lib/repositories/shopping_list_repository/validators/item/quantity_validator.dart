import '../../repository.dart';

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
