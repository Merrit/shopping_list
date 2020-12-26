import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/screens/aisles_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final DocumentSnapshot document;

  ItemDetailsScreen({@required this.document});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  String selectedAisle;
  List<String> aisles;
  DocumentReference document;

  @override
  void initState() {
    super.initState();
    document = widget.document.reference;
    selectedAisle = widget.document.data()['aisle'];
    _setAisles();
  }

  /// Add the `Unsorted` pseudo-aisle without propogating it elsewhere.
  ///
  /// There is no reason for example it should show up when adding a new item,
  /// or when managing the user's lists.
  _setAisles() {
    aisles = Provider.of<FirestoreUser>(context, listen: false).aisles;
    if (!aisles.contains('Unsorted')) {
      aisles.add('Unsorted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.document.data()['itemName']), centerTitle: true),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                hint: Text('Aisle (optional)'),
                value: selectedAisle,
                onChanged: (value) {
                  setState(() {
                    selectedAisle = value;
                    document.update({'aisle': value});
                  });
                },
                items: aisles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                    // onTap: () => aisle = value,
                  );
                }).toList(),
              ),
              // Consumer<FirestoreUser>(
              //   builder: (context, user, widget) {
              //     return DropdownButton(
              //       hint: Text('Aisle (optional)'),
              //       value: selectedAisle,
              //       onChanged: (value) {
              //         setState(() {
              //           selectedAisle = value;
              //         });
              //       },
              //       items: user.aisles
              //           .map<DropdownMenuItem<String>>((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(value),
              //           // onTap: () => aisle = value,
              //         );
              //       }).toList(),
              //     );
              //   },
              // ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AislesScreen()),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
