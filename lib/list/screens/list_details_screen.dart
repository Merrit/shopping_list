import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/globals.dart';

class ListDetailsScreen extends StatefulWidget {
  // final String listName;

  // ListDetailsScreen({@required this.listName});

  @override
  _ListDetailsScreenState createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
  String listName;

  @override
  void initState() {
    super.initState();
    listName =
        Provider.of<FirestoreUser>(context, listen: false).currentListName;
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
                builder: (context, firestoreUser, widget) {
                  return SettingsTile(
                    children: [
                      Text('List Sharing'),
                      Text('Shared with:'),
                      Builder(builder: (context) {
                        List<Widget> sharedTiles = [];
                        Map<String, String> sharedWith =
                            Map<String, String>.from(
                                firestoreUser.lists[firestoreUser.currentList]
                                    ['sharedWith']);
                        if (sharedWith != null && sharedWith.length > 0) {
                          sharedWith.forEach((key, value) {
                            sharedTiles.add(Text(key));
                          });
                        }
                        // snapshot.data.forEach((key, value) {
                        //   sharedTiles.add(ListTile(title: Text(key)));
                        // });
                        return Column(children: sharedTiles);
                      }),
                      // FutureBuilder(
                      //   future: firestoreUser.listSharedWith,
                      //   builder:
                      //       (context, AsyncSnapshot<List<String>> snapshot) {
                      //     if (!snapshot.hasData) {
                      //       return Container();
                      //     }
                      //     return (snapshot.data.length > 0)
                      //         ? Builder(builder: (context) {
                      //             List<Widget> sharedTiles = [];
                      //             snapshot.data.forEach((element) {});
                      //             // snapshot.data.forEach((key, value) {
                      //             //   sharedTiles.add(ListTile(title: Text(key)));
                      //             // });
                      //             return Column(children: sharedTiles);
                      //           })
                      //         : Text('Not shared');
                      //   },
                      // ),
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
        onFieldSubmitted: (value) => _shareList(context: context, email: value),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () =>
              _shareList(context: context, email: _shareToEmailController.text),
        ),
      ],
    );
  }
}

/// Check if the provided email is associated with an existing user account, if
/// yes then give that account permission to use this list.
Future<String> _shareList(
    {@required BuildContext context, @required String email}) async {
  // Check not current user
  String currentUserEmail = Globals.user.email;
  if ((currentUserEmail != null) && (email != currentUserEmail)) {
    FirestoreUser user = Provider.of<FirestoreUser>(context, listen: false);
    var allowedUsers = user.lists[user.currentList]['allowedUsers'];
    // List<String> foundAccounts;
    // try {
    //   foundAccounts =
    //       await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'invalid-email') return 'invalid-email';
    // }
    // if (foundAccounts.length == 1) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var query = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (query.docs.length == 1) {
      Map<String, dynamic> accountInfo = query.docs.first.data();
      var uid = accountInfo['uid'];
      firestore.collection('lists').doc(user.currentList).set(
        {
          'sharedWith': {email: uid},
          'allowedUsers': {uid: true},
        },
        SetOptions(merge: true),
      );
      return 'success';
    } else {
      return 'multiple-accounts';
    }

    // }

    // Provider.of<FirestoreUser>(context, listen: false)
    //     .currentListReference
    //     .update({'allowedUsers': email});
  }

  // List<String> myList =
  //     await FirebaseAuth.instance.;

  // var myquery = await FirebaseFirestore.instance
  //     .collection('users')
  //     .where('email', isEqualTo: email)
  //     .;
  var end = 'end';
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
