import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';

Future<String> createEmailAccount(
    {@required String email, @required String password}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return 'success';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'weak-password';
    } else if (e.code == 'email-already-in-use') {
      return 'email-already-in-use';
    }
  }
  return 'error';
}
