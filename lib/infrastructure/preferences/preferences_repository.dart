import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  static late SharedPreferences _prefs;

  /// Pass in a mock during tests, otherwise get SharedPreferences.
  static Future<void> init([SharedPreferences? sharedPreferences]) async {
    if (sharedPreferences != null) {
      _prefs = sharedPreferences;
    } else {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Object? getKey(String key) => _prefs.get(key);

  Future<void> setString({required String key, required String value}) {
    return _prefs.setString(key, value);
  }
}
