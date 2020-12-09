import 'package:flutter/material.dart';
import 'package:shopping_list/authentication/create_email_account.dart';
import 'package:shopping_list/authentication/email_signin_screen.dart';
import 'package:shopping_list/main.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmailSigninScreen()));
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

void showErrorDialog(
    {@required BuildContext context,
    @required String errorMessage // Message to the user.
    }) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('There was a problem'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      });
}
