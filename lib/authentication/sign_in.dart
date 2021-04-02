import 'package:firebase_auth/firebase_auth.dart';

import 'package:shopping_list/globals.dart';

Future<String> signInWithEmail(
    {required String email, required String password}) async {
  late UserCredential userCredential;
  String result;

  try {
    userCredential = await Globals.auth
        .signInWithEmailAndPassword(email: email, password: password);
    result = 'success';
  } on FirebaseAuthException catch (e) {
    result = e.code.toString();
  }

  switch (result) {
    case 'success':
      if (Globals.auth.currentUser!.emailVerified) {
        Globals.user = userCredential.user!;
        return result;
      } else {
        await Globals.auth.signOut();
        return 'email-not-verified';
      }
    default:
      return result;
  }
}
