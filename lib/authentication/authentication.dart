import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_list/globals.dart';

void initAuth() {
  Globals.auth = FirebaseAuth.instance;

  subscribeAuth();
}

void subscribeAuth() {
  Globals.auth.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
      Globals.user = null;
    } else {
      print('User is signed in!');
      Globals.user = user;
    }
  });
}
