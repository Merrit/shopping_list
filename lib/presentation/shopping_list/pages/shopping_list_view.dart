import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/application/home/cubit/home_cubit.dart';
import 'package:shopping_list/application/shopping_list/cubit/shopping_list_cubit.dart';
import 'package:shopping_list/domain/core/core.dart';
import 'package:shopping_list/presentation/core/core.dart';
import 'package:shopping_list/presentation/item_details/pages/item_details_page.dart';
import 'package:shopping_list/presentation/shopping_list/widgets/create_item_shortcut.dart';
import 'package:shopping_list/presentation/shopping_list/widgets/aisle_group.dart';
import 'package:shopping_list/presentation/shopping_list/widgets/item_tile.dart';
import 'package:shopping_list/presentation/shopping_list/widgets/main_floating_button.dart';
import 'package:shopping_list/repositories/shopping_list_repository/models/item.dart';

late ShoppingListCubit shoppingListCubit;

class ShoppingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    shoppingListCubit = context.read<ShoppingListCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final haveActiveList = (state.currentListId != '');
        return (haveActiveList) ? ActiveListView() : _NoActiveListView();
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

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, homeState) {
        final viewIsDense = homeState.shoppingViewMode == 'Dense';
        return BlocBuilder<ShoppingListCubit, ShoppingListState>(
          builder: (context, shoppingListState) {
            final items = shoppingListState.items
                .where((e) => e.isComplete == false)
                .toList();

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
                      top: 40,
                      bottom: 100,
                    ),
                    separatorBuilder: (context, index) {
                      if (viewIsDense) {
                        return const SizedBox(height: 20);
                      } else {
                        return const Divider(
                          indent: 20,
                          endIndent: 20,
                          height: 4,
                        );
                      }
                    },
                    itemCount: (viewIsDense)
                        ? shoppingListState.aisles.length
                        : items.length,
                    itemBuilder: (context, index) {
                      if (viewIsDense) {
                        return AisleGroup(index: index);
                      } else {
                        var item = items[index];
                        return ItemTile(item: item);
                      }
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Function to navigate to details shared by AisleGroup & ItemTile.
Future<void> goToItemDetails(BuildContext context, Item item) async {
  final homeCubit = context.read<HomeCubit>();
  final shoppingListCubit = context.read<ShoppingListCubit>();
  final newItem = await Navigator.push<Item>(
    context,
    MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: shoppingListCubit),
          BlocProvider.value(value: homeCubit),
        ],
        child: ItemDetailsPage(item: item),
      ),
    ),
  );
  if (newItem != null) {
    final cubit = context.read<ShoppingListCubit>();
    await cubit.updateItem(oldItem: item, newItem: newItem);
  }
}
