import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login.dart';

class PasswordInput extends StatelessWidget {
  final FormType formType;

  const PasswordInput(this.formType);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextField(
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            helperText:
                (formType == FormType.signup) ? 'Minimum 12 characters' : null,
            errorText: state.passwordFieldErrorText(),
          ),
          onSubmitted: (_) => context.read<LoginCubit>().submitForm(formType),
        );
      },
    );
  }
}
