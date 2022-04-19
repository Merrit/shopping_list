import '../../core/core.dart';

class Password {
  final String value;
  final bool isValid;

  const Password._internal({
    required this.value,
    required this.isValid,
  });

  const Password.initial()
      : value = '',
        isValid = false;

  factory Password(String input) {
    return Password._internal(
      value: input,
      isValid: validatePassword(input),
    );
  }
}
