import 'package:equatable/equatable.dart';

/// User model.
///
/// [User.empty] represents an unauthenticated user.
class User extends Equatable {
  final String email;

  final String id;

  const User({
    required this.email,
    required this.id,
  });

  static const empty = User(email: '', id: '');

  @override
  List<Object> get props => [email, id];
}
