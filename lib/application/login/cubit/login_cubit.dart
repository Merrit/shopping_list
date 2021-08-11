import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_list/application/authentication/bloc/login_status.dart';
import 'package:shopping_list/domain/authentication/authentication.dart';
import 'package:shopping_list/domain/core/core.dart';
import 'package:shopping_list/domain/login/login.dart';
import 'package:shopping_list/repositories/authentication_repository/repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository) : super(LoginState.initial());

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

  void submitForm(FormType formType) {
    if (formType == FormType.login) {
      logInWithCredentials();
    } else {
      signUpFormSubmitted();
    }
  }

  Future<void> logInWithCredentials() async {
    if (!state.credentialsAreValid) {
      emit(state.copyWith(formStatus: FormStatus.modified));
      return;
    }
    emit(state.copyWith(status: SubmissionInProgress()));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: SubmissionSuccess()));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
          status: SubmissionFailure(
        code: e.code,
        message: e.message,
        email: e.email,
      )));
    }
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: SubmissionInProgress()));
    try {
      await _authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: SubmissionSuccess()));
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(
          status: SubmissionFailure(
        code: e.code,
        message: e.message,
      )));
    }
  }

/* ---------------------------- Sign up specific ---------------------------- */

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = Password(value);
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
    ));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.credentialsAreValid) {
      emit(state.copyWith(formStatus: FormStatus.modified));
      return;
    }
    emit(state.copyWith(status: SubmissionInProgress()));
    try {
      await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: SubmissionSuccess()));
    } on SignUpFailure catch (e) {
      emit(state.copyWith(status: SubmissionFailure(code: e.code)));
    }
  }
}
