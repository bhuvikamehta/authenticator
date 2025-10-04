import 'package:flutter/material.dart';


final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  primaryColor: Color(0xFF007ACC),
  // accentColor: Color(0xFF007ACC),
  // Material3 if you want
  colorScheme: ColorScheme.light(
    primary: Color(0xFF007ACC),
    onPrimary: Colors.white,
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF3F4FC),
    onSurface: Color(0xFF2C234E),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(color: Color(0xFF2C234E), fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Color(0xFF2C234E), fontSize: 16),
    bodyMedium: TextStyle(color: Color(0xFF545592), fontSize: 14),
  ),
  // Optional: button themes, icon themes, etc using the accent/primary
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF242B4B),
  primaryColor: Color(0xFFDCD447),
  hintColor: Color(0xFFDCD447),
  // colorScheme: ColorScheme.dark(
  //   primary: Color(0xFFDCD447),
  //   onPrimary: Color(0xFF242B4B),
  //   background: Color(0xFF242B4B),
  //   surface: Color(0xFF2B3453),
  //   onSurface: Color(0xFFF0F0F5),
  // ),
  textTheme: TextTheme(
    displayLarge: TextStyle(color: Color(0xFFFFFFFF), fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Color(0xFFF0F0F5), fontSize: 16),
    bodyMedium: TextStyle(color: Color(0xFF9CABD1), fontSize: 14),
  ),
  // Additional theme settings for buttons, icons etc.
);
