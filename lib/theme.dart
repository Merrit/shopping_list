import 'package:flutter/material.dart';

class AppTheme {
  static final dark = ThemeData(
    accentColor: Colors.lightBlueAccent,
    textTheme: TextTheme(subtitle2: TextStyle(color: Colors.blue)),
    brightness: Brightness.dark,
    toggleableActiveColor: Colors.lightBlueAccent,
  );
}
