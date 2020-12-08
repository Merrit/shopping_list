import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopping_list/globals.dart' as globals;
import 'package:shopping_list/main.dart';

final Future<FirebaseApp> _firebase = Firebase.initializeApp();
FirebaseAuth auth;

void initFirebase() async {
  initAuth(await _firebase);
}

void initAuth(FirebaseApp firebaseApp) {
  auth = FirebaseAuth.instance;
  if (auth.currentUser != null) {
    globals.userSignedIn = true;
    runApp(ListApp());
  } else {
    runApp(SigninApp());
  }
  subscribeAuth();
}

void subscribeAuth() {
  FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null) {
      print('User is currently signed out!');
      globals.userSignedIn = false;
    } else {
      print('User is signed in!');
      globals.userSignedIn = true;
    }
  });
}

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
  } catch (e) {
    print('Other auth error: \n$e');
    return 'other error';
  }
  return 'fail';
}
