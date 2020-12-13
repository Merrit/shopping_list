import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/authentication/signin_screen.dart';
import 'package:shopping_list/list/list_screen.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    // Initialize Firebase Authentication.
    initAuth();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      // Listen to the auth stream from Firebase.
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        // Wait for the stream to be active.
        if (snapshot.connectionState == ConnectionState.active) {
          // Check if there is a user.
          // If yes, start the app; if no, start the sign in screen.
          // On web this always comes up null, so we get to the sign in screen.
          if (FirebaseAuth.instance.currentUser != null) {
            return ListScreen();
          } else {
            return SigninScreen();
          }
        }
        return Container(child: CircularProgressIndicator());
      },
    );
  }
}
