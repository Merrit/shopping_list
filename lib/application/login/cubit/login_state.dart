part of 'login_cubit.dart';

/// Represents the state of the login / sign up screen and its forms.
class LoginState extends Equatable {
  final Email email;
  final Password password;
  final Password confirmedPassword;
  final FormStatus formStatus;
  final LoginStatus status;

  final bool credentialsAreValid;
  final String? emailFieldErrorText;

  const LoginState._internal({
    required this.email,
    required this.password,
    required this.confirmedPassword,
    required this.formStatus,
    required this.status,
    required this.credentialsAreValid,
    required this.emailFieldErrorText,
  });

  factory LoginState({
    required Email email,
    required Password password,
    required Password confirmedPassword,
    required FormStatus formStatus,
    required LoginStatus status,
  }) {
    final credentialsAreValid = (email.isValid && password.isValid);
    final formModified = (formStatus == FormStatus.modified);
    final emailFieldErrorText =
        (formModified && !email.isValid) ? 'invalid email' : null;
    return LoginState._internal(
      email: email,
      password: password,
      confirmedPassword: confirmedPassword,
      formStatus: formStatus,
      status: status,
      credentialsAreValid: credentialsAreValid,
      emailFieldErrorText: emailFieldErrorText,
    );
  }

  LoginState.initial()
      : email = const Email.initial(),
        password = const Password.initial(),
        confirmedPassword = const Password.initial(),
        formStatus = FormStatus.unmodified,
        status = SignedOut(),
        credentialsAreValid = true,
        emailFieldErrorText = null;

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
  List<Object> get props => [
        email,
        password,
        confirmedPassword,
        status,
        formStatus,
        credentialsAreValid,
      ];

  LoginState copyWith({
    Email? email,
    Password? password,
    Password? confirmedPassword,
    LoginStatus? status,
    FormStatus? formStatus,
    bool? credentialsAreValid,
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
