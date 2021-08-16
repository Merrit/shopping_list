import 'package:flutter/material.dart';

class AppTheme {
  static final dark = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColorDark: Colors.lightBlue,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.lightBlueAccent,
    ),
    toggleableActiveColor: Colors.lightBlueAccent,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(20),
      ),
    ),
  );
}
