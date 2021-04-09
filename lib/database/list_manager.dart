import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_list/app.dart';
import 'package:shopping_list/list/item.dart';

class ListManager {
  final _app = App.instance;
  final _uid = App.instance.user!.uid;

  ListManager._singleton();

  static final instance = ListManager._singleton();

  // DocumentReference get currentListReference {
  //   return FirebaseFirestore.instance.collection('lists').doc(currentList);
  // }

  Future<DocumentSnapshot> getCurrentList() {
    final currentListId = _app.currentListId;
    final Future<DocumentSnapshot> snapshot;
    if (currentListId != null) {
      snapshot = getListById(currentListId);
    } else {
      snapshot = getFirstList();
      _setCurrentListId(snapshot);
    }
    return snapshot;
  }

  void _setCurrentListId(Future<DocumentSnapshot> snapshot) async {
    _app.currentListId = await snapshot.then((value) => value.get('name'));
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

  void updateItems(List<Item> items, DocumentReference listReference) {
    if (items.isEmpty) {
      throw Exception('List of items to update must not be empty.');
    }
    final itemsMap = <String, dynamic>{};
    items.forEach((item) => itemsMap[item.name] = item.toJson());
    listReference.set({'items': itemsMap}, SetOptions(merge: true));
  }
}
