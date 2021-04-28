import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/shopping_list/item_details/item_details.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';
import 'package:shopping_list_repository/src/models/item.dart';

import '../shopping_list.dart';

class ShoppingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return (state.currentListId == '')
            ? _NoActiveListView()
            : _ActiveListView();
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

class _ActiveListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _ScrollingShoppingList(),
        FloatingButton(),
      ],
    );
  }
}

class _ScrollingShoppingList extends StatelessWidget {
  final wideHeaders = <String>[
    'Item',
    'Quantity',
    'Aisle',
    'Price each',
    'Price total',
  ];

  final narrowHeaders = <String>[
    'Items',
    '',
    '',
    '',
    '',
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShoppingListCubit>();
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var isWide = (constraints.maxWidth > 600);
            var headers = (isWide) ? wideHeaders : narrowHeaders;
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: (isWide) ? 0 : constraints.maxWidth,
                      ),
                      child: DataTable(
                        columnSpacing: (constraints.maxWidth > 600) ? null : 20,
                        onSelectAll: (_) => cubit.toggleAllItemsChecked(),
                        columns: headers
                            .map((header) => DataColumn(label: Text(header)))
                            .toList(),
                        rows: state.items
                            .where((element) => !element.isComplete)
                            .map(
                              (Item item) => DataRow(
                                selected: state.checkedItems.contains(item),
                                onSelectChanged: (_) {
                                  cubit.toggleItemChecked(item);
                                },
                                cells: [
                                  DataCell(
                                    Text(item.name),
                                    onTap: () =>
                                        _goToItemDetails(context, item),
                                  ),
                                  DataCell(
                                    Text(item.quantity),
                                    onTap: () =>
                                        _goToItemDetails(context, item),
                                  ),
                                  DataCell(
                                    Text(cubit.verifyAisle(aisle: item.aisle)),
                                    onTap: () =>
                                        _goToItemDetails(context, item),
                                  ),
                                  DataCell(
                                    Text(''),
                                    onTap: () =>
                                        _goToItemDetails(context, item),
                                  ),
                                  DataCell(
                                    Text(''),
                                    onTap: () =>
                                        _goToItemDetails(context, item),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    if (state.completedItems().isNotEmpty)
                      _CompletedItemsButton(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Future<void> _goToItemDetails(BuildContext context, Item item) async {
  final cubit = context.read<ShoppingListCubit>();
  final newItem = await Navigator.push<Item>(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: ItemDetailsPage(item: item),
      ),
    ),
  );
  if (newItem != null) {
    final cubit = context.read<ShoppingListCubit>();
    cubit.updateItem(oldItem: item, newItem: newItem);
  }
}

class _CompletedItemsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: OutlinedButton(
        onPressed: () => showSlideInSidePanel(
          context: context,
          child: BlocProvider.value(
            value: context.read<ShoppingListCubit>(),
            child: BlocBuilder<ShoppingListCubit, ShoppingListState>(
              builder: (context, state) {
                final cubit = context.read<ShoppingListCubit>();
                return StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return Column(
                      children: [
                        OutlinedButton(
                          onPressed: (state.completedItems().isNotEmpty)
                              ? () {
                                  cubit.deleteCompletedItems();
                                  setState(() {});
                                }
                              : null,
                          child: Text('Delete all completed'),
                        ),
                        Column(
                          children: state.items
                              .where((element) => element.isComplete)
                              .map((item) => ListTile(
                                    leading: Checkbox(
                                      value: true,
                                      onChanged: (_) {
                                        cubit.updateItem(
                                          oldItem: item,
                                          newItem:
                                              item.copyWith(isComplete: false),
                                        );
                                        setState(() {});
                                      },
                                    ),
                                    title: Text(item.name),
                                  ))
                              .toList(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
        child: Text(
          'Completed items',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
