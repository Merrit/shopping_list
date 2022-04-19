import '../../core/core.dart';

class Email {
  final String value;
  final bool isValid;

  const Email._internal({
    required this.value,
    required this.isValid,
  });

  const Email.initial()
      : value = '',
        isValid = false;

  factory Email(String input) {
    return Email._internal(
      value: input,
      isValid: validateEmailAddress(input),
    );
  }
}
