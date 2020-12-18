import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/create_new_list.dart';

class ShoppingDrawer extends StatefulWidget {
  // final Function setCurrentList;
  final List<Widget> drawerListWidgets;

  ShoppingDrawer({
    // @required Function callback,
    @required this.drawerListWidgets,
  });
  //  : this.setCurrentList = callback;

  @override
  _ShoppingDrawerState createState() => _ShoppingDrawerState();
}

class _ShoppingDrawerState extends State<ShoppingDrawer> {
  TextEditingController newListController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Text('My Shopping Lists'),
                RaisedButton(
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
                                          controller: newListController,
                                          onSubmitted: (listName) {
                                            createNewList(
                                                context: context,
                                                listName: listName);
                                            Provider.of<FirestoreUser>(context,
                                                    listen: false)
                                                .currentListName = listName;
                                            // widget.setCurrentList();
                                            setState(
                                                () => Navigator.pop(context));
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.check),
                                        onPressed: () {
                                          createNewList(
                                              context: context,
                                              listName: newListController.text);
                                          Provider.of<FirestoreUser>(context,
                                                      listen: false)
                                                  .currentListName =
                                              newListController.text;
                                          // widget.setCurrentList();
                                          setState(
                                              () => Navigator.pop(context));
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
                ),
              ],
            ),
          ),
          Expanded(child: ListView(children: widget.drawerListWidgets)),
          TextButton(
            child: Text('Sign out'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, 'signinScreen');
            },
          ),
        ],
      ),
    );
  }
}
