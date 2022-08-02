import 'package:flutter/material.dart';

import 'shopping_list_view.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final homeCubit = context.read<HomeCubit>();
    return const ShoppingListView();
  }
}
