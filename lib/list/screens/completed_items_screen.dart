import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/components/confirm_dialog.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';
import 'package:shopping_list/list/screens/list_items.dart';

class CompletedItemsScreen extends StatefulWidget {
  @override
  _CompletedItemsScreenState createState() => _CompletedItemsScreenState();
}

class _CompletedItemsScreenState extends State<CompletedItemsScreen> {
  ListItems listItems;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListItems(),
      child: Builder(
        builder: (context) {
          listItems = Provider.of<ListItems>(context, listen: false);
          return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                  onPressed: () => _deleteItems(deleteAll: true),
                  child: Text('Delete all'),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount:
                  Provider.of<FirestoreUser>(context).completedItems.length,
              itemBuilder: (context, index) {
                var firestoreUser =
                    Provider.of<FirestoreUser>(context, listen: false);
                var currentList = firestoreUser.currentList;
                var item = firestoreUser.lists[currentList]['items']
                    [firestoreUser.completedItems.keys.toList()[index]];
                // Set the state for the tiles' checkboxes.
                listItems.setItemState(
                    itemName: item['itemName'], isChecked: false);
                return ShoppingListTile(key: Key(item['itemName']), item: item);
              },
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                children: [
                  Spacer(),
                  Consumer<ListItems>(
                    builder: (context, listItems, widget) {
                      return TextButton(
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
                      return TextButton(
                        onPressed: (listItems.checkedItems.containsValue(true))
                            ? () => _deleteItems(deleteAll: false)
                            : null,
                        child: Text('Delete checked'),
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// If `deleteAll` is false, only delete checked items.
  _deleteItems({bool deleteAll = false}) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(content: 'Confirm: delete items?'),
    );
    if (confirmed == false) return;
    var firestoreUser = Provider.of<FirestoreUser>(context, listen: false);
    listItems.deleteItems(
      firestoreUser,
      deleteAll: deleteAll,
    );
  }

  /// Restores all checked items to the main list.
  _restoreItems() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(content: 'Confirm: Restore items?'),
    );
    if (confirmed == false) return;
    var firestoreUser = Provider.of<FirestoreUser>(context, listen: false);
    listItems.restoreItems(firestoreUser);
  }
}
