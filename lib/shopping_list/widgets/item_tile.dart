import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

import '../shopping_list.dart';

class ItemTile extends StatelessWidget {
  final Item item;

  final bool isCompleted;

  const ItemTile({
    Key? key,
    required this.item,
  })  : isCompleted = false,
        super(key: key);

  const ItemTile.completed({
    Key? key,
    required this.item,
  })  : isCompleted = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return (isCompleted)
        ? _CompletedItemTile(item: item)
        : _ActiveItemTile(item: item);
  }
}

class _ActiveItemTile extends StatelessWidget {
  final Item item;

  const _ActiveItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShoppingListCubit>();
    return Card(
      child: ListTile(
        title: Row(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            if (int.tryParse(item.quantity)! > 1)
              Flexible(
                child: Chip(
                  label: Text(item.quantity),
                  backgroundColor: Colors.blue,
                ),
              ),
            Flexible(child: Container()),
            Flexible(child: Container()),
            Flexible(child: Container()),
          ],
        ),
        // subtitle: Row(
        //   children: [
        //     if (int.tryParse(item.quantity)! > 1)
        //       Chip(
        //         label: Text(item.quantity),
        //         backgroundColor: Colors.blue,
        //       ),
        //   ],
        // ),
        trailing: BlocBuilder<ShoppingListCubit, ShoppingListState>(
          builder: (context, state) {
            return Checkbox(
              key: UniqueKey(),
              value: state.checkedItems.contains(item),
              onChanged: (value) => cubit.toggleItemChecked(item),
            );
          },
        ),
        onTap: () {
          _goToItemDetails(context);
        },
      ),
    );
  }

  Future<void> _goToItemDetails(BuildContext context) async {
    final newItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(item: item),
      ),
    );
    if (newItem != null) {
      final cubit = context.read<ShoppingListCubit>();
      cubit.updateItem(oldItem: item, newItem: newItem);
    }
  }
}

class _CompletedItemTile extends StatelessWidget {
  final Item item;

  const _CompletedItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShoppingListCubit>();
    return ListTile(
      title: Text(
        item.name,
        style: TextStyle(
          decoration: TextDecoration.lineThrough,
        ),
      ),
      enabled: false,
      trailing: Checkbox(
        value: true,
        onChanged: (_) => cubit.updateItem(
          oldItem: item,
          newItem: item.copyWith(isComplete: false),
        ),
      ),
    );
  }
}
