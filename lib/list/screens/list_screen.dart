import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/components/circular_loading_widget.dart';
import 'package:shopping_list/database/list_manager.dart';
import 'package:shopping_list/list/components/add_item_dialog.dart';
import 'package:shopping_list/list/components/drawer.dart';
import 'package:shopping_list/list/components/floating_list_button_bar.dart';
import 'package:shopping_list/list/components/shopping_list_builder.dart';
import 'package:shopping_list/list/screens/list_details_screen.dart';
import 'package:shopping_list/list/shopping_list.dart';

/// The main app screen that contains the shopping list.
class ListScreen extends StatefulWidget {
  static const id = 'ListScreen';

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late final ShoppingList list;
  final listFuture = ListManager.instance.getCurrentList();
  final _log = Logger('ListScreen');

  _ListScreenState() {
    _log.info('Initialized');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: listFuture,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          final listSnapshot = snapshot.data!;
          final snapshotData = listSnapshot.data()!;
          return ChangeNotifierProvider<ShoppingList>(
            create: (_) => ShoppingList(
              listSnapshot: listSnapshot,
              snapshotData: snapshotData,
            ),
            builder: (context, child) {
              list = Provider.of<ShoppingList>(context, listen: false);
              return Shortcuts(
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
                              ShoppingListBuilder(),
                            ],
                          ),
                          FloatingListButtonBar(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return CircularLoadingWidget();
        }
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
        title: Consumer<ShoppingList>(builder: (context, list, child) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ListDetailsScreen(listID: list.name);
              }));
            },
            child: Text(list.name),
          );
        }),
        centerTitle: true);
  }

  /// Hotkeys
  final shortcuts = <LogicalKeySet, Intent>{
    LogicalKeySet(LogicalKeyboardKey.keyN): const NewItemIntent(),
  };

  /// Hotkey actions.
  ///
  /// [N] key opens [AddItemDialog].
  late final actions = <Type, Action<Intent>>{
    NewItemIntent: CallbackAction<NewItemIntent>(
      onInvoke: (NewItemIntent intent) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddItemDialog(list);
          },
        );
      },
    ),
  };
}

/// Part of the hotkeys.
class NewItemIntent extends Intent {
  const NewItemIntent();
}
