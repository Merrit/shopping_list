import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shopping_list.dart';

class SortByPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sort by'),
      ),
      body: SortByView(),
    );
  }
}

class SortByState extends ChangeNotifier {
  // bool
}

class SortByView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoppingCubit = context.read<ShoppingListCubit>();

    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
      builder: (context, state) {
        return ListView(
          children: <String>[
            'Name',
            'Quantity',
            'Aisle',
            'Price',
            'Total',
          ]
              .map((e) => RadioListTile<String>(
                    title: Text(e),
                    value: e,
                    groupValue: state.sortBy,
                    onChanged: (String? value) {
                      shoppingCubit.updateSortedBy(
                          ascending: state.sortAscending, sortBy: e);
                    },
                    secondary: (state.sortBy == e)
                        ? IconButton(
                            onPressed: () {
                              shoppingCubit.updateSortedBy(
                                  ascending: !state.sortAscending, sortBy: e);
                            },
                            icon: FaIcon((state.sortAscending)
                                ? FontAwesomeIcons.sortAmountDownAlt
                                : FontAwesomeIcons.sortAmountUpAlt),
                          )
                        : null,
                  ))
              .toList(),
        );
      },
    );
  }
}
