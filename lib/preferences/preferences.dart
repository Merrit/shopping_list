import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Save and load local user preferences and state.
class Preferences {
  static final instance = Preferences._singleton();
  late SharedPreferences prefs;

  final _log = Logger('Preferences');

  Preferences._singleton() {
    _log.info('Initialized');
  }

  /// Initialize shared_preferences, returns true to indicate finished.
  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// Returns the name of the most recently used list.
  String? lastUsedListName() => prefs.getString('lastUsedList');

  /// Save the name of the most recently used list.
  Future<void> setLastUsedList(String lastUsedList) async =>
      await prefs.setString('lastUsedList', lastUsedList);

  String get taxRate => prefs.get('taxRate') as String? ?? '';

  Future<void> setTaxRate(String taxRate) async =>
      await prefs.setString('taxRate', taxRate);
}
