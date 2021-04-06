import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shopping_list/app.dart';
import 'package:shopping_list/authentication/screens/email_signin_screen.dart';
import 'package:shopping_list/list/screens/list_screen.dart';

class SigninScreen extends StatefulWidget {
  static const id = 'SigninScreen';

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final app = App.instance;
  Widget authWidget = SignInButtons();
  late final StreamSubscription<User?> authStream;
  final _log = Logger('SigninScreen');

  _SigninScreenState() {
    _log.info('Initialized');
    listenToAuthStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign in')),
      body: SingleChildScrollView(
        child: authWidget,
      ),
    );
  }

  void listenToAuthStream() {
    authStream = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _log.info('No user is signed in.');
      } else {
        logIn(user);
      }
    });
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<void> logIn(User user) async {
    await authStream.cancel();
    showLoadingDialog();
    _log.info('${user.email} is signed in.');
    await app.init();
    setUser(user);
    await goToListScreen();
  }

  Future<void> goToListScreen() async {
    // final listSnapshot = await ListManager.instance.getCurrentList();
    await Navigator.pushReplacementNamed(
      context,
      ListScreen.id,
      // arguments: listSnapshot,
    );
  }

  void setUser(User user) {
    app.user = user;
  }

  @override
  void dispose() {
    authStream.cancel();
    super.dispose();
  }
}

class SignInButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: double.infinity),
          Container(
            height: 100,
            width: 100,
            child: Placeholder(),
          ),
          SizedBox(height: 80),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 50,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, EmailSigninScreen.id);
              },
              child: Row(
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 20),
                  Text('Sign in with email'),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 50,
            width: 200,
            child: Placeholder(),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 50,
            width: 200,
            child: Placeholder(),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 50,
            width: 200,
            child: Placeholder(),
          ),
        ],
      ),
    );
  }
}
