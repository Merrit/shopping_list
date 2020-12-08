import 'package:flutter/material.dart';
import 'package:shopping_list/firebase/firebase_auth.dart';
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
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SignInEmailDialog();
                        });
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

class SignInEmailDialog extends StatelessWidget {
  const SignInEmailDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        // height: 100,
        // width: 100,
        child: Column(
          children: [
            ElevatedButton(
              child: Text('Create account'),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) {
                      return CreateEmailAccountDialog();
                    });
              },
            ),
            Text('or'),
            Divider(
              thickness: 5,
              height: 100,
            ),
            Text('Sign in'),
            Text('email:'),
            TextField(),
            Text('password:'),
            TextField(),
            ElevatedButton(
              child: Text('Sign in'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CreateEmailAccountDialog extends StatelessWidget {
  String email = "";
  String password = '';
  String confirmedPassword = '';
  final String weakPasswordError = ''
      'The password provided is too weak.\n'
      'Password must be at least 6 characters long.';
  final String alreadyExistsError = ''
      'The account already exists for that email.\n'
      'Please try signing in.';

  CreateEmailAccountDialog({
    Key key,
  }) : super(key: key);

  void _signUp({@required BuildContext context}) async {
    if (password == confirmedPassword) {
      var result = await createEmailAccount(email: email, password: password);
      switch (result) {
        case 'success':
          showDialog(
              context: context, builder: (context) => AccountCreatedMessage());
          break;
        case 'weak-password':
          _showErrorDialog(context: context, errorMessage: weakPasswordError);
          break;
        case 'email-already-in-use':
          _showErrorDialog(context: context, errorMessage: alreadyExistsError);
          break;
        default:
          var _msg = 'Unknown error.';
          _showErrorDialog(context: context, errorMessage: _msg);
      }
    } else {
      var _msg = 'Passwords do not match.';
      _showErrorDialog(context: context, errorMessage: _msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        // height: 100,
        // width: 100,
        child: Column(
          children: [
            Text('Create account'),
            Divider(
              thickness: 5,
              height: 100,
            ),
            Text('email:'),
            TextField(onChanged: (value) => email = value),
            Text('password:'),
            TextField(onChanged: (value) => password = value),
            Text('confirm password:'),
            TextField(onChanged: (value) => confirmedPassword = value),
            ElevatedButton(
              child: Text('Sign up'),
              onPressed: () => _signUp(context: context),
            ),
          ],
        ),
      ),
    );
  }
}

void _showErrorDialog(
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

class AccountCreatedMessage extends StatelessWidget {
  final _msg = '''Account created successfully.
      You will now be signed in.''';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text('Success'),
      content: Text(_msg),
      actions: [
        TextButton(
          child: Text('Ok'),
          onPressed: () {
            runApp(ListApp());
          },
        ),
      ],
    );
  }
}
