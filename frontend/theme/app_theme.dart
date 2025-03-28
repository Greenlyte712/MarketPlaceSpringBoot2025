import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Color.fromARGB(255, 11, 2, 59),
      foregroundColor: Color.fromARGB(255, 218, 212, 212),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 4, 3, 61),
        foregroundColor: Color.fromARGB(255, 236, 234, 234),
      ),
    ),
  );
}
