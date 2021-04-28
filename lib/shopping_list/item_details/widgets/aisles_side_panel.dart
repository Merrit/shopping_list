import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';

import '../../shopping_list.dart';

class AisleSidePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, listState) {
        final shoppingCubit = context.read<ShoppingListCubit>();
        return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
          builder: (context, itemState) {
            final itemCubit = context.read<ItemDetailsCubit>();
            var _currentAisle = itemState.aisle;
            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return BlocProvider.value(
                              value: shoppingCubit,
                              child: _CreateAisleDialog(),
                            );
                          },
                        );
                        setState(() {});
                      },
                      child: Text('Create aisle'),
                    ),
                    for (var aisle in listState.aisles)
                      RadioListTile<String>(
                        title: Text(aisle.name),
                        value: aisle.name,
                        groupValue: _currentAisle,
                        onChanged: (String? value) {
                          setState(() => _currentAisle = value!);
                          itemCubit.updateAisle(value!);
                        },
                        secondary: IconButton(
                          onPressed: () {
                            shoppingCubit.deleteAisle(aisle: aisle);
                            itemCubit.updateAisle('None');
                            setState(() {});
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _CreateAisleDialog extends StatelessWidget {
  _CreateAisleDialog({
    Key? key,
  }) : super(key: key);

  late final ShoppingListCubit shoppingCubit;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    shoppingCubit = context.read<ShoppingListCubit>();
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Name'),
            onSubmitted: (_) => _createAisle(context),
          ),
          SizedBox(height: 20),
          AppIcon(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _createAisle(context),
          child: Text('Create'),
        ),
      ],
    );
  }

  void _createAisle(BuildContext context) {
    shoppingCubit.createAisle(name: _controller.value.text);
    Navigator.pop(context);
  }
}
