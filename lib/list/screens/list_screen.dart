import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/aisle_header.dart';
import 'package:shopping_list/list/components/drawer.dart';
import 'package:shopping_list/list/components/floating_add_list_item_button.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';
import 'package:shopping_list/list/screens/list_details_screen.dart';

/// The main app screen that contains the shopping list.
class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    FirestoreUser firestoreUser = Provider.of<FirestoreUser>(context);

    return Scaffold(
      appBar: AppBar(
          title: Consumer<FirestoreUser>(builder: (context, user, child) {
            return GestureDetector(
              child: Text(user.currentListName),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ListDetailsScreen(listID: user.currentList)),
              ),
            );
          }),
          centerTitle: true),
      drawer: ShoppingDrawer(),
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
          StreamBuilder<DocumentSnapshot>(
            stream: firestoreUser.listStream,
            // ignore: missing_return
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading');
              }

              if (snapshot.connectionState == ConnectionState.active) {
                Map<String, dynamic> listData = snapshot.data.data();
                List<Map<String, dynamic>> listItems = [];
                if (listData['items'] != null) {
                  listData['items'].forEach((key, value) {
                    listItems.add(value);
                  });
                }

                return Expanded(
                  child: GroupedListView<dynamic, String>(
                    elements: listItems,
                    groupBy: (item) => item['aisle'],
                    groupSeparatorBuilder: (String groupByValue) =>
                        AisleHeader(aisle: groupByValue),
                    itemBuilder: (context, dynamic item) =>
                        ShoppingListTile(item: item),
                    // separator: Divider(),
                    // itemComparator: , // optional
                    useStickyGroupSeparators: false, // optional
                    floatingHeader: false, // optional
                    order: GroupedListOrder.ASC, // optional
                  ),
                );
              }
              return Container();
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
