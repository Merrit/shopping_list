import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/item_details/cubit/item_details_cubit.dart';
import '../../../application/shopping_list/cubit/shopping_list_cubit.dart';
import '../../../domain/core/core.dart';
import '../../../infrastructure/shopping_list_repository/shopping_list_repository.dart';
import '../../core/core.dart';
import '../widgets/floating_done_button.dart';

class AislesPage extends StatelessWidget {
  static const id = 'aisles_page';

  const AislesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Aisle')),
        body: const AislesView(),
      ),
    );
  }
}

class AislesView extends StatelessWidget {
  const AislesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _AislesList(),
        const FloatingDoneButton(),
      ],
    );
  }
}

class _AislesList extends StatelessWidget {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _isLargeFormFactor = isLargeFormFactor(context);

    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, shoppingListState) {
        return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
          builder: (context, itemDetailsState) {
            return Scrollbar(
              controller: _controller,
              thumbVisibility: _isLargeFormFactor ? true : false,
              child: ListView(
                controller: _controller,
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
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: () => _createAisle(context: context),
                    icon: const CircleAvatar(child: Icon(Icons.add)),
                  ),
                ],
              ),
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
                label: const Text('Edit name'),
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
            child: const Text(
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
      label: const Text('Edit color'),
      elevation: 1,
      onPressed: () async {
        Color? newColor;
        // ignore: prefer_function_declarations_over_variables
        final Function callback = (Color color) => newColor = color;
        final confirmed = await ColorPicker(
          // Current color is pre-selected.
          color: Color(aisle.color),
          onColorChanged: (Color color) => callback(color),
          heading: const Text('Select color'),
          subheading: const Text('Select color shade'),
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

Future<void> _createAisle({required BuildContext context}) async {
  final itemDetailsCubit = context.read<ItemDetailsCubit>();
  final shoppingListCubit = context.read<ShoppingListCubit>();
  final input = await InputDialog.show(
    context: context,
    initialValue: '',
    title: 'Create aisle',
    hintText: 'Aisle name',
  );
  if (input != null) {
    final newAisle = input.capitalizeFirst;
    await shoppingListCubit.createAisle(name: newAisle);
    itemDetailsCubit.updateItem(aisle: newAisle);
  }
}
