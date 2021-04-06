import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/app.dart';

import 'package:shopping_list/authentication/screens/create_email_account_screen.dart';
import 'package:shopping_list/authentication/screens/email_signin_screen.dart';
import 'package:shopping_list/authentication/screens/signin_screen.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/screens/item_details_screen.dart';
import 'package:shopping_list/list/screens/list_screen.dart';
import 'package:shopping_list/loading_screen.dart';

void main() async {
  // Ensure setup is finished.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  initLogger();

  runApp(RestartWidget(child: ListApp()));
}

/// Initialize the logger.
///
/// The logger will listen and print any logs statements.
void initLogger() {
  Logger.root.onRecord.listen((record) {
    var msg = '${record.level.name}: ${record.time}: '
        '${record.loggerName}: ${record.message}';
    if (record.error != null) msg += '\nError: ${record.error}';
    print(msg);
  });
}

/// RestartWidget wraps everything, and its `restartApp` method allows us to
/// call a restart on the app easily with `RestartWidget.restartApp(context)`.
class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({required this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
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

class ListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<App>(create: (_) => App.instance),
        ChangeNotifierProvider<FirestoreUser>(
          create: (context) => FirestoreUser(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(centerTitle: true),
        ),
        routes: {
          SigninScreen.id: (context) => SigninScreen(),
          EmailSigninScreen.id: (context) => EmailSigninScreen(),
          CreateEmailAccountScreen.id: (context) => CreateEmailAccountScreen(),
          ListScreen.id: (context) => ListScreen(),
          LoadingScreen.id: (context) => LoadingScreen(),
          ItemDetailsScreen.id: (context) => ItemDetailsScreen(),
        },
        initialRoute: SigninScreen.id,
      ),
    );
  }
}
