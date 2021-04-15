import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';

import '../../authentication.dart';

class VerifyEmailScreen extends StatelessWidget {
  static const id = 'verify_email_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () => context
              .read<AuthenticationBloc>()
              .add(AuthenticationLogoutRequested()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(child: AppIcon(size: 150)),
            const SizedBox(height: 50),
            const Text('A verification email has been sent to '
                'the address provided.\n'
                '\n'
                'Please verify your email, then sign in.'),
          ],
        ),
      ),
    );
  }
}
