import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/authentication/core/login_status.dart';

import '../login.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.submissionFailure) {
          _showSignUpFailureSnackbar(context);
        }
        if (state.status == LoginStatus.submissionSuccess) {
          _showSuccessDialog(context);
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmailInput(FormType.signup),
            const SizedBox(height: 8.0),
            PasswordInput(FormType.signup),
            const SizedBox(height: 8.0),
            _ConfirmPasswordInput(),
            const SizedBox(height: 8.0),
            _SignUpButton(),
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
            labelText: 'confirm password',
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
                key: const Key('signUpForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  primary: Colors.orangeAccent,
                ),
                onPressed: () =>
                    context.read<LoginCubit>().submitForm(FormType.signup),
                child: const Text('SIGN UP'),
              );
      },
    );
  }
}

class _SuccessfulSignUpDialog extends StatelessWidget {
  const _SuccessfulSignUpDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text('A verification email has been sent to '
          'the address provided.\n'
          '\n'
          'Please verify your email, then sign in.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Confirm'),
        ),
      ],
    );
  }
}

Future<void> _showSuccessDialog(BuildContext context) async {
  final loginCubit = context.read<LoginCubit>();
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: loginCubit,
        child: _SuccessfulSignUpDialog(),
      );
    },
  );
}

void _showSignUpFailureSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(content: Text('Sign Up Failure')),
    );
}
