import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/home/cubit/home_cubit.dart';
import '../../../shopping_list/pages/shopping_list_page.dart';
import '../home.dart';

late HomeCubit homeCubit;

class HomePage extends StatelessWidget {
  static const id = 'home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    homeCubit = context.read<HomeCubit>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: BlocListener<HomeCubit, HomeState>(
            listenWhen: (previous, current) =>
                previous.snackBarMsg != current.snackBarMsg,
            listener: (context, state) {
              if (state.snackBarMsg == '') return;
              final snackBar = SnackBar(content: Text(state.snackBarMsg));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Scaffold(
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: ShoppingListAppBar(),
              ),
              drawer: (constraints.maxWidth > 600)
                  ? null
                  : const Drawer(child: ListDrawer()),
              body: constraints.maxWidth > 600
                  ? const TwoColumnView()
                  : const ShoppingListPage(),
            ),
          ),
        );
      },
    );
  }
}

class TwoColumnView extends StatelessWidget {
  const TwoColumnView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          child: ListDrawer(),
        ),
        VerticalDivider(width: 0),
        Flexible(
          child: ShoppingListPage(),
        ),
      ],
    );
  }
}
