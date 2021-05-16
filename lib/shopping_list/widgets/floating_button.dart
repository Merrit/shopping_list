import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/core/validators/validators.dart';

import '../shopping_list.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        return Consumer<ActiveListState>(
          builder: (context, value, child) {
            return Visibility(
              visible: value.showFloatingButton,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: (state.checkedItems.isEmpty)
                      ? const _CreateItemButton()
                      : const _SetCompletedButton(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CreateItemButton extends StatelessWidget {
  const _CreateItemButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shouldAutofocus = platformIsWebMobile(context) ? false : true;
    final cubit = context.read<ShoppingListCubit>();
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final _controller = TextEditingController();
            return AlertDialog(
              title: Text('Create item'),
              content: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                autofocus: shouldAutofocus,
                onSubmitted: (_) {
                  cubit.createItem(name: _controller.value.text);
                  Navigator.pop(context);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    cubit.createItem(name: _controller.value.text);
                    Navigator.pop(context);
                  },
                  child: Text('Create'),
                )
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}

class _SetCompletedButton extends StatelessWidget {
  const _SetCompletedButton();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShoppingListCubit>();
    return FloatingActionButton(
      onPressed: () async => await cubit.setCheckedItemsCompleted(),
      backgroundColor: Colors.green,
      child: Icon(Icons.done_all),
    );
  }
}
