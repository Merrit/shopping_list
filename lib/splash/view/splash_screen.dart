import 'package:flutter/material.dart';
import 'package:shopping_list/core/widgets/app_icon.dart';

class SplashScreen extends StatelessWidget {
  static const id = 'splash_screen';
  // static Route route() {
  //   return MaterialPageRoute<void>(builder: (_) => SplashScreen());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppIcon(size: 150),
      ),
    );
  }
}
