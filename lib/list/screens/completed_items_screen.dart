import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/components/confirm_dialog.dart';
import 'package:shopping_list/list/item.dart';
import 'package:shopping_list/list/shopping_list.dart';
import 'package:shopping_list/list/state/list_items_state.dart';

class CompletedItemsScreen extends StatefulWidget {
  static const id = 'completed_items_screen';

  @override
  _CompletedItemsScreenState createState() => _CompletedItemsScreenState();
}

class _CompletedItemsScreenState extends State<CompletedItemsScreen> {
  final List<String> checkedItems = [];
  // late final list = ModalRoute.of(context)!.settings.arguments as ShoppingList;
  late final ShoppingList list = context.read<ShoppingList>();
  late final ListItemsState listItemsState = context.watch<ListItemsState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: listItemsState.completedItems.length,
        itemBuilder: (context, index) {
          final item = listItemsState.completedItems[index];
          return ListTile(
            key: Key(item.name),
            title: Text(item.name),
            trailing: Checkbox(
              value: checkedItems.contains(item.name),
              onChanged: (value) {
                _toggleCheckbox(item);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Spacer(),
            ElevatedButton(
              // onPressed: null,
              onPressed: (checkedItems.isNotEmpty) ? _restoreItems : null,
              child: Text('Restore checked'),
            ),
            Spacer(),
            ElevatedButton(
              // onPressed: null,
              onPressed: (checkedItems.isNotEmpty)
                  ? () => _deleteItems(deleteAll: false)
                  : null,
              child: Text('Delete checked'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => _deleteItems(deleteAll: true),
              child: Text('Delete all'),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider.value(
  //     value: list,
  //     builder: (context, child) {
  //       return Scaffold(
  //         appBar: AppBar(),
  //         body: ListView.builder(
  //           itemCount: list.listItemsState.completedItems.length,
  //           itemBuilder: (context, index) {
  //             final item = list.listItemsState.completedItems[index];
  //             return ListTile(
  //               key: Key(item.name),
  //               title: Text(item.name),
  //               trailing: Checkbox(
  //                 value: checkedItems.contains(item.name),
  //                 onChanged: (value) {
  //                   _toggleCheckbox(item);
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //         bottomNavigationBar: BottomAppBar(
  //           child: Row(
  //             children: [
  //               Spacer(),
  //               ElevatedButton(
  //                 // onPressed: null,
  //                 onPressed: (checkedItems.isNotEmpty) ? _restoreItems : null,
  //                 child: Text('Restore checked'),
  //               ),
  //               Spacer(),
  //               ElevatedButton(
  //                 // onPressed: null,
  //                 onPressed: (checkedItems.isNotEmpty)
  //                     ? () => _deleteItems(deleteAll: false)
  //                     : null,
  //                 child: Text('Delete checked'),
  //               ),
  //               Spacer(),
  //               ElevatedButton(
  //                 onPressed: () => _deleteItems(deleteAll: true),
  //                 child: Text('Delete all'),
  //               ),
  //               Spacer(),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _toggleCheckbox(Item item) {
    setState(() {
      if (checkedItems.contains(item.name)) {
        checkedItems.remove(item.name);
      } else {
        checkedItems.add(item.name);
      }
    });
  }

  /// If `deleteAll` is false, only delete checked items.
  void _deleteItems({bool deleteAll = false}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(content: 'Confirm: delete items?'),
    );
    if (confirmed == false) return;
    // var firestoreUser = Provider.of<FirestoreUser>(context, listen: false);
    // listItems.deleteItems(
    //   firestoreUser,
    //   deleteAll: deleteAll,
    // );
  }

  /// Restores all checked items to the main list.
  Future<void> _restoreItems() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(content: 'Confirm: Restore items?'),
    );
    if (confirmed == false) return;
    final itemsToRestore = listItemsState.completedItems
        .where((item) => checkedItems.contains(item.name))
        .toList();
    assert(itemsToRestore.isNotEmpty);
    itemsToRestore.forEach((item) {
      // list.listItemsState.completedItems.removeWhere((element) {
      //   return element.name == item.name;
      // });
      item.isComplete = false;
    });
    listItemsState.setItemsCompletion(
        itemsToRestore.map((item) => item.name).toList(), false);
    // list.updateItems(itemsToRestore);
  }
}
