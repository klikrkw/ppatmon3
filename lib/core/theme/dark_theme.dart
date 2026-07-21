import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.blue.shade900,
      secondary: Colors.blue.shade800,
      tertiary: Colors.blue.shade600,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    ),
    cardColor: CardTheme(color: Colors.blue.shade600).color,
    scaffoldBackgroundColor: Colors.black,
  );
}
