import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManagerSingleValuePair {
  final SharedPreferences _prefs;

  PreferenceManagerSingleValuePair(this._prefs);

  // Set first launch
  Future<void> setFirstAppLaunch(bool value) async {
    await _prefs.setBool('isFirstLaunch', value);
  }

  bool get isFirstAppLaunch => _prefs.getBool('isFirstLaunch') ?? false;

  // Generic Setters
  Future<void> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);
  Future<void> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);
  Future<void> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);
  Future<void> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  // Generic Getters
  bool? getBool(String key) => _prefs.getBool(key);
  int? getInt(String key) => _prefs.getInt(key);
  double? getDouble(String key) => _prefs.getDouble(key);
  String? getString(String key) => _prefs.getString(key);

  // Delete
  Future<void> remove(String key) async => await _prefs.remove(key);
}
