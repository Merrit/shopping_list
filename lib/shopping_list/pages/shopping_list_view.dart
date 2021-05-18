import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/shopping_list/widgets/create_item_shortcut.dart';

import '../shopping_list.dart';

class ShoppingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final haveActiveList = (state.currentListId != '');
        final prefsInitialized = (state.prefs != null);
        if (haveActiveList && prefsInitialized) {
          return ActiveListView();
        } else {
          return _NoActiveListView();
        }
      },
    );
  }
}

class _NoActiveListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.currentListId == '') {
          // Show the drawer if there is no active list so that
          // the user can select or create a list.
          Scaffold.of(context).openDrawer();
        }
      },
      child: Container(),
    ));
  }
}

class CreateItemIntent extends Intent {
  const CreateItemIntent();
}

class ActiveListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActiveListState(),
      child: CreateItemShortcut(
        child: Stack(
          children: [
            ScrollingShoppingList(),
            FloatingButton(),
          ],
        ),
      ),
    );
  }

  static Future<void> showCreateItemDialog(
      {required BuildContext context}) async {
    final shoppingListCubit = context.read<ShoppingListCubit>();
    final input = await InputDialog.show(
      context: context,
      title: 'New item',
    );
    if ((input != null) && (input != '')) {
      await shoppingListCubit.createItem(name: input);
    }
  }
}

class ActiveListState extends ChangeNotifier {
  bool showFloatingButton = true;

  double _previousScrollOffset = 0.0;

  void updateFloatingButtonVisibility(double offset) {
    final oldShowBool = showFloatingButton;
    if (offset > _previousScrollOffset) {
      showFloatingButton = false;
    } else {
      showFloatingButton = true;
    }
    _previousScrollOffset = offset;
    if (oldShowBool != showFloatingButton) notifyListeners();
  }
}
