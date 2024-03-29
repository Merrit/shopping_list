import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../../../application/authentication/bloc/login_status.dart';
import '../../../application/login/cubit/login_cubit.dart';
import '../../../domain/core/core.dart';
import '../../../domain/login/login.dart';
import '../../../infrastructure/authentication_repository/authentication_repository.dart';
import '../../core/core.dart';
import '../login.dart';

class LoginPage extends StatelessWidget {
  static const id = 'login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status is SubmissionFailure) {
            final failure = state.status as SubmissionFailure;
            final message = '${failure.code} \n ${failure.message}';
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Authentication Failure: $message'),
                ),
              );

            if (state.status is SubmissionInProgress) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const Center(
                    child: SizedBox(
                      height: 52,
                      width: 52,
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              );
            }
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
    const AppIcon(height: 100),
    const SizedBox(height: 16.0),
    const EmailInput(FormType.login),
    const SizedBox(height: 12.0),
    const PasswordInput(FormType.login),
    const SizedBox(height: 12.0),
    _LoginButton(),
    const SizedBox(height: 12.0),
    _GoogleLoginButton(),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final mobileHorizonalPadding = mediaQuery.size.width / 10;
    final wideHorizonalPadding = mediaQuery.size.width / 4;
    final isWide = isLargeFormFactor(context);
    final horizontalPadding =
        (isWide) ? wideHorizonalPadding : mobileHorizonalPadding;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverPadding(padding: EdgeInsets.only(top: 10)),
            for (var child in children)
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
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
    return SignInButton(
      Buttons.Email,
      padding: const EdgeInsets.symmetric(vertical: 16),
      onPressed: () => context.read<LoginCubit>().submitForm(FormType.login),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.GoogleDark,
      padding: const EdgeInsets.symmetric(vertical: 8),
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
        style: theme.textTheme.titleSmall,
      ),
    );
  }
}
