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
