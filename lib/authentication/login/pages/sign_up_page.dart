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
    AppIcon(height: 100),
    const SizedBox(height: 16.0),
    EmailInput(FormType.signup),
    const SizedBox(height: 12.0),
    PasswordInput(FormType.signup),
    const SizedBox(height: 12.0),
    _ConfirmPasswordInput(),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: CustomScrollView(
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
        return (state.status is SubmissionInProgress)
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
