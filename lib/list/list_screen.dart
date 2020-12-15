import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/globals.dart';
import 'package:shopping_list/list/components/floating_add_list_item_button.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';
import 'package:shopping_list/list/create_new_list.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List listNames = [];
  List<Widget> drawerListWidgets = [];
  TextEditingController newListController = TextEditingController();
  Future<bool> finishedLoading;
  CollectionReference listItems;

  @override
  void initState() {
    super.initState();
    finishedLoading = _initFirebase();
  }

  Future<bool> _initFirebase() async {
    await _initDrawer();
    Provider.of<FirestoreUser>(context, listen: false).currentListName =
        (listNames.length > 0) ? listNames[0] : '';
    await setCurrentList();
    return true;
  }

  Future<void> _initDrawer() async {
    QuerySnapshot listsSnapshot =
        await Provider.of<FirestoreUser>(context, listen: false)
            .userDoc
            .collection('lists')
            .get();
    listsSnapshot.docs.forEach((doc) {
      listNames.add(doc.id);
      drawerListWidgets.add(TextButton(
        child: Text(doc.id),
        onPressed: () {
          Provider.of<FirestoreUser>(context, listen: false).currentListName =
              doc.id;
          setState(() => Navigator.pop(context));
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: finishedLoading,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
                title: Consumer<FirestoreUser>(builder: (context, user, child) {
                  return Text(user.currentListName);
                }),
                centerTitle: true),
            drawer: Drawer(
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
                                                    Provider.of<FirestoreUser>(
                                                                context,
                                                                listen: false)
                                                            .currentListName =
                                                        listName;
                                                    setCurrentList();

                                                    setState(() =>
                                                        Navigator.pop(context));
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
                                                  setCurrentList();
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
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(children: drawerListWidgets),
                  ),
                  TextButton(
                    child: Text('Sign out'),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, 'signinScreen');
                    },
                  ),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: listItems.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading');
                }

                return ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return ShoppingListTile(document: document);
                  }).toList(),
                );
              },
            ),
            floatingActionButton: FloatingAddListItemButton(),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> setCurrentList() {
    listItems = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<FirestoreUser>(context, listen: false).userDoc.id)
        .collection('lists')
        .doc(Provider.of<FirestoreUser>(context, listen: false).currentListName)
        .collection('items');
    return null;
  }
}
