import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

import '../../shopping_list.dart';

class AislesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Aisle')),
        body: AislesView(),
      ),
    );
  }
}

class AislesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemDetailsCubit = context.read<ItemDetailsCubit>();
    final shoppingListCubit = context.read<ShoppingListCubit>();

    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, shoppingListState) {
        return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
          builder: (context, itemDetailsState) {
            var _currentAisle = itemDetailsState.aisle;
            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return ListView(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final input = await InputDialog.show(
                            context: context,
                            initialValue: '',
                            title: 'Create aisle',
                            hintText: 'Aisle name',
                          );
                          if (input != null) {
                            shoppingListCubit.createAisle(name: input);
                          }
                        },
                        child: Text('Create aisle'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(child: Text('Long press to edit items')),
                    const SizedBox(height: 20),
                    for (var aisle in shoppingListState.aisles)
                      GestureDetector(
                        onLongPress: () async {
                          final colorBeforeDialog = aisle.color;
                          final confirmed = await ColorPicker(
                            // Current color is pre-selected.
                            color: Color(aisle.color),
                            onColorChanged: (Color color) => _updateColor(
                              aisle: aisle,
                              color: color,
                              shoppingListCubit: shoppingListCubit,
                            ),
                            heading: Text('Select color'),
                            subheading: Text('Select color shade'),
                            pickersEnabled: const <ColorPickerType, bool>{
                              ColorPickerType.primary: true,
                              ColorPickerType.accent: false,
                            },
                          ).showPickerDialog(context);
                          if (!confirmed) {
                            _updateColor(
                                color: Color(colorBeforeDialog),
                                aisle: aisle,
                                shoppingListCubit: shoppingListCubit);
                          }
                        },
                        child: RadioListTile<String>(
                          title: Row(
                            children: [
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
                            onPressed: () {
                              shoppingListCubit.deleteAisle(aisle: aisle);
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

  void _updateColor({
    required Color color,
    required Aisle aisle,
    required ShoppingListCubit shoppingListCubit,
  }) {
    shoppingListCubit.updateAisleColor(color: color.value, oldAisle: aisle);
  }
}
