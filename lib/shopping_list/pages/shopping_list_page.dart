// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/home/cubit/home_cubit.dart';
import '../../application/shopping_list/cubit/shopping_list_cubit.dart';
import '../../domain/core/core.dart';
import '../../presentation/core/core.dart';
import '../../presentation/home/home.dart';
import '../shopping_list.dart';

late ShoppingListCubit shoppingListCubit;

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    shoppingListCubit = context.read<ShoppingListCubit>();

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.currentListId == '') {
          // Show the drawer if there is no active list so that
          // the user can select or create a list.
          Scaffold.of(context).openDrawer();
        }
      },
      builder: (context, state) {
        return (state.currentListId == '')
            ? const SizedBox()
            : const ShoppingListView();
      },
    );
  }
}

class ShoppingListView extends StatelessWidget {
  const ShoppingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShoppingListCubit, ShoppingListState>(
      listener: (context, state) {
        if (state.showCreateItemDialog) showCreateItemDialog(context: context);
      },
      child: Stack(
        children: [
          ScrollingItemsWidget(),
          const FloatingButton(
            floatingActionButton: MainFloatingButton(),
          ),
        ],
      ),
    );
  }

  static Future<void> showCreateItemDialog(
      {required BuildContext context}) async {
    final navigator = Navigator.of(context);
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
        navigator: navigator,
        item: Item(name: newItemName),
        creatingItem: true,
      );
    } else {
      await shoppingListCubit.createItem(name: newItemName);
    }
  }
}

class ScrollingItemsWidget extends StatelessWidget {
  ScrollingItemsWidget({Key? key}) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _isLargeFormFactor = isLargeFormFactor(context);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, homeState) {
        return BlocBuilder<ShoppingListCubit, ShoppingListState>(
          builder: (context, shoppingListState) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final double sidePadding = _isLargeFormFactor
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
                  child: ListView(
                    controller: _scrollController,
                    padding: listViewPadding,
                    children: shoppingListState.aisles
                        .where((aisle) => aisle.itemCount > 0)
                        .map((aisle) => AisleGroup(
                              key: ValueKey(aisle),
                              aisle: aisle,
                            ))
                        .toList(),
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
  required NavigatorState navigator,
  required Item item,
  bool creatingItem = false,
}) async {
  final newItem = await navigator.push<Item>(
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

  // If there are no changes we don't do any update.
  if (newItem == null || newItem == item) return;
  if (creatingItem) {
    await shoppingListCubit.createItemFromItem(newItem);
  } else {
    await shoppingListCubit.updateItem(oldItem: item, newItem: newItem);
  }
}
