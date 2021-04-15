import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/list/components/add_item_dialog.dart';
import 'package:shopping_list/list/state/checked_items.dart';
import 'package:shopping_list/list/state/list_items_state.dart';
import 'package:shopping_list/list/screens/completed_items_screen.dart';
import 'package:shopping_list/list/shopping_list.dart';

class FloatingListButtonBar extends StatelessWidget {
  final completedButtonFuture = Future.delayed(Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    final listItemsState = Provider.of<ListItemsState>(context, listen: false);
    final list = Provider.of<ShoppingList>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Stack(
        children: [
          // Completed items button.
          FutureBuilder(
              future: completedButtonFuture,
              builder: (context, snapshot) {
                if (context.watch<ListItemsState>().hasCompletedItems) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => Colors.grey,
                      )),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          CompletedItemsScreen.id,
                          arguments: list,
                        );
                      },
                      child: Text('Completed items'),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Mark completed button.
                Consumer<CheckedItems>(builder: (context, items, widget) {
                  if (items.containsCheckedItems) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: FloatingActionButton(
                        heroTag: null,
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          listItemsState.setItemsCompletion(
                            items.itemList,
                            true,
                          );
                        },
                        child: Icon(Icons.done_all),
                      ),
                    );
                  }
                  return Container(height: 0);
                }),
                // Add item button.
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ChangeNotifierProvider.value(
                            value: list,
                            child: AddItemDialog(),
                          );
                          // final currency = App.instance.currency;
                          // final cost = currency.parse('0.00', pattern: '0.00');
                          // print('cost: $cost');
                        },
                      );
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
