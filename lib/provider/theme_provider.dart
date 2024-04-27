import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  String currentTheme = "dark";

  ThemeMode get themeMode {
    if (currentTheme == "light") {
      return ThemeMode.light;
    } else if (currentTheme == "dark") {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  void changeTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("theme", theme);

    currentTheme = theme;

    notifyListeners();
  }

  void initialize() async {
    final prefs = await SharedPreferences.getInstance();

    currentTheme = prefs.getString("theme") ?? "light";

    notifyListeners();
  }
}