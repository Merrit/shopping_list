import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

import '../../shopping_list.dart';

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
                itemCount: 50,
                itemBuilder: (context, index) {
                  final label = shoppingListState.labels[index];
                  return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
                    key: Key('$index'),
                    builder: (context, itemDetailsState) {
                      return ListTile(
                        leading: (itemDetailsState.labels.contains(label.name))
                            ? Icon(Icons.check)
                            : SizedBox(),
                        title: Text(
                          label.name,
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Color(label.color),
                                  ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final colorBeforeDialog = label.color;
                                final confirmed = await ColorPicker(
                                  // Current color is pre-selected.
                                  color: Color(label.color),
                                  onColorChanged: (Color color) async {
                                    await _updateColor(
                                      color: color,
                                      label: label,
                                      shoppingListCubit: shoppingListCubit,
                                    );
                                  },
                                  heading: Text('Select color'),
                                  subheading: Text('Select color shade'),
                                  pickersEnabled: const <ColorPickerType, bool>{
                                    ColorPickerType.primary: true,
                                    ColorPickerType.accent: false,
                                  },
                                ).showPickerDialog(context);
                                if (!confirmed) {
                                  await _updateColor(
                                    color: Color(colorBeforeDialog),
                                    label: label,
                                    shoppingListCubit: shoppingListCubit,
                                  );
                                }
                              },
                              icon: Icon(Icons.edit_outlined),
                            ),
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
                },
              ),
            );
          },
        ),
        FloatingButton(
          floatingActionButton: FloatingLabelButton(),
        ),
      ],
    );
  }
}

class FloatingLabelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoppingListCubit = context.read<ShoppingListCubit>();

    return FloatingActionButton.extended(
      onPressed: () async {
        final newLabel = await InputDialog.show(
          context: context,
          title: 'New label',
        );
        if (newLabel != null) {
          await shoppingListCubit.createLabel(name: newLabel.capitalizeFirst);
        }
      },
      label: Text('New label'),
      icon: Icon(Icons.add),
    );
  }
}

Future<void> _updateColor({
  required Color color,
  required Label label,
  required ShoppingListCubit shoppingListCubit,
}) async {
  await shoppingListCubit.updateLabelColor(color: color.value, oldLabel: label);
}
