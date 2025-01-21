import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadThemePreference();
  }

  void toggleTheme() async {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
      await _saveThemePreference(isDarkMode: true);
    } else {
      emit(ThemeMode.light);
      await _saveThemePreference(isDarkMode: false);
    }
  }

  Future<void> _saveThemePreference({required bool isDarkMode}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
