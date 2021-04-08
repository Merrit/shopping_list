import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/list/item.dart';
import 'package:shopping_list/list/screens/item_details_screen.dart';
import 'package:shopping_list/list/screens/list_screen.dart';
import 'package:shopping_list/list/shopping_list.dart';
import 'package:shopping_list/list/state/checked_items.dart';

/// The tile that represents each item in the main list screen.
class ShoppingListTile extends StatefulWidget {
  ShoppingListTile({required Key key}) : super(key: key);

  @override
  _ShoppingListTileState createState() => _ShoppingListTileState();
}

class _ShoppingListTileState extends State<ShoppingListTile> {
  late final item = Provider.of<Item>(context, listen: false);
  late final list = Provider.of<ShoppingList>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 1),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, ItemDetailsScreen.id),
        child: Padding(
          padding: const EdgeInsets.only(left: 13), // Match CheckBox padding.
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Consumer<Item>(
                        builder: (context, item, child) {
                          return Text(item.name);
                        },
                      )),
                  Expanded(
                    flex: 1,
                    child: Consumer<Item>(
                      builder: (context, item, child) {
                        return (item.quantity != '1')
                            ? Text('${item.quantity}')
                            : Container();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Consumer<Item>(
                      builder: (context, item, child) {
                        return (item.price != '0.00')
                            ? Text('\$${item.price}')
                            : Container();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Consumer<Item>(
                      builder: (context, item, child) {
                        return (item.total != '0.00')
                            ? Text('\$${item.total}')
                            : Container();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Consumer<CheckedItems>(
                      builder: (context, items, widget) {
                        return Checkbox(
                          value: items.isItemChecked(item.name),
                          onChanged: (value) {
                            items.toggleCheckedStatus(item.name);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              _notesWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notesWidget() {
    return Consumer<Item>(
      builder: (context, item, child) {
        if (item.notes == '') {
          return Container();
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  item.notes,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
