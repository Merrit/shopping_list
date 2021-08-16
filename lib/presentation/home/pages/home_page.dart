import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/application/authentication/bloc/authentication_bloc.dart';
import 'package:shopping_list/application/home/cubit/home_cubit.dart';
import 'package:shopping_list/infrastructure/preferences/preferences_repository.dart';
import 'package:shopping_list/infrastructure/shopping_list_repository/shopping_list_repository.dart';
import 'package:shopping_list/presentation/shopping_list/pages/shopping_list_page.dart';

import '../home.dart';

late HomeCubit homeCubit;

class HomePage extends StatelessWidget {
  static const id = 'home_page';

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) => HomeCubit(
        PreferencesRepository(),
        shoppingListRepository: FirebaseShoppingListRepository(user.id),
        user: user,
      ),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    homeCubit = context.read<HomeCubit>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: ShoppingListAppBar(),
            ),
            drawer: (constraints.maxWidth > 600)
                ? null
                : Drawer(child: ListDrawer()),
            body: constraints.maxWidth > 600
                ? ShoppingListTwoColumnView()
                : ShoppingListPage(),
          ),
        );
      },
    );
  }
}

class ShoppingListTwoColumnView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          child: ListDrawer(),
        ),
        VerticalDivider(
          width: 0,
        ),
        Flexible(
          child: ShoppingListPage(),
        ),
      ],
    );
  }
}
