import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

import '../../shopping_list.dart';

class AislesPage extends StatelessWidget {
  static const id = 'aisles_page';

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
    final shoppingListCubit = context.read<ShoppingListCubit>();

    return Stack(
      children: [
        _AislesList(),
        CreateAisleButton(shoppingListCubit: shoppingListCubit),
      ],
    );
  }
}

class _AislesList extends StatelessWidget {
  const _AislesList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, shoppingListState) {
        return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
          builder: (context, itemDetailsState) {
            return ListView(
              padding: Insets.listViewWithFloatingButton,
              children: [
                ExpansionPanelList.radio(
                  children: [
                    ...shoppingListState.aisles
                        .map((aisle) => ExpansionPanelRadio(
                              value: aisle.name,
                              headerBuilder: (context, isExpanded) {
                                return AisleHeader(aisle: aisle);
                              },
                              body: (aisle.name == 'None')
                                  ? Container()
                                  : AisleExpandedBody(aisle: aisle),
                            ))
                        .toList(),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class AisleHeader extends StatelessWidget {
  final Aisle aisle;

  const AisleHeader({Key? key, required this.aisle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemDetailsCubit = context.read<ItemDetailsCubit>();

    return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
      builder: (context, state) {
        return RadioListTile<String>(
          title: Chip(
            label: Text(aisle.name),
            backgroundColor: Color(aisle.color),
          ),
          value: aisle.name,
          groupValue: state.aisle,
          onChanged: (String? value) {
            itemDetailsCubit.updateItem(aisle: value);
          },
        );
      },
    );
  }
}

class AisleExpandedBody extends StatelessWidget {
  final Aisle aisle;

  const AisleExpandedBody({Key? key, required this.aisle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShoppingListCubit shoppingListCubit =
        context.read<ShoppingListCubit>();
    final ItemDetailsCubit itemDetailsCubit = context.read<ItemDetailsCubit>();

    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 10,
            children: [
              ActionChip(
                label: Text('Edit name'),
                elevation: 1,
                onPressed: () async {
                  final input = await InputDialog.show(
                    context: context,
                    title: 'Name',
                    initialValue: aisle.name,
                    preselectText: true,
                  );
                  if (input != null) {
                    await shoppingListCubit.updateAisle(
                      oldAisle: aisle,
                      name: input,
                    );
                  }
                },
              ),
              EditColorChip(
                aisle: aisle,
              ),
            ],
          ),
          TextButton(
            onPressed: () async {
              await shoppingListCubit.deleteAisle(aisle: aisle);
              if (itemDetailsCubit.state.aisle == aisle.name) {
                itemDetailsCubit.updateItem(aisle: 'None');
              }
            },
            child: Text(
              'Remove aisle',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class EditColorChip extends StatelessWidget {
  final Aisle aisle;

  const EditColorChip({
    Key? key,
    required this.aisle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shoppingListCubit = context.read<ShoppingListCubit>();

    return ActionChip(
      label: Text('Edit color'),
      elevation: 1,
      onPressed: () async {
        Color? newColor;
        final Function callback = (Color color) => newColor = color;
        final confirmed = await ColorPicker(
          // Current color is pre-selected.
          color: Color(aisle.color),
          onColorChanged: (Color color) => callback(color),
          heading: Text('Select color'),
          subheading: Text('Select color shade'),
          pickersEnabled: const <ColorPickerType, bool>{
            ColorPickerType.primary: true,
            ColorPickerType.accent: false,
          },
        ).showPickerDialog(context);
        if (!confirmed) return;
        if (newColor == null) return;
        await shoppingListCubit.updateAisle(
          oldAisle: aisle,
          color: newColor?.value,
        );
      },
    );
  }
}

class CreateAisleButton extends StatelessWidget {
  const CreateAisleButton({
    Key? key,
    required this.shoppingListCubit,
  }) : super(key: key);

  final ShoppingListCubit shoppingListCubit;

  @override
  Widget build(BuildContext context) {
    return FloatingButton(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Create aisle'),
        onPressed: () async {
          final input = await InputDialog.show(
            context: context,
            initialValue: '',
            title: 'Create aisle',
            hintText: 'Aisle name',
          );
          if (input != null) {
            await shoppingListCubit.createAisle(name: input.capitalizeFirst);
            final itemDetailsCubit = context.read<ItemDetailsCubit>();
            itemDetailsCubit.updateItem(aisle: input.capitalizeFirst);
          }
        },
      ),
    );
  }
}
