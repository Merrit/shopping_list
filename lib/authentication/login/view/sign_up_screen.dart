import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/login/login.dart';

class SignUpScreen extends StatelessWidget {
  static const id = 'sign_up_screen';

  const SignUpScreen();

  // static Route route() {
  //   return MaterialPageRoute<void>(builder: (_) => const SignUpScreen());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
          child: SignUpForm(),
        ),
      ),
    );
  }
}
