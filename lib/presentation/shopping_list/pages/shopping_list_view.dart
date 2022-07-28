import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/home/cubit/home_cubit.dart';
import '../../../application/shopping_list/cubit/shopping_list_cubit.dart';
import '../../../domain/core/core.dart';
import '../../../infrastructure/shopping_list_repository/shopping_list_repository.dart';
import '../../core/core.dart';
import '../../home/home.dart';
import '../../item_details/pages/item_details_page.dart';
import '../widgets/aisle_group.dart';
import '../widgets/create_item_shortcut.dart';
import '../widgets/item_tile.dart';
import '../widgets/main_floating_button.dart';

late ShoppingListCubit shoppingListCubit;

class ShoppingListView extends StatelessWidget {
  const ShoppingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    shoppingListCubit = context.read<ShoppingListCubit>();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final haveActiveList = (state.currentListId != '');
        return (haveActiveList) ? const ActiveListView() : _NoActiveListView();
      },
    );
  }
}

class _NoActiveListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.currentListId == '') {
          // Show the drawer if there is no active list so that
          // the user can select or create a list.
          Scaffold.of(context).openDrawer();
        }
      },
      child: Container(),
    );
  }
}

class ActiveListView extends StatelessWidget {
  const ActiveListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreateItemShortcut(
      child: Stack(
        children: [
          ScrollingShoppingList(),
          const FloatingButton(
            floatingActionButton: MainFloatingButton(),
          ),
        ],
      ),
    );
  }

  static Future<void> showCreateItemDialog(
      {required BuildContext context}) async {
    bool customize = false;
    final shoppingListCubit = context.read<ShoppingListCubit>();

    final input = await showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController? _controller;

        return AlertDialog(
          title: const Text('New item'),
          content: Autocomplete<Item>(
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
              _controller = textEditingController;

              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                autofocus: platformIsWebMobile(context) ? false : true,
                onSubmitted: (_) => Navigator.pop(context, _controller?.text),
              );
            },
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') return [];

              return shoppingListCubit //
                  .state
                  .completedItems
                  .where((e) => e.name
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final Item item = options.toList()[index];

                        return Material(
                          child: ListTile(
                            title: Text(item.name),
                            onTap: () {
                              print('click!');
                              shoppingListCubit.updateItem(
                                oldItem: item,
                                newItem: item.copyWith(isComplete: false),
                              );
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    customize = true;
                    Navigator.pop(context, _controller?.text);
                  },
                  child: const Text('Customize'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, _controller?.text),
                  child: const Text('Create'),
                ),
              ],
            ),
          ],
        );
      },
    );
    if (input == null) return;
    final newItemName = input.capitalizeFirst;
    if (customize) {
      await goToItemDetails(
        context: context,
        item: Item(name: newItemName),
        creatingItem: true,
      );
    } else {
      await shoppingListCubit.createItem(name: newItemName);
    }
  }
}

class ScrollingShoppingList extends StatelessWidget {
  final _scrollController = ScrollController();

  ScrollingShoppingList({Key? key}) : super(key: key);

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
                    ? (constraints.maxWidth * 0.15)
                    : Insets.xsmall;

                final listViewPadding = EdgeInsets.only(
                  left: sidePadding,
                  right: sidePadding,
                  top: 40,
                  bottom: 100,
                );

                return Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: _isLargeFormFactor ? true : false,
                  child: (viewIsDense)
                      // Dense ListView.
                      ? ListView(
                          controller: _scrollController,
                          padding: listViewPadding,
                          children: shoppingListState.aisles
                              .where((aisle) => aisle.itemCount > 0)
                              .map((aisle) => AisleGroup(
                                    key: ValueKey(aisle),
                                    aisle: aisle,
                                  ))
                              .toList(),
                        )
                      // Spacious ListView.
                      : ListView.separated(
                          controller: _scrollController,
                          padding: listViewPadding,
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
      },
    );
  }
}

/// Function to navigate to details shared by AisleGroup & ItemTile.
Future<void> goToItemDetails({
  required BuildContext context,
  required Item item,
  bool creatingItem = false,
}) async {
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
  if (newItem == null) return;
  if (creatingItem) {
    await shoppingListCubit.createItemFromItem(newItem);
  } else {
    await shoppingListCubit.updateItem(oldItem: item, newItem: newItem);
  }
}
