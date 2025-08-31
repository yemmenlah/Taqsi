import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  bool isDark = false;

  ThemeMode get currentMode => isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
