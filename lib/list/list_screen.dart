import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/aisle_header.dart';
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: 5,
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('Item')),
                Expanded(flex: 1, child: Text('#')),
                Expanded(flex: 1, child: Text('\$ ea.')),
                Expanded(flex: 1, child: Text('\$ total')),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Provider.of<FirestoreUser>(context).listItems.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading');
              }

              return Expanded(
                child: GroupedListView<dynamic, String>(
                  elements: snapshot.data.docs,
                  groupBy: (document) => document.data()['aisle'],
                  groupSeparatorBuilder: (String groupByValue) =>
                      AisleHeader(aisle: groupByValue),
                  itemBuilder: (context, dynamic document) =>
                      ShoppingListTile(document: document),
                  // separator: Divider(),
                  // itemComparator: , // optional
                  useStickyGroupSeparators: false, // optional
                  floatingHeader: false, // optional
                  order: GroupedListOrder.ASC, // optional
                ),
              );
            },
          ),
        ],
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
