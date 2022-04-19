import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/infrastructure/authentication_repository/models/user.dart';

void main() {
  const user = User(
    id: 'unique_user_id',
    email: 'very@email.com',
    emailIsVerified: true,
  );

  test('Can instantiate empty', () {
    const user = User.empty;
    expect(user, isA<User>());
    expect(user.email, equals(''));
    expect(user.id, equals(''));
    expect(user.emailIsVerified, isFalse);
  });

  test('User has an id', () {
    expect(user.id, isA<String>());
  });

  test('User has an email', () {
    expect(user.email, isA<String>());
  });

  test('Email is set as verified', () {
    expect(user.emailIsVerified, isTrue);
  });
}
