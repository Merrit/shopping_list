import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            TextFieldTile(),
            SizedBox(height: 30),
            TextButton(
              onPressed: () {
                cubit.deleteList();
                Navigator.pushReplacementNamed(context, HomePage.id);
              },
              child: Text('Delete list'),
            ),
          ],
        );
      },
    );
  }
}

class TextFieldTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('List name'),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: state.name,
              ),
            ),
          ],
        );
      },
    );
  }
}
