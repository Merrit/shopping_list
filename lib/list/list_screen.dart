import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/drawer.dart';
import 'package:shopping_list/list/components/drawer_provider.dart';
import 'package:shopping_list/list/components/floating_add_list_item_button.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';

/// The main app screen that contains the shopping list.
class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Consumer<FirestoreUser>(builder: (context, user, child) {
            return Text(user.currentListName);
          }),
          centerTitle: true),
      drawer: ChangeNotifierProvider(
        create: (context) => DrawerProvider(),
        child: ShoppingDrawer(),
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
      floatingActionButton:
          Consumer<FirestoreUser>(builder: (context, user, child) {
        return (user.currentListName == 'No lists yet')
            ? Container()
            : FloatingAddListItemButton();
      }),
    );
  }
}
