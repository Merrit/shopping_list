import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../shopping_list.dart';

class MainFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final hasCheckedItems = (state.checkedItems.isNotEmpty);
        final shoppingListCubit = context.read<ShoppingListCubit>();

        return FloatingActionButton(
          onPressed: () async => (hasCheckedItems)
              ? await shoppingListCubit.setCheckedItemsCompleted()
              : await ActiveListView.showCreateItemDialog(context: context),
          backgroundColor: (hasCheckedItems) ? Colors.green : null,
          child: Icon(
            (hasCheckedItems) ? Icons.done_all : Icons.add,
          ),
        );
      },
    );
  }
}
