import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:shopping_list/globals.dart';

Future<String> signInWithEmail(
    {@required String email, @required String password}) async {
  try {
    UserCredential userCredential = await Globals.auth
        .signInWithEmailAndPassword(email: email, password: password);
    Globals.user = userCredential.user;
    return 'success';
  } catch (e) {
    return e.code;
  }
}
