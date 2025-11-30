import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

final themeProvider =
    NotifierProvider<ThemeNotifier, CupertinoThemeData>(ThemeNotifier.new);

class ThemeNotifier extends Notifier<CupertinoThemeData> {
  static const _prefKey = "isDarkMode";
  late bool _isDark;

  @override
  CupertinoThemeData build() {
    _init();
    return AppTheme.theme(false); // default light khi chưa load xong
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_prefKey) ?? false;

    state = AppTheme.theme(_isDark);
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    state = AppTheme.theme(_isDark);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, _isDark);
  }
}
