import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/app.dart';
import 'package:shopping_list/list/shopping_list.dart';

class ListManager {
  static final instance = ListManager._singleton();
  final List<ShoppingList> _lists = [];
  final _uid = App.instance.user.uid;

  ListManager._singleton();

  // Future<List<ShoppingList>> lists() async {
  //   await _getListsFromFirebase();
  //   firebaseHasLists = _firebaseListData.docs.isNotEmpty;
  //   await _buildListObjects();
  //   return _lists;
  // }

  Future<DocumentSnapshot> getCurrentList() {
    final currentList = App.instance.currentList;
    final Future<DocumentSnapshot> snapshot;
    if (currentList != null) {
      snapshot = getListById(currentList);
    } else {
      snapshot = getFirstList();
    }
    return snapshot;
  }

  Future<DocumentSnapshot> getListById(String id) async {
    final reference = FirebaseFirestore.instance.collection('lists').doc(id);
    final snapshot = await reference.snapshots().first;
    final listExists = snapshot.exists;
    if (listExists) {
      return snapshot;
    } else {
      return getFirstList();
    }
  }

  Future<DocumentSnapshot> getFirstList() async {
    final _lists = await lists().get();
    if (_lists.size == 0) {
      return await createList(listName: 'My Shopping List');
    } else {
      return _lists.docs.first.reference.snapshots().first;
    }
  }

  Query lists() => FirebaseFirestore.instance
      .collection('lists')
      .where('allowedUsers.$_uid', isEqualTo: true);

  // Future<void> _getListsFromFirebase() async {
  //   var lists = FirebaseFirestore.instance
  //     .collection('lists')
  //     .where('allowedUsers.${App.instance.user.uid}', isEqualTo: true);
  //     lists.
  //   // _firebaseListData = await FirebaseFirestore.instance
  //   //     .collection('lists')
  //   //     .where('allowedUsers.$_uid', isEqualTo: true)
  //   //     .get();
  //   //
  //   // var myTest =      FirebaseFirestore.instance
  //   // .collection('lists')
  //   // .where('allowedUsers.$_uid', isEqualTo: true).snapshots();
  //   // myTest.s
  // }

  // Future<void> _buildListObjects() async {
  //   if (firebaseHasLists) {
  //     _buildListFromFirebase();
  //   } else {
  //     await _buildListFromNew();
  //   }
  // }

  // void _buildListFromFirebase() {
  //   _firebaseListData.docs.
  //   _firebaseListData.docs.forEach((doc) {
  //     _lists.add(ShoppingList.fromJson(doc.data()!));
  //     doc.
  //   });
  // }

  Future<void> _buildListFromNew() async {
    // final newList = await createList(listName: 'My List');
    // _lists.add(newList);
  }

  /// Create a new list document in Firebase.
  Future<DocumentSnapshot> createList({required String listName}) async {
    final listMap = <String, dynamic>{
      'aisles': ['Unsorted'],
      'allowedUsers': {_uid: true},
      'items': {},
      'name': listName,
      'notes:': '',
      'owner': _uid,
    };
    final listReference = FirebaseFirestore.instance.collection('lists').doc();
    await listReference.set(
      listMap,
      SetOptions(merge: true),
    );
    final listSnapshot = listReference.snapshots().first;
    return listSnapshot;
  }
}
