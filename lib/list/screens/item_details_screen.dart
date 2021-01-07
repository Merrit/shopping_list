import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/screens/aisles_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  // final DocumentSnapshot document;

  ItemDetailsScreen({@required this.item});
  // ItemDetailsScreen({@required this.document});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  Map<String, dynamic> item;
  String selectedAisle;
  // DocumentReference document;

  @override
  void initState() {
    super.initState();
    // document = widget.document.reference;
    item = widget.item;
    selectedAisle = (item['aisle'] == 'Unsorted') ? null : item['aisle'];
    // selectedAisle = widget.document.data()['aisle'];
  }

  @override
  Widget build(BuildContext context) {
    FirestoreUser user = Provider.of<FirestoreUser>(context);

    return Scaffold(
      appBar: AppBar(title: Text(item['itemName']), centerTitle: true),
      body: Column(
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
                        // selectedAisle = value;
                        item['aisle'] = value;
                        Provider.of<FirestoreUser>(context, listen: false)
                            .updateAisle(item: item['itemName'], aisle: value);
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
                // child: DropdownButton<String>(
                //   hint: Text('Aisle (optional)'),
                //   value: selectedAisle,
                //   onChanged: (value) {
                //     setState(() {
                //       selectedAisle = value;
                //       item['aisle'] = value;
                //       Provider.of<FirestoreUser>(context, listen: false)
                //           .updateAisle(item: item['itemName'], aisle: value);
                //     });
                //   },
                //   items:
                //       user.aisles.map<DropdownMenuItem<String>>((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //       // onTap: () => aisle = value,
                //     );
                //   }).toList(),
                // ),
              ),
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
