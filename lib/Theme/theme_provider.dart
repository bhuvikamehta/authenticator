import 'package:auth_app/Theme/theme_data.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = darkTheme;
  ThemeData? get themeData => _themeData;
  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}