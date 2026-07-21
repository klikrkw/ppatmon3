import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade400,
      secondary: Colors.blue.shade300,
      tertiary: Colors.blue.shade100,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade300),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(backgroundColor: Colors.blue.shade400),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    ),
    cardColor: CardTheme(color: Colors.blue.shade200).color,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
  );
}
