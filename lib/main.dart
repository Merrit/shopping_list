import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_list/authentication/email_signin_screen.dart';
import 'package:shopping_list/authentication/signin_screen.dart';
import 'package:shopping_list/list/list_screen.dart';
import 'package:shopping_list/globals.dart';
import 'package:shopping_list/authentication/authentication.dart';

void main() async {
  // Ensure setup is finished before running app.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(ListApp());
}

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    // initAuth();
    // Initialize Firebase Authentication.
    Globals.auth = FirebaseAuth.instance;
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

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(child: Text('Something went wrong'));
  }
}

// TODO: Implement anonymous signin.

/// The main Shopping List app.
class ListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      routes: {
        Routes.signinScreen: (context) => SigninScreen(),
        Routes.signinEmailScreen: (context) => EmailSigninScreen(),
        Routes.listScreen: (context) => ListScreen(),
        Routes.loadingScreen: (context) => Loading(),
      },
      initialRoute: Routes.loadingScreen,
    );
  }
}
