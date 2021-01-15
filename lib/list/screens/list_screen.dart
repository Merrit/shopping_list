import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/aisle_header.dart';
import 'package:shopping_list/list/components/drawer.dart';
import 'package:shopping_list/list/components/floating_add_list_item_button.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';
import 'package:shopping_list/list/screens/list_details_screen.dart';

/// The main app screen that contains the shopping list.
class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  FirestoreUser firestoreUser;
  Map<String, dynamic> items;
  bool _isInitialized = false;
  ListItems listItemState;

  @override
  void didChangeDependencies() {
    // Ensure we only initialize once.
    if (!_isInitialized) {
      firestoreUser = Provider.of<FirestoreUser>(context);
      items = firestoreUser.lists[firestoreUser.currentList]['items'];
      _isInitialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListItems(),
      child: Scaffold(
        appBar: AppBar(
            title: Consumer<FirestoreUser>(builder: (context, user, child) {
              return GestureDetector(
                child: Text(user.currentListName),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ListDetailsScreen(listID: user.currentList),
                  ),
                ),
              );
            }),
            centerTitle: true),
        drawer: ShoppingDrawer(),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (items != null && items.length > 0)
              Container(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 5,
                  bottom: 5,
                ),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: Text('Item')),
                    Expanded(flex: 1, child: Text('#')),
                    Expanded(flex: 1, child: Text('\$ ea.')),
                    Expanded(flex: 1, child: Text('\$ total')),
                    Expanded(flex: 1, child: Container()),
                  ],
                ),
              ),
            StreamBuilder<DocumentSnapshot>(
              stream: firestoreUser.listStream,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading');
                }

                if (snapshot.connectionState == ConnectionState.active) {
                  listItemState =
                      Provider.of<ListItems>(context, listen: false);
                  listItemState.reset();
                  Map<String, dynamic> listData = snapshot.data.data();
                  List<Map<String, dynamic>> listItems = [];
                  if (listData['items'] != null) {
                    listData['items'].forEach((key, value) {
                      listItems.add(value);
                    });
                  }

                  return Expanded(
                    child: GroupedListView<dynamic, String>(
                      elements: listItems,
                      groupBy: (item) => item['aisle'],
                      groupSeparatorBuilder: (String groupByValue) =>
                          AisleHeader(aisle: groupByValue),
                      itemBuilder: (context, dynamic item) {
                        var itemName = item['itemName'];
                        if (!listItemState.checkedItems.containsKey(itemName)) {
                          listItemState.setItemState(
                            itemName: itemName,
                            value: false,
                          );
                        }
                        return ShoppingListTile(item: item);
                      },
                      // separator: Divider(),
                      // itemComparator: , // optional
                      useStickyGroupSeparators: false, // optional
                      floatingHeader: false, // optional
                      order: GroupedListOrder.ASC, // optional
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
        floatingActionButton: (firestoreUser.currentListName == 'No lists yet')
            ? Container()
            : Consumer<ListItems>(
                builder: (context, items, widget) {
                  if (items.checkedItems.containsValue(true)) {
                    return FloatingClearItemsButton();
                  }
                  return FloatingAddListItemButton();
                },
              ),
      ),
    );
  }
}

/// Appears when one or more list items are checked.
///
/// When pressed sends checked items to Completed.
class FloatingClearItemsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.clear_all),
      backgroundColor: Colors.orange,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('test'),
            );
          },
        );
      },
    );
  }
}

/// Holds the state for the current list.
class ListItems extends ChangeNotifier {
  Map<String, bool> _checkedItems = {};

  /// List items are added here as Map<itemName, isChecked>.
  Map<String, bool> get checkedItems {
    return _checkedItems;
  }

  void setItemState(
      {@required String itemName,
      @required bool value,
      bool isUpdate = false}) {
    assert(itemName != null && value != null);
    _checkedItems[itemName] = value;
    if (isUpdate) notifyListeners();
  }

  void reset() => _checkedItems.clear();
}
