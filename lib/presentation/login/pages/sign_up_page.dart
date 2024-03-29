import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication/bloc/login_status.dart';
import '../../../application/login/cubit/login_cubit.dart';
import '../../../domain/core/core.dart';
import '../../../domain/login/login.dart';
import '../../../infrastructure/authentication_repository/authentication_repository.dart';
import '../../core/core.dart';
import '../login.dart';

class SignUpPage extends StatelessWidget {
  static const id = 'sign_up_page';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status is SubmissionFailure) {
            final failure = state.status as SubmissionFailure;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Sign Up Failure: ${failure.code}'),
                ),
              );
          }
        },
        child: SignUpView(),
      ),
    );
  }
}

class SignUpView extends StatelessWidget {
  final children = <Widget>[
    const AppIcon(height: 100),
    const SizedBox(height: 16.0),
    const EmailInput(FormType.signup),
    const SizedBox(height: 12.0),
    const PasswordInput(FormType.signup),
    const SizedBox(height: 12.0),
    _ConfirmPasswordInput(),
  ];

  SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final mobileHorizonalPadding = mediaQuery.size.width / 10;
    final wideHorizonalPadding = mediaQuery.size.width / 4;
    final isWide = isLargeFormFactor(context);
    final horizontalPadding =
        (isWide) ? wideHorizonalPadding : mobileHorizonalPadding;

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: CustomScrollView(
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
            errorText: state.confirmPasswordFieldErrorText,
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
        return (state.status is SubmissionInProgress)
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
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
