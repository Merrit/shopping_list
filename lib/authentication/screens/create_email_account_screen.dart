import 'package:flutter/material.dart';

import 'package:shopping_list/authentication/create_email_account.dart';
import 'package:shopping_list/authentication/notify_email_sent.dart';

class CreateEmailAccountScreen extends StatefulWidget {
  static const id = 'CreateEmailAccountScreen';

  @override
  _CreateEmailAccountScreenState createState() =>
      _CreateEmailAccountScreenState();
}

class _CreateEmailAccountScreenState extends State<CreateEmailAccountScreen> {
  final GlobalKey<FormState> _createEmailAccountFormKey =
      GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  String? _emailErrorText;
  String? _passwordErrorText;
  String? _passwordConfirmErrorText;

  String email = '';
  String password = '';
  String confirmedPassword = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create account')),
      body: Stack(
        children: [
          Container(
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
                      setState(() => _emailErrorText = null);
                    },
                    onChanged: (value) => email = value,
                    onFieldSubmitted: (value) => _signUp(context: context),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: _passwordErrorText,
                    ),
                    onTap: () {
                      setState(() => _passwordErrorText = null);
                    },
                    onChanged: (value) => password = value,
                    onFieldSubmitted: (value) => _signUp(context: context),
                  ),
                  TextFormField(
                    controller: _passwordConfirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      errorText: _passwordConfirmErrorText,
                    ),
                    onTap: () {
                      setState(() => _passwordConfirmErrorText = null);
                    },
                    onChanged: (value) => confirmedPassword = value,
                    onFieldSubmitted: (value) => _signUp(context: context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text('A validation email will be '
                        'sent to the address you provide'),
                  ),
                  ElevatedButton(
                    onPressed: () => _signUp(context: context),
                    child: Text('Sign up'),
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? Container(
                  padding: EdgeInsets.all(30),
                  color: Colors.black.withOpacity(0.5),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Container(),
        ],
      ),
    );
  }

  void _signUp({required BuildContext context}) async {
    if (email == '') {
      setState(() {
        _emailErrorText = 'Email is required';
      });
      return;
    }
    if (password.length < 12) {
      setState(() {
        _passwordConfirmErrorText = 'Password must be at least 12 characters';
      });
      return;
    }
    if (password == confirmedPassword) {
      setState(() => isLoading = true);
      var result = await createEmailAccount(email: email, password: password);
      setState(() => isLoading = false);
      switch (result) {
        case 'success':
          await notifyEmailSent(context);
          break;
        case 'weak-password':
          // This should never run since we require 12 characters.
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
        case 'invalid-email':
          setState(() {
            _emailErrorText = 'Ivalid email';
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
}
