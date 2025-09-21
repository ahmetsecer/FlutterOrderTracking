import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  ThemeMode mode = ThemeMode.system;
  void toggle() {
    mode = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

ThemeData lightTheme() {
  final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5)); // indigo-ish, no gradient
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFFF7F7F9),
    appBarTheme: const AppBarTheme(centerTitle: false),
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      isDense: true,
    ),
    chipTheme: const ChipThemeData(shape: StadiumBorder()),
  );
}

ThemeData darkTheme() {
  final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5), brightness: Brightness.dark);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      isDense: true,
    ),
    chipTheme: const ChipThemeData(shape: StadiumBorder()),
  );
}
