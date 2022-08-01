import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/home/cubit/home_cubit.dart';
import '../../../application/shopping_list/cubit/shopping_list_cubit.dart';
import 'shopping_list_view.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final homeCubit = context.read<HomeCubit>();
    return const ShoppingListView();
  }
}
