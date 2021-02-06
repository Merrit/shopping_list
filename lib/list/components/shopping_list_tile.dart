import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/screens/item_details_screen.dart';
import 'package:shopping_list/list/screens/list_items.dart';

/// The tile that represents each item in the main list screen.
class ShoppingListTile extends StatefulWidget {
  final Map<String, dynamic> item;

  ShoppingListTile({Key key, @required this.item}) : super(key: key);

  @override
  _ShoppingListTileState createState() => _ShoppingListTileState();
}

class _ShoppingListTileState extends State<ShoppingListTile> {
  FirestoreUser firestoreUser;
  Map<String, dynamic> item;
  String itemName;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    itemName = item['itemName'];
    firestoreUser = Provider.of<FirestoreUser>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 1),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailsScreen(item: item),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 3, child: Text(itemName)),
                  Expanded(
                    flex: 1,
                    child: (item['quantity'] != '1')
                        ? Text(item['quantity'].toString())
                        : Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: (item['price'] != '0.00')
                        ? Text('\$${item['price'].toString()}')
                        : Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: (item['total'] != '0.00')
                        ? Text('\$${item['total'].toString()}')
                        : Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Consumer<ListItems>(
                      builder: (context, listItems, widget) {
                        return Checkbox(
                          value: listItems.checkedItems[itemName],
                          onChanged: (value) {
                            listItems.setItemState(
                              itemName: itemName,
                              isChecked: value,
                              isUpdate: true,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
