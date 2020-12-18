import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/globals.dart';
import 'package:shopping_list/list/components/drawer.dart';
import 'package:shopping_list/list/components/floating_add_list_item_button.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';

/// The main app screen that contains the shopping list.
class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  /// listItems is what SteamBuilder listens to in order to build the list.
  // CollectionReference listItems;

  /// Buttons for each of the user's lists.
  List<Widget> drawerListWidgets = [];

  @override
  void initState() {
    super.initState();
    // var listName =
    //     Provider.of<FirestoreUser>(context, listen: false).currentListName;
    // switch (listName) {
    //   case '':
    //     var defaultList = 'Shopping List';
    //     _initFirebase(listName: defaultList);
    //     Provider.of<FirestoreUser>(context, listen: false).currentListName =
    //         defaultList;
    //     break;
    //   default:
    //     _initFirebase(listName: listName);
    // }
    _initDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Consumer<FirestoreUser>(builder: (context, user, child) {
            return Text(user.currentListName);
          }),
          centerTitle: true),
      drawer: ShoppingDrawer(
        // callback: setCurrentList,
        drawerListWidgets: drawerListWidgets,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Provider.of<FirestoreUser>(context).listItems.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }
          // For each item in listItems we build a tile widget.
          // Continues to do so when new items have been added.
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

  // void _initFirebase({@required String listName}) async {
  //   listItems = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(Provider.of<FirestoreUser>(context, listen: false).userDoc.id)
  //       .collection('lists')
  //       .doc(listName)
  //       .collection('items');
  // }

  Future<void> _initDrawer() async {
    // Find what lists exist.
    QuerySnapshot listsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(Globals.user.uid)
        .collection('lists')
        .get();
    // Create the list buttons for the Drawer.
    listsSnapshot.docs.forEach((doc) {
      drawerListWidgets.add(TextButton(
        child: Text(doc.id),
        onPressed: () {
          Provider.of<FirestoreUser>(context, listen: false).currentListName =
              doc.id;
          // setCurrentList();
          setState(() => Navigator.pop(context));
        },
      ));
    });
  }

  /// Switch to a new list.
  // void setCurrentList() {
  //   Provider.of<FirestoreUser>(context, listen: false).currentListName
  //   // setState(() {
  //   //   listItems = FirebaseFirestore.instance
  //   //       .collection('users')
  //   //       .doc(Provider.of<FirestoreUser>(context, listen: false).userDoc.id)
  //   //       .collection('lists')
  //   //       .doc(Provider.of<FirestoreUser>(context, listen: false)
  //   //           .currentListName)
  //   //       .collection('items');
  //   // });
  // }
}
