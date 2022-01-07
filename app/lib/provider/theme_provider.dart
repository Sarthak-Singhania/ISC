import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode? themeMode;

  void initalTheme() {
    themeMode = ThemeMode.system;

    notifyListeners();
  }

  void toggleLightTheme() {
    themeMode = ThemeMode.light;
    notifyListeners();
  }

  void toggleDarkTheme() {
    themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void toggleSystemTheme() {
    themeMode = ThemeMode.system;
    notifyListeners();
  }
}
