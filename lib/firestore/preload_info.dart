import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/globals.dart';

Future<void> preloadInfo() async {
  PreloadInfo.userDoc =
      FirebaseFirestore.instance.collection('users').doc(Globals.user.uid);

  await PreloadInfo.initDrawer();

  return null;
}
