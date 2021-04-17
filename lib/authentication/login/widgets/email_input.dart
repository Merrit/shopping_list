import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login.dart';

class EmailInput extends StatelessWidget {
  final FormType formType;

  const EmailInput(this.formType);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextField(
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state.emailFieldErrorText(),
          ),
          onSubmitted: (_) => context.read<LoginCubit>().submitForm(formType),
        );
      },
    );
  }
}
