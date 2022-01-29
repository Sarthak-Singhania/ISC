import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode? themeMode;
  Color checkTheme(Color first, Color second,BuildContext context) {
      print(ThemeMode.system);
      if (themeMode == ThemeMode.light) {
        return first;
      } else if (themeMode == ThemeMode.dark) {
        return second;
      } else {
        if (MediaQuery.of(context).platformBrightness == Brightness.light) {
          return first;
        } else {
          return second;
        }
      }
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
