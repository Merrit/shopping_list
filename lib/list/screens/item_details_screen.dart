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

  @override
  void initState() {
    super.initState();
    item = widget.item;
    selectedAisle = (item['aisle'] == 'Unsorted') ? null : item['aisle'];
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
          )
        ],
      ),
    );
  }
}
