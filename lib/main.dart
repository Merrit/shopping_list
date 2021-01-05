import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/authentication/screens/create_email_account_screen.dart';

import 'package:shopping_list/authentication/screens/email_signin_screen.dart';
import 'package:shopping_list/authentication/screens/signin_screen.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/list_screen.dart';
import 'package:shopping_list/globals.dart';
import 'package:shopping_list/loading_screen.dart';

void main() async {
  // Ensure setup is finished.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(RestartWidget(child: ListApp()));
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child);
  }
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
    return ChangeNotifierProvider(
      create: (context) => FirestoreUser(),
      // update: (_, __, ___) => FirestoreUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(centerTitle: true),
        ),
        routes: {
          Routes.signinScreen: (context) => SigninScreen(),
          Routes.signinEmailScreen: (context) => EmailSigninScreen(),
          Routes.createEmailAccountScreen: (context) =>
              CreateEmailAccountScreen(),
          Routes.listScreen: (context) => ListScreen(),
          Routes.loadingScreen: (context) => Loading(),
        },
        initialRoute: Routes.loadingScreen,
      ),
    );
  }
}
