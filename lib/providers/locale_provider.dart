import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Locale state notifier
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  static const _boxName = 'settings';
  static const _localeKey = 'locale';

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ru'),
    Locale('es'),
  ];

  Future<void> _loadLocale() async {
    try {
      final box = await Hive.openBox(_boxName);
      final localeCode = box.get(_localeKey, defaultValue: 'en') as String;
      state = Locale(localeCode);
    } catch (e) {
      state = const Locale('en');
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;

    state = locale;
    try {
      final box = await Hive.openBox(_boxName);
      await box.put(_localeKey, locale.languageCode);
    } catch (e) {
      // Ignore storage errors
    }
  }

  String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      case 'es':
        return 'Español';
      default:
        return locale.languageCode;
    }
  }
}

/// Provider for locale
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);
