import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/globals.dart';
import 'package:shopping_list/list/components/drawer_provider.dart';
import 'package:shopping_list/list/components/new_list_dialog.dart';
import 'package:shopping_list/list/delete_list.dart';
import 'package:shopping_list/list/screens/list_details_screen.dart';
import 'package:shopping_list/main.dart';

class ShoppingDrawer extends StatefulWidget {
  @override
  _ShoppingDrawerState createState() => _ShoppingDrawerState();
}

class _ShoppingDrawerState extends State<ShoppingDrawer> {
  @override
  Widget build(BuildContext context) {
    FirestoreUser firestoreUser =
        Provider.of<FirestoreUser>(context, listen: false);
    String currentList = firestoreUser.currentListName;

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
            //     // For each item in lists we build a tile widget.
            // Continues to do so when new items have been added.
            return Expanded(
              child: ListView(
                shrinkWrap: true,
                children: user.lists.entries.map((list) {
                  return ListTile(
                    title: Center(child: Text(list.value['listName'])),
                    onTap: () {
                      Provider.of<FirestoreUser>(context, listen: false)
                          .currentList = list.key;
                      setState(() => Navigator.pop(context));
                    },
                    onLongPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ListDetailsScreen(listID: list.key)));
                    },
                  );
                }).toList(),
              ),
            );
            // return StreamBuilder<QuerySnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection('lists')
            //       .where('allowedUsers', arrayContains: Globals.user.uid)
            //       .snapshots(),
            //   // stream: user.userDoc.collection('lists').snapshots(),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       return Text('Something went wrong');
            //     }

            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Text('Loading');
            //     }
            //     // For each item in lists we build a tile widget.
            //     // Continues to do so when new items have been added.
            //     return Expanded(
            //       child: ListView(
            //         shrinkWrap: true,
            //         children:
            //             snapshot.data.docs.map((DocumentSnapshot document) {
            //           return ListTile(
            //             title: Center(child: Text(document['listName'])),
            //             trailing: drawer.editingLists
            //                 ? IconButton(
            //                     icon: Icon(
            //                       Icons.remove_circle,
            //                       color: Colors.red,
            //                     ),
            //                     onPressed: () {
            //                       showDialog(
            //                           context: context,
            //                           builder: (context) =>
            //                               ConfirmListDelete(
            //                                   listID: document.id));
            //                     })
            //                 : null,
            //             onTap: () {
            //               Provider.of<FirestoreUser>(context, listen: false)
            //                   .currentList = document.id;
            //               setState(() => Navigator.pop(context));
            //             },
            //           );
            //         }).toList(),
            //       ),
            //     );
            //   },
            // );
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
