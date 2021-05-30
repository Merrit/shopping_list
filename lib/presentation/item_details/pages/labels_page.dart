import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/application/item_details/cubit/item_details_cubit.dart';
import 'package:shopping_list/application/shopping_list/cubit/shopping_list_cubit.dart';

import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/presentation/item_details/widgets/floating_done_button.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

class LabelsPage extends StatelessWidget {
  static const id = 'labels_page';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Labels')),
        body: LabelsView(),
      ),
    );
  }
}

class LabelsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = ScrollController();
    final _isLargeFormFactor = isLargeFormFactor(context);
    final itemDetailsCubit = context.read<ItemDetailsCubit>();
    final shoppingListCubit = context.read<ShoppingListCubit>();

    return Stack(
      children: [
        BlocBuilder<ShoppingListCubit, ShoppingListState>(
          builder: (context, shoppingListState) {
            return Scrollbar(
              controller: _controller,
              isAlwaysShown: _isLargeFormFactor ? true : false,
              child: ListView.builder(
                controller: _controller,
                padding: Insets.listViewWithFloatingButton,
                itemCount: shoppingListState.labels.length + 1,
                itemBuilder: (context, index) {
                  if (index != shoppingListState.labels.length) {
                    return _LabelTile(
                      index: index,
                      shoppingListCubit: shoppingListCubit,
                      itemDetailsCubit: itemDetailsCubit,
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: IconButton(
                        onPressed: () => _createLabel(context: context),
                        icon: CircleAvatar(child: Icon(Icons.add)),
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
        FloatingDoneButton(),
      ],
    );
  }
}

class _LabelTile extends StatelessWidget {
  const _LabelTile({
    Key? key,
    required this.index,
    required this.shoppingListCubit,
    required this.itemDetailsCubit,
  }) : super(key: key);

  final int index;
  final ShoppingListCubit shoppingListCubit;
  final ItemDetailsCubit itemDetailsCubit;

  @override
  Widget build(BuildContext context) {
    final shoppingListState = shoppingListCubit.state;
    final label = shoppingListState.labels[index];
    return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
      key: Key('$index'),
      builder: (context, itemDetailsState) {
        return ListTile(
          leading: Checkbox(
            value: itemDetailsState.labels.contains(label.name),
            onChanged: (_) => itemDetailsCubit.toggleLabel(label.name),
          ),
          title: Text(
            label.name,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Color(label.color),
                ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ActionChip(
                label: Text('Edit color'),
                onPressed: () async => await _editColor(label, context),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () async {
                  await shoppingListCubit.deleteLabel(label);
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          onTap: () => itemDetailsCubit.toggleLabel(label.name),
        );
      },
    );
  }

  Future<void> _editColor(Label label, BuildContext context) async {
    Color labelColor = Color(label.color);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label.name,
                    style: TextStyle(color: labelColor),
                  ),
                  ColorPicker(
                    // Current color is pre-selected.
                    color: labelColor,
                    onColorChanged: (Color color) {
                      setState(() => labelColor = color);
                    },
                    heading: Text('Select color'),
                    subheading: Text('Select color shade'),
                    pickersEnabled: const <ColorPickerType, bool>{
                      ColorPickerType.primary: true,
                      ColorPickerType.accent: false,
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
    if (confirmed != null) {
      await _updateColor(
        color: labelColor,
        label: label,
        shoppingListCubit: shoppingListCubit,
      );
    }
  }
}

Future<void> _createLabel({required BuildContext context}) async {
  final shoppingListCubit = context.read<ShoppingListCubit>();
  final newLabel = await InputDialog.show(
    context: context,
    title: 'New label',
  );
  if (newLabel != null) {
    await shoppingListCubit.createLabel(name: newLabel.capitalizeFirst);
  }
}

Future<void> _updateColor({
  required Color color,
  required Label label,
  required ShoppingListCubit shoppingListCubit,
}) async {
  await shoppingListCubit.updateLabelColor(color: color.value, oldLabel: label);
}