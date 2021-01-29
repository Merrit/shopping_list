import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/add_item_dialog.dart';
import 'package:shopping_list/list/components/aisle_header.dart';
import 'package:shopping_list/list/components/drawer.dart';
import 'package:shopping_list/list/components/floating_add_list_item_button.dart';
import 'package:shopping_list/list/components/shopping_list_tile.dart';
import 'package:shopping_list/list/screens/completed_items_screen.dart';
import 'package:shopping_list/list/screens/list_details_screen.dart';
import 'package:shopping_list/list/screens/list_items.dart';

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
  FocusNode hotkeyFocusNode = FocusNode();
  bool mainListHasFocus = false;

  @override
  void didChangeDependencies() {
    // Ensure we only initialize once.
    if (!_isInitialized) {
      firestoreUser = Provider.of<FirestoreUser>(context);
      if (firestoreUser.lists.length > 0) {
        items = firestoreUser.lists[firestoreUser.currentList]['items'];
        _isInitialized = true;
      }
    }
    hotkeyFocusNode.addListener(() {
      setState(() => mainListHasFocus = hotkeyFocusNode.hasFocus);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListItems(),
      child: RawKeyboardListener(
        focusNode: hotkeyFocusNode,
        autofocus: true,
        onKey: (mainListHasFocus) ? (RawKeyEvent key) => _hotkey(key) : null,
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
                        // ignore: missing_return
                        itemBuilder: (context, dynamic item) {
                          var itemName = item['itemName'];
                          if (!listItemState.checkedItems
                              .containsKey(itemName)) {
                            listItemState.setItemState(
                              itemName: itemName,
                              isChecked: false,
                            );
                          }
                          if (item['isComplete'] != true) {
                            return ShoppingListTile(item: item);
                          }
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
          bottomNavigationBar: BottomAppBar(
            color: Colors.blueGrey,
            child: Row(
              children: [
                Spacer(flex: 5),
                Flexible(
                  flex: 1,
                  child: Consumer<ListItems>(
                    builder: (context, items, widget) {
                      if (items.checkedItems.containsValue(true)) {
                        return OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white,
                            side: BorderSide(color: Colors.white),
                          ),
                          onPressed: () => items.completeItems(firestoreUser),
                          child: Icon(Icons.clear_all),
                        );
                      }
                      if (firestoreUser.completedItems.length > 0) {
                        return IconButton(
                            icon: Icon(Icons.done_all, color: Colors.grey[400]),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CompletedItemsScreen()),
                              );
                            });
                      }
                      return Container(height: 0);
                    },
                  ),
                ),
                Spacer(flex: 1),
                IconButton(icon: Icon(Icons.more_vert), onPressed: null),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton:
              (firestoreUser.currentListName == 'No lists yet')
                  ? Container()
                  : FloatingAddListItemButton(),
        ),
      ),
    );
  }

  _hotkey(RawKeyEvent key) {
    if (key.character == 'n') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddItemDialog();
          });
    }
  }
}
