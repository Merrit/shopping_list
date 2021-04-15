import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shopping_list/helpers/capitalize_string.dart';
import 'package:shopping_list/list/aisle.dart';
import 'package:shopping_list/list/item.dart';
import 'package:shopping_list/list/shopping_list.dart';

class AddItemDialog extends StatefulWidget {
  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final addItemController = TextEditingController();
  String aisle = 'Unsorted';
  final quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _addItem(),
          child: Text('Confirm'),
        ),
      ],
    );
  }

  void _addItem() {
    final list = Provider.of<ShoppingList>(context, listen: false);
    final _quantity =
        (quantityController.text != '') ? quantityController.text : '1';
    final item = Item(
      aisle: aisle,
      hasTax: false,
      isComplete: false,
      name: addItemController.text.capitalizeFirst,
      notes: '',
      price: '0.00',
      quantity: _quantity,
      total: '0.00',
    );
    list.createNewItem(item);
    Navigator.pop(context);
  }
}
