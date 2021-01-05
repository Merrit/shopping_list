import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';

class AislesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> _aisles =
        Provider.of<FirestoreUser>(context, listen: true).aisles;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Aisles'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddAisleDialog(),
                );
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: (_aisles != null)
            ? ListView.builder(
                itemCount: _aisles.length,
                itemBuilder: (context, int index) {
                  return AisleTile(aisle: _aisles[index]);
                },
              )
            : Container(),
      ),
    );
  }
}

class AisleTile extends StatelessWidget {
  const AisleTile({
    Key key,
    @required this.aisle,
  }) : super(key: key);

  final String aisle;

  @override
  Widget build(BuildContext context) {
    return (aisle != 'Unsorted')
        ? ListTile(
            title: Center(child: Text(aisle)),
            trailing: IconButton(
                icon: Icon(Icons.remove_circle),
                onPressed: () {
                  Provider.of<FirestoreUser>(context, listen: false)
                      .removeAisle(aisle: aisle);
                }),
          )
        : Container();
  }
}

class AddAisleDialog extends StatefulWidget {
  @override
  _AddAisleDialogState createState() => _AddAisleDialogState();
}

class _AddAisleDialogState extends State<AddAisleDialog> {
  TextEditingController aisleNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        autofocus: true,
        decoration: InputDecoration(hintText: 'Aisle name'),
        controller: aisleNameController,
        onFieldSubmitted: (value) => _addAisle(),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () => _addAisle(),
        )
      ],
    );
  }

  _addAisle() {
    setState(() {
      Provider.of<FirestoreUser>(context, listen: false)
          .addAisle(newAisle: aisleNameController.text);
      Navigator.pop(context);
    });
  }
}
