import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

import '../../shopping_list.dart';

// ignore: must_be_immutable
class AisleSidePanel extends StatelessWidget {
  late ItemDetailsCubit itemDetailsCubit;
  late ShoppingListCubit shoppingCubit;

  Future<void> _updateColor(Color color, Aisle aisle) async {
    await shoppingCubit.updateAisleColor(color: color.value, oldAisle: aisle);
  }

  @override
  Widget build(BuildContext context) {
    itemDetailsCubit = context.read<ItemDetailsCubit>();
    shoppingCubit = context.read<ShoppingListCubit>();

    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, shoppingListState) {
        return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
          builder: (context, itemDetailsState) {
            var _currentAisle = itemDetailsState.aisle;
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
                    const SizedBox(height: 20),
                    Text('Long press to edit items'),
                    const SizedBox(height: 20),
                    for (var aisle in shoppingListState.aisles)
                      GestureDetector(
                        onLongPress: () async {
                          final colorBeforeDialog = aisle.color;
                          final confirmed = await ColorPicker(
                            // Current color is pre-selected.
                            color: Color(aisle.color),
                            onColorChanged: (Color color) =>
                                _updateColor(color, aisle),
                            heading: Text('Select color'),
                            subheading: Text('Select color shade'),
                            pickersEnabled: const <ColorPickerType, bool>{
                              ColorPickerType.primary: true,
                              ColorPickerType.accent: false,
                            },
                          ).showPickerDialog(context);
                          if (!confirmed) {
                            await _updateColor(
                              Color(colorBeforeDialog),
                              aisle,
                            );
                          }
                        },
                        child: RadioListTile<String>(
                          title: Row(
                            children: [
                              Text(aisle.name),
                              SizedBox(width: 10),
                              Chip(
                                label: Text(aisle.name),
                                backgroundColor: Color(aisle.color),
                              ),
                            ],
                          ),
                          value: aisle.name,
                          groupValue: _currentAisle,
                          onChanged: (String? value) {
                            setState(() => _currentAisle = value!);
                            itemDetailsCubit.updateItem(aisle: value);
                          },
                          secondary: IconButton(
                            onPressed: () async {
                              await shoppingCubit.deleteAisle(aisle: aisle);
                              itemDetailsCubit.updateItem(aisle: 'None');
                              setState(() {});
                            },
                            icon: Icon(Icons.close),
                          ),
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

  Future<void> _createAisle(BuildContext context) async {
    await shoppingCubit.createAisle(name: _controller.value.text);
    Navigator.pop(context);
  }
}
