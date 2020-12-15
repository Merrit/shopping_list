import 'package:flutter/material.dart';

import 'package:shopping_list/globals.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkIfSignedIn());
  }

  /// Workaround because the initial SteamBuilder's snapshot.hasData never
  /// triggers on the web version.
  /// May have something to do with this bug that was just fixed,
  /// but will need verification:
  /// https://github.com/FirebaseExtended/flutterfire/pull/4312
  void _checkIfSignedIn() async {
    // Slight delay for any potential user info to actually populate.
    // We can't do this directly in the StreamBuilder since it
    // doesn't work with async.
    await Future.delayed(Duration(milliseconds: 500));
    // **Now** check if there is a logged in user.
    if (Globals.auth.currentUser != null) {
      print('User is logged in, moving to main app screen.');
      Navigator.pushReplacementNamed(context, Routes.listScreen);
    } else {
      // No saved user loaded, so continue normal sign in.
      print('User not logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign in')),
      body: SingleChildScrollView(
        child: Container(
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
                  child: Row(
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 20),
                      Text('Sign in with email'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.signinEmailScreen);
                  },
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
        ),
      ),
    );
  }
}
