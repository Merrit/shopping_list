import 'package:flutter/material.dart';

import 'package:shopping_list/firebase/firebase_auth.dart';
import 'package:shopping_list/firebase/signin_screen.dart';
import 'package:shopping_list/list/list_screen.dart';
import 'package:shopping_list/globals.dart' as globals;

void main() {
  // WidgetsFlutterBinding.ensureInitialized() appears to be
  // needed because we are doing work before runApp().
  WidgetsFlutterBinding.ensureInitialized();
  initFirebase();
  // if (globals.userSignedIn) {
  //   runApp(ListApp());
  // } else {
  //   runApp(SigninApp());
  // }
}

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
