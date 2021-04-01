import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/authentication/components/email_sent_dialog.dart';
import 'package:shopping_list/globals.dart';

Future<void> notifyEmailSent(BuildContext context) async {
  final uid = Globals.user!.uid;
  await Globals.auth.currentUser!.sendEmailVerification();
  // Set the user Document.
  // We do so here so it doesn't happen at every sign in.
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'uid': uid,
    'email': Globals.user!.email,
  });
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => EmailSentDialog(),
  );
}
