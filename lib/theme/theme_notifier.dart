import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mix/mix.dart';
import 'app_theme.dart';

// Provider cho Cupertino Theme (giữ nguyên)
final themeProvider = NotifierProvider<ThemeNotifier, CupertinoThemeData>(
  ThemeNotifier.new,
);

// Provider cho Mix Theme
final mixThemeProvider = NotifierProvider<MixThemeNotifier, MixThemeData>(
  MixThemeNotifier.new,
);

// Provider cho isDark state
final isDarkProvider = NotifierProvider<IsDarkNotifier, bool>(
  IsDarkNotifier.new,
);

class IsDarkNotifier extends Notifier<bool> {
  static const _prefKey = "isDarkMode";

  @override
  bool build() {
    _init();
    return false; // default light
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_prefKey) ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, state);
  }
}

class ThemeNotifier extends Notifier<CupertinoThemeData> {
  @override
  CupertinoThemeData build() {
    final isDark = ref.watch(isDarkProvider);
    return AppTheme.cupertinoTheme(isDark);
  }
}

class MixThemeNotifier extends Notifier<MixThemeData> {
  @override
  MixThemeData build() {
    final isDark = ref.watch(isDarkProvider);
    return AppTheme.mixTheme(isDark);
  }
}
