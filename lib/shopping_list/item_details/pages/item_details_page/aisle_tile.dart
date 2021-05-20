import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/shopping_list/item_details/pages/aisles_page.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

class AisleTile extends StatelessWidget {
  const AisleTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shoppingCubit = context.watch<ShoppingListCubit>();

    return ListTile(
      leading: Icon(Icons.format_color_text),
      title: Text('Aisle'),
      trailing: Icon(Icons.keyboard_arrow_right),
      subtitle: Row(
        // Row needed to un-center the chip.
        children: [
          BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
            builder: (context, state) {
              return Chip(
                label: Text(state.aisle),
                backgroundColor: Color(
                  shoppingCubit.state.aisles
                      .firstWhere((aisle) => aisle.name == state.aisle)
                      .color,
                ),
              );
            },
          ),
        ],
      ),
      onTap: () {
        _goToAislesPage(context);
      },
    );
  }

  void _goToAislesPage(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWide = mediaQuery.size.width > 600;
    if (isWide) {
      final state = context.read<DetailsPageState>();
      state.subpage = AislesPage.id;
    } else {
      final itemDetailsCubit = context.read<ItemDetailsCubit>();
      final shoppingCubit = context.read<ShoppingListCubit>();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: shoppingCubit),
                BlocProvider.value(value: itemDetailsCubit),
              ],
              child: AislesPage(),
            );
          },
        ),
      );
    }
  }
}