import 'package:flutter/material.dart';

class AppTheme {
  static final dark = ThemeData(
    brightness: Brightness.dark,
    accentColor: Colors.lightBlueAccent,
    toggleableActiveColor: Colors.lightBlueAccent,
    textTheme: TextTheme(
      subtitle2: TextStyle(color: Colors.blue),
    ),
    // dataTableTheme: DataTableThemeData(
    //   dataTextStyle: TextStyle(
    //     fontSize: 18,
    //   ),
    //   headingTextStyle: TextStyle(
    //     fontSize: 20,
    //   ),
    // ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
  );
}
