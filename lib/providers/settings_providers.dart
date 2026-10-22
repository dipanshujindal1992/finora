import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finora/models/user_model.dart' hide ThemeMode;
import 'package:finora/core/constants/app_constants.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized first');
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(prefs);
});

class SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  ThemeMode getThemeMode() {
    final themeIndex = _prefs.getInt(AppConstants.sharedPrefsThemeKey) ?? 0;
    return ThemeMode.values[themeIndex];
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _prefs.setInt(AppConstants.sharedPrefsThemeKey, themeMode.index);
  }

  String getCurrency() {
    return _prefs.getString(AppConstants.sharedPrefsCurrencyKey) ??
        AppConstants.currencyCode;
  }

  Future<void> setCurrency(String currency) async {
    await _prefs.setString(AppConstants.sharedPrefsCurrencyKey, currency);
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool(AppConstants.sharedPrefsNotificationsKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.sharedPrefsNotificationsKey, enabled);
  }

  bool getBiometricEnabled() {
    return _prefs.getBool(AppConstants.sharedPrefsBiometricKey) ?? false;
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.sharedPrefsBiometricKey, enabled);
  }

  bool isFirstLaunch() {
    return _prefs.getBool(AppConstants.sharedPrefsFirstLaunchKey) ?? true;
  }

  Future<void> setFirstLaunchComplete() async {
    await _prefs.setBool(AppConstants.sharedPrefsFirstLaunchKey, false);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return ThemeModeNotifier(repository);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SettingsRepository _repository;

  ThemeModeNotifier(this._repository) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    state = _repository.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await _repository.setThemeMode(themeMode);
  }
}
