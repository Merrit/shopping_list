import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/home/home.dart';

import '../shopping_list.dart';

class ShoppingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentListId = context.watch<HomeCubit>().state.currentListId;
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 50,
              ),
              children: state.items
                  .map((item) => ItemTile(
                        key: ValueKey(item.name),
                        item: item,
                      ))
                  .toList(),
            ),
            currentListId == '' ? Container() : CreateItemButton(),
          ],
        );
      },
    );
  }
}
