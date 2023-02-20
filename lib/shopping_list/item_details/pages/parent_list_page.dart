import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/home/cubit/home_cubit.dart';
import '../../../application/shopping_list/cubit/shopping_list_cubit.dart';
import '../../../presentation/home/pages/home_page.dart';

class ParentListPage extends StatelessWidget {
  final String itemName;

  const ParentListPage({Key? key, required this.itemName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Parent List')),
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
      padding: const EdgeInsets.all(40),
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
        onChanged: (String? listName) async {
          final navigator = Navigator.of(context);
          await homeCubit.moveItemToList(
            item: shoppingListCubit.state.items
                .firstWhere((item) => item.name == itemName),
            currentListName: shoppingListCubit.state.name,
            newListName: listName!,
          );
          homeCubit.showSnackBar('$itemName moved to $listName.');
          await navigator.pushReplacementNamed(HomePage.id);
        },
      ),
    );
  }
}
