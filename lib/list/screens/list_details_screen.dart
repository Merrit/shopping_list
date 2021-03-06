import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/delete_list.dart';
import 'package:shopping_list/list/share_list.dart';

class ListDetailsScreen extends StatefulWidget {
  final String listID;

  ListDetailsScreen({@required this.listID});

  @override
  _ListDetailsScreenState createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
  FirestoreUser firestoreUser;
  String listID;
  Map<String, dynamic> listInfo;
  String listName;

  @override
  void initState() {
    super.initState();
    firestoreUser = Provider.of<FirestoreUser>(context, listen: false);
    listID = widget.listID;
    listInfo = firestoreUser.lists[listID];
    listName = listInfo['listName'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listName),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<FirestoreUser>(
                builder: (context, user, widget) {
                  return SettingsTile(
                    children: [
                      Text('List Sharing'),
                      Text('Shared with:'),
                      Builder(builder: (context) {
                        List<Widget> sharedTiles = [];
                        Map<String, String> sharedWith;
                        try {
                          sharedWith = Map<String, String>.from(
                              user.lists[listID]['sharedWith']);
                        } catch (e) {}
                        // Don't care about the error because we check below.
                        if (sharedWith != null && sharedWith.length > 0) {
                          sharedWith.forEach((key, value) {
                            sharedTiles.add(Text(key));
                          });
                        }
                        return Column(children: sharedTiles);
                      }),
                      TextButton(
                        child: Text('Add person'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AddShareDialog());
                        },
                      ),
                    ],
                  );
                },
              ),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            ConfirmListDelete(listID: listID));
                  },
                  child: Text('Delete List'))
            ],
          ),
        ),
      ),
    );
  }
}

class AddShareDialog extends StatefulWidget {
  @override
  _AddShareDialogState createState() => _AddShareDialogState();
}

class _AddShareDialogState extends State<AddShareDialog> {
  TextEditingController _shareToEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        autofocus: true,
        controller: _shareToEmailController,
        decoration: InputDecoration(hintText: 'Email of user to share with'),
        onFieldSubmitted: (value) => shareList(context: context, email: value),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () =>
              shareList(context: context, email: _shareToEmailController.text),
        ),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final List<Widget> children;

  const SettingsTile({this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

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
          onPressed: () {
            deleteList(context: context, listID: listID);
          },
        ),
      ],
    );
  }
}
