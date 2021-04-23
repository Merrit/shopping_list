import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

import '../shopping_list.dart';

class ItemTile extends StatelessWidget {
  final Item item;

  const ItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShoppingListCubit>();
    return Card(
      child: ListTile(
        title: Text(
          item.name,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text(item.quantity),
              backgroundColor: Colors.blueGrey,
            ),
          ],
        ),
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
