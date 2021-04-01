import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';

import 'package:shopping_list/helpers/capitalize_string.dart';

class NewListDialog extends StatefulWidget {
  @override
  _NewListDialogState createState() => _NewListDialogState();
}

class _NewListDialogState extends State<NewListDialog> {
  TextEditingController newListController = TextEditingController();
  String? newListErrorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Create new shopping list'),
            SizedBox(height: 20),
            TextFormField(
              controller: newListController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'List Name',
                errorText: newListErrorText,
              ),
              onFieldSubmitted: (listName) => _createList(listName),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _createList(newListController.text),
          child: Text('Confirm'),
        ),
      ],
    );
  }

  void _createList(String listName) {
    listName = listName.capitalizeFirstOfEach;
    if (listName == '') {
      setState(() {
        newListErrorText = 'Choose a list name';
      });
    } else {
      var firestoreUser = Provider.of<FirestoreUser>(context, listen: false);
      firestoreUser.createNewList(listName: listName);
      setState(() => Navigator.pop(context));
    }
  }
}
