import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../shopping_list.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shoppingListCubit = context.read<ShoppingListCubit>();

    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final hasCheckedItems = (state.checkedItems.isNotEmpty);

        return Consumer<ActiveListState>(
          builder: (context, value, child) {
            return Visibility(
              visible: value.showFloatingButton,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FloatingActionButton(
                    onPressed: () async => (hasCheckedItems)
                        ? await shoppingListCubit.setCheckedItemsCompleted()
                        : await ActiveListView.showCreateItemDialog(
                            context: context),
                    backgroundColor: (hasCheckedItems) ? Colors.green : null,
                    child: Icon(
                      (hasCheckedItems) ? Icons.done_all : Icons.add,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
