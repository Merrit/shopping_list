import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/authentication/email_signin_screen.dart';
import 'package:shopping_list/authentication/loading_screen.dart';
import 'package:shopping_list/authentication/signin_screen.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/list_screen.dart';
import 'package:shopping_list/globals.dart';

void main() async {
  // Ensure setup is finished.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ListApp());
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
    return ProxyProvider(
      create: (context) => FirestoreUser(),
      update: (_, __, ___) => FirestoreUser(),
      child: MaterialApp(
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
      ),
    );
  }
}
