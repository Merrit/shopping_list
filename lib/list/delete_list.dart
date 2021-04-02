import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/screens/list_screen.dart';

/// Deletes a list document in Firebase.
void deleteList({required BuildContext context, required String listID}) {
  final user = Provider.of<FirestoreUser>(context, listen: false);

  user.deleteList(listID);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => ListScreen()),
  );
}
