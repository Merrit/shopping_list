import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:grouped_list/grouped_list.dart';
import 'package:shopping_list/list/components/item_tile.dart';
import 'package:shopping_list/list/item.dart';
import 'package:shopping_list/list/list_collection.dart';
import 'package:shopping_list/main.dart';

final listCollection = ListCollection();

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  var listOfStores = []; // Add to seperate drawer widget
  var storeName = "";

  void addItem(String itemName) {
    var _item = Item(
      itemName: itemName,
      amount: 0,
      category: '',
    );
    // listCollection.lists
    // walmart.items.add(_item);
  }

  void initDrawer() {
    listCollection.lists.forEach((listName, list) {
      listOfStores.add(TextButton(
        child: Text(listName),
        onPressed: () {},
      ));
    });
  }

  @override
  void initState() {
    super.initState();
    initDrawer();
    listCollection.createNewList(listName: 'Walmart');
    // storeName = listCollection.
    // initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopping List"), centerTitle: true),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Text('My Shopping Lists'),
            ),
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
                                    child: TextField(onSubmitted: (value) {
                                      setState(() {
                                        listCollection.createNewList(
                                            listName: value);
                                      });
                                      Navigator.pop(context);
                                    }),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.check),
                                    onPressed: () {},
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
            TextButton(
              child: Text('Sign out'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                runApp(SigninApp());
              },
            ),
            Expanded(
              child: ListView(
                children: [],
              ),
            ),
          ],
        ),
      ),
      body: GroupedListView<dynamic, String>(
        elements: listCollection.lists['Walmart'].items,
        groupBy: (element) => element.category,
        groupComparator: (value1, value2) => value2.compareTo(value1),
        itemComparator: (item1, item2) =>
            item1.itemName.compareTo(item2.itemName),
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: false,
        groupSeparatorBuilder: (String value) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        itemBuilder: (c, product) {
          return ItemTile(item: product);
        },
      ),
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
                            addItem(value);
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
                              addItem(newItem);
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
}

class SomethingWentWrongScreen extends StatefulWidget {
  @override
  _SomethingWentWrongScreenState createState() =>
      _SomethingWentWrongScreenState();
}

class _SomethingWentWrongScreenState extends State<SomethingWentWrongScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('Something went wrong'),
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('Loading..'),
      ),
    );
  }
}
