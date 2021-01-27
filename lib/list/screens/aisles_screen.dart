import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/helpers/capitalize_string.dart';

class AislesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> _aisles =
        Provider.of<FirestoreUser>(context, listen: true).aisles;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Aisles'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: (_aisles != null)
            ? ListView.separated(
                itemCount: _aisles.length,
                itemBuilder: (context, int index) {
                  return AisleTile(aisle: _aisles[index]);
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddAisleDialog(),
          );
        },
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
    return ListTile(
      title: Center(child: Text(aisle)),
      onTap: () => Navigator.pop(context, aisle),
      onLongPress: () async {
        if (aisle == 'Unsorted') return; // TODO: Add message or something.
        var confirmed = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Delete list?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        );
        if (confirmed) {
          Provider.of<FirestoreUser>(context, listen: false)
              .removeAisle(aisle: aisle);
        }
      },
    );
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
          .addAisle(newAisle: aisleNameController.text.capitalizeFirstOfEach);
      Navigator.pop(context);
    });
  }
}
