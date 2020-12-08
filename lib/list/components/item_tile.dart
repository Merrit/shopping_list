import 'package:flutter/material.dart';
import 'package:shopping_list/list/item.dart';

class ItemTile extends StatefulWidget {
  final Item item;

  ItemTile({@required this.item});

  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  bool isChecked = false;
  TextDecoration productLineThrough = TextDecoration.none;
  TextStyle productTextStyle = TextStyle();
  String product = "";
  List<Widget> subList = [];

  @override
  void initState() {
    super.initState();
    productTextStyle = TextStyle(
      fontSize: 20,
      decoration: productLineThrough,
    );
    product = widget.item.itemName;
    // product = widget.product;
    if (widget.item.subItems.length > 0) {
      widget.item.subItems.forEach((subItem) {
        // subList.add(Text(subItem['product']));
        subList.add(
          ListTile(
            // contentPadding: EdgeInsets.only(left: 4, right: 50),
            // horizontalTitleGap: 4,
            leading: Text(subItem.item),
            title: Text(subItem.amount),
            trailing: Checkbox(
              value: false,
              onChanged: (value) {},
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.shopping_basket),
                Text(
                  product,
                  style: TextStyle(
                    fontSize: 20,
                    decoration: productLineThrough,
                  ),
                ),
                Text('2'),
                Text('\$6.49 ea.'),
                Text('\$12.98'),
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value;
                      if (value != null) {
                        productLineThrough = value
                            ? TextDecoration.lineThrough
                            : TextDecoration.none;
                      }
                    });
                  },
                ),
              ],
            ),
            Column(children: subList),
            // getSublistWidget(subList: subList),
          ],
        ),
        // child: ListTile(
        //   contentPadding:
        //       EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        //   leading: Icon(Icons.account_circle),
        //   title: Text(
        //     element['product'],
        //     style: TextStyle(fontSize: 20),
        //   ),
        //   subtitle: amount,
        //   trailing: Checkbox(
        //     value: false,
        //     onChanged: (bool newValue) {},
        //   ),
        // ),
      ),
    );
  }
}
