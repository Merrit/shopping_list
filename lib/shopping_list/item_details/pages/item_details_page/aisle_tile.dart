import 'package:collection/collection.dart';
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
      title: Row(
        children: [
          Text('Aisle'),
          const SizedBox(width: 15),
          BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
            builder: (context, state) {
              final aisleFromList = shoppingCubit.state.aisles
                  .firstWhereOrNull((aisle) => aisle.name == state.aisle);
              final backgroundColor =
                  (aisleFromList == null) ? null : Color(aisleFromList.color);

              return Chip(
                label: Text(state.aisle),
                backgroundColor: backgroundColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            },
          ),
        ],
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
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
