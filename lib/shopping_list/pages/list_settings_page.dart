import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/home/home.dart';

import '../shopping_list.dart';

class ListSettingsPage extends StatelessWidget {
  static const id = 'list_settings_page';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: ListSettingsView(),
      ),
    );
  }
}

class ListSettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShoppingListCubit>();
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(30),
          children: [
            SettingsTile(
              label: 'List name',
              title: state.name,
              onChanged: (value) => cubit.updateListName(value),
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: () => _deleteList(cubit, context),
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
