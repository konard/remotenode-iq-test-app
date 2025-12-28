import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Theme mode state notifier
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const _boxName = 'settings';
  static const _themeKey = 'theme_mode';

  Future<void> _loadTheme() async {
    try {
      final box = await Hive.openBox(_boxName);
      final themeIndex = box.get(_themeKey, defaultValue: 0) as int;
      state = ThemeMode.values[themeIndex];
    } catch (e) {
      state = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_themeKey, mode.index);
    } catch (e) {
      // Ignore storage errors
    }
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      setTheme(ThemeMode.dark);
    } else if (state == ThemeMode.dark) {
      setTheme(ThemeMode.system);
    } else {
      setTheme(ThemeMode.light);
    }
  }
}

/// Provider for theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);
