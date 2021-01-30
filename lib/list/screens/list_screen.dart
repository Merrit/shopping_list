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
  FirestoreUser firestoreUser;
  Map<String, dynamic> items;
  bool _isInitialized = false;
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
          body: Stack(
            children: [
              Column(
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
