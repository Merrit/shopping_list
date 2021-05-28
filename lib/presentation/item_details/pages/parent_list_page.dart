import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/application/shopping_list/cubit/shopping_list_cubit.dart';
import 'package:shopping_list/home/home.dart';

class ParentListPage extends StatelessWidget {
  final String itemName;

  const ParentListPage({Key? key, required this.itemName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Parent List')),
        body: ParentListView(itemName: itemName),
      ),
    );
  }
}

class ParentListView extends StatelessWidget {
  final String itemName;

  const ParentListView({Key? key, required this.itemName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final shoppingListCubit = context.read<ShoppingListCubit>();

    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(40),
      child: DropdownButton<String>(
        value: shoppingListCubit.state.name,
        items: homeCubit.state.shoppingLists
            .map((e) => e.name)
            .toList()
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: (value) async {
          await homeCubit.moveItemToList(
            item: shoppingListCubit.state.items
                .firstWhere((item) => item.name == itemName),
            currentListName: shoppingListCubit.state.name,
            newListName: value!,
          );
          await Navigator.pushReplacementNamed(context, HomePage.id);
        },
      ),
    );
  }
}
