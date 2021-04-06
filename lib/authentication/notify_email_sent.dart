import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/app.dart';
import 'package:shopping_list/authentication/components/email_sent_dialog.dart';

Future<void> notifyEmailSent(BuildContext context) async {
  final app = App.instance;
  final user = app.user;
  final uid = user.uid;
  await user.sendEmailVerification();
  // Set the user Document.
  // We do so here so it doesn't happen at every sign in.
  await FirebaseFirestore.instance.collection('users').doc(uid).set({
    'uid': uid,
    'email': user.email,
  });
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => EmailSentDialog(),
  );
}
