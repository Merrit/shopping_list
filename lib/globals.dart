import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Globals {
  static FirebaseAuth auth;
  static User user;
}

class Routes {
  static final String signinScreen = 'signinScreen';
  static final String signinEmailScreen = 'signinEmailScreen';
  static final String listScreen = 'listScreen';
  static final String createEmailAccountScreen = 'createEmailAccountScreen';
  static final String loadingScreen = 'loadingScreen';
}

class PreloadInfo {
  static DocumentReference userDoc;
  static List listNames = [];

  static Future<void> initDrawer() async {
    QuerySnapshot listsSnapshot = await userDoc.collection('lists').get();
    listsSnapshot.docs.forEach((doc) {
      listNames.add(doc.id);
      //   drawerListWidgets.add(TextButton(
      //     child: Text(doc.id),
      //     onPressed: () {
      //       Provider.of<FirestoreUser>(context, listen: false).currentListName =
      //           doc.id;
      //       setState(() => Navigator.pop(context));
      //     },
      //   ));
      // });
      // setState(() {
      //   listNames = listNames;
      // });
    });
    return null;
  }
}
