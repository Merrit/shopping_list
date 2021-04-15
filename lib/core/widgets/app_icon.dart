import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final double? size;

  const AppIcon({this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.shopping_bag_outlined,
      color: Colors.blue[300],
      size: size,
    );
  }
}