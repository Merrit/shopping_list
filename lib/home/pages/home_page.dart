import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

import '../home.dart';

class HomePage extends StatelessWidget {
  static const id = 'home_page';

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) => HomeCubit(
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
