import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/new_list_dialog.dart';
import 'package:shopping_list/list/screens/list_details_screen.dart';
// import 'package:shopping_list/main.dart';
import 'package:shopping_list/preferences/screens/preferences_screen.dart';

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
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return NewListDialog();
                        });
                  },
                  child: Text('New List'),
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
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Transform(
                  // Have the logout icon pointing left (away from app).
                  // Default is pointing right (towards app).
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(Icons.logout),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // RestartWidget.restartApp(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreferencesScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
