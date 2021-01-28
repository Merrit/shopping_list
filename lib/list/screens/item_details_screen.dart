import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shopping_list/components/input_dialog.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/aisle.dart';
import 'package:shopping_list/preferences/preferences.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  ItemDetailsScreen({@required this.item});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  bool wasUpdated = false;
  Map<String, dynamic> item;
  String selectedAisle;
  bool hasTax;

  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    item = widget.item;
    hasTax = item['hasTax'] ?? false;
    selectedAisle = (item['aisle'] == 'Unsorted') ? null : item['aisle'];
    priceController.text =
        (item['price'] != '0.00') ? item['price'].toString() : '';
  }

  @override
  Widget build(BuildContext context) {
    FirestoreUser user = Provider.of<FirestoreUser>(context);

    return WillPopScope(
      // When user returns to previous page, notify whether or not the item was
      // changed so we know if an update needs to be triggered.
      onWillPop: () async {
        _updateItem();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(item['itemName']), centerTitle: true),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: SettingsList(
                  darkBackgroundColor: Colors.grey[850],
                  sections: [
                    SettingsSection(
                      tiles: [
                        SettingsTile(
                          title: 'Aisle',
                          leading: Icon(Icons.shopping_cart_outlined),
                          subtitle: item['aisle'],
                          onPressed: (context) async {
                            var _aisle = await setAisle(context);
                            setState(() => item['aisle'] = _aisle);
                            user.updateAisle(
                                item: item['itemName'], aisle: _aisle);
                          },
                        ),
                        SettingsTile(
                          leading: Icon(Icons.add_shopping_cart),
                          title: 'Quantity',
                          subtitle: item['quantity'],
                          onPressed: (context) async {
                            String result = await showInputDialog(
                              context: context,
                              title: 'Quantity',
                              type: InputDialogs.onlyInt,
                            );
                            if (result != '') {
                              setState(() => item['quantity'] = result);
                              wasUpdated = true;
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => wasUpdated = true,
                  // Only allow entry numbers in double format.
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  decoration: InputDecoration(labelText: 'Price'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Text('Tax'),
                    Checkbox(
                      value: hasTax,
                      onChanged: (value) {
                        setState(() => hasTax = value);
                        item['hasTax'] = value;
                        wasUpdated = true;
                      },
                    ),
                  ],
                ),
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  /// If the user updated any fields, update the item data.
  void _updateItem() {
    // Check if price was updated and field is not empty.
    if (priceController.text != item['price'] && priceController.text != '') {
      var _price = double.tryParse(priceController.text.trim());
      item['price'] = _price.toStringAsFixed(2).toString();
    }
    // Update the total price for this item.
    if (wasUpdated) {
      int _quantity = int.tryParse(item['quantity']);
      double _price = double.tryParse(item['price']);
      double _taxRate = double.tryParse(Preferences.taxRate) ?? 0.00;
      double _total = (_quantity * _price);
      if (hasTax && _taxRate > 0.00) {
        _taxRate = _taxRate / 100;
        var _taxAmount = _total * _taxRate;
        _total = _total + _taxAmount;
      }
      item['total'] = _total.toStringAsFixed(2);
    }
    // Now allow return to previous screen.
    Navigator.pop(context, wasUpdated);
  }
}
