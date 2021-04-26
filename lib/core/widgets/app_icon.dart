import 'package:flutter/material.dart';

/// Shopping List's own icon.
class AppIcon extends StatelessWidget {
  final double? height;
  final double? width;

  const AppIcon({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icon/icon.png',
      height: height,
      width: width,
    );
  }
}
