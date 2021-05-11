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
              .map((element) => RadioListTile<String>(
                    title: Text(element),
                    value: element,
                    groupValue: state.sortBy,
                    onChanged: (String? value) {
                      shoppingCubit.updateList(sortBy: element);
                    },
                    secondary: (state.sortBy == element)
                        ? IconButton(
                            onPressed: () {
                              shoppingCubit.updateList(
                                sortAscending: !state.sortAscending,
                              );
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
