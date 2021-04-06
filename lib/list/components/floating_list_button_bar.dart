import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/list/components/add_item_dialog.dart';
import 'package:shopping_list/list/shopping_list.dart';

class FloatingListButtonBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = Provider.of<ShoppingList>(context, listen: false);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer<ShoppingList>(builder: (context, list, widget) {
              if (list.containsCompletedItems()) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: FloatingActionButton(
                    heroTag: null,
                    backgroundColor: Colors.yellow[800],
                    onPressed: null,
                    // onPressed: () => items.completeItems(firestoreUser),
                    child: Icon(Icons.clear_all),
                  ),
                );
              }
              return Container(height: 0);
            }),
            Consumer<ShoppingList>(builder: (context, list, widget) {
              if (list.containsCompletedItems()) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: FloatingActionButton(
                    heroTag: null,
                    backgroundColor: Colors.blue,
                    onPressed: () => print('pressed'),
                    // onPressed: () {
                    //   Navigator.push(context, MaterialPageRoute(
                    //     builder: (context) {
                    //       return CompletedItemsScreen();
                    //     },
                    //   ));
                    // },
                    child: Icon(Icons.done_all),
                  ),
                );
              }
              return Container(height: 0);
            }),
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
    );
  }
}
