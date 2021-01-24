import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/screens/aisles_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  ItemDetailsScreen({@required this.item});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  Map<String, dynamic> item;
  String selectedAisle;
  TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    item = widget.item;
    selectedAisle = (item['aisle'] == 'Unsorted') ? null : item['aisle'];
    quantityController.text =
        (item['quantity'] != '0') ? item['quantity'].toString() : null;
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
          padding: EdgeInsets.symmetric(horizontal: 120),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<FirestoreUser>(
                    builder: (context, firestoreUser, widget) {
                      return DropdownButton<String>(
                        hint: Text('Aisle (optional)'),
                        value: firestoreUser.lists[firestoreUser.currentList]
                            ['items'][item['itemName']]['aisle'],
                        onChanged: (value) {
                          setState(() {
                            item['aisle'] = value;
                            Provider.of<FirestoreUser>(context, listen: false)
                                .updateAisle(
                                    item: item['itemName'], aisle: value);
                          });
                        },
                        items: user.aisles
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: 'Quantity'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  // Only allow entry numbers in double format.
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  decoration: InputDecoration(labelText: 'Price'),
                ),
              ),
              Spacer(flex: 6),
            ],
          ),
        ),
      ),
    );
  }

  /// If the user updated any fields, update the item data.
  void _updateItem() {
    bool wasUpdated = false;
    // Check if quantity was updated and field is not empty.
    if (quantityController.text != item['quantity'] &&
        quantityController.text != '') {
      item['quantity'] = quantityController.text.trim();
      wasUpdated = true;
    }
    // Check if price was updated and field is not empty.
    if (priceController.text != item['price'] && priceController.text != '') {
      var _price = double.tryParse(priceController.text.trim());
      item['price'] = _price.toStringAsFixed(2).toString();
      wasUpdated = true;
    }
    // Update the total price for this item.
    if (wasUpdated) {
      int _quantity = int.tryParse(item['quantity']);
      double _price = double.tryParse(item['price']);
      double _total = _quantity * _price;
      item['total'] = _total.toStringAsFixed(2);
    }
    // Now allow return to previous screen.
    Navigator.pop(context, wasUpdated);
  }
}
