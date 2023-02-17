import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/shopping_list/cubit/shopping_list_cubit.dart';

class MainFloatingButton extends StatelessWidget {
  const MainFloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final hasCheckedItems = (state.checkedItems.isNotEmpty);
        final shoppingListCubit = context.read<ShoppingListCubit>();

        return FloatingActionButton(
          onPressed: () async => (hasCheckedItems)
              ? await shoppingListCubit.setCheckedItemsCompleted()
              : shoppingListCubit.tiggerShowCreateItemDialog(),
          backgroundColor: (hasCheckedItems) ? Colors.green : null,
          child: Icon(
            (hasCheckedItems) ? Icons.done_all : Icons.add,
          ),
        );
      },
    );
  }
}
