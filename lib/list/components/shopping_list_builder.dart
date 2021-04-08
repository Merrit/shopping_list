import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/components/circular_loading_widget.dart';
import 'package:shopping_list/list/components/aisle_header.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';
import 'package:shopping_list/list/item.dart';
import 'package:shopping_list/list/state/list_items_state.dart';
import 'package:shopping_list/list/shopping_list.dart';

/// Displays a loading indicator until the list stream is active.
/// Once active returns the list view.
class ShoppingListBuilder extends StatelessWidget {
  final _log = Logger('ShoppingListBuilder');

  ShoppingListBuilder() {
    _log.info('Initialized');
  }

  @override
  Widget build(BuildContext context) {
    final listItemsState = Provider.of<ListItemsState>(context, listen: false);
    final list = Provider.of<ShoppingList>(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: list.listStream(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            var rawItemsData = snapshot.data!.get('items');
            var items = Map<String, Map<String, dynamic>>.from(rawItemsData);
            return Expanded(
              child: GroupedListView<Map<String, dynamic>, String>(
                elements: items.values.toList(),
                groupBy: (item) => item['aisle'],
                groupSeparatorBuilder: (String groupByValue) =>
                    AisleHeader(aisle: groupByValue),
                itemBuilder: (context, Map<String, dynamic> item) {
                  if (!item['isComplete']) {
                    return ChangeNotifierProvider<Item>(
                      create: (_) => Item.fromJson(item),
                      builder: (context, child) {
                        final item = Provider.of<Item>(context, listen: false);
                        item.parentList = list;
                        listItemsState.trackItem(item);
                        return ShoppingListTile(key: UniqueKey());
                      },
                    );
                  } else {
                    final completedItem = Item.fromJson(item);
                    completedItem.parentList = list;
                    listItemsState.trackItem(completedItem);
                    return Container();
                  }
                },
                // separator: Divider(),
                // itemComparator: , // optional
                useStickyGroupSeparators: false, // optional
                floatingHeader: false, // optional
                order: GroupedListOrder.ASC, // optional
              ),
            );
          } else {
            return CircularLoadingWidget();
          }
        });
  }
}
