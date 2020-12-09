import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:shopping_list/main.dart';

Future<String> signInWithEmail(
    {@required String email, @required String password}) async {
  try {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return 'success';
  } catch (e) {
    return e.code;
  }
}
