import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';

/// Confirm user wishes to delete this list.
class ConfirmListDelete extends StatelessWidget {
  final String listID;

  ConfirmListDelete({@required this.listID});

  @override
  Widget build(BuildContext context) {
    FirestoreUser user = Provider.of<FirestoreUser>(context, listen: false);
    var _listName = user.lists[listID]['listName'];

    return AlertDialog(
      content: SingleChildScrollView(
        child: Text('Delete $_listName?'),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () => deleteList(context: context, listID: listID),
        ),
      ],
    );
  }
}

/// Deletes a list document in Firebase.
deleteList({@required BuildContext context, @required String listID}) {
  FirestoreUser user = Provider.of<FirestoreUser>(context, listen: false);
  user.deleteList(listID);
  // FirebaseFirestore.instance.collection('lists').doc(listID).delete();

  // user.lists.remove(listID);

  // // user.removeListName(listID);

  // if (user.currentList == listID) user.currentList = '';

  Navigator.pop(context);
}
