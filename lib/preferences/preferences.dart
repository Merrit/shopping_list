import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:shopping_list/globals.dart';

/// Save and load local user preferences and state.
class Preferences {
  static SharedPreferences prefs;
  static String _uid = Globals.user.uid;

  /// Initialize shared_preferences, returns true to indicate finished.
  static Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  /// Get the name of the most recently used list.
  static String get lastUsedList {
    String prefsStringyMap = prefs.getString(_uid);
    if (prefsStringyMap != null) {
      // shared_preferences can't save maps, so we convert from saved String.
      Map prefsMap = json.decode(prefsStringyMap);
      String lastList = prefsMap['lastUsedList'];
      return lastList;
    } else {
      // Will be null if the saved value doesn't exist yet.
      return null;
    }
  }

  /// Save the name of the most recently used list.
  static set lastUsedList(String lastUsedList) {
    Map lastListMap = {'lastUsedList': lastUsedList};
    // shared_preferences can't save maps, so we convert to String first.
    prefs.setString(_uid, json.encode(lastListMap));
  }
}
