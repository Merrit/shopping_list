import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/app.dart';

import 'package:shopping_list/authentication/screens/signin_screen.dart';
import 'package:shopping_list/components/circular_loading_widget.dart';
import 'package:shopping_list/database/list_manager.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/screens/list_screen.dart';
import 'package:shopping_list/list/shopping_list.dart';

enum LoadingType {
  ListScreen,
  Unspecified,
}

class LoadingScreen extends StatefulWidget {
  static const id = 'LoadingScreen';
  final LoadingType? type;

  LoadingScreen([this.type = LoadingType.Unspecified]);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final listFuture = ListManager.instance.getCurrentList();
  final _log = Logger('LoadingScreen');

  _LoadingScreenState() {
    _log.info('Initialized');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == LoadingType.ListScreen) {
      return FutureBuilder<DocumentSnapshot>(
        future: listFuture,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final listSnapshot = snapshot.data!;
            final snapshotData = listSnapshot.data()!;
            return ChangeNotifierProvider<ShoppingList>(
              create: (_) => ShoppingList(
                listSnapshot: listSnapshot,
                snapshotData: snapshotData,
              ),
              // child: ListScreen(),
              // builder: (context, child) => ListScreen(),
            );
          } else {
            return CircularLoadingWidget();
          }
        },
      );
    } else {
      return Material(
        child: Center(
          child: Text('Wrong LoadingType: ${widget.type}'),
        ),
      );
    }
  }
// old auth widget
//
  // StreamBuilder<User?> _authenticationLoader() {
  //   return StreamBuilder<User?>(
  //     // Listen to the auth stream from Firebase.
  //     stream: FirebaseAuth.instance.authStateChanges(),
  //     builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
  //       // Wait for the stream to be active.
  //       if (snapshot.connectionState == ConnectionState.active) {
  //         // Check if there is a user.
  //         // If yes, start the app; if no, start the sign in screen.
  //         // On web this always comes up null, so we get to the sign in screen.
  //         if (FirebaseAuth.instance.currentUser != null) {
  //           // Preload initial data, and wait on the loading screen until
  //           // the preload is completed.
  //           final loadingComplete =
  //               Provider.of<FirestoreUser>(context, listen: false)
  //                   .setInitialData();
  //           return FutureBuilder(
  //             future: loadingComplete,
  //             builder: (context, snapshot) {
  //               if (snapshot.hasData) {
  //                 if (App.instance.user.emailVerified) {
  //                   return ListScreen();
  //                 } else {
  //                   return SigninScreen();
  //                 }
  //               }
  //               return _loadingScreen();
  //             },
  //           );
  //         } else {
  //           return SigninScreen();
  //         }
  //       }
  //       return CircularLoadingWidget();
  //     },
  //   );
  // }
}
