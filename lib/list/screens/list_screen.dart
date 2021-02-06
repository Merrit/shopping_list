import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/firestore/firestore_user.dart';
import 'package:shopping_list/list/components/add_item_dialog.dart';
import 'package:shopping_list/list/components/drawer.dart';
import 'package:shopping_list/list/components/floating_list_button_bar.dart';
import 'package:shopping_list/list/components/shopping_list_builder.dart';
import 'package:shopping_list/list/screens/list_details_screen.dart';
import 'package:shopping_list/list/screens/list_items.dart';

/// The main app screen that contains the shopping list.
class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  FocusNode hotkeyFocusNode = FocusNode();
  FirestoreUser firestoreUser;
  Map<String, dynamic> items;
  bool _isInitialized = false;
  bool mainListHasFocus = false;

  @override
  void didChangeDependencies() {
    _initFirestoreUser();
    _initHotkey();
    super.didChangeDependencies();
  }

  void _initFirestoreUser() {
    // Ensure we only initialize once.
    if (!_isInitialized) {
      firestoreUser = Provider.of<FirestoreUser>(context);
      if (firestoreUser.lists.length > 0) {
        items = firestoreUser.lists[firestoreUser.currentList]['items'];
        _isInitialized = true;
      }
    }
  }

  void _initHotkey() {
    // Start the Add Item ('N') hotkey.
    hotkeyFocusNode.addListener(() {
      setState(() => mainListHasFocus = hotkeyFocusNode.hasFocus);
    });
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
          appBar: _appBar(),
          drawer: ShoppingDrawer(),
          body: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (items != null && items.length > 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      // List header. TODO: Improve / fix / remove this..
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
                  ShoppingListBuilder(context),
                ],
              ),
              FloatingListButtonBar(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
        title: Consumer<FirestoreUser>(builder: (context, user, child) {
          return GestureDetector(
            child: Text(user.currentListName),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ListDetailsScreen(listID: user.currentList);
              }));
            },
          );
        }),
        centerTitle: true);
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
