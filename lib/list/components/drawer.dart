import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/new_list_dialog.dart';
import 'package:shopping_list/list/screens/list_details_screen.dart';
import 'package:shopping_list/main.dart';

class ShoppingDrawer extends StatefulWidget {
  @override
  _ShoppingDrawerState createState() => _ShoppingDrawerState();
}

class _ShoppingDrawerState extends State<ShoppingDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                Text('My Shopping Lists'),
                RaisedButton(
                  child: Text('New List'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return NewListDialog();
                        });
                  },
                ),
              ],
            ),
          ),
          Consumer<FirestoreUser>(builder: (context, user, child) {
            // For each item in lists we build a tile widget.
            // Continues to do so when new items have been added.
            return Expanded(
              child: ListView(
                shrinkWrap: true,
                children: user.lists.entries.map((list) {
                  return ListTile(
                    title: Center(child: Text(list.value['listName'])),
                    onTap: () {
                      user.currentList = list.key;
                      setState(() => Navigator.pop(context));
                    },
                    onLongPress: () {
                      user.currentList = list.key;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListDetailsScreen(listID: list.key),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            );
          }),
          TextButton(
            child: Text('Sign out'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              RestartWidget.restartApp(context);
            },
          ),
        ],
      ),
    ));
  }
}
