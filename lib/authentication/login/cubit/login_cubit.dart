import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/authentication/core/core.dart';
import 'package:shopping_list/core/form_status.dart';
import 'package:shopping_list/core/validators/validators.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository)
      : super(const LoginState.initial());

  void emailChanged(String value) {
    final email = Email(value);
    emit(state.copyWith(
      email: email,
    ));
  }

  void passwordChanged(String value) {
    final password = Password(value);
    emit(state.copyWith(
      password: password,
    ));
  }

  Future<void> logInWithCredentials() async {
    if (state.credentialsAreValid() == false) {
      emit(state.copyWith(formStatus: FormStatus.modified));
      return;
    }
    emit(state.copyWith(status: LoginStatus.submissionInProgress));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: LoginStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: LoginStatus.submissionFailure));
    }
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.submissionInProgress));
    try {
      await _authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: LoginStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: LoginStatus.submissionFailure));
    }
  }
}
