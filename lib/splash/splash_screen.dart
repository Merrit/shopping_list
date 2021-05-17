import 'package:flutter/material.dart';
import 'package:shopping_list/core/widgets/app_icon.dart';

class SplashPage extends StatelessWidget {
  static const id = 'splash_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            AppIcon(
              height: 150,
              width: 150,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
