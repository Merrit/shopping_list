import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/authentication/components/email_sent_dialog.dart';
import 'package:shopping_list/globals.dart';

notifyEmailSent(BuildContext context) async {
  String uid = Globals.user.uid;
  await Globals.auth.currentUser.sendEmailVerification();
  FirebaseFirestore.instance.collection('users').doc(uid).set({
    'uid': uid,
    'email': Globals.user.email,
  });
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => EmailSentDialog(),
  );
}
