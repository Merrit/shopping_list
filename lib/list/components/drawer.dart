import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/drawer_provider.dart';
import 'package:shopping_list/list/create_new_list.dart';
import 'package:shopping_list/list/delete_list.dart';
import 'package:shopping_list/main.dart';

class ShoppingDrawer extends StatefulWidget {
  @override
  _ShoppingDrawerState createState() => _ShoppingDrawerState();
}

class _ShoppingDrawerState extends State<ShoppingDrawer> {
  TextEditingController newListController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String currentList =
        Provider.of<FirestoreUser>(context, listen: false).currentListName;

    return Drawer(
      child: Consumer<DrawerProvider>(builder: (context, drawer, child) {
        return SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    Text('My Shopping Lists'),
                    (currentList == 'No lists yet')
                        ? Container(width: 0, height: 0)
                        : TextButton(
                            child: Text(drawer.editingLists ? 'Done' : 'Edit'),
                            onPressed: () {
                              drawer.editingLists = !drawer.editingLists;
                            },
                          ),
                    (drawer.editingLists || (currentList == 'No lists yet'))
                        ? RaisedButton(
                            child: Text('New List'),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Create a new shopping list'),
                                            Text('Name'),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        newListController,
                                                    onSubmitted: (listName) {
                                                      createNewList(
                                                          context: context,
                                                          listName: listName);
                                                      Provider.of<FirestoreUser>(
                                                                  context,
                                                                  listen: false)
                                                              .currentListName =
                                                          listName;
                                                      setState(() =>
                                                          Navigator.pop(
                                                              context));
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.check),
                                                  onPressed: () {
                                                    createNewList(
                                                        context: context,
                                                        listName:
                                                            newListController
                                                                .text);
                                                    Provider.of<FirestoreUser>(
                                                                context,
                                                                listen: false)
                                                            .currentListName =
                                                        newListController.text;
                                                    // widget.setCurrentList();
                                                    setState(() =>
                                                        Navigator.pop(context));
                                                  },
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
              Consumer<FirestoreUser>(builder: (context, user, child) {
                return StreamBuilder<QuerySnapshot>(
                  stream: user.userDoc.collection('lists').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading');
                    }
                    // For each item in lists we build a tile widget.
                    // Continues to do so when new items have been added.
                    return Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return ListTile(
                            title: Center(child: Text(document.id)),
                            trailing: drawer.editingLists
                                ? IconButton(
                                    icon: Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              ConfirmListDelete(
                                                  listName: document.id));
                                    })
                                : null,
                            onTap: () {
                              Provider.of<FirestoreUser>(context, listen: false)
                                  .currentListName = document.id;
                              setState(() => Navigator.pop(context));
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
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
        );
      }),
    );
  }
}
