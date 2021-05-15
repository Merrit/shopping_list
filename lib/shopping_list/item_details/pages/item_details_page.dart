import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shopping_list/core/core.dart';
import 'package:shopping_list/home/home.dart';
import 'package:shopping_list/repositories/shopping_list_repository/repository.dart';
import 'package:shopping_list/settings/settings.dart';
import 'package:shopping_list/shopping_list/item_details/pages/aisles_page.dart';
import 'package:shopping_list/shopping_list/shopping_list.dart';

import '../item_details.dart';

// ignore: must_be_immutable
class ItemDetailsPage extends StatelessWidget {
  static const id = 'item_details_page';

  Item itemForCubit;

  ItemDetailsPage({
    Key? key,
    required Item item,
  })  : itemForCubit = item,
        super(key: key);

  Future<bool> _onWillPop(BuildContext context) async {
    final item = context.read<ItemDetailsCubit>().updatedItem();
    // Return the modified item.
    Navigator.pop(context, item);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemDetailsCubit(itemForCubit),
      child: Builder(builder: (context) {
        return WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(),
              body: ItemDetailsView(),
            ),
          ),
        );
      }),
    );
  }
}

// ignore: must_be_immutable
class ItemDetailsView extends StatelessWidget {
  ItemDetailsView({
    Key? key,
  }) : super(key: key);

  late HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    homeCubit = context.read<HomeCubit>();

    return BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
      // buildWhen: (previous, current) =>
      //     (previous.aisle != current.aisle) ||
      //     (previous.hasTax != current.hasTax) ||
      //     (previous.labels != current.labels),
      builder: (context, state) {
        final itemDetailsCubit = context.read<ItemDetailsCubit>();
        final shoppingCubit = context.watch<ShoppingListCubit>();
        final mediaQuery = MediaQuery.of(context);
        final isWide = (mediaQuery.size.width > 600);
        final listPadding = (isWide)
            ? EdgeInsets.symmetric(
                vertical: 40,
                horizontal: mediaQuery.size.width / 3,
              )
            : const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              );
        final items = [
          ListTile(
            leading: Icon(Icons.title),
            title: Text('Name'),
            trailing: Icon(Icons.keyboard_arrow_right),
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
            trailing: Icon(Icons.keyboard_arrow_right),
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
          ListTile(
            leading: Icon(Icons.format_color_text),
            title: Text('Aisle'),
            trailing: Icon(Icons.keyboard_arrow_right),
            subtitle: Row(
              // Row needed to un-center the chip.
              children: [
                Chip(
                  label: Text(state.aisle),
                  backgroundColor: Color(
                    shoppingCubit.state.aisles
                        .firstWhere((aisle) => aisle.name == state.aisle)
                        .color,
                  ),
                ),
              ],
            ),
            onTap: () {
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
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Price'),
            trailing: Icon(Icons.keyboard_arrow_right),
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
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 6.0,
              ),
              child: ListTile(
                leading: Icon(Icons.label),
                title: Text('Labels'),
                subtitle: BlocBuilder<ItemDetailsCubit, ItemDetailsState>(
                  builder: (context, state) {
                    return Wrap(
                      // spacing: 10,
                      children: state.labels
                          .map(
                            (label) => Chip(
                              label: Text(label),
                              backgroundColor: Color(shoppingCubit.state.labels
                                  .firstWhere(
                                      (element) => element.name == label)
                                  .color),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: itemDetailsCubit),
                            BlocProvider.value(value: shoppingCubit),
                          ],
                          child: ChooseLabelsPage(),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          SettingsTile(
            label: Text('Notes'),
            defaultText: state.notes,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (value) => itemDetailsCubit.updateItem(notes: value),
          ),
          const SizedBox(height: 40),
          DropdownButton<String>(
            value: shoppingCubit.state.name,
            items: homeCubit.state.shoppingLists
                .map((e) => e.name)
                .toList()
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              homeCubit.moveItemToList(
                item: shoppingCubit.state.items
                    .firstWhere((element) => element.name == state.name),
                currentListName: shoppingCubit.state.name,
                newListName: value!,
              );
              Navigator.pop(context);
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

  String _verifyAisle({
    required ShoppingListCubit shoppingCubit,
    required String aisle,
  }) {
    final verifiedAisle = (shoppingCubit.verifyAisle(aisle: aisle));
    if (verifiedAisle == '') {
      return 'None';
    } else {
      return verifiedAisle;
    }
  }
}

class _Buffer extends StatelessWidget {
  const _Buffer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 40);
  }
}
