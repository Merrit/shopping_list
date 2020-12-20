import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/create_new_list.dart';

class NewListDialog extends StatefulWidget {
  @override
  _NewListDialogState createState() => _NewListDialogState();
}

class _NewListDialogState extends State<NewListDialog> {
  TextEditingController newListController = TextEditingController();
  String newListErrorText;

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
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () => _createList(newListController.text),
        ),
      ],
    );
  }

  _createList(String listName) {
    if (listName == '') {
      setState(() {
        newListErrorText = 'Choose a list name';
      });
    } else {
      createNewList(context: context, listName: listName);
      Provider.of<FirestoreUser>(context, listen: false).currentListName =
          listName;
      setState(() => Navigator.pop(context));
    }
  }
}
