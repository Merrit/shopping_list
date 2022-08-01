import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/home/cubit/home_cubit.dart';
import '../../shopping_list/pages/shopping_list_page.dart';
import '../home.dart';

late HomeCubit homeCubit;

class HomePage extends StatelessWidget {
  static const id = 'home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    homeCubit = context.read<HomeCubit>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: ShoppingListAppBar(),
            ),
            drawer: (constraints.maxWidth > 600)
                ? null
                : const Drawer(child: ListDrawer()),
            body: constraints.maxWidth > 600
                ? const ShoppingListTwoColumnView()
                : const ShoppingListPage(),
          ),
        );
      },
    );
  }
}

class ShoppingListTwoColumnView extends StatelessWidget {
  const ShoppingListTwoColumnView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        SizedBox(
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
