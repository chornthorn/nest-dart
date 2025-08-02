import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'preference_keys.dart';

/// Simple utility class for managing application configuration using SharedPreferences
class ConfigPreference {
  final SharedPreferences _prefs;

  ConfigPreference(this._prefs);

  // =============================================================================
  // BASIC METHODS
  // =============================================================================

  /// Save a string value
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Get a string value with default
  String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  /// Save an integer value
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// Get an integer value with default
  int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  /// Save a boolean value
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// Get a boolean value with default
  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  /// Save a JSON object
  Future<bool> setJson(String key, dynamic value) async {
    final jsonString = jsonEncode(value);
    return await _prefs.setString(key, jsonString);
  }

  /// Get a JSON object
  T? getJson<T>(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as T;
    } catch (e) {
      return null;
    }
  }

  /// Remove a key
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// Clear all preferences
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // =============================================================================
  // APP SETTINGS
  // =============================================================================

  /// App Theme (light, dark, system)
  Future<bool> setTheme(String theme) async {
    return await setString(PreferenceKeys.appTheme, theme);
  }

  String getTheme() {
    return getString(PreferenceKeys.appTheme, defaultValue: 'system');
  }

  /// First time launch
  Future<bool> setFirstLaunch(bool isFirst) async {
    return await setBool(PreferenceKeys.isFirstLaunch, isFirst);
  }

  bool isFirstLaunch() {
    return getBool(PreferenceKeys.isFirstLaunch, defaultValue: true);
  }

  // =============================================================================
  // USER SETTINGS
  // =============================================================================

  /// User name
  Future<bool> setUserName(String name) async {
    return await setString(PreferenceKeys.userName, name);
  }

  String getUserName() {
    return getString(PreferenceKeys.userName);
  }

  /// User ID
  Future<bool> setUserId(int id) async {
    return await setInt(PreferenceKeys.userId, id);
  }

  int getUserId() {
    return getInt(PreferenceKeys.userId);
  }

  // =============================================================================
  // TODO SETTINGS
  // =============================================================================

  /// Show completed todos
  Future<bool> setShowCompleted(bool show) async {
    return await setBool(PreferenceKeys.showCompletedTodos, show);
  }

  bool getShowCompleted() {
    return getBool(PreferenceKeys.showCompletedTodos, defaultValue: true);
  }

  /// Todos per page
  Future<bool> setTodosPerPage(int count) async {
    return await setInt(PreferenceKeys.todosPerPage, count);
  }

  int getTodosPerPage() {
    return getInt(PreferenceKeys.todosPerPage, defaultValue: 20);
  }

  /// Last refresh time
  Future<bool> setLastRefresh(DateTime time) async {
    return await setString(
      PreferenceKeys.lastRefreshTime,
      time.toIso8601String(),
    );
  }

  DateTime? getLastRefresh() {
    final timeString = getString(PreferenceKeys.lastRefreshTime);
    if (timeString.isEmpty) return null;

    try {
      return DateTime.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  // =============================================================================
  // API SETTINGS
  // =============================================================================

  /// API base URL
  Future<bool> setApiUrl(String url) async {
    return await setString(PreferenceKeys.apiBaseUrl, url);
  }

  String getApiUrl() {
    return getString(
      PreferenceKeys.apiBaseUrl,
      defaultValue: 'https://jsonplaceholder.typicode.com',
    );
  }

  // =============================================================================
  // UTILITY METHODS
  // =============================================================================

  /// Reset to default settings
  Future<bool> resetDefaults() async {
    await clear();
    await setFirstLaunch(false);
    await setTheme('system');
    await setShowCompleted(true);
    await setTodosPerPage(20);
    return true;
  }

  /// Get all preferences as Map
  Map<String, dynamic> getAllPreferences() {
    final Map<String, dynamic> prefs = {};
    final keys = _prefs.getKeys();

    for (final key in keys) {
      prefs[key] = _prefs.get(key);
    }

    return prefs;
  }
}
