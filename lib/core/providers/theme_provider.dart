import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final storage = const FlutterSecureStorage();

    final value = await storage.read(key: 'isDark') ?? 'false';
    bool isDark = value == 'true';
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    // final prefs = await SharedPreferences.getInstance();
    final storage = const FlutterSecureStorage();

    final isDark = state == ThemeMode.dark;

    state = isDark ? ThemeMode.light : ThemeMode.dark;
    // await prefs.write( 'isDark', state == ThemeMode.dark);
    await storage.write(
      key: 'isDark',
      value: state == ThemeMode.dark ? 'true' : 'false',
    );

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark, // Android
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light, // iOS
      ),
    );
  }
}
