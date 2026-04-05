import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/storage_keys.dart';

class AppSettingsViewModel extends ChangeNotifier {
  AppSettingsViewModel(this._preferences) {
    _themeMode = _readThemeMode();
    _locale = _readLocale();
  }

  final SharedPreferences _preferences;

  late ThemeMode _themeMode;
  late Locale _locale;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  ThemeMode _readThemeMode() {
    final raw = _preferences.getString(StorageKeys.themeMode);
    for (final mode in ThemeMode.values) {
      if (mode.name == raw) {
        return mode;
      }
    }
    return ThemeMode.system;
  }

  Locale _readLocale() {
    final code = _preferences.getString(StorageKeys.localeTag) ?? 'en';
    return Locale(code);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _preferences.setString(StorageKeys.themeMode, mode.name);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _preferences.setString(StorageKeys.localeTag, locale.languageCode);
    notifyListeners();
  }
}
