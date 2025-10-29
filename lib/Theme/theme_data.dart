import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  primaryColor: const Color(0xFF007AFF),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF007AFF),
    onPrimary: Colors.white,
    surface: Color(0xFFF7F8FA),
    onSurface: Color(0xFF1C1C1E),
    secondary: Color(0xFF6E6E73),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Color(0xFF1C1C1E),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Color(0xFF1C1C1E),
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFF6E6E73),
      fontSize: 14,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF007AFF),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF2F2F7),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide.none,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF000000),
  primaryColor: const Color(0xFF00D0A8),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF00D0A8),
    onPrimary: Color(0xFF000000),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFFFFFFF),
    secondary: Color(0xFFA0AEC0),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFFA0AEC0),
      fontSize: 14,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00D0A8),
      foregroundColor: const Color(0xFF000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),
);
