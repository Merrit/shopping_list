import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:shopping_list/globals.dart';

Future<String> signInWithEmail(
    {@required String email, @required String password}) async {
  UserCredential userCredential;
  String result;

  try {
    userCredential = await Globals.auth
        .signInWithEmailAndPassword(email: email, password: password);
    result = 'success';
  } catch (e) {
    result = e.code;
  }

  switch (result) {
    case 'success':
      if (Globals.auth.currentUser.emailVerified) {
        Globals.user = userCredential.user;
        return result;
      } else {
        Globals.auth.signOut();
        return 'email-not-verified';
      }
      break;
    default:
      return result;
  }
}
