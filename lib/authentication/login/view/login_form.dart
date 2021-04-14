import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/core/core.dart';
import 'package:shopping_list/authentication/login/cubit/login_cubit.dart';
import 'package:shopping_list/authentication/sign_up/sign_up.dart';
import 'package:shopping_list/core/form_status.dart';

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
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: Colors.blue[300],
                size: 120,
              ),
              const SizedBox(height: 16.0),
              _EmailInput(),
              const SizedBox(height: 8.0),
              _PasswordInput(),
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

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email',
            helperText: '',
            errorText: _emailFieldErrorText(state),
          ),
          onSubmitted: (_) => context.read<LoginCubit>().logInWithCredentials(),
        );
      },
    );
  }
}

String? _emailFieldErrorText(LoginState state) {
  if (state.formStatus == FormStatus.modified) {
    return state.email.isValid ? null : 'invalid email';
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            helperText: '',
            errorText: _passwordFieldErrorText(state),
          ),
          onSubmitted: (_) => context.read<LoginCubit>().logInWithCredentials(),
        );
      },
    );
  }
}

String? _passwordFieldErrorText(LoginState state) {
  if (state.formStatus == FormStatus.modified) {
    return state.password.isValid ? null : 'invalid password';
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
            onPressed: () => context.read<LoginCubit>().logInWithCredentials(),
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
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      child: Text(
        'CREATE ACCOUNT',
        style: theme.textTheme.subtitle2,
      ),
    );
  }
}
