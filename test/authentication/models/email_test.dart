import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/domain/authentication/authentication.dart';

void main() {
  test('Can instantiate initial', () {
    final email = Email.initial();
    expect(email, isA<Email>());
    expect(email.value, '');
    expect(email.isValid, isFalse);
  });

  test('Valid email is valid', () {
    final email = Email('Iroh@BaSing.Se');
    expect(email.value, 'Iroh@BaSing.Se');
    expect(email.isValid, isTrue);
  });

  test('Invalid email is invalid', () {
    final email = Email('lemur');
    expect(email.isValid, isFalse);
  });
}
