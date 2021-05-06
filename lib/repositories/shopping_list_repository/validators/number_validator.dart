class NumberValidator {
  final String input;

  const NumberValidator(this.input);

  bool isValidNumber() {
    final validInt = isValidInt();
    final validDouble = isValidDouble();
    if (validInt || validDouble) {
      return true;
    } else {
      return false;
    }
  }

  bool isValidInt() {
    final valid = int.tryParse(input);
    if (valid == null) {
      return false;
    } else {
      return true;
    }
  }

  bool isValidDouble() {
    final valid = double.tryParse(input);
    if (valid == null) {
      return false;
    } else {
      return true;
    }
  }
}
