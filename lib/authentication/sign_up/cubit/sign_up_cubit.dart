import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/authentication/core/core.dart';
import 'package:shopping_list/core/form_status.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthenticationRepository _authenticationRepository;

  SignUpCubit(this._authenticationRepository)
      : super(const SignUpState.initial());

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

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = Password(value);
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
    ));
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.credentialsAreValid()) return;
    emit(state.copyWith(status: LoginStatus.submissionInProgress));
    try {
      await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: LoginStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: LoginStatus.submissionFailure));
    }
  }
}
