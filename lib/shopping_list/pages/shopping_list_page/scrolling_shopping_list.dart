import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shopping_list.dart';

class ScrollingShoppingList extends StatelessWidget {
  final _scrollController = ScrollController(
    keepScrollOffset: true,
  );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        context
            .read<ActiveListState>()
            .updateFloatingButtonVisibility(_scrollController.offset);
      });
    });

    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        final items = state.items.where((e) => e.isComplete == false).toList();

        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(4),
          separatorBuilder: (context, index) {
            return const Divider(
              indent: 20,
              endIndent: 20,
            );
          },
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            return ItemTile(item: item);
          },
        );
      },
    );
  }
}
