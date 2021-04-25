import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:shopping_list/core/core.dart';

import '../../authentication.dart';

class LoginPage extends StatelessWidget {
  static const id = 'login_page';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: BlocListener<LoginCubit, LoginState>(
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
        child: LoginView(),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  final _spacer = const SizedBox(height: 12.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleColumnPagePadding(
        child: SingleChildScrollViewWithExpanded(
          children: [
            const AppIcon(),
            const SizedBox(height: 16.0),
            EmailInput(FormType.login),
            _spacer,
            PasswordInput(FormType.login),
            _spacer,
            _LoginButton(),
            _spacer,
            _GoogleLoginButton(),
            Spacer(),
            _SignUpButton(),
            const SizedBox(height: 20.0),
          ],
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
          return SignInButton(
            Buttons.Email,
            padding: EdgeInsets.symmetric(vertical: 16),
            onPressed: () =>
                context.read<LoginCubit>().submitForm(FormType.login),
          );
        }
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.GoogleDark,
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
      onPressed: () => Navigator.pushNamed(context, SignUpPage.id),
      child: Text(
        'CREATE ACCOUNT',
        style: theme.textTheme.subtitle2,
      ),
    );
  }
}
