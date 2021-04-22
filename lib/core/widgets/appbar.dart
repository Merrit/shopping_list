import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

import '../../home/home.dart';

class ShoppingListAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final _shoppingList = state.shoppingLists
            .firstWhereOrNull((list) => list.id == state.currentListId);
        return (_shoppingList == null)
            ? AppBar()
            : AppBar(
                title: Text(_shoppingList.name),
                actions: [
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        'List settings',
                      ].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                    onSelected: (String choice) {
                      switch (choice) {
                        case 'List settings':
                          _showListSettings(context);
                          break;
                        default:
                      }
                    },
                  ),
                ],
              );
      },
    );
  }
}

void _showListSettings(BuildContext context) {
  final homeCubit = context.read<HomeCubit>();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => ShoppingListCubit(homeCubit: homeCubit),
          child: ListSettingsPage(),
        );
      },
    ),
  );
}
