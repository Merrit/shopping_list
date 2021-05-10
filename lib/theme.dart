import 'package:flutter/material.dart';

class AppTheme {
  static final dark = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColorDark: Colors.lightBlue,
    // primarySwatch: Colors.lightBlue,
    accentColor: Colors.lightBlueAccent,
    toggleableActiveColor: Colors.lightBlueAccent,
    // textTheme: TextTheme(
    //     // subtitle2: TextStyle(color: Colors.blue),
    //     ),
    // cardTheme: CardTheme(
    //   color: Colors.grey[700],
    // ),
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
