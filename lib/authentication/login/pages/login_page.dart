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
          if (state.status is SubmissionFailure) {
            final failure = state.status as SubmissionFailure;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Authentication Failure: ${failure.code}'),
                ),
              );
          }
        },
        child: LoginView(),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  LoginView({
    Key? key,
  }) : super(key: key);

  final children = <Widget>[
    AppIcon(height: 100),
    const SizedBox(height: 16.0),
    EmailInput(FormType.login),
    const SizedBox(height: 12.0),
    PasswordInput(FormType.login),
    const SizedBox(height: 12.0),
    _LoginButton(),
    const SizedBox(height: 12.0),
    _GoogleLoginButton(),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverPadding(padding: EdgeInsets.only(top: 10)),
            for (var child in children)
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: (mediaQuery.size.width < 600) ? 8 : 400,
                ),
                sliver: SliverToBoxAdapter(child: child),
              ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _SignUpButton(),
                ),
              ),
            ),
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
        if (state.status is SubmissionInProgress) {
          return const Center(
            child: SizedBox(
              height: 52,
              width: 52,
              child: CircularProgressIndicator(),
            ),
          );
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
