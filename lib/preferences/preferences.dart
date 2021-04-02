import 'package:shared_preferences/shared_preferences.dart';

/// Save and load local user preferences and state.
class Preferences {
  // TODO: Make Preferences a singleton instead of static.

  static late final SharedPreferences prefs;

  /// Initialize shared_preferences, returns true to indicate finished.
  static Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// Returns the name of the most recently used list.
  static String? lastUsedList() => prefs.getString('lastUsedList');

  /// Save the name of the most recently used list.
  static Future<void> setLastUsedList(String lastUsedList) async =>
      await prefs.setString('lastUsedList', lastUsedList);

  static String get taxRate => prefs.get('taxRate') as String? ?? '';

  static Future<void> setTaxRate(String taxRate) async =>
      await prefs.setString('taxRate', taxRate);
}
