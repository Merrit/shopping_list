import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/application/shopping_list/cubit/shopping_list_cubit.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/home/home.dart';

class ListSettingsPage extends StatelessWidget {
  static const id = 'list_settings_page';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('List settings'),
        ),
        body: ListSettingsView(),
      ),
    );
  }
}

// ignore: must_be_immutable
class ListSettingsView extends StatelessWidget {
  late HomeCubit homeCubit;
  late ShoppingListCubit shoppingListCubit;

  Future<void> _updateColor(Color color) async {
    await shoppingListCubit.updateList(color: color.value);
  }

  @override
  Widget build(BuildContext context) {
    homeCubit = context.read<HomeCubit>();
    shoppingListCubit = context.read<ShoppingListCubit>();
    final black = Colors.white.value;
    print('black: $black');
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(30),
          children: [
            SettingsTile(
              label: Text('List name'),
              hintText: state.name,
              onChanged: (value) async {
                await shoppingListCubit.updateList(name: value);
              },
            ),
            const SizedBox(height: 30),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                title: const Text('List name color'),
                trailing: ColorIndicator(
                  width: 44,
                  height: 44,
                  borderRadius: 4,
                  color: Color(state.color),
                ),
                onTap: () async {
                  final colorBeforeDialog = state.color;
                  final confirmed = await ColorPicker(
                    // Current color is pre-selected.
                    color: Color(state.color),
                    onColorChanged: (Color color) async {
                      await _updateColor(color);
                    },
                    // width: 40,
                    // height: 30,
                    // borderRadius: 4,
                    // spacing: 5,
                    // runSpacing: 5,
                    heading: Text('Select color'),
                    subheading: Text('Select color shade'),
                    pickersEnabled: const <ColorPickerType, bool>{
                      ColorPickerType.primary: true,
                      ColorPickerType.accent: false,
                    },
                  ).showPickerDialog(
                    context,
                    // constraints: const BoxConstraints(
                    //     minHeight: 460, minWidth: 300, maxWidth: 320),
                  );
                  if (!confirmed) {
                    await shoppingListCubit.updateList(
                        color: colorBeforeDialog);
                  }
                },
              ),
            ),
            const SizedBox(height: 100),
            OutlinedButton(
              onPressed: () => _deleteList(shoppingListCubit, context),
              child: Text(
                'Delete list',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<void> _deleteList(ShoppingListCubit cubit, BuildContext context) async {
  var shouldDelete = false;
  await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Delete list?'),
        content: Text('This cannot be undone.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              shouldDelete = true;
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
  if (shouldDelete) {
    cubit.deleteList();
    await Navigator.pushReplacementNamed(context, HomePage.id);
  }
}
