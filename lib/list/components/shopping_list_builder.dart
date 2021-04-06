import 'package:flutter/material.dart';

import 'package:grouped_list/grouped_list.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/list/components/aisle_header.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';
import 'package:shopping_list/list/item.dart';
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
    final list = Provider.of<ShoppingList>(context);
    return Expanded(
      child: GroupedListView<Map<String, dynamic>, String>(
        elements: list.items.values.toList(),
        groupBy: (item) => item['aisle'],
        groupSeparatorBuilder: (String groupByValue) =>
            AisleHeader(aisle: groupByValue),
        itemBuilder: (context, Map<String, dynamic> item) {
          if (!item['isComplete']) {
            return ChangeNotifierProvider<Item>(
              create: (_) => Item.fromJson(item),
              child: ShoppingListTile(key: Key(item['name'])),
            );
          } else {
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
  }
}
