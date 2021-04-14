part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final Email email;
  final Password password;
  final Password confirmedPassword;
  final FormStatus formStatus;
  final LoginStatus status;

  const SignUpState({
    required this.email,
    required this.password,
    required this.confirmedPassword,
    required this.status,
  }) : formStatus = FormStatus.modified;

  const SignUpState.initial()
      : email = const Email.initial(),
        password = const Password.initial(),
        confirmedPassword = const Password.initial(),
        formStatus = FormStatus.modified,
        status = LoginStatus.none;

  bool credentialsAreValid() {
    if (email.isValid && password.isValid) {
      return true;
    } else {
      return false;
    }
  }

  @override
  List<Object> get props => [email, password, confirmedPassword, formStatus];

  SignUpState copyWith({
    Email? email,
    Password? password,
    Password? confirmedPassword,
    LoginStatus? status,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
    );
  }
}
