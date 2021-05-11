import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

import '../../shopping_list.dart';

// ignore: must_be_immutable
class ChooseLabelsPage extends StatelessWidget {
  late ItemDetailsCubit itemDetailsCubit;
  late ShoppingListCubit shoppingCubit;

  void _updateColor(Color color, Label label) {
    shoppingCubit.updateLabelColor(color: color.value, oldLabel: label);
  }

  @override
  Widget build(BuildContext context) {
    itemDetailsCubit = context.read<ItemDetailsCubit>();
    shoppingCubit = context.read<ShoppingListCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Labels'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BlocBuilder<ShoppingListCubit, ShoppingListState>(
              builder: (context, shoppingListState) {
                return Wrap(
                  spacing: 15,
                  children: shoppingListState.labels
                      .map(
                        (label) =>
                            BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
                          builder: (context, itemDetailsState) {
                            return GestureDetector(
                              onLongPress: () async {
                                final colorBeforeDialog = label.color;
                                final confirmed = await ColorPicker(
                                  // Current color is pre-selected.
                                  color: Color(label.color),
                                  onColorChanged: (Color color) =>
                                      _updateColor(color, label),
                                  heading: Text('Select color'),
                                  subheading: Text('Select color shade'),
                                  pickersEnabled: const <ColorPickerType, bool>{
                                    ColorPickerType.primary: true,
                                    ColorPickerType.accent: false,
                                  },
                                ).showPickerDialog(context);
                                if (!confirmed) {
                                  _updateColor(Color(colorBeforeDialog), label);
                                }
                              },
                              child: FilterChip(
                                selected: itemDetailsState.labels
                                    .contains(label.name),
                                label: Text(label.name),
                                backgroundColor: Color(label.color),
                                // TODO: Add opacity or something to help
                                // differentiate between selected and not color.
                                selectedColor: Color(label.color),
                                onSelected: (_) {
                                  itemDetailsCubit.toggleLabel(label.name);
                                },
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider.value(
                  value: shoppingCubit,
                  child: EditLabelsPage(),
                );
              },
            ),
          );
        },
        label: Text('Edit labels'),
      ),
    );
  }
}

class EditLabelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoppingCubit = context.read<ShoppingListCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Labels'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<ShoppingListCubit, ShoppingListState>(
          builder: (context, state) {
            return Wrap(
              spacing: 10,
              children: state.labels
                  .map(
                    (label) => Chip(
                      label: Text(label.name),
                      onDeleted: () => shoppingCubit.deleteLabel(label),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newLabel = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider.value(
                  value: shoppingCubit,
                  child: CreateTagPage(),
                );
              },
            ),
          );
          if (newLabel != null) shoppingCubit.createLabel(name: newLabel);
        },
        label: Text('New label'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

class CreateTagPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();

    Future<bool> _onWillPop() async {
      final newLabel = _controller.value.text;
      Navigator.pop(context, newLabel);
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
