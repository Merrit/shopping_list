import 'package:flutter/material.dart';
import 'package:shopping_list/authentication/create_email_account_screen.dart';
import 'package:shopping_list/authentication/sign_in.dart';
import 'package:shopping_list/main.dart';

class EmailSigninScreen extends StatefulWidget {
  EmailSigninScreen({
    Key key,
  }) : super(key: key);

  @override
  _EmailSigninScreenState createState() => _EmailSigninScreenState();
}

class _EmailSigninScreenState extends State<EmailSigninScreen> {
  final GlobalKey<FormState> _emailSigninFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _emailErrorText = null;
  String _passwordErrorText = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign in with email')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 50),
            Icon(Icons.email, size: 50),
            Form(
              key: _emailSigninFormKey,
              child: Container(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: _emailErrorText,
                      ),
                      onTap: () {
                        setState(() {
                          _emailErrorText = null;
                        });
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: _passwordErrorText,
                      ),
                      onTap: () {
                        setState(() {
                          _passwordErrorText = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Sign in'),
              onPressed: () {
                _signIn(context);
              },
            ),
            Spacer(),
            TextButton(
              child: Text('Create account'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateEmailAccountScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _signIn(BuildContext context) async {
    if (_emailSigninFormKey.currentState.validate()) {
      String result = await signInWithEmail(
          email: _emailController.text, password: _passwordController.text);
      switch (result) {
        case 'success':
          var _msg = 'Success! You will now be logged in.';
          var _successSnack = SnackBar(
            content: Text(_msg),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context)
              .showSnackBar(_successSnack)
              .closed
              .then((SnackBarClosedReason reason) {
            runApp(ListApp());
          });
          break;
        case 'user-not-found':
          setState(() {
            _emailErrorText = 'User not found';
          });
          break;
        case 'invalid-email':
          setState(() {
            _emailErrorText = 'Invalid email';
          });
          break;
        case 'user-disabled':
          setState(() {
            _emailErrorText = 'Account is disabled';
          });
          break;
        case 'wrong-password':
          setState(() {
            _passwordErrorText = 'Incorrect password';
          });
          break;
        default:
          var _otherErrorSnack =
              SnackBar(content: Text('There was a problem..'));
          ScaffoldMessenger.of(context).showSnackBar(_otherErrorSnack);
      }
    }
  }
}
