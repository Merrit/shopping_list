import 'package:flutter/material.dart';
// import 'package:shopping_list/app.dart';
import 'package:shopping_list/authentication/authenticator.dart';
// import 'package:shopping_list/authentication/notify_email_sent.dart';
import 'package:shopping_list/authentication/screens/create_email_account_screen.dart';

class EmailSigninScreen extends StatefulWidget {
  static const id = 'EmailSigninScreen';

  @override
  _EmailSigninScreenState createState() => _EmailSigninScreenState();
}

class _EmailSigninScreenState extends State<EmailSigninScreen> {
  final GlobalKey<FormState> _emailSigninFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailErrorText;
  String? _passwordErrorText;

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
                        setState(() => _emailErrorText = null);
                      },
                      onFieldSubmitted: (value) => _signIn(context),
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
                          _passwordController.clear();
                        });
                      },
                      onFieldSubmitted: (value) => _signIn(context),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signIn(context),
              child: Text('Sign in'),
            ),
            Spacer(),
            TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                CreateEmailAccountScreen.id,
              ),
              child: Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn(BuildContext context) async {
    final result = await Authenticator.instance.signInWithEmail(
        email: _emailController.text, password: _passwordController.text);
    switch (result) {
      case 'success':
        final snackBar = SnackBar(
          content: Text('Logged in successfully'),
          behavior: SnackBarBehavior.fixed,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      case 'email-not-verified':
        await _notifyEmailNotVerified();
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
        var _otherErrorSnack = SnackBar(content: Text('There was a problem..'));
        ScaffoldMessenger.of(context).showSnackBar(_otherErrorSnack);
    }
  }

  Future<void> _notifyEmailNotVerified() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Email address has not been verified.\n'
              '\n'
              'Follow the link in the verification email that was sent to the '
              // 'address you provided (${App.instance.user!.email}), '
              'then try again.'),
          actions: [
            // TextButton(
            //   onPressed: () => notifyEmailSent(context),
            //   child: Text('Resend Verification Email'),
            // ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
