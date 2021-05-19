import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/settings/settings.dart';
import 'package:shopping_list/shopping_list/item_details/pages/parent_list_page.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

import '../../item_details.dart';
import 'aisle_tile.dart';
import 'labels_tile.dart';

class ItemDetailsView extends StatelessWidget {
  const ItemDetailsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
      builder: (context, state) {
        final itemDetailsCubit = context.read<ItemDetailsCubit>();
        final shoppingCubit = context.watch<ShoppingListCubit>();
        final mediaQuery = MediaQuery.of(context);
        final isWide = (mediaQuery.size.width > 600);
        final listPadding = (isWide)
            ? EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 20,
              )
            : const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              );
        final items = [
          ListTile(
            leading: Icon(Icons.title),
            title: Text('Name'),
            subtitle: Text(state.name),
            onTap: () async {
              final input = await InputDialog.show(
                context: context,
                title: 'Name',
                initialValue: state.name,
              );
              if (input != null) itemDetailsCubit.updateItem(name: input);
            },
          ),
          ListTile(
            leading: Icon(Icons.tag),
            title: Text('Quantity'),
            subtitle: Text(state.quantity),
            onTap: () async {
              final input = await InputDialog.show(
                context: context,
                title: 'Quantity',
                type: InputDialogs.onlyInt,
                initialValue: state.quantity,
                preselectText: true,
              );
              if (input != null) itemDetailsCubit.updateItem(quantity: input);
            },
          ),
          AisleTile(),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Price'),
            subtitle: Text(state.price),
            onTap: () async {
              final input = await InputDialog.show(
                context: context,
                title: 'Price',
                type: InputDialogs.onlyDouble,
                initialValue: state.price,
              );
              if (input != null) itemDetailsCubit.updateItem(price: input);
            },
          ),
          InkWell(
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider.value(
                      value: homeCubit,
                      child: SettingsPage(),
                    );
                  },
                ),
              );
            },
            child: SwitchListTile(
              secondary: Icon(Icons.calculate_outlined),
              title: Text('Tax'),
              value: state.hasTax,
              onChanged: (value) => itemDetailsCubit.updateItem(hasTax: value),
            ),
          ),
          LabelsTile(),
          ListTile(
            leading: Icon(Icons.notes),
            title: Text('Notes'),
            subtitle: (state.notes == '') ? null : Text(state.notes),
            onTap: () async {
              final input = await InputDialog.show(
                context: context,
                title: 'Notes',
                initialValue: state.notes,
                type: InputDialogs.multiLine,
              );
              if (input != null) itemDetailsCubit.updateItem(notes: input);
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('List'),
            subtitle: Text(shoppingCubit.state.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: homeCubit),
                        BlocProvider.value(value: shoppingCubit),
                      ],
                      child: ParentListPage(itemName: state.name),
                    );
                  },
                ),
              );
            },
          ),
        ];

        return ListView.separated(
          padding: listPadding,
          separatorBuilder: (context, index) => const Divider(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return items[index];
          },
        );
      },
    );
  }
}
