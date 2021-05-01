import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';

import '../../authentication.dart';

class VerifyEmailPage extends StatelessWidget {
  static const id = 'verify_email_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(child: AppIcon()),
            const SizedBox(height: 50),
            const Text('A verification email has been sent to '
                'the address provided.\n'
                '\n'
                'Please verify your email, then sign in.'),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
              child: Text('BACK'),
            ),
          ],
        ),
      ),
    );
  }
}
