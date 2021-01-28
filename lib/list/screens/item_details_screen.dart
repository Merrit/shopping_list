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

  @override
  void initState() {
    super.initState();
    item = widget.item;
    hasTax = item['hasTax'] ?? false;
    selectedAisle = (item['aisle'] == 'Unsorted') ? null : item['aisle'];
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
                              var _newQuantity = (result == '0') ? '1' : result;
                              setState(() => item['quantity'] = _newQuantity);
                              wasUpdated = true;
                            }
                          },
                        ),
                        SettingsTile(
                          leading: Icon(Icons.add_shopping_cart),
                          title: 'Price',
                          subtitle: (item['price'] != '0.00')
                              ? item['price']
                              : 'Not set',
                          onPressed: (context) async {
                            String result = await showInputDialog(
                              context: context,
                              title: 'Price',
                              type: InputDialogs.onlyDouble,
                            );
                            if (result != '') {
                              setState(() => item['price'] = result);
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
