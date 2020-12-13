import 'package:firebase_auth/firebase_auth.dart';

class Globals {
  static FirebaseAuth auth;
  static User user;
}

class Routes {
  static final String signinScreen = 'signinScreen';
  static final String signinEmailScreen = 'signinEmailScreen';
  static final String listScreen = 'listScreen';
  static final String createEmailAccountScreen = 'createEmailAccountScreen';
  static final String loadingScreen = 'loadingScreen';
}
