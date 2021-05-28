import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/application/shopping_list/cubit/shopping_list_cubit.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/presentation/shopping_list/widgets/main_floating_button.dart';

import '../../shopping_list.dart';

late ShoppingListCubit shoppingListCubit;

class ShoppingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    shoppingListCubit = context.read<ShoppingListCubit>();

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

class ActiveListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CreateItemShortcut(
      child: Stack(
        children: [
          ScrollingShoppingList(),
          FloatingButton(
            floatingActionButton: MainFloatingButton(),
          ),
        ],
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
      await shoppingListCubit.createItem(name: input.capitalizeFirst);
    }
  }
}
