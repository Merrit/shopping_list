import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shopping_list/components/advanced_text_field.dart';
import 'package:shopping_list/components/input_dialog.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/aisle.dart';
import 'package:shopping_list/preferences/preferences.dart';
import 'package:shopping_list/preferences/screens/preferences_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  static const id = 'item_details_screen';

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  FirestoreUser firestoreUser;
  bool wasUpdated = false;
  Map<String, dynamic>/*!*/ item;
  String selectedAisle;
  bool hasTax;
  String taxRate;
  String originalName;

  Widget titleWidget;
  Text _defaultTitleWidget;
  final titleController = TextEditingController();
  Widget titleTextField;

  @override
  void didChangeDependencies() {
    firestoreUser = Provider.of<FirestoreUser>(context, listen: false);
    item = ModalRoute.of(context).settings.arguments;
    hasTax = item['hasTax'] ?? false;
    selectedAisle = (item['aisle'] == 'Unsorted') ? null : item['aisle'];
    taxRate = _getTaxRate();
    _createTitleWidgets();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirestoreUser>(context);

    return WillPopScope(
      // When user returns to previous page, notify whether or not the item was
      // changed so we know if an update needs to be triggered.
      onWillPop: () async {
        _updateItem();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () => setState(() => titleWidget = titleTextField),
            child: titleWidget,
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
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
                      user.updateAisle(item: item['itemName'], aisle: _aisle);
                    },
                  ),
                  SettingsTile(
                    leading: Icon(Icons.add_shopping_cart),
                    title: 'Quantity',
                    subtitle: item['quantity'],
                    onPressed: (context) async {
                      final result = await showInputDialog(
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
                    leading: Icon(Icons.attach_money),
                    title: 'Price',
                    subtitle:
                        (item['price'] != '0.00') ? item['price'] : 'Not set',
                    onPressed: (context) async {
                      final result = await showInputDialog(
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
                  SettingsTile.switchTile(
                    leading: Icon(Icons.calculate_outlined),
                    title: 'Tax',
                    subtitle: taxRate,
                    switchValue: hasTax,
                    onToggle: (bool value) {
                      if (taxRate == 'Not set') {
                        _setTaxRate();
                      } else {
                        setState(() {
                          hasTax = value;
                          wasUpdated = true;
                        });
                      }
                    },
                  ),
                  SettingsTile(
                    leading: Icon(Icons.notes),
                    title: 'Notes',
                    subtitle: item['notes'] ?? '',
                    onPressed: (context) async {
                      final result = await showInputDialog(
                        type: InputDialogs.multiLine,
                        context: context,
                        title: 'Notes',
                        initialValue: item['notes'],
                      );
                      if (result != '') {
                        setState(() => item['notes'] = result);
                        wasUpdated = true;
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// If the user updated any fields, update the item data.
  void _updateItem() {
    item['hasTax'] = hasTax;
    // Update the total price for this item.
    if (wasUpdated) {
      final _quantity = int.tryParse(item['quantity']);
      final _price = double.tryParse(item['price']);
      var _taxRate = double.tryParse(Preferences.taxRate) ?? 0.00;
      var _total = (_quantity * _price);
      if (hasTax && _taxRate > 0.00) {
        _taxRate = _taxRate / 100;
        var _taxAmount = _total * _taxRate;
        _total = _total + _taxAmount;
      }
      item['total'] = _total.toStringAsFixed(2);
    }
    // Check if itemName was updated.
    if (originalName != null) {
      // Delete old item & create new item with new name.
      // Needed until the process of creating and handling items doesn't
      // rely on using the item name for the map name.
      firestoreUser.addListItem(item);
      firestoreUser.deleteItems(items: [originalName]);
    } else {
      // If itemName is unchanged just update the item.
      firestoreUser.updateItem(item);
    }
    // Now allow return to previous screen.
    Navigator.pop(context);
  }

  String _getTaxRate() {
    var taxRate = '${Preferences.taxRate}%';
    if (taxRate == '%') taxRate = 'Not set';
    return taxRate;
  }

  Future<void> _setTaxRate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PreferencesScreen()),
    );
    setState(() => taxRate = _getTaxRate());
  }

  void _createTitleWidgets() {
    _defaultTitleWidget = Text(item['itemName']);
    titleWidget = _defaultTitleWidget;
    titleTextField = AdvancedTextField(
      width: 300,
      initialValue: item['itemName'],
      callback: _titleWidgetCallback,
    );
  }

  void _titleWidgetCallback(String newName) {
    if (newName == '') {
      setState(() => titleWidget = _defaultTitleWidget);
    } else {
      originalName = item['itemName'];
      item['itemName'] = newName;
      _defaultTitleWidget = Text(newName);
      setState(() => titleWidget = _defaultTitleWidget);
      wasUpdated = true;
    }
  }
}
