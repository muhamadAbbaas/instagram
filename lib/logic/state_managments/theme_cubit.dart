import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/data/local/cash_helper.dart';

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

  Future<void> _saveThemePreference({
    required bool isDarkMode,
  }) async {
    await CacheHelper.setData(key: 'isDarkMode', value: isDarkMode);
  }

  Future<void> _loadThemePreference() async {
    final isDarkMode = CacheHelper.getData(key: 'isDarkMode') ?? false;
    emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
