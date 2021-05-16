import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

import '../../shopping_list.dart';

class LabelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemDetailsCubit = context.read<ItemDetailsCubit>();
    final shoppingListCubit = context.read<ShoppingListCubit>();

    return Scaffold(
      appBar: AppBar(title: Text('Labels')),
      body: BlocBuilder<ShoppingListCubit, ShoppingListState>(
        builder: (context, shoppingListState) {
          return ListView.builder(
            padding: EdgeInsets.only(
              top: 20,
              left: 4,
            ),
            itemCount: shoppingListState.labels.length,
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
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newLabel = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider.value(
                  value: shoppingListCubit,
                  child: CreateLabelPage(),
                );
              },
            ),
          );
          if (newLabel != null) {
            await shoppingListCubit.createLabel(name: newLabel);
          }
        },
        label: Text('New label'),
        icon: Icon(Icons.add),
      ),
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

class CreateLabelPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();

    Future<bool> _onWillPop() async {
      final newLabel = _controller.value.text;
      final isBlank = (newLabel == '');
      final value = (isBlank) ? null : newLabel;
      Navigator.pop(context, value);
      return true;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create label'),
          actions: [
            IconButton(
              onPressed: () => _onWillPop(),
              icon: Icon(Icons.done),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Label name',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
