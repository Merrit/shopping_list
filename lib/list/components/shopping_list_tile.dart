import 'package:flutter/material.dart';
import 'package:shopping_list/list/screens/item_details_screen.dart';

/// The tile that represents each item in the main list screen.
class ShoppingListTile extends StatefulWidget {
  final Map<String, dynamic> item;

  ShoppingListTile({@required this.item});

  @override
  _ShoppingListTileState createState() => _ShoppingListTileState();
}

class _ShoppingListTileState extends State<ShoppingListTile> {
  Map<String, dynamic> item;
  String itemName;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    itemName = item['itemName'];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetailsScreen(item: item)));
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 3, child: Text(itemName)),
                Expanded(flex: 1, child: Text('')), // #
                Expanded(flex: 1, child: Text('')), // $
                Expanded(flex: 1, child: Text('')), // $ total
                Expanded(
                    flex: 1,
                    child: Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value;
                          });
                        })),
              ],
            )
          ],
        ),
      ),
    );
  }
}
