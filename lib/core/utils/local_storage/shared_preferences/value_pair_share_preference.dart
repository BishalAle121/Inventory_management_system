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
  Future<void> setBool(String key, bool value) async => await _prefs.setBool(key, value);
  Future<void> setInt(String key, int value) async => await _prefs.setInt(key, value);
  Future<void> setDouble(String key, double value) async => await _prefs.setDouble(key, value);
  Future<void> setString(String key, String value) async => await _prefs.setString(key, value);

  // Generic Getters
  bool? getBool(String key) => _prefs.getBool(key);
  int? getInt(String key) => _prefs.getInt(key);
  double? getDouble(String key) => _prefs.getDouble(key);
  String? getString(String key) => _prefs.getString(key);

  // Delete
  Future<void> remove(String key) async => await _prefs.remove(key);
}



/*
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManagerSingleValuePair {
  static final PreferenceManagerSingleValuePair _instance =
      PreferenceManagerSingleValuePair._internal();

  late SharedPreferences _sharedPreferences;

  PreferenceManagerSingleValuePair._internal();

  static PreferenceManagerSingleValuePair get Instance => _instance;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  set setFirstAppLunch(bool value) =>
      _sharedPreferences.setBool('isFirstLunch', value);
  bool get isFirstAppLunch =>
      _sharedPreferences.getBool('isFirstLunch') ?? false;

  // Set Single Value in Shared Preference
  void boolValueSetOrUpdate(bool value, String key) =>
      _sharedPreferences.setBool(key, value);
  void intValueSetOrUpdate(String key, int value) =>
      _sharedPreferences.setInt(key, value);
  void doubleValueSetOrUpdate(String key, double value) =>
      _sharedPreferences.setDouble(key, value);
  void stringValueSetOrUpdate(String key, String value) =>
      _sharedPreferences.setString(key, value);

  // Get Single Value in Shared Preference
  bool? getAccessToken(String key) => _sharedPreferences.getBool(key);
  int? getIntValue(String key) => _sharedPreferences.getInt(key);
  double? getDoubleValue(String key) => _sharedPreferences.getDouble(key);
  String? getStringValue(String key) => _sharedPreferences.getString(key);

  // Delete Single Value in Shared Preference
  void deleteBoolValue(String delete) => _sharedPreferences.remove(delete);
}
*/
