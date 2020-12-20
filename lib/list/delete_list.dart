import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';

/// Confirm user wishes to delete this list.
class ConfirmListDelete extends StatelessWidget {
  final String listName;

  ConfirmListDelete({@required this.listName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Text('Delete $listName?'),
      ),
      actions: [
        TextButton(
          child: Text('Confirm'),
          onPressed: () => deleteList(context: context, listName: listName),
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

/// Deletes a list document in Firebase.
deleteList({@required BuildContext context, @required String listName}) {
  Provider.of<FirestoreUser>(context, listen: false)
      .userDoc
      .collection('lists')
      .doc(listName)
      .delete();

  Provider.of<FirestoreUser>(context, listen: false).listNames.remove(listName);

  Provider.of<FirestoreUser>(context, listen: false).currentListName = '';

  Navigator.pop(context);
}
