import 'package:firebase_auth/firebase_auth.dart';

class Routes {
  static const String signinScreen = 'signinScreen';
  static const String signinEmailScreen = 'signinEmailScreen';
  static const String listScreen = 'listScreen';
  static const String createEmailAccountScreen = 'createEmailAccountScreen';
  static const String loadingScreen = 'loadingScreen';
}

class Globals {
  static late FirebaseAuth auth;
  static late User? user;
}
