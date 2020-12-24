import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/add_list_item.dart';
import 'package:shopping_list/list/screens/aisles_screen.dart';

class AddItemDialog extends StatefulWidget {
  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController addItemController = TextEditingController();
  String aisle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Item Name',
            ),
            controller: addItemController,
            autofocus: true,
            onFieldSubmitted: (value) => _addItem(),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Consumer<FirestoreUser>(
                builder: (context, user, widget) {
                  return DropdownButton(
                    hint: Text('Aisle (optional)'),
                    value: aisle,
                    onChanged: (value) {
                      setState(() {
                        aisle = value;
                      });
                    },
                    items: user.aisles
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                        // onTap: () => aisle = value,
                      );
                    }).toList(),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AislesScreen()),
                ),
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () => _addItem(),
        ),
      ],
    );
  }

  _addItem() {
    addListItem(
      context: context,
      itemName: addItemController.text,
      aisle: aisle,
    );
    Navigator.pop(context);
  }
}
