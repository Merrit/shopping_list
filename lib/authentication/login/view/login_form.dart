import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/core/login_status.dart';
import 'package:shopping_list/authentication/login/login.dart';
import 'package:shopping_list/core/widgets/widgets.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LoginStatus.submissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
        if (state.status == LoginStatus.verificationEmailSent) {
          _showSuccessDialog(context);
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppIcon(size: 120),
              const SizedBox(height: 16.0),
              EmailInput(FormType.login),
              const SizedBox(height: 8.0),
              PasswordInput(FormType.login),
              const SizedBox(height: 8.0),
              _LoginButton(),
              const SizedBox(height: 8.0),
              _GoogleLoginButton(),
              const SizedBox(height: 4.0),
              _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == LoginStatus.submissionInProgress) {
          return const CircularProgressIndicator();
        } else {
          return ElevatedButton(
            key: const Key('loginForm_continue_raisedButton'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              primary: const Color(0xFFFFD600),
            ),
            onPressed: () =>
                context.read<LoginCubit>().submitForm(FormType.login),
            child: const Text('LOGIN'),
          );
        }
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text(
        'SIGN IN WITH GOOGLE',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        primary: theme.accentColor,
      ),
      icon: const Icon(Icons.hot_tub),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      // onPressed: () => Navigator.of(context).push<void>(SignUpScreen.route()),
      onPressed: () => Navigator.pushNamed(context, SignUpScreen.id),
      child: Text(
        'CREATE ACCOUNT',
        style: theme.textTheme.subtitle2,
      ),
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
