import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';

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
            'Aisle-custom',
            'Price',
            'Total',
          ]
              .map((element) => RadioListTile<String>(
                    title: Text(element),
                    value: element,
                    groupValue: state.sortBy,
                    onChanged: (String? value) async {
                      await shoppingCubit.updateList(sortBy: element);
                    },
                    secondary: (state.sortBy == element)
                        ? _CustomizeSortButton(element: element)
                        : null,
                  ))
              .toList(),
        );
      },
    );
  }
}

class _CustomizeSortButton extends StatelessWidget {
  final String element;

  const _CustomizeSortButton({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
        builder: (context, state) {
      if (state.sortBy != 'Aisle-custom') {
        return _SwitchDirectionsButton(element: element);
      } else {
        return _CustomAisleOrderButton();
      }
    });
  }
}

class _SwitchDirectionsButton extends StatelessWidget {
  final String element;

  const _SwitchDirectionsButton({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shoppingCubit = context.read<ShoppingListCubit>();

    return BlocBuilder<ShoppingListCubit, ShoppingListState>(
        builder: (context, state) {
      return IconButton(
        onPressed: () async {
          await shoppingCubit.updateList(
            sortAscending: !state.sortAscending,
          );
        },
        icon: FaIcon((state.sortAscending)
            ? FontAwesomeIcons.sortAmountDownAlt
            : FontAwesomeIcons.sortAmountUpAlt),
      );
    });
  }
}

class _CustomAisleOrderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shoppingListCubit = context.read<ShoppingListCubit>();
    final aisles = shoppingListCubit.state.aisles;
    return ActionChip(
      label: Text('Customize'),
      onPressed: () async {
        final reorderedAisles = await showDialog<List<Aisle>>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                width: double.maxFinite,
                child: ReorderableListView.builder(
                  padding: EdgeInsets.all(20),
                  shrinkWrap: true,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) newIndex--;
                    final aisle = aisles[oldIndex];
                    aisles.removeAt(oldIndex);
                    aisles.insert(newIndex, aisle);
                  },
                  header: _header(),
                  itemCount: aisles.length,
                  itemBuilder: (context, index) {
                    final aisle = aisles[index];
                    return ListTile(
                      key: ValueKey(aisle),
                      title: Center(child: Text(aisle.name)),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, aisles);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
        if (reorderedAisles != null) {
          await shoppingListCubit.updateList(aisles: reorderedAisles);
        }
      },
    );
  }

  Widget? _header() {
    // Running platform checks on web causes an exception.
    if (kIsWeb) return null;
    if (Platform.isAndroid || Platform.isIOS) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text('Long press to reorder'),
        ),
      );
    } else {
      return null;
    }
  }
}
