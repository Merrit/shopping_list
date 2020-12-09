import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_list/authentication/signin_screen.dart';
import 'package:shopping_list/list/list_screen.dart';

FirebaseAuth auth;

void main() async {
  // Ensure setup is finished before running app.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp();

  // Load authentication.
  auth = FirebaseAuth.instance;

  if (auth.currentUser != null) {
    runApp(ListApp());
  } else {
    runApp(SigninApp());
  }
}

// TODO: Implement anonymous signin.
/// Runs if the user needs to sign in or sign up.
class SigninApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: SigninScreen(),
    );
  }
}

/// The main Shopping List app.
class ListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: ListScreen(),
    );
  }
}
