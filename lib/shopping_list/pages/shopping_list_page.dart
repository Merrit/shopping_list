import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/home/home.dart';

import '../shopping_list.dart';

class ShoppingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return BlocProvider(
      create: (context) => ShoppingListCubit(
        homeCubit: homeCubit,
      ),
      child: ShoppingListView(),
    );
  }
}
