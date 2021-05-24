import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/core/helpers/form_factor.dart';

import '../../shopping_list.dart';

class ScrollingShoppingList extends StatelessWidget {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _isLargeFormFactor = isLargeFormFactor(context);

    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final items = state.items.where((e) => e.isComplete == false).toList();

        return Scrollbar(
          controller: _scrollController,
          isAlwaysShown: _isLargeFormFactor ? true : false,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.only(
              left: 4,
              right: 4,
              top: 4,
              bottom: 100,
            ),
            separatorBuilder: (context, index) {
              return const Divider(
                indent: 20,
                endIndent: 20,
                height: 4,
              );
            },
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return ItemTile(item: item);
            },
          ),
        );
      },
    );
  }
}
