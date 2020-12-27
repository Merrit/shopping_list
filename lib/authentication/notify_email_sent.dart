import 'package:flutter/material.dart';
import 'package:shopping_list/authentication/components/email_sent_dialog.dart';
import 'package:shopping_list/globals.dart';

notifyEmailSent(BuildContext context) async {
  await Globals.auth.currentUser.sendEmailVerification();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => EmailSentDialog(),
  );
}
