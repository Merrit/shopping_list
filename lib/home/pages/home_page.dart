import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list_repository/shopping_list_repository.dart';

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
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(),
      body: ShoppingListGridView(),
      floatingActionButton: FloatingCreateListButton(),
    );
  }
}

class ShoppingListGridView extends StatelessWidget {
  const ShoppingListGridView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.shoppingLists != current.shoppingLists,
      builder: (context, state) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return GridView.count(
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 1.0 / 1.3,
              crossAxisCount: constraints.maxWidth > 600 ? 5 : 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 40.0,
              children: state.shoppingLists
                  .map((list) => ShoppingListCard(
                        key: ValueKey(list.id),
                        list: list,
                      ))
                  .toList(),
            );
          },
        );
      },
    );
  }
}
