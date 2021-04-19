import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shopping_list.dart';

class ShoppingListPage extends StatelessWidget {
  static const id = 'shopping_list_page';

  @override
  Widget build(BuildContext context) {
    final listId = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (context) => ShoppingListCubit(listId: listId),
      child: ShoppingListView(),
    );
  }
}

class ShoppingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        return Container();
      },
    );
  }
}
