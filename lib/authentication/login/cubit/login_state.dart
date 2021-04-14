part of 'login_cubit.dart';

/// Represents the state of the login page and its forms.
class LoginState extends Equatable {
  final Email email;
  final Password password;
  final FormStatus formStatus;
  final LoginStatus status;

  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    this.formStatus = FormStatus.unmodified,
  });

  const LoginState.initial()
      : email = const Email.initial(),
        password = const Password.initial(),
        formStatus = FormStatus.unmodified,
        status = LoginStatus.none;

  bool credentialsAreValid() {
    if (email.isValid && password.isValid) {
      return true;
    } else {
      return false;
    }
  }

  @override
  List<Object> get props => [email, password, formStatus, status];

  LoginState copyWith({
    Email? email,
    Password? password,
    LoginStatus? status,
    FormStatus? formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
