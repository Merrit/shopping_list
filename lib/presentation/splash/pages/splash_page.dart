import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/infrastructure/authentication_repository/authentication_repository.dart';
import 'package:shopping_list/presentation/core/core.dart';
import 'package:shopping_list/presentation/home/pages/home_page.dart';

class SplashPage extends StatelessWidget {
  static const id = 'splash_page';

  const SplashPage();

  @override
  Widget build(BuildContext context) {
    // Workaround for the bug in Web debug version where
    // hot restart gets stuck on the splash page.
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final user = context.read<AuthenticationRepository>().currentUser;
      if (user == User.empty) {
        print('No user found on SpashPage');
      } else {
        Navigator.pushReplacementNamed(context, HomePage.id);
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 50,
              width: double.infinity,
            ),
            AppIcon(
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 50),
            Flexible(
              flex: 2,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
