import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shopping_list/helpers/capitalize_string.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/aisle.dart';

class AddItemDialog extends StatefulWidget {
  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final TextEditingController addItemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  FirestoreUser firestoreUser;
  String aisle = 'Unsorted';

  @override
  Widget build(BuildContext context) {
    firestoreUser = Provider.of<FirestoreUser>(context, listen: false);

    return AlertDialog(
      title: Text('Add item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Item Name'),
              controller: addItemController,
              autofocus: true,
              onFieldSubmitted: (value) => _addItem(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Quantity'),
              controller: quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onFieldSubmitted: (value) => _addItem(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SettingsTile(
              title: 'Aisle',
              subtitle: aisle,
              onPressed: (context) async {
                var _aisle = await setAisle(context);
                setState(() => aisle = _aisle);
              },
            ),
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
    String _aisle = aisle ?? 'Unsorted';
    var _quantity =
        (quantityController.text != '') ? quantityController.text : '1';
    Map<String, dynamic> item = {
      'itemName': addItemController.text.capitalizeFirst,
      'aisle': _aisle,
      'isComplete': false,
      'quantity': _quantity,
      'price': '0.00',
      'total': '0.00',
      'hasTax': false
    };
    firestoreUser.addListItem(item);
    Navigator.pop(context);
  }
}
