import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/add_item_dialog.dart';
import 'package:shopping_list/list/screens/completed_items_screen.dart';
import 'package:shopping_list/list/screens/list_items.dart';

class FloatingListButtonBar extends StatelessWidget {
  FloatingListButtonBar(BuildContext context)
      : firestoreUser = Provider.of(context, listen: false);

  final FirestoreUser firestoreUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer<ListItems>(builder: (context, items, widget) {
              if (items.checkedItems.containsValue(true)) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: FloatingActionButton(
                    heroTag: null,
                    child: Icon(Icons.clear_all),
                    backgroundColor: Colors.yellow[800],
                    onPressed: () => items.completeItems(firestoreUser),
                  ),
                );
              }
              return Container(height: 0);
            }),
            Consumer<ListItems>(builder: (context, items, widget) {
              if (firestoreUser.completedItems.length > 0) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: FloatingActionButton(
                    heroTag: null,
                    child: Icon(Icons.done_all),
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return CompletedItemsScreen();
                        },
                      ));
                    },
                  ),
                );
              }
              return Container(height: 0);
            }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddItemDialog();
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
