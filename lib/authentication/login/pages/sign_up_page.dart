import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';

import '../../authentication.dart';

class SignUpPage extends StatelessWidget {
  static const id = 'sign_up_page';

  const SignUpPage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.submissionFailure) {
            _showSignUpFailureSnackbar(context);
          }
        },
        child: SignUpView(),
      ),
    );
  }
}

class SignUpView extends StatelessWidget {
  final _spacer = const SizedBox(height: 12.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleColumnPagePadding(
        child: SingleChildScrollViewWithExpanded(
          children: [
            const AppIcon(),
            const SizedBox(height: 16.0),
            EmailInput(FormType.signup),
            _spacer,
            PasswordInput(FormType.signup),
            _spacer,
            _ConfirmPasswordInput(),
            Spacer(),
            _SignUpButton(),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextField(
          onChanged: (confirmPassword) => context
              .read<LoginCubit>()
              .confirmedPasswordChanged(confirmPassword),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirm password',
            helperText: '',
            errorText: state.confirmPasswordFieldErrorText(),
          ),
          onSubmitted: (_) => context.read<LoginCubit>().signUpFormSubmitted(),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return (state.status == LoginStatus.submissionInProgress)
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  elevation: 4.0,
                ),
                onPressed: () =>
                    context.read<LoginCubit>().submitForm(FormType.signup),
                child: const Text('Register'),
              );
      },
    );
  }
}

void _showSignUpFailureSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(content: Text('Sign Up Failure')),
    );
}
