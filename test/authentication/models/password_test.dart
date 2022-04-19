import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/domain/authentication/authentication.dart';

void main() {
  test('Can instantiate initial', () {
    const password = Password.initial();
    expect(password, isA<Password>());
    expect(password.value, '');
    expect(password.isValid, false);
  });

  test('Valid password is valid', () {
    final password = Password('walking-iron-pondskipper');
    expect(password.value, 'walking-iron-pondskipper');
    expect(password.isValid, isTrue);
  });

  test('Invalid password is invalid', () {
    final password = Password('bison');
    expect(password.isValid, isFalse);
  });
}
