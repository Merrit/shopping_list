import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthFailure implements Exception {
  final String code;
  final String? message;
  final String? email;

  const AuthFailure({
    required this.code,
    this.message,
    this.email,
  });
}

class SignUpFailure extends AuthFailure {
  SignUpFailure(String code) : super(code: code);
}

class LogInWithEmailAndPasswordFailure extends AuthFailure {
  LogInWithEmailAndPasswordFailure(FirebaseAuthException exception)
      : super(
            code: exception.code,
            message: exception.message,
            email: exception.email);
}

class LogInWithGoogleFailure extends AuthFailure {
  LogInWithGoogleFailure(String code) : super(code: code);
}

class LogOutFailure extends AuthFailure {
  LogOutFailure({required String code, String? message})
      : super(code: code, message: message);
}
