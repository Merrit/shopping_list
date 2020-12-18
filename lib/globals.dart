import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globals {
  static SharedPreferences prefs;
  static FirebaseAuth auth;
  static User user;

  /// Returns true when finished.
  static Future<void> initPrefs() async {
    Globals.prefs = await SharedPreferences.getInstance();
    return true;
  }
}

class Routes {
  static final String signinScreen = 'signinScreen';
  static final String signinEmailScreen = 'signinEmailScreen';
  static final String listScreen = 'listScreen';
  static final String createEmailAccountScreen = 'createEmailAccountScreen';
  static final String loadingScreen = 'loadingScreen';
}
