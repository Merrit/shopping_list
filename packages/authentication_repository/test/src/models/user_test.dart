import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final user = User(
    id: 'unique_user_id',
    email: 'very@email.com',
    emailIsVerified: true,
  );

  test('Can instantiate empty', () {
    final user = User.empty;
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
