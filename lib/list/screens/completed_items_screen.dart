import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/components/confirm_dialog.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';
import 'package:shopping_list/list/state/list_items_state.dart';
import 'package:shopping_list/list/screens/list_items.dart';

class CompletedItemsScreen extends StatefulWidget {
  static const id = 'completed_items_screen';

  @override
  _CompletedItemsScreenState createState() => _CompletedItemsScreenState();
}

class _CompletedItemsScreenState extends State<CompletedItemsScreen> {
  late final listItemsState = Provider.of<ListItemsState>(context);

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
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Spacer(),
            Consumer<ListItems>(
              builder: (context, listItems, widget) {
                return ElevatedButton(
                  onPressed: (listItems.checkedItems.containsValue(true))
                      ? _restoreItems
                      : null,
                  child: Text('Restore checked'),
                );
              },
            ),
            Spacer(),
            Consumer<ListItems>(
              builder: (context, listItems, widget) {
                return ElevatedButton(
                  onPressed: (listItems.checkedItems.containsValue(true))
                      ? () => _deleteItems(deleteAll: false)
                      : null,
                  child: Text('Delete checked'),
                );
              },
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

  /// If `deleteAll` is false, only delete checked items.
  void _deleteItems({bool deleteAll = false}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(content: 'Confirm: delete items?'),
    );
    if (confirmed == false) return;
    var firestoreUser = Provider.of<FirestoreUser>(context, listen: false);
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
    var firestoreUser = Provider.of<FirestoreUser>(context, listen: false);
    // listItems.restoreItems(firestoreUser);
  }
}
