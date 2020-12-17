import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/globals.dart';
import 'package:shopping_list/list/components/drawer.dart';
import 'package:shopping_list/list/components/floating_add_list_item_button.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';
import 'package:shopping_list/list/create_new_list.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  bool isLoading = true;
  Future<bool> finishedLoading;
  CollectionReference listItems;
  ShoppingDrawer shoppingDrawer;

  @override
  void initState() {
    super.initState();
    // shoppingDrawer = ;
    listItems = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<FirestoreUser>(context, listen: false).userDoc.id)
        .collection('lists')
        .doc(Provider.of<FirestoreUser>(context, listen: false).currentListName)
        .collection('items');
    finishedLoading = _initFirebase();
  }

  Future<bool> _initFirebase() async {
    // await _initDrawer();
    // Provider.of<FirestoreUser>(context, listen: false).currentListName = '';

    // await setCurrentList();
    // isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Consumer<FirestoreUser>(builder: (context, user, child) {
            return Text(user.currentListName);
          }),
          centerTitle: true),
      drawer: ShoppingDrawer(callback: setCurrentList),
      body: StreamBuilder<QuerySnapshot>(
        stream: listItems.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
    // return FutureBuilder(
    //   future: finishedLoading,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return Scaffold(
    //         appBar: AppBar(
    //             title: Consumer<FirestoreUser>(builder: (context, user, child) {
    //               return Text(user.currentListName);
    //             }),
    //             centerTitle: true),
    //         drawer: ShoppingDrawer(callback: setCurrentList),
    //         body: StreamBuilder<QuerySnapshot>(
    //           stream: listItems.snapshots(),
    //           builder: (BuildContext context,
    //               AsyncSnapshot<QuerySnapshot> snapshot) {
    //             if (snapshot.hasError) {
    //               return Text('Something went wrong');
    //             }

    //             if (snapshot.connectionState == ConnectionState.waiting) {
    //               return Text('Loading');
    //             }

    //             return ListView(
    //               children: snapshot.data.docs.map((DocumentSnapshot document) {
    //                 return ShoppingListTile(document: document);
    //               }).toList(),
    //             );
    //           },
    //         ),
    //         floatingActionButton: FloatingAddListItemButton(),
    //       );
    //     }
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );
  }

  void setCurrentList() {
    setState(() {
      listItems = FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<FirestoreUser>(context, listen: false).userDoc.id)
          .collection('lists')
          .doc(Provider.of<FirestoreUser>(context, listen: false)
              .currentListName)
          .collection('items');
    });
  }
}
