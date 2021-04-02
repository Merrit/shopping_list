import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
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
  _ListScreenState() {
    _log.info('Initialized');
  }

  late FirestoreUser firestoreUser;
  Map<String, dynamic>? items;
  bool _isInitialized = false;
  final _log = Logger('ListScreen');

  @override
  void didChangeDependencies() {
    _initFirestoreUser();
    super.didChangeDependencies();
  }

  void _initFirestoreUser() {
    // Ensure we only initialize once.
    if (!_isInitialized) {
      firestoreUser = Provider.of<FirestoreUser>(context);
      if (firestoreUser.lists.isNotEmpty) {
        items = firestoreUser.lists[firestoreUser.currentList!]['items'];
        _isInitialized = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListItems(),
      child: Shortcuts(
        shortcuts: shortcuts,
        child: Actions(
          actions: actions,
          child: Focus(
            autofocus: true,
            child: Scaffold(
              appBar: _appBar(),
              drawer: ShoppingDrawer(),
              body: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (items != null && items!.isNotEmpty)
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
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
        title: Consumer<FirestoreUser>(builder: (context, user, child) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ListDetailsScreen(listID: user.currentList!);
              }));
            },
            child: Text(user.currentListName!),
          );
        }),
        centerTitle: true);
  }

  /// Hotkey actions.
  ///
  /// [N] key opens [AddItemDialog].
  late final actions = <Type, Action<Intent>>{
    NewItemIntent: CallbackAction<NewItemIntent>(
      onInvoke: (NewItemIntent intent) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddItemDialog();
          },
        );
      },
    ),
  };

  /// Hotkeys
  final shortcuts = <LogicalKeySet, Intent>{
    LogicalKeySet(LogicalKeyboardKey.keyN): const NewItemIntent(),
  };
}

/// Part of the hotkeys.
class NewItemIntent extends Intent {
  const NewItemIntent();
}
