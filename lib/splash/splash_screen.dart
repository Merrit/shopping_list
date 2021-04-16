import 'package:flutter/material.dart';
import 'package:shopping_list/core/widgets/app_icon.dart';

class SplashPage extends StatelessWidget {
  static const id = 'splash_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppIcon(size: 150),
      ),
    );
  }
}
