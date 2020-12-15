import 'package:flutter/material.dart';
import 'package:shopping_list/list/add_list_item.dart';

class FloatingAddListItemButton extends StatefulWidget {
  @override
  _FloatingAddListItemButtonState createState() =>
      _FloatingAddListItemButtonState();
}

class _FloatingAddListItemButtonState extends State<FloatingAddListItemButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              var newItem = '';
              return Dialog(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Add item', style: TextStyle(fontSize: 30)),
                      TextField(
                        autofocus: true,
                        onChanged: (value) {
                          newItem = value;
                        },
                        onSubmitted: (value) {
                          addListItem(context: context, itemName: newItem);
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                      Ink(
                        decoration: ShapeDecoration(
                          color: Colors.blue,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            addListItem(context: context, itemName: newItem);
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
