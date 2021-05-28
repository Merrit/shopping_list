import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/application/shopping_list/cubit/shopping_list_cubit.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/presentation/shopping_list/widgets/create_item_shortcut.dart';
import 'package:shopping_list/presentation/shopping_list/widgets/item_tile.dart';
import 'package:shopping_list/presentation/shopping_list/widgets/main_floating_button.dart';

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

class ScrollingShoppingList extends StatelessWidget {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _isLargeFormFactor = isLargeFormFactor(context);

    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final items = state.items.where((e) => e.isComplete == false).toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            double sidePadding = _isLargeFormFactor
                ? (constraints.maxWidth / 10)
                : Insets.xsmall;

            return Scrollbar(
              controller: _scrollController,
              isAlwaysShown: _isLargeFormFactor ? true : false,
              child: ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  left: sidePadding,
                  right: sidePadding,
                  top: 4,
                  bottom: 100,
                ),
                separatorBuilder: (context, index) {
                  return const Divider(
                    indent: 20,
                    endIndent: 20,
                    height: 4,
                  );
                },
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return ItemTile(item: item);
                },
              ),
            );
          },
        );
      },
    );
  }
}
