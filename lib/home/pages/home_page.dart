import 'package:authentication_repository/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/authentication/authentication.dart';
import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/home/cubit/home_cubit.dart';
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
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(user: user),
      body: ShoppingListGridView(),
      floatingActionButton: _FloatingCreateListButton(),
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
              padding: const EdgeInsets.all(12.0),
              childAspectRatio: 1.0 / 1.3,
              crossAxisCount: constraints.maxWidth > 600 ? 5 : 2,
              crossAxisSpacing: 20.0,
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

class ShoppingListCard extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListCard({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text(list.name)),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollViewWithExpanded(
        children: [
          Text(user.email),
        ],
      ),
    );
  }
}

class _FloatingCreateListButton extends StatelessWidget {
  const _FloatingCreateListButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () =>
          context.read<HomeCubit>().createList(name: 'The Jade Dragon'),
      label: Text('Create list'),
    );
  }
}
