import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/globals.dart';

/// Check if the provided email is associated with an existing user account, if
/// yes then give that account permission to use this list.
// ignore: missing_return
Future<String> shareList(
    {required BuildContext context, required String email}) async {
  // Check not current user
  final currentUserEmail = Globals.user.email;
  if ((currentUserEmail != null) && (email != currentUserEmail)) {
    final user = Provider.of<FirestoreUser>(context, listen: false);
    final firestore = FirebaseFirestore.instance;
    var query = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (query.docs.length == 1) {
      final accountInfo = query.docs.first.data()!;
      var uid = accountInfo['uid'];
      await firestore.collection('lists').doc(user.currentList).set(
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
  }
}
