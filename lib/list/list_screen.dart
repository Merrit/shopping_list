import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/globals.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String currentListName = '';
  FirebaseFirestore _firestore;
  DocumentReference _thisUser;
  List listNames = [];
  List<Widget> drawerListWidgets = [];
  TextEditingController newListController = TextEditingController();
  DocumentReference _listRef;
  Future<bool> finishedLoading;
  CollectionReference listItems;
  // Future<QuerySnapshot> _listItems;
  // CollectionReference _listItems;

  @override
  void initState() {
    super.initState();
    finishedLoading = _initFirebase();
  }

  Future<bool> _initFirebase() async {
    _firestore = FirebaseFirestore.instance;
    _thisUser = _firestore.collection('users').doc(Globals.user.uid);
    await _initDrawer();
    currentListName = (listNames.length > 0) ? listNames[0] : '';
    await _setCurrentList();
    return true;
  }

  Future<void> _initDrawer() async {
    QuerySnapshot listsSnapshot = await _thisUser.collection('lists').get();
    listsSnapshot.docs.forEach((doc) {
      listNames.add(doc.id);
      drawerListWidgets.add(TextButton(
        child: Text(doc.id),
        onPressed: () {
          setState(() {
            currentListName = doc.id;
            _setCurrentList();
            Navigator.pop(context);
          });
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: finishedLoading,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text(currentListName), centerTitle: true),
            drawer: Drawer(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Column(
                      children: [
                        Text('My Shopping Lists'),
                        RaisedButton(
                          child: Text('New List'),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Create a new shopping list'),
                                          Text('Name'),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: newListController,
                                                  onSubmitted: (listName) =>
                                                      _createList(
                                                          listName: listName),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.check),
                                                onPressed: () => _createList(
                                                    listName:
                                                        newListController.text),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(children: drawerListWidgets),
                  ),
                  TextButton(
                    child: Text('Sign out'),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, 'signinScreen');
                    },
                  ),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: listItems.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading');
                }

                return ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return ShoppingListTile(document: document);
                  }).toList(),
                );
              },
            ),
            // body: FutureBuilder<QuerySnapshot>(
            //   future: _listItems,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       var _items = snapshot.data.docs;
            //       List<Widget> _itemWidgets = [];
            //       _items.forEach((item) {
            //         _itemWidgets.add(ListTile(title: Text(item['itemName'])));
            //       });
            //       var end = 'end';
            //       return ListView(
            //         children: _itemWidgets,
            //       );
            //     }

            //     return Container();
            //   },
            // ),
            // body: StreamBuilder<DocumentSnapshot>(
            //   stream: _listRef.snapshots(),
            //   builder: (context, stream) {
            //     if (stream.connectionState == ConnectionState.waiting) {
            //       return Center(child: CircularProgressIndicator());
            //     }

            //     if (stream.hasError) {
            //       return Center(child: Text(stream.error.toString()));
            //     }

            //     DocumentSnapshot _listRefSnapshot;

            //     _listRefSnapshot = stream.data.;
            //     // try {
            //     // } catch (e) {
            //     //   return Container();
            //     // }
            //     var item = _listRefSnapshot;
            //     print('listRef: ${item}');

            //     return ListView.builder(
            //       itemCount: 1,
            //       itemBuilder: (context, index) => ListTile(
            //         title: Text(_listRefSnapshot[index].toString()),
            //       ),
            //     );
            //   },
            // ),

            // body: GroupedListView<dynamic, String>(
            //   elements: listCollection.lists['Walmart'].items,
            //   groupBy: (element) => element.category,
            //   groupComparator: (value1, value2) => value2.compareTo(value1),
            //   itemComparator: (item1, item2) =>
            //       item1.itemName.compareTo(item2.itemName),
            //   order: GroupedListOrder.DESC,
            //   useStickyGroupSeparators: false,
            //   groupSeparatorBuilder: (String value) => Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Text(
            //       value,
            //       textAlign: TextAlign.center,
            //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            //   itemBuilder: (c, product) {
            //     return ItemTile(item: product);
            //   },
            // ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      var newItem = '';
                      return Dialog(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Add item', style: TextStyle(fontSize: 30)),
                              TextField(
                                autofocus: true,
                                onChanged: (value) {
                                  newItem = value;
                                },
                                onSubmitted: (value) {
                                  _newListItem(itemName: value);
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              Ink(
                                decoration: ShapeDecoration(
                                  color: Colors.blue,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: () {
                                    _newListItem(itemName: newItem);
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _createList({@required String listName}) {
    setState(() {
      _thisUser
          .collection('lists')
          .doc(listName)
          .set({'listName': listName}, SetOptions(merge: true));
      currentListName = listName;
      _setCurrentList();
      Navigator.pop(context);
    });
  }

  Future<void> _setCurrentList() {
    _listRef = _thisUser.collection('lists').doc(currentListName);
    listItems = FirebaseFirestore.instance
        .collection('users')
        .doc(_thisUser.id)
        .collection('lists')
        .doc(currentListName)
        .collection('items');
    // _listItems =
    //     _thisUser.collection('lists').doc(currentListName).collection('items');
    // _listItems = _thisUser
    //     .collection('lists')
    //     .doc(currentListName)
    //     .collection('items')
    //     .get();
    return null;
  }

  void _newListItem({@required String itemName}) {
    print('Adding $itemName');
    // setState(() {
    _thisUser.collection('lists').doc(currentListName).collection('items').add({
      'itemName': itemName,
    });
    // });
    // .collection('items')
    // .doc(itemName)
    // .set({'itemName': itemName}, SetOptions(merge: true));
  }
}

class ShoppingListTile extends StatelessWidget {
  final DocumentSnapshot document;

  ShoppingListTile({
    @required this.document,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(document.data()['itemName']),
      onTap: () {
        document.reference.delete();
        // Provider.of<FirestoreUser>(context, listen: false).userDoc.collection('lists').doc(document.)
      },
    );
  }
}
