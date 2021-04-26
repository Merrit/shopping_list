import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/home/home.dart';

import '../shopping_list.dart';

class ShoppingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return (state.currentListId == '')
            ? _NoActiveListView()
            : _ScrollingShoppingList();
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

class _ScrollingShoppingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 8,
              ),
              children: _listWidgets(context, state),
            ),
            FloatingButton(),
          ],
        );
      },
    );
  }

  List<Widget> _listWidgets(BuildContext context, ShoppingListState state) {
    final displayList = <Widget>[];
    displayList.addAll(_activeItemWidgets(state));
    displayList.add(_completedItemWidgets(context, state));
    return displayList;
  }

  List<ItemTile> _activeItemWidgets(ShoppingListState state) {
    return state.activeItems().map((item) {
      return ItemTile(
        key: UniqueKey(),
        item: item,
      );
    }).toList();
  }

  Widget _completedItemWidgets(BuildContext context, ShoppingListState state) {
    final cubit = context.read<ShoppingListCubit>();
    final completedItems = <Widget>[];
    completedItems.addAll(state
        .completedItems()
        .map((item) => ItemTile.completed(
              key: UniqueKey(),
              item: item,
            ))
        .toList());
    if (completedItems.isNotEmpty) {
      completedItems.add(
        TextButton(
          onPressed: () => cubit.deleteCompletedItems(),
          child: Text('Delete all completed'),
        ),
      );
      return Theme(
        // Hide ExpansionTile's dividers.
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey<String>('completed_items'),
          title: Text(
            'Completed items',
            style: TextStyle(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          children: completedItems,
        ),
      );
    } else {
      return Container();
    }
  }
}
