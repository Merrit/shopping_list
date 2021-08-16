import 'package:equatable/equatable.dart';

/// User model.
///
/// [User.empty] represents an unauthenticated user.
class User extends Equatable {
  final String id;
  final String email;
  final bool emailIsVerified;

  const User({
    required this.id,
    required this.email,
    required this.emailIsVerified,
  });

  static const empty = User(
    email: '',
    id: '',
    emailIsVerified: false,
  );

  @override
  List<Object> get props => [id, email, emailIsVerified];

  @override
  String toString() => '\n'
      'id: $id, \n'
      'email: $email, \n'
      'emailIsVerified: $emailIsVerified, \n'
      '\n';
}
