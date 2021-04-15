part of 'login_cubit.dart';

/// Represents the state of the login / sign up screen and its forms.
class LoginState extends Equatable {
  final Email email;
  final Password password;
  final Password confirmedPassword;
  final FormStatus formStatus;
  final LoginStatus status;

  const LoginState({
    required this.email,
    required this.password,
    required this.confirmedPassword,
    required this.status,
    this.formStatus = FormStatus.unmodified,
  });

  const LoginState.initial()
      : email = const Email.initial(),
        password = const Password.initial(),
        confirmedPassword = const Password.initial(),
        formStatus = FormStatus.unmodified,
        status = LoginStatus.none;

  bool credentialsAreValid() {
    if (email.isValid && password.isValid) {
      return true;
    } else {
      return false;
    }
  }

  String? emailFieldErrorText() {
    if (formStatus == FormStatus.modified) {
      return email.isValid ? null : 'invalid email';
    }
  }

  String? passwordFieldErrorText() {
    if (formStatus == FormStatus.modified) {
      return password.isValid ? null : 'invalid password';
    }
  }

  String? confirmPasswordFieldErrorText() {
    if (formStatus == FormStatus.modified) {
      return (confirmedPassword.value == password.value)
          ? null
          : 'passwords do not match';
    }
  }

  @override
  List<Object> get props =>
      [email, password, confirmedPassword, formStatus, status];

  LoginState copyWith({
    Email? email,
    Password? password,
    Password? confirmedPassword,
    LoginStatus? status,
    FormStatus? formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
