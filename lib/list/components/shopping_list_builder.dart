import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/aisle_header.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';
import 'package:shopping_list/list/screens/list_items.dart';

/// Displays a loading indicator until the list stream is active.
/// Once active returns the list view.
class ShoppingListBuilder extends StatelessWidget {
  ShoppingListBuilder(BuildContext context)
      : firestoreUser = Provider.of(context, listen: false);

  final FirestoreUser firestoreUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firestoreUser.listStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return Text('Something went wrong');

        if (snapshot.connectionState == ConnectionState.active) {
          // Actual shopping list.
          final listData = snapshot.data!.data()!;
          return _ShoppingGroupedListView(context, listData);
        }

        // Default while loading.
        return Expanded(
          child: Column(
            children: [
              Spacer(),
              CircularProgressIndicator(),
              Spacer(flex: 4),
            ],
          ),
        );
      },
    );
  }
}

/// Returns a grouped list view of the list's items.
class _ShoppingGroupedListView extends StatelessWidget {
  _ShoppingGroupedListView(BuildContext context, this.listData)
      : listItemState = Provider.of<ListItems>(context, listen: false) {
    // Ensure we have fresh state if list changed.
    listItemState.reset();
    // Create a list of items that GroupedListView can work with.
    if (listData['items'] != null) {
      listData['items'].forEach((key, value) {
        listItems.add(value);
      });
    }
  }

  final ListItems listItemState;
  final Map<String, dynamic> listData;
  final List<Map<String, dynamic>> listItems = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GroupedListView<dynamic, String>(
        elements: listItems,
        groupBy: (item) => item['aisle'],
        groupSeparatorBuilder: (String groupByValue) =>
            AisleHeader(aisle: groupByValue),
        // ignore: missing_return
        itemBuilder: (context, dynamic item) {
          var itemName = item['itemName'];
          // Track each item's completion state in ListItems.
          if (!listItemState.checkedItems.containsKey(itemName)) {
            listItemState.setItemState(
              itemName: itemName,
              isChecked: false,
            );
          }
          if (item['isComplete'] != true) {
            return ShoppingListTile(item: item);
          }
        },
        // separator: Divider(),
        // itemComparator: , // optional
        useStickyGroupSeparators: false, // optional
        floatingHeader: false, // optional
        order: GroupedListOrder.ASC, // optional
      ),
    );
  }
}
