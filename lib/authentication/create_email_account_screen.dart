import 'package:flutter/material.dart';

import 'package:shopping_list/authentication/create_email_account.dart';
import 'package:shopping_list/globals.dart';

class CreateEmailAccountScreen extends StatefulWidget {
  @override
  _CreateEmailAccountScreenState createState() =>
      _CreateEmailAccountScreenState();
}

// TODO: This and email_signin_screen.dart can probably be combined,
// with a conditional on which column of elements is shown or similar.
// This would reduce duplicate code and complexity.
class _CreateEmailAccountScreenState extends State<CreateEmailAccountScreen> {
  final GlobalKey<FormState> _createEmailAccountFormKey =
      GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  String _emailErrorText = null;
  String _passwordErrorText = null;
  String _passwordConfirmErrorText = null;

  String email = '';
  String password = '';
  String confirmedPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create account')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _createEmailAccountFormKey,
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
                onChanged: (value) => email = value,
                // onFieldSubmitted: (value) => _signUp(context: context),
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
                onChanged: (value) => password = value,
                // onFieldSubmitted: (value) => _signUp(context: context),
              ),
              TextFormField(
                controller: _passwordConfirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  errorText: _passwordConfirmErrorText,
                ),
                onTap: () {
                  setState(() {
                    _passwordConfirmErrorText = null;
                  });
                },
                onChanged: (value) => confirmedPassword = value,
                // onFieldSubmitted: (value) => _signUp(context: context),
              ),
              ElevatedButton(
                child: Text('Sign up'),
                onPressed: () => _signUp(context: context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp({@required BuildContext context}) async {
    if (password == confirmedPassword) {
      var result = await createEmailAccount(email: email, password: password);
      switch (result) {
        case 'success':
          var _msg = 'Success! You will now be logged in.';
          var _successSnack = SnackBar(
            content: Text(_msg),
            duration: Duration(seconds: 2),
          );
          _dispose();
          ScaffoldMessenger.of(context)
              .showSnackBar(_successSnack)
              .closed
              .then((SnackBarClosedReason reason) {
            // runApp(ListApp());
            Navigator.pushReplacementNamed(context, Routes.listScreen);
          });
          break;
        case 'weak-password':
          setState(() {
            _passwordConfirmErrorText =
                'Password must be at least 6 characters';
          });
          break;
        case 'email-already-in-use':
          setState(() {
            _emailErrorText = 'Account with this email already exists';
          });
          break;
        default:
          var otherErrorSnack =
              SnackBar(content: Text('There was a problem..'));
          ScaffoldMessenger.of(context).showSnackBar(otherErrorSnack);
      }
    } else {
      setState(() {
        _passwordConfirmErrorText = 'Passwords do not match';
      });
    }
  }

  void _dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }
}
