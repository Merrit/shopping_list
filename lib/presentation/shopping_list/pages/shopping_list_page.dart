import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/application/home/cubit/home_cubit.dart';
import 'package:shopping_list/application/shopping_list/cubit/shopping_list_cubit.dart';
import 'package:shopping_list/infrastructure/preferences/preferences_repository.dart';

import 'shopping_list_view.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage();

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return BlocProvider(
      create: (context) => ShoppingListCubit(
        PreferencesRepository(),
        homeCubit: homeCubit,
      ),
      child: ShoppingListView(),
    );
  }
}
