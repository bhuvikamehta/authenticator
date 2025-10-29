import 'package:auth_app/Theme/theme_data.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = darkTheme;
  
  ThemeData? get themeData => _themeData;
  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  bool _isDark = true; // Should match the initial _themeData

  bool get isDark => _isDark;
  void toggleTheme() {
    if (isDark){
      _themeData = lightTheme;
      _isDark = false;
    }
    else{
      _themeData = darkTheme;
      _isDark = true;
    }
    notifyListeners();
  }
}