import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shopping_list.dart';

class CreateItemButton extends StatelessWidget {
  const CreateItemButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShoppingListCubit>();
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final _controller = TextEditingController();
                    return AlertDialog(
                      title: Text('Create item'),
                      content: TextField(
                        controller: _controller,
                        autofocus: true,
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
            ),
          ),
        );
      },
    );
  }
}
