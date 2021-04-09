import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/app.dart';

import 'package:shopping_list/authentication/screens/create_email_account_screen.dart';
import 'package:shopping_list/authentication/screens/email_signin_screen.dart';
import 'package:shopping_list/authentication/screens/signin_screen.dart';
import 'package:shopping_list/components/circular_loading_widget.dart';
import 'package:shopping_list/database/list_manager.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/screens/completed_items_screen.dart';
import 'package:shopping_list/list/screens/item_details_screen.dart';
import 'package:shopping_list/list/screens/list_screen.dart';
import 'package:shopping_list/list/shopping_list.dart';
import 'package:shopping_list/list/state/checked_items.dart';
import 'package:shopping_list/list/state/list_items_state.dart';
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
  final app = App.instance;
  // final Future<void> appInit = App.instance.init();
  final _log = Logger('ListApp');

  @override
  Widget build(BuildContext context) {
    if (app.user == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(centerTitle: true),
        ),
        routes: {
          CreateEmailAccountScreen.id: (context) => CreateEmailAccountScreen(),
          EmailSigninScreen.id: (context) => EmailSigninScreen(),
          SigninScreen.id: (context) => SigninScreen(),
        },
        initialRoute: SigninScreen.id,
      );
    } else {
      final futureListSnapshot = ListManager.instance.getCurrentList();
      return FutureBuilder<DocumentSnapshot>(
        future: futureListSnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _log.info('futureListSnapshot completed');
            final listSnapshot = snapshot.data!;
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<ShoppingList>(
                  create: (_) => ShoppingList(
                    listSnapshot: listSnapshot,
                    snapshotData: listSnapshot.data()!,
                  ),
                  lazy: false,
                ),
                ChangeNotifierProvider<CheckedItems>(
                  create: (_) => CheckedItems.instance,
                ),
                ChangeNotifierProvider<ListItemsState>(
                  create: (_) => ListItemsState.instance,
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  brightness: Brightness.dark,
                  appBarTheme: AppBarTheme(centerTitle: true),
                ),
                routes: {
                  CompletedItemsScreen.id: (context) => CompletedItemsScreen(),
                  ItemDetailsScreen.id: (context) => ItemDetailsScreen(),
                  ListScreen.id: (context) => ListScreen(),
                },
                initialRoute: ListScreen.id,
              ),
            );
          } else {
            return CircularLoadingWidget();
          }
        },
      );
    }
  }
}
