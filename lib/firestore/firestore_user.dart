import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/globals.dart';

class FirestoreUser {
  final DocumentReference userDoc;

  FirestoreUser()
      : this.userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(Globals.user.uid);
}
