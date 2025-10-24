import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventorymanagement/core/utils/local_storage/sqlite_manager/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/token_service.dart';
import '../utils/local_storage/shared_preferences/value_pair_share_preference.dart';

// Provide SharedPreferences (must override in main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override this in main.dart with actual instance.');
});

// TokenService depends on SharedPreferences
final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService(ref.watch(sharedPreferencesProvider));
});

// PreferenceManagerSingleValuePair depends on SharedPreferences
final preferenceManagerSingleValuePareProvider = Provider<PreferenceManagerSingleValuePair>((ref) {
  return PreferenceManagerSingleValuePair(ref.watch(sharedPreferencesProvider));
});


final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});


