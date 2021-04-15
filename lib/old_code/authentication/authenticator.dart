import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shopping_list/app.dart';

class Authenticator {
  Authenticator._singleton();
  static final Authenticator instance = Authenticator._singleton();

  // final _app = App.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> createEmailAccount({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> signInWithEmail(
      {required String email, required String password}) async {
    // late UserCredential userCredential;
    String result;

    try {
      // userCredential = await _auth.signInWithEmailAndPassword(
      //     email: email, password: password);
      result = 'success';
    } on FirebaseAuthException catch (e) {
      result = e.code.toString();
    }

    switch (result) {
      case 'success':
        if (_auth.currentUser!.emailVerified) {
          // _app.user = userCredential.user!;
          return result;
        } else {
          await _auth.signOut();
          return 'email-not-verified';
        }
      default:
        return result;
    }
  }
}
